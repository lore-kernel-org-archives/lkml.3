Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaADP0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:26:15 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49366 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbaADP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:26:06 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] Staging: vt6656: Correct usage of braces
Date: Sat,  4 Jan 2014 16:25:14 +0100
Message-Id: <1388849118-11994-10-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

Conforming to the linux coding style guidelines, a single line block
of an if statement does not require curly braces unless another block
of the if cascade requires them. Therefore unnecessary curly braces
are removed by this patch and missing ones are added.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index e281d3c..1972a5b 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -104,14 +104,12 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
 		if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
-			(memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)) {
+			(memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0))
 				pbyBSSID = pbyDesireBSSID;
-		}
 	}
 	if (pbyDesireSSID != NULL) {
-		if (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0) {
+		if (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
 			pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
-		}
 	}
 
 	if ((pbyBSSID != NULL) && (pDevice->bRoaming == false)) {
@@ -191,12 +189,11 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 					pCurrBSS->abyBSSID);
 				jj++;
 
-				if (pSelect == NULL) {
+				if (pSelect == NULL)
 					pSelect = pCurrBSS;
 				/* compare RSSI, select the strongest signal */
-				} else if (pCurrBSS->uRSSI < pSelect->uRSSI) {
+				else if (pCurrBSS->uRSSI < pSelect->uRSSI)
 					pSelect = pCurrBSS;
-				}
 			}
 		}
 
@@ -204,9 +201,11 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 
 		if (pSelect != NULL) {
 			pSelect->bSelected = true;
-			if (pDevice->bRoaming == false)  {
+			if (pDevice->bRoaming == false) {
 				/* Einsn Add @20070907 */
-				memcpy(pbyDesireSSID, pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
+				memcpy(pbyDesireSSID,
+				       pCurrBSS->abySSID,
+				       WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			}
 
 			return pSelect;
@@ -374,9 +373,8 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
 		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
 		/* assoc with BSS */
-		if (pBSSList == pMgmt->pCurrBSS) {
+		if (pBSSList == pMgmt->pCurrBSS)
 			bParsingQuiet = true;
-		}
 	}
 
 	WPA_ClearRSN(pBSSList);
@@ -504,11 +502,10 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 		memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
 	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
 
-	if (pExtSuppRates != NULL) {
+	if (pExtSuppRates != NULL)
 		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
-	} else {
+	else
 		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
-	}
 	pBSSList->sERP.byERP = psERP->byERP;
 	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
@@ -529,9 +526,8 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
 		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
 		/* assoc with BSS */
-		if (pBSSList == pMgmt->pCurrBSS) {
+		if (pBSSList == pMgmt->pCurrBSS)
 			bParsingQuiet = true;
-		}
 	}
 
 	WPA_ClearRSN(pBSSList); /* mike update */
@@ -707,9 +703,8 @@ void BSSvUpdateAPNode(struct vnt_private *pDevice,
 	memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
 
 	pMgmt->sNodeDBTable[0].bActive = true;
-	if (pDevice->byBBType == BB_TYPE_11B) {
+	if (pDevice->byBBType == BB_TYPE_11B)
 		uRateLen = WLAN_RATES_MAXLEN_11B;
-	}
 	pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES) pSuppRates,
 						(PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates,
 						uRateLen);
@@ -827,8 +822,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 				PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
 				wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 			}
-		} else if (pDevice->bLinkPass == true)
+		} else if (pDevice->bLinkPass == true) {
 			pDevice->byReAssocCount = 0;
+		}
 	}
 
 	pMgmt->eLastState = pMgmt->eCurrState;
@@ -1119,13 +1115,12 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 	wFIFOCtl = pkt_info[byPktNum].fifo_ctl;
 	pbyDestAddr = pkt_info[byPktNum].dest_addr;
 
-	if (wFIFOCtl & FIFOCTL_AUTO_FB_0) {
+	if (wFIFOCtl & FIFOCTL_AUTO_FB_0)
 		byFallBack = AUTO_FB_0;
-	} else if (wFIFOCtl & FIFOCTL_AUTO_FB_1) {
+	else if (wFIFOCtl & FIFOCTL_AUTO_FB_1)
 		byFallBack = AUTO_FB_1;
-	} else {
+	else
 		byFallBack = AUTO_FB_NONE;
-	}
 
 	/* Only Unicast using support rates */
 	if (wFIFOCtl & FIFOCTL_NEEDACK) {
-- 
1.8.1.2

