Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaLTQli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:41:38 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54129 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaLTQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:41:24 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: hal: odm.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 17:44:10 +0100
Message-Id: <1419093850-8610-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
odm_1R_CCA23a() odm_TXPowerTrackingCheckAP() odm_TXPowerTrackingCheckMP()
odm_RSSIMonitorCheck23aAP() odm_RSSIMonitorCheck23aMP() odm_RSSIMonitorInit()
odm_RefreshRateAdaptiveMask23aAPADSL23a() odm_RefreshRateAdaptiveMask23aMP23a()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/hal/odm.c |   81 -----------------------------------
 1 file changed, 81 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index 1c0f106d..6d84fb5 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -187,24 +187,13 @@ void odm23a_DynBBPSInit(struct dm_odm_t *pDM_Odm);
 
 void odm_DynamicBBPowerSaving23a(struct dm_odm_t *pDM_Odm);
 
-void odm_1R_CCA23a(struct dm_odm_t *pDM_Odm);
 /* END---------BB POWER SAVE----------------------- */
 
-void odm_RefreshRateAdaptiveMask23aMP23a(struct dm_odm_t *pDM_Odm);
-
 void odm_RefreshRateAdaptiveMask23aCE23a(struct dm_odm_t *pDM_Odm);
 
-void odm_RefreshRateAdaptiveMask23aAPADSL23a(struct dm_odm_t *pDM_Odm);
-
 void odm_DynamicTxPower23aInit(struct dm_odm_t *pDM_Odm);
 
-void odm_RSSIMonitorInit(struct dm_odm_t *pDM_Odm);
-
-void odm_RSSIMonitorCheck23aMP(struct dm_odm_t *pDM_Odm);
-
 void odm_RSSIMonitorCheck23aCE(struct dm_odm_t *pDM_Odm);
-void odm_RSSIMonitorCheck23aAP(struct dm_odm_t *pDM_Odm);
-
 void odm_RSSIMonitorCheck23a(struct dm_odm_t *pDM_Odm);
 void odm_DynamicTxPower23a(struct dm_odm_t *pDM_Odm);
 
@@ -212,16 +201,12 @@ void odm_RefreshRateAdaptiveMask23a(struct dm_odm_t *pDM_Odm);
 
 void ODM_TXPowerTrackingCheck23a(struct dm_odm_t *pDM_Odm);
 
-void odm_TXPowerTrackingCheckAP(struct dm_odm_t *pDM_Odm);
-
 void odm_RateAdaptiveMaskInit23a(struct dm_odm_t *pDM_Odm);
 
 void odm_TXPowerTrackingThermalMeterInit23a(struct dm_odm_t *pDM_Odm);
 
 void odm_TXPowerTrackingInit23a(struct dm_odm_t *pDM_Odm);
 
-void odm_TXPowerTrackingCheckMP(struct dm_odm_t *pDM_Odm);
-
 void odm_TXPowerTrackingCheckCE23a(struct dm_odm_t *pDM_Odm);
 
 static void odm_EdcaTurboCheck23a(struct dm_odm_t *pDM_Odm);
@@ -946,40 +931,6 @@ void odm_DynamicBBPowerSaving23a(struct dm_odm_t *pDM_Odm)
 	return;
 }
 
