#' format_radial
#'
#' Reads in summary data. Checks and organises columns for use in calculating radial IVW and radial MR-Egger estimates. Where variant IDs are not provided, a vector is generated for variant identification.
#'
#' @param BXG A numeric vector of beta-coefficient values for genetic associations with the first variable (exposure).
#' @param BYG A numeric vector of beta-coefficient values for genetic associations with the second variable (outcome).
#' @param seBXG The standard errors corresponding to the beta-coefficients \code{BXG}.
#' @param seBYG The standard errors corresponding to the beta-coefficients \code{BYG}.
#' @param RSID A vector of names for genetic variants included in the analysis. If variant IDs are not provided (\code{RSID="NULL"}), a vector of ID numbers will be generated.
#' @param external_weight An extra weight from external sources.
#' @param external_RSID Names for genetic variants for the external weights.
#' @return A formatted data frame.
#'
#'@author Wes Spiller; Jack Bowden.
#'@references Bowden, J., et al., Improving the visualization, interpretation and analysis of two-sample summary data Mendelian randomization via the Radial plot and Radial regression. International Journal of Epidemiology, 2018. 47(4): p. 1264-1278.
#'@export
#'@examples
#'
#' format_radial(summarydata[,1],summarydata[,3],summarydata[,2],summarydata[,4])
#'

#Function for formatting data frame
#external weight -> change the name

format_radial<-function(BXG, BYG, seBXG, seBYG, RSID, external_weight = NULL, external_RSID = NULL){

  #Generates placeholder SNP IDs if not provided.

  if(missing(RSID)) {
    RSID<-seq(from=1,to=length(BYG),by=1)

    warning("Missing SNP IDs; Generating placeholders")

  }

  #Rearrange variable order in formatted data frame
  F.Data<-data.frame(RSID,BXG,BYG,seBXG,seBYG)
  names(F.Data) <- c("SNP", "beta.exposure", "beta.outcome", "se.exposure", "se.outcome")

  temp <- F.Data

  if (!is.null(external_weight) & !is.null(external_RSID)){

  E.Data <- data.frame(external_RSID, external_weight)
  names(E.Data) <- c("SNP", "weight.external")

  if(length(F.Data$SNP) == length(E.Data$SNP)) {

   temp <- merge(F.Data, E.Data, by = c("SNP"))

  }

  if(length(F.Data$SNP) != length(E.Data$SNP)) {

  temp <- merge(F.Data, E.Data, by = c("SNP"), all.x = TRUE)

  message("Removing the following SNPs for having missing values in external weights:\n", paste(F.Data$SNP[!(F.Data$SNP %in% E.Data$SNP)], collapse=", "))

  }
  }

  return(temp)

}
