Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaADP1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:27:17 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49403 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbaADP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:26:12 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] Staging: vt6656: Remove bogus parentheses in conditions
Date: Sat,  4 Jan 2014 16:25:16 +0100
Message-Id: <1388849118-11994-12-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unrequired parentheses around comparisons in complex
conditions.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 138 ++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index c780869..b71bc33 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -103,41 +103,41 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 	if (pbyDesireBSSID != NULL) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
-		if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
-			(memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0))
+		if (!is_broadcast_ether_addr(pbyDesireBSSID) &&
+			memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)
 				pbyBSSID = pbyDesireBSSID;
 	}
-	if ((pbyDesireSSID != NULL) &&
-	    (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0))
+	if (pbyDesireSSID != NULL &&
+	    ((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
 		pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
 
-	if ((pbyBSSID != NULL) && (pDevice->bRoaming == false)) {
+	if (pbyBSSID != NULL && pDevice->bRoaming == false) {
 		/* match BSSID first */
 		for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 			pCurrBSS = &(pMgmt->sBSSList[ii]);
 
 			pCurrBSS->bSelected = false;
 
-			if ((pCurrBSS->bActive) &&
-			    (pCurrBSS->bSelected == false) &&
-			    (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID))) {
+			if (pCurrBSS->bActive &&
+			    pCurrBSS->bSelected == false &&
+			    ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
 				if (pSSID != NULL) {
 					/* compare ssid */
-					if ((!memcmp(pSSID->abySSID,
+					if (!memcmp(pSSID->abySSID,
 						     ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
-						     pSSID->len)) &&
-					    ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
-					     ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) &&
+						     pSSID->len) &&
+					    (pMgmt->eConfigMode == WMAC_CONFIG_AUTO ||
+					     (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA &&
 					      WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-					     ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) &&
+					     (pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA &&
 					      WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)))) {
 
 						pCurrBSS->bSelected = true;
 						return pCurrBSS;
 					}
-				} else if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
-					((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
+				} else if (pMgmt->eConfigMode == WMAC_CONFIG_AUTO ||
+					(pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
+					(pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
 					pCurrBSS->bSelected = true;
 					return pCurrBSS;
 				}
@@ -155,30 +155,30 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			pCurrBSS->bSelected = false;
 			if (pCurrBSS->bActive) {
 
-				if ((pSSID != NULL) &&
+				if (pSSID != NULL &&
 				    /* matched SSID */
 				    (memcmp(pSSID->abySSID,
 					    ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
 					    pSSID->len) ||
-				     (pSSID->len !=
-					((PWLAN_IE_SSID) pCurrBSS->abySSID)->len))) {
+				     pSSID->len !=
+					((PWLAN_IE_SSID) pCurrBSS->abySSID)->len)) {
 					/* SSID not match skip this BSS */
 					continue;
 				}
 
-				if (((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
-					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
+				if ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
+					(pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
 					) {
 					/* Type not match skip this BSS */
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSS type mismatch.... Config[%d] BSS[0x%04x]\n", pMgmt->eConfigMode, pCurrBSS->wCapInfo);
 					continue;
 				}
 
-				if ((ePhyType != PHY_TYPE_AUTO) &&
-				    (((ePhyType == PHY_TYPE_11A) &&
-				     (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse)) ||
-				    ((ePhyType != PHY_TYPE_11A) &&
-				     (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse)))) {
+				if (ePhyType != PHY_TYPE_AUTO &&
+				    ((ePhyType == PHY_TYPE_11A &&
+				     PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse) ||
+				    (ePhyType != PHY_TYPE_11A &&
+				     PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
 					/* PhyType not match skip this BSS */
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
 					continue;
@@ -268,12 +268,12 @@ PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 		pBSSList = &(pMgmt->sBSSList[ii]);
-		if ((pBSSList->bActive) &&
-		    (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) &&
-		    (pSSID->len == ((PWLAN_IE_SSID) pBSSList->abySSID)->len) &&
-		    (memcmp(pSSID->abySSID,
+		if (pBSSList->bActive &&
+		    ether_addr_equal(pBSSList->abyBSSID, abyBSSID) &&
+		    pSSID->len == ((PWLAN_IE_SSID) pBSSList->abySSID)->len &&
+		    memcmp(pSSID->abySSID,
 			    ((PWLAN_IE_SSID) pBSSList->abySSID)->abySSID,
-			    pSSID->len) == 0))
+			    pSSID->len) == 0)
 			return pBSSList;
 	}
 
@@ -367,10 +367,10 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	pBSSList->uRSSI = pRxPacket->uRSSI;
 	pBSSList->bySQ = pRxPacket->bySQ;
 
-	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
-	    (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA &&
+	    pMgmt->eCurrState == WMAC_STATE_ASSOC &&
 	    /* assoc with BSS */
-	    (pBSSList == pMgmt->pCurrBSS))
+	    pBSSList == pMgmt->pCurrBSS)
 		bParsingQuiet = true;
 
 	WPA_ClearRSN(pBSSList);
@@ -399,7 +399,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 		}
 	}
 
-	if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) || (pBSSList->bWPA2Valid == true)) {
+	if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2 || pBSSList->bWPA2Valid == true) {
 
 		PSKeyItem  pTransmitKey = NULL;
 		bool	   bIs802_1x = false;
@@ -410,23 +410,23 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 				break;
 			}
 		}
-		if ((bIs802_1x == true) && (pSSID->len == ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->len) &&
-			(!memcmp(pSSID->abySSID, ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->abySSID, pSSID->len))) {
+		if (bIs802_1x == true && pSSID->len == ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->len &&
+			!memcmp(pSSID->abySSID, ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->abySSID, pSSID->len)) {
 
 			bAdd_PMKID_Candidate((void *) pDevice,
 					 pBSSList->abyBSSID,
 					 &pBSSList->sRSNCapObj);
 
-			if ((pDevice->bLinkPass == true) &&
-			    (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
-			    ((KeybGetTransmitKey(&(pDevice->sKey),
+			if (pDevice->bLinkPass == true &&
+			    pMgmt->eCurrState == WMAC_STATE_ASSOC &&
+			    (KeybGetTransmitKey(&(pDevice->sKey),
 						 pDevice->abyBSSID,
 						 PAIRWISE_KEY,
-						 &pTransmitKey) == true) ||
-			     (KeybGetTransmitKey(&(pDevice->sKey),
+						 &pTransmitKey) == true ||
+			     KeybGetTransmitKey(&(pDevice->sKey),
 						 pDevice->abyBSSID,
 						 GROUP_KEY,
-						 &pTransmitKey) == true))) {
+						 &pTransmitKey) == true)) {
 				pDevice->gsPMKIDCandidate.StatusType = Ndis802_11StatusType_PMKID_CandidateList;
 				pDevice->gsPMKIDCandidate.Version = 1;
 
@@ -500,7 +500,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	if (pSSID->len > WLAN_SSID_MAXLEN)
 		pSSID->len = WLAN_SSID_MAXLEN;
 
-	if ((pSSID->len != 0) && (pSSID->abySSID[0] != 0))
+	if (pSSID->len != 0 && pSSID->abySSID[0] != 0)
 		memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
 	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
 
@@ -525,10 +525,10 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 		pBSSList->uRSSI = pRxPacket->uRSSI;
 	pBSSList->bySQ = pRxPacket->bySQ;
 
-	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
-	    (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA &&
+	    pMgmt->eCurrState == WMAC_STATE_ASSOC &&
 	    /* assoc with BSS */
-	    (pBSSList == pMgmt->pCurrBSS))
+	    pBSSList == pMgmt->pCurrBSS)
 		bParsingQuiet = true;
 
 	WPA_ClearRSN(pBSSList); /* mike update */
@@ -598,9 +598,9 @@ int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
 
 	/* Index = 0 reserved for AP Node */
 	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
-		if ((pMgmt->sNodeDBTable[ii].bActive) &&
-		    (ether_addr_equal(abyDstAddr,
-				      pMgmt->sNodeDBTable[ii].abyMACAddr))) {
+		if (pMgmt->sNodeDBTable[ii].bActive &&
+		    ether_addr_equal(abyDstAddr,
+				     pMgmt->sNodeDBTable[ii].abyMACAddr)) {
 			*puNodeIndex = ii;
 			return true;
 		}
@@ -811,7 +811,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	if (pDevice->byReAssocCount > 0) {
 		pDevice->byReAssocCount++;
-		if ((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  /* 10 sec timeout */
+		if (pDevice->byReAssocCount > 10 && pDevice->bLinkPass != true) {  /* 10 sec timeout */
 			printk("Re-association timeout!!!\n");
 			pDevice->byReAssocCount = 0;
 			/* if (pDevice->bWPASuppWextEnabled == true) */
@@ -888,7 +888,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 			if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending\n",
 						   ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
-				if ((ii > 0) && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
+				if (ii > 0 && pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15) {
 					BSSvRemoveOneNode(pDevice, ii);
 					DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove\n", ii);
 					continue;
@@ -898,7 +898,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	}
 
-	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->byBBType == BB_TYPE_11G)) {
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->byBBType == BB_TYPE_11G) {
 
 		/* on/off protect mode */
 		if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
@@ -949,8 +949,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 	pItemSSID = (PWLAN_IE_SSID) pMgmt->abyDesireSSID;
 	pCurrSSID = (PWLAN_IE_SSID) pMgmt->abyCurrSSID;
 
-	if ((pMgmt->eCurrMode == WMAC_MODE_STANDBY) ||
-		(pMgmt->eCurrMode == WMAC_MODE_ESS_STA)) {
+	if (pMgmt->eCurrMode == WMAC_MODE_STANDBY ||
+		pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 
 		if (pMgmt->sNodeDBTable[0].bActive) { /* Assoc with BSS */
 
@@ -959,8 +959,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 				s_vCheckPreEDThreshold(pDevice);
 			}
 
-			if ((pMgmt->sNodeDBTable[0].uInActiveCount >= (LOST_BEACON_COUNT/2)) &&
-				(pDevice->byBBVGACurrent != pDevice->abyBBVGA[0])) {
+			if (pMgmt->sNodeDBTable[0].uInActiveCount >= (LOST_BEACON_COUNT/2) &&
+				pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) {
 				pDevice->byBBVGANew = pDevice->abyBBVGA[0];
 				bScheduleCommand((void *) pDevice,
 					WLAN_CMD_CHANGE_BBSENSITIVITY,
@@ -1004,7 +1004,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 					pDevice->uAutoReConnectTime = 0;
 					pDevice->uIsroamingTime = 0;
 					pDevice->bRoaming = false;
-				} else if ((pDevice->bRoaming == false) && (pDevice->bIsRoaming == true)) {
+				} else if (pDevice->bRoaming == false && pDevice->bIsRoaming == true) {
 					pDevice->uIsroamingTime++;
 					if (pDevice->uIsroamingTime >= 20)
 						pDevice->bIsRoaming = false;
@@ -1035,7 +1035,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 		/* if adhoc started which essid is NULL string, rescanning. */
-		if ((pMgmt->eCurrState == WMAC_STATE_STARTED) && (pCurrSSID->len == 0)) {
+		if (pMgmt->eCurrState == WMAC_STATE_STARTED && pCurrSSID->len == 0) {
 			if (pDevice->uAutoReConnectTime < 10) {
 				pDevice->uAutoReConnectTime++;
 			} else {
@@ -1149,8 +1149,8 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 			pMgmt->sNodeDBTable[0].uTxRetry += byTxRetry;
 			if (byTxRetry != 0) {
 				pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE] += byTxRetry;
-				if ((byFallBack == AUTO_FB_NONE) ||
-					(wRate < RATE_18M)) {
+				if (byFallBack == AUTO_FB_NONE ||
+					wRate < RATE_18M) {
 					pMgmt->sNodeDBTable[0].uTxFail[wRate] += byTxRetry;
 				} else if (byFallBack == AUTO_FB_0) {
 					for (ii = 0; ii < byTxRetry; ii++) {
@@ -1176,11 +1176,11 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 			}
 		}
 
-		if (((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
-		     (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) &&
-		    (BSSbIsSTAInNodeDB((void *) pDevice,
+		if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA ||
+		     pMgmt->eCurrMode == WMAC_MODE_ESS_AP) &&
+		    BSSbIsSTAInNodeDB((void *) pDevice,
 				       pbyDestAddr,
-				       &uNodeIndex))) {
+				       &uNodeIndex)) {
 			pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
 			if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
 				/* transmit success, TxAttempts at least plus one */
@@ -1274,8 +1274,8 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	int ii;
 
-	if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
-		((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
+	if (pMgmt->eCurrState == WMAC_STATE_ASSOC ||
+		(pMgmt->eCurrMode == WMAC_MODE_IBSS_STA && pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
 		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
 		if (pBSSList != NULL) {
 			/* Update BB register if RSSI is too strong */
@@ -1364,8 +1364,8 @@ static void s_vCheckPreEDThreshold(struct vnt_private *pDevice)
 	PKnownBSS pBSSList = NULL;
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
-	if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
-		((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
+	if (pMgmt->eCurrState == WMAC_STATE_ASSOC ||
+		(pMgmt->eCurrMode == WMAC_MODE_IBSS_STA && pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
 		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
 		if (pBSSList != NULL) {
 			pDevice->byBBPreEDRSSI = (u8) (~(pBSSList->ldBmAverRange) + 1);
-- 
1.8.1.2

