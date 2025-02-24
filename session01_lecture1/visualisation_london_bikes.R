library(tidyverse)
library(mosaic)
library(here)
library(lubridate)
library(skimr)


#read the CSV file
bike <- read_csv(here::here("data", "london_bikes.csv"))

# fix dates using lubridate, and generate new variables for year, month, month_name, day, and day_of _week
bike <- bike %>%   
  mutate(
    year=year(day),
    month = month(day),
    month_name=month(day, label = TRUE),
    day_of_week = wday(day, label = TRUE)) 

# generate new variable season_name to turn seasons from numbers to Winter, Spring, etc
bike <- bike %>%  
  mutate(
    season_name = case_when(
      month_name %in%  c("Dec", "Jan", "Feb")  ~ "Winter",
      month_name %in%  c("Mar", "Apr", "May")  ~ "Spring",
      month_name %in%  c("Jun", "Jul", "Aug")  ~ "Summer",
      month_name %in%  c("Sep", "Oct", "Nov")  ~ "Autumn",
    ),
    season_name = factor(season_name, 
                         levels = c("Winter", "Spring", "Summer", "Autumn"))
  )

# examine what the resulting data frame looks like
glimpse(bike)
skim(bike)


# Time series plot of bikes rented
ggplot(bike, aes(x=day, y=bikes_hired))+
  geom_smooth()+
  geom_point(alpha = 0.4)+
  theme_bw()+
  NULL


#summary statistics
favstats(~ bikes_hired, data= bike)

# if we wanted to get summary statistics by `year`, `day_of_week`,  `month_name`, or `season_name`
# we use mosaic's syntax `Y ~ X` that allows us to facet our analysis of a variable Y by variable X 
# using the syntax `favstats( Y ~ X, data=...)`

favstats(bikes_hired ~ year, data=bike)
favstats(bikes_hired ~ day_of_week, data=bike)
favstats(bikes_hired ~ month_name, data=bike)
favstats(bikes_hired ~ season_name, data=bike)


# Histogram of bikes rented
ggplot(bike, aes(x=bikes_hired))+
  geom_histogram()+
  theme_bw()+
  NULL

# Histogram faceted by season_name
ggplot(bike, aes(x=bikes_hired))+
  geom_histogram()+
  facet_wrap(~season_name)+
  theme_bw()+
  NULL

# Histogram faceted by month_name
ggplot(bike, aes(x=bikes_hired))+
  geom_histogram()+
  facet_wrap(~month_name)+
  theme_bw()+
  NULL

# Histogram faceted by month_name in 4 rows
ggplot(bike, aes(x=bikes_hired))+
  geom_histogram()+
  facet_wrap(~month_name, nrow = 4)+
  theme_bw()+
  NULL


# Density plot 
ggplot(bike, aes(x=bikes_hired))+
  geom_density()+
  theme_bw()+
  NULL

# Density plot filled by season_name 
ggplot(bike, aes(x=bikes_hired))+
  geom_density(aes(fill=season_name), alpha = 0.3)+
  theme_bw()+
  NULL

# Density plot filled by season_name, and faceted by season_name
ggplot(bike, aes(x=bikes_hired))+
  geom_density(aes(fill=season_name), alpha = 0.3)+
  facet_wrap(~season_name, nrow = 4)+
  theme_bw()+
  NULL

# Density plot filled by season_name, and faceted by month_name
ggplot(bike, aes(x=bikes_hired))+
  geom_density(aes(fill=season_name), alpha = 0.3)+
  facet_wrap(~month_name, nrow = 4)+
  theme_bw()+
  theme(legend.position="none")+
  NULL

#Boxplot of bikes_hired  by month
# since 'month' is a number, it treats it as a continuous variable; hence we get just one box
ggplot(bike, aes(x=month, y= bikes_hired))+
  geom_boxplot()+
  theme_bw()+
  NULL


#Boxplot  by month_name
ggplot(bike, aes(x=month_name, y= bikes_hired))+
  geom_boxplot()+
  theme_bw()+
  NULL


#Boxplot by month_name
ggplot(bike, aes(x=month_name, y= bikes_hired, fill=season_name))+
  geom_boxplot()+
  theme_bw()+
  NULL


#Violin plot by month_name
ggplot(bike, aes(x=month_name, y= bikes_hired))+
  geom_violin()+
  theme_bw()+
  NULL


# Summary stats of bikes hired vs rain and snow
favstats(bikes_hired ~ i_rain_drizzle, data=bike)
favstats(bikes_hired ~ i_rain_drizzle + season_name, data=bike)


favstats(bikes_hired ~ i_snow_ice, data=bike)
favstats(bikes_hired ~ i_snow_ice + season_name, data=bike)

#Boxplot of bikes_hired temperature by rain (TRUE/FALSE)
bike %>% filter(!is.na(i_rain_drizzle)) %>% 
ggplot( aes(x=factor(i_rain_drizzle), y= bikes_hired))+
  geom_boxplot()+
  theme_bw()+
  NULL

#Boxplot of bikes_hired temperature by snow (TRUE/FALSE)
bike %>% filter(!is.na(i_snow_ice)) %>% 
ggplot(aes(x=factor(i_snow_ice), y= bikes_hired))+
  geom_boxplot()+
  theme_bw()+
  NULL


# bikes_hired vs. `temp`, `rh` (relative humidity)`, `slp` (pressure), and `wdsp` (windspeed)
ggplot(bike, aes(x=temp, y= bikes_hired))+
  geom_point()+
  geom_smooth(method = "lm")+
  theme_bw()+
  NULL

ggplot(bike, aes(x=rh, y= bikes_hired))+
  geom_point()+
  geom_smooth(method = "lm")+
  theme_bw()+
  NULL

ggplot(bike, aes(x=slp, y= bikes_hired))+
  geom_point()+
  geom_smooth(method = "lm")+
  theme_bw()+
  NULL

ggplot(bike, aes(x=wdsp, y= bikes_hired))+
  geom_point()+
  geom_smooth(method = "lm")+
  theme_bw()+
  NULL
