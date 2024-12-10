#loading appropriate library
library(dplyr)

#loading in datasets
rff_2024 <- readRDS(here::here("Final project", "rff_2024.rds"))
transmission_pairs_2024 <- readRDS(here::here("Final project", "transmission_pairs_2024.rds"))

#selecting columns needed from transmission_pairs_2024
transmission_subset <- transmission_pairs_2024 %>%
  select(caseID, Infectedby_Date_Time_Exposure, Infectedby_Date_Time_Onset)

#performing left join (inserting new columns into rff_2024)
merged_rff_2024 <- rff_2024 %>%
  left_join(transmission_subset, by = "caseID")

head(merged_rff_2024)

#changing the order of the columns so the new columns "Infectedby_Date_Time_Exposure"," and "Infectedby_Date_Time_Onset" go right before "Did you have symptoms?"
merged_rff_2024 <- merged_rff_2024 %>%
  select(caseID, Infectedby, Gender, Course, `If you are in EPI 569, which TA group are you in?`, `Date of Exposure`, `Time of Exposure`,
        Date_of_Onset, Date_Time_Onset, Date_Time_Exposure,Infectedby_Date_Time_Exposure, Infectedby_Date_Time_Onset, `Did you have symptoms?`, 
        `How many hours after exposure did you develop symptoms?`, `How many hours after your symptom onset did you feel better?`, Date_Time_Recovery,
        Date_of_Recovery, Severe, Date_became_severe, `How many people did you expose?`, `How many people did you infect?`, `Date of First Exposure`,
        `Time of First Exposure`, `Date of Second Exposure`, `Time of Second Exposure`, `Date of Third Exposure`, `Time of Third Exposure`, `Date of Fourth Exposure`,
        `Time of Fourth Exposure`, `Date of Fifth Exposure`, `Time of Fifth Exposure`, Date_Time_First_Exposure, Date_Time_Second_Exposure, Date_Time_Third_Exposure,
        Date_Time_Fourth_Exposure, Date_Time_Fifth_Exposure
        )

#Cleaning: renaming merged file columns
clean_merged_rff_2024 <- merged_rff_2024 %>%
  rename(c(ta_group_569 = `If you are in EPI 569, which TA group are you in?`,
           date_of_exposure = `Date of Exposure`,
           time_of_exposure = `Time of Exposure`,,
           symptoms = `Did you have symptoms?`,
           symptom_onset_hours = `How many hours after exposure did you develop symptoms?`,
           symptom_recovery_hours = `How many hours after your symptom onset did you feel better?`,
           exposure_count = `How many people did you expose?`,
           infection_count = `How many people did you infect?`,
           first_exposure_date = `Date of First Exposure`,
           first_exposure_time = `Time of First Exposure`,
           second_exposure_date = `Date of Second Exposure`,
           second_exposure_time = `Time of Second Exposure`,
           third_exposure_date = `Date of Third Exposure`,
           third_exposure_time = `Time of Third Exposure`,
           fourth_exposure_date = `Date of Fourth Exposure`,
           fourth_exposure_time = `Time of Fourth Exposure`,
           fifth_exposure_daate = `Date of Fifth Exposure`,
           fifth_exposure_time = `Time of Fifth Exposure`
  )) %>%
  
  #Cleaning: fixing error in caseID 41 and 
  mutate(symptoms = if_else(caseID == 41, "Yes", symptoms), 
         symptom_onset_hours = if_else(symptoms=="No", NA, symptom_recovery_hours)
  )

#saving the new file to share
saveRDS(clean_merged_rff_2024, here::here("Final project", "clean_merged_rff_2024.rds"))
