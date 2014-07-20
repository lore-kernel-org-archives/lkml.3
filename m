Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaGTHrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 03:47:55 -0400
Received: from alpha.vorteksed.com.mk ([178.79.145.172]:59625 "EHLO
	alpha.vorteksed.com.mk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaGTHry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 03:47:54 -0400
X-Greylist: delayed 749 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2014 03:47:54 EDT
From: Petar Dimitrijevic <petar.dimitrijevic@vorteksed.com.mk>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Petar Dimitrijevic <petar.dimitrijevic@vorteksed.com.mk>
Subject: [PATCH] staging: vt6655: Fixed checkpatch errors
Date: Sun, 20 Jul 2014 09:34:55 +0200
Message-Id: <1405841695-60623-1-git-send-email-petar.dimitrijevic@vorteksed.com.mk>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the errors report by the checkpatch script.
Most of them are use of C99 comments.

The checkpatch doesn't report any errors after the clean up.
However, please not that there are still ton of warnings left.

Signed-off-by: Petar Dimitrijevic <petar.dimitrijevic@vorteksed.com.mk>
---
 drivers/staging/vt6655/datarate.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index f8420d6..83ad74c 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -47,11 +47,12 @@
 
 /*---------------------  Static Classes  ----------------------------*/
 
-extern unsigned short TxRate_iwconfig; //2008-5-8 <add> by chester
+extern unsigned short TxRate_iwconfig; /* 2008-5-8 <add> by chester */
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-static const unsigned char acbyIERate[MAX_RATE] =
-{0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
+static const unsigned char acbyIERate[MAX_RATE] = {
+0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C
+};
 
 #define AUTORATE_TXOK_CNT       0x0400
 #define AUTORATE_TXFAIL_CNT     0x0064
@@ -70,7 +71,7 @@ s_vResetCounter(
 {
 	unsigned char ii;
 
-	// clear statistic counter for auto_rate
+	/* clear statistic counter for auto_rate */
 	for (ii = 0; ii <= MAX_RATE; ii++) {
 		psNodeDBTable->uTxOk[ii] = 0;
 		psNodeDBTable->uTxFail[ii] = 0;
@@ -102,8 +103,8 @@ DATARATEbyGetRateIdx(
 {
 	unsigned char ii;
 
-	//Erase basicRate flag.
-	byRate = byRate & 0x7F;//0111 1111
+	/* Erase basicRate flag. */
+	byRate = byRate & 0x7F;/* 0111 1111 */
 
 	for (ii = 0; ii < MAX_RATE; ii++) {
 		if (acbyIERate[ii] == byRate)
@@ -151,13 +152,14 @@ wGetRateIdx(
 {
 	unsigned short ii;
 
-	//Erase basicRate flag.
-	byRate = byRate & 0x7F;//0111 1111
+	/* Erase basicRate flag. */
+	byRate = byRate & 0x7F;/* 0111 1111 */
 
 	for (ii = 0; ii < MAX_RATE; ii++) {
 		if (acbyIERate[ii] == byRate)
 			return ii;
 	}
+
 	return 0;
 }
 
@@ -218,7 +220,7 @@ RATEvParseMaxRate(
 	for (ii = 0; ii < uRateLen; ii++) {
 		byRate = (unsigned char)(pItemRates->abyRates[ii]);
 		if (WLAN_MGMT_IS_BASICRATE(byRate) && bUpdateBasicRate)  {
-			// Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate
+			/* Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate */
 			CARDbAddBasicRate((void *)pDevice, wGetRateIdx(byRate));
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ParseMaxRate AddBasicRate: %d\n", wGetRateIdx(byRate));
 		}
@@ -238,9 +240,9 @@ RATEvParseMaxRate(
 
 		for (ii = 0; ii < uExtRateLen; ii++) {
 			byRate = (unsigned char)(pItemExtRates->abyRates[ii]);
-			// select highest basic rate
+			/* select highest basic rate */
 			if (WLAN_MGMT_IS_BASICRATE(pItemExtRates->abyRates[ii])) {
-				// Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate
+				/* Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate */
 				CARDbAddBasicRate((void *)pDevice, wGetRateIdx(byRate));
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ParseMaxRate AddBasicRate: %d\n", wGetRateIdx(byRate));
 			}
@@ -302,10 +304,9 @@ RATEvTxRateFallBack(
 	unsigned short wIdxUpRate = 0;
 	unsigned long dwTxDiff = 0;
 
-	if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING) {
-		// Don't do Fallback when scanning Channel
+	if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING)
+		/* Don't do Fallback when scanning Channel */
 		return;
-	}
 
 	psNodeDBTable->uTimeCount++;
 
@@ -357,11 +358,13 @@ RATEvTxRateFallBack(
 		    (psNodeDBTable->uTxFail[MAX_RATE] * 4)) {
 			psNodeDBTable->wTxDataRate = wIdxUpRate;
 		}
-	} else { // adhoc, if uTxOk =0 & uTxFail = 0
+	} else {
+		/* adhoc, if uTxOk =0 & uTxFail = 0 */
 		if (psNodeDBTable->uTxFail[MAX_RATE] == 0)
 			psNodeDBTable->wTxDataRate = wIdxUpRate;
 	}
-//2008-5-8 <add> by chester
+
+	/* 2008-5-8 <add> by chester */
 	TxRate_iwconfig = psNodeDBTable->wTxDataRate;
 	s_vResetCounter(psNodeDBTable);
 
-- 
1.9.1