-void odm_1R_CCA23a(struct dm_odm_t *pDM_Odm)
-{
-	struct dynamic_pwr_sav *pDM_PSTable = &pDM_Odm->DM_PSTable;
-
-	if (pDM_Odm->RSSI_Min != 0xFF) {
-		if (pDM_PSTable->PreCCAState == CCA_2R) {
-			if (pDM_Odm->RSSI_Min >= 35)
-				pDM_PSTable->CurCCAState = CCA_1R;
-			else
-				pDM_PSTable->CurCCAState = CCA_2R;
-		} else {
-			if (pDM_Odm->RSSI_Min <= 30)
-				pDM_PSTable->CurCCAState = CCA_2R;
-			else
-				pDM_PSTable->CurCCAState = CCA_1R;
-		}
-	} else {
-		pDM_PSTable->CurCCAState = CCA_MAX;
-	}
-
-	if (pDM_PSTable->PreCCAState != pDM_PSTable->CurCCAState) {
-		if (pDM_PSTable->CurCCAState == CCA_1R) {
-			if (pDM_Odm->RFType == ODM_2T2R)
-				ODM_SetBBReg(pDM_Odm, 0xc04, bMaskByte0, 0x13);
-			else
-				ODM_SetBBReg(pDM_Odm, 0xc04, bMaskByte0, 0x23);
-		} else {
-			ODM_SetBBReg(pDM_Odm, 0xc04, bMaskByte0, 0x33);
-			/* PHY_SetBBReg(pAdapter, 0xe70, bMaskByte3, 0x63); */
-		}
-		pDM_PSTable->PreCCAState = pDM_PSTable->CurCCAState;
-	}
-}
-
 void ODM_RF_Saving23a(struct dm_odm_t *pDM_Odm, u8 bForceInNormal)
 {
 	struct dynamic_pwr_sav *pDM_PSTable = &pDM_Odm->DM_PSTable;
@@ -1177,10 +1128,6 @@ void odm_RefreshRateAdaptiveMask23a(struct dm_odm_t *pDM_Odm)
 	odm_RefreshRateAdaptiveMask23aCE23a(pDM_Odm);
 }
 
-void odm_RefreshRateAdaptiveMask23aMP23a(struct dm_odm_t *pDM_Odm)
-{
-}
-
 void odm_RefreshRateAdaptiveMask23aCE23a(struct dm_odm_t *pDM_Odm)
 {
 	u8 i;
@@ -1216,10 +1163,6 @@ void odm_RefreshRateAdaptiveMask23aCE23a(struct dm_odm_t *pDM_Odm)
 
 }
 
-void odm_RefreshRateAdaptiveMask23aAPADSL23a(struct dm_odm_t *pDM_Odm)
-{
-}
-
 /*  Return Value: bool */
 /*  - true: RATRState is changed. */
 bool ODM_RAStateCheck23a(struct dm_odm_t *pDM_Odm, s32 RSSI, bool bForceUpdate,
@@ -1284,14 +1227,6 @@ void odm_DynamicTxPower23aInit(struct dm_odm_t *pDM_Odm)
 	pdmpriv->DynamicTxHighPowerLvl = TxHighPwrLevel_Normal;
 }
 
-/* 3 ============================================================ */
-/* 3 RSSI Monitor */
-/* 3 ============================================================ */
-
-void odm_RSSIMonitorInit(struct dm_odm_t *pDM_Odm)
-{
-}
-
 void odm_RSSIMonitorCheck23a(struct dm_odm_t *pDM_Odm)
 {
 	/*  For AP/ADSL use struct rtl8723a_priv * */
@@ -1306,10 +1241,6 @@ void odm_RSSIMonitorCheck23a(struct dm_odm_t *pDM_Odm)
 	odm_RSSIMonitorCheck23aCE(pDM_Odm);
 }	/*  odm_RSSIMonitorCheck23a */
 
-void odm_RSSIMonitorCheck23aMP(struct dm_odm_t *pDM_Odm)
-{
-}
-
 static void
 FindMinimumRSSI(
 	struct rtw_adapter *pAdapter
@@ -1378,10 +1309,6 @@ void odm_RSSIMonitorCheck23aCE(struct dm_odm_t *pDM_Odm)
 	ODM_CmnInfoUpdate23a(&pHalData->odmpriv, ODM_CMNINFO_RSSI_MIN, pdmpriv->MinUndecoratedPWDBForDM);
 }
 
-void odm_RSSIMonitorCheck23aAP(struct dm_odm_t *pDM_Odm)
-{
-}
-
 /* endif */
 /* 3 ============================================================ */
 /* 3 Tx Power Tracking */
@@ -1422,14 +1349,6 @@ void odm_TXPowerTrackingCheckCE23a(struct dm_odm_t *pDM_Odm)
 {
 }
 
-void odm_TXPowerTrackingCheckMP(struct dm_odm_t *pDM_Odm)
-{
-}
-
-void odm_TXPowerTrackingCheckAP(struct dm_odm_t *pDM_Odm)
-{
-}
-
 /* EDCA Turbo */
 static void ODM_EdcaTurboInit23a(struct dm_odm_t *pDM_Odm)
 {
-- 
1.7.10.4

