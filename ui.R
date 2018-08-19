
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

#checking that the dependencies exist
req.packages=c("shiny","jpeg","tesseract","wordcloud","tm","RColorBrewer","quanteda","DT")
if(any(! req.packages  %in% installed.packages()))
  stop(
    paste0("Not all dependent packages are installed on your computer.\n Please install: ",
           paste(req.packages[!req.packages %in% installed.packages()],collapse=","),
           ". See '?install.packages' for more information on how to install R packages.")
  )

library(shiny)

library(jpeg)
library(tesseract)
library(wordcloud)
library(tm)
library(RColorBrewer)
library(quanteda)
library(DT)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("A simple OCR app - Optical Character Recognition"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
      
      fileInput('file1', 'Choose an image (max 5MB)'),
      tags$hr(),
      numericInput("maxwords", "Max number words in cloud",value=100),
      numericInput("minfreq", "Minimum word frequency in cloud", value=2),
      checkboxInput("stopwords", "Remove (English) stopwords", value = FALSE)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        
                        tabPanel("Overview",

                         h4(p("What this shiny app does")),
                         br(),
                         p("This shiny app does OCR - Optical Character Recognition - by trying to convert alphanumeric text in images, i.e. optical characters, into regular soft copy text.")
                         p("The Optical Recognition part happens via a trained model in Google's Tesseract OCR engine accessed by R's tesseRact package.")
                         p("The app's backend workflow takes an input an image URL, binarizes the image, passes it through tesseract and finally outputs usable soft-copy text. All this backend processing happens in the background and (ideally) requires no user intervention whatsoever.")
                         br(),

                         h4(p("How to use this shiny application")),
                         br(),
                         p("This app require one data input from the user, viz. an image file containing printed text. Click on the Browse (in left side-bar panel) and upload the input file.")
                         p("Note that right now the app works only on standard image files and has an upper limit of 5MB. The clearer the image, the bigger the font, the greater the contrast (ideally white background and black font), the better the results' quality.") 
                         br(),

                         h4(p("Download Sample Input Files")),
                         br(),
                         downloadButton('downloadData', 'Download sample input image file (works only in browsers)'),
                         br(),
                         br(),

			p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -"),
                         img(src = "example1.png") #, height = 280, width = 400

                ),

        
        tabPanel(
          "Introduction",
          htmlOutput("intro")
        ),
        tabPanel(
          "Image & extracted text",
          fluidRow(
            column(
              width=7,
              imageOutput("plaatje")
            ),
            column(
              width=5,
              verbatimTextOutput("OCRtext")
            )
          )
        ),
        tabPanel(
          "Extracted text as sentences",
          DT::dataTableOutput("sentences")
        ),
        tabPanel(
          "Wordcloud",
          plotOutput("cloud", height = "800px")
        )
      )
    )
  )
))
