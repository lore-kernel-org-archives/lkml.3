Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaADP0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:26:21 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49437 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038AbaADP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:26:17 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] Staging: vt6656: Reduce line length of bssdb.c
Date: Sat,  4 Jan 2014 16:25:18 +0100
Message-Id: <1388849118-11994-14-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

Long lines are split into multiple ones to reduce the line length.
Additionally some alignment fixes are made that previous patches
missed.

Unfortunately, due to the high indentation levels present in parts of
bssdb.c, this patch leaves some lines which are longer than 80
characters.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 301 +++++++++++++++++++++++++++--------------
 1 file changed, 201 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 6662d6e..9c78dab 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -104,8 +104,8 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
 		if (!is_broadcast_ether_addr(pbyDesireBSSID) &&
-			memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)
-				pbyBSSID = pbyDesireBSSID;
+		    memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)
+			pbyBSSID = pbyDesireBSSID;
 	}
 	if (pbyDesireSSID &&
 	    ((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
@@ -136,8 +136,10 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 						return pCurrBSS;
 					}
 				} else if (pMgmt->eConfigMode == WMAC_CONFIG_AUTO ||
-					(pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
-					(pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
+					   (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA &&
+					    WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
+					   (pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA &&
+					    WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {
 					pCurrBSS->bSelected = true;
 					return pCurrBSS;
 				}
@@ -166,11 +168,15 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 					continue;
 				}
 
-				if ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
-					(pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
-					) {
+				if ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA &&
+				     WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
+				    (pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA &&
+				     WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))) {
 					/* Type not match skip this BSS */
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSS type mismatch.... Config[%d] BSS[0x%04x]\n", pMgmt->eConfigMode, pCurrBSS->wCapInfo);
+					DBG_PRT(MSG_LEVEL_DEBUG,
+						KERN_INFO "BSS type mismatch.... Config[%d] BSS[0x%04x]\n",
+						pMgmt->eConfigMode,
+						pCurrBSS->wCapInfo);
 					continue;
 				}
 
@@ -180,7 +186,10 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 				    (ePhyType != PHY_TYPE_11A &&
 				     PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
 					/* PhyType not match skip this BSS */
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
+					DBG_PRT(MSG_LEVEL_DEBUG,
+						KERN_INFO "Physical type mismatch.... ePhyType[%d] BSS[%d]\n",
+						ePhyType,
+						pCurrBSS->eNetworkTypeInUse);
 					continue;
 				}
 
@@ -232,7 +241,7 @@ void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 		if (bKeepCurrBSSID &&
 		    pMgmt->sBSSList[ii].bActive &&
 		    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
-			             pMgmt->abyCurrBSSID)) {
+				     pMgmt->abyCurrBSSID)) {
 
 			/* mike mark:
 			 * there are two BSSID's in list. If that AP is
@@ -321,7 +330,8 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	}
 
 	if (ii == MAX_BSS_NUM) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get free KnowBSS node failed.\n");
+		DBG_PRT(MSG_LEVEL_DEBUG,
+			KERN_INFO "Get free KnowBSS node failed.\n");
 		return false;
 	}
 	/* save the BSS info */
@@ -340,16 +350,21 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 
 	if (pSuppRates->len > WLAN_RATES_MAXLEN)
 		pSuppRates->len = WLAN_RATES_MAXLEN;
-	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
+	memcpy(pBSSList->abySuppRates, pSuppRates,
+	       pSuppRates->len + WLAN_IEHDR_LEN);
 
 	if (pExtSuppRates) {
 		if (pExtSuppRates->len > WLAN_RATES_MAXLEN)
 			pExtSuppRates->len = WLAN_RATES_MAXLEN;
-		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSbInsertToBSSList: pExtSuppRates->len = %d\n", pExtSuppRates->len);
+		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates,
+		       pExtSuppRates->len + WLAN_IEHDR_LEN);
+		DBG_PRT(MSG_LEVEL_DEBUG,
+			KERN_INFO "BSSbInsertToBSSList: pExtSuppRates->len = %d\n",
+			pExtSuppRates->len);
 
 	} else {
-		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
+		memset(pBSSList->abyExtSuppRates, 0,
+		       WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 	}
 	pBSSList->sERP.byERP = psERP->byERP;
 	pBSSList->sERP.bERPExist = psERP->bERPExist;
@@ -379,7 +394,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 		unsigned int uLen = pRSNWPA->len + 2;
 
 		if (uLen <= (uIELength -
-				(unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
+			     (unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
 			pBSSList->wWPALen = uLen;
 			memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
 			WPA_ParseRSN(pBSSList, pRSNWPA);
@@ -392,26 +407,31 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 		unsigned int uLen = pRSN->len + 2;
 
 		if (uLen <= (uIELength -
-				(unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
+			     (unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
 			pBSSList->wRSNLen = uLen;
 			memcpy(pBSSList->byRSNIE, pRSN, uLen);
 			WPA2vParseRSN(pBSSList, pRSN);
 		}
 	}
 
-	if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2 || pBSSList->bWPA2Valid == true) {
+	if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2 ||
+	    pBSSList->bWPA2Valid == true) {
 
 		PSKeyItem  pTransmitKey = NULL;
 		bool	   bIs802_1x = false;
 
 		for (ii = 0; ii < pBSSList->wAKMSSAuthCount; ii++) {
-			if (pBSSList->abyAKMSSAuthType[ii] == WLAN_11i_AKMSS_802_1X) {
+			if (pBSSList->abyAKMSSAuthType[ii] ==
+					WLAN_11i_AKMSS_802_1X) {
 				bIs802_1x = true;
 				break;
 			}
 		}
-		if (bIs802_1x == true && pSSID->len == ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->len &&
-			!memcmp(pSSID->abySSID, ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->abySSID, pSSID->len)) {
+		if (bIs802_1x == true &&
+		    pSSID->len == ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->len &&
+		    !memcmp(pSSID->abySSID,
+			     ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->abySSID,
+			     pSSID->len)) {
 
 			bAdd_PMKID_Candidate((void *) pDevice,
 					 pBSSList->abyBSSID,
@@ -427,7 +447,8 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 						 pDevice->abyBSSID,
 						 GROUP_KEY,
 						 &pTransmitKey) == true)) {
-				pDevice->gsPMKIDCandidate.StatusType = Ndis802_11StatusType_PMKID_CandidateList;
+				pDevice->gsPMKIDCandidate.StatusType =
+					Ndis802_11StatusType_PMKID_CandidateList;
 				pDevice->gsPMKIDCandidate.Version = 1;
 
 
@@ -438,7 +459,8 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	if (pDevice->bUpdateBBVGA) {
 		/* Monitor if RSSI is too strong. */
 		pBSSList->byRSSIStatCnt = 0;
-		RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI), &pBSSList->ldBmMAX);
+		RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI),
+			     &pBSSList->ldBmMAX);
 		pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
 		pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
 		for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
@@ -502,12 +524,15 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 
 	if (pSSID->len != 0 && pSSID->abySSID[0] != 0)
 		memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
-	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
+	memcpy(pBSSList->abySuppRates, pSuppRates,
+	       pSuppRates->len + WLAN_IEHDR_LEN);
 
 	if (pExtSuppRates)
-		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
+		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates,
+		       pExtSuppRates->len + WLAN_IEHDR_LEN);
 	else
-		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
+		memset(pBSSList->abyExtSuppRates, 0,
+		       WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 	pBSSList->sERP.byERP = psERP->byERP;
 	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
@@ -536,7 +561,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	if (pRSNWPA) {
 		unsigned int uLen = pRSNWPA->len + 2;
 		if (uLen <= (uIELength -
-				(unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
+			     (unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
 			pBSSList->wWPALen = uLen;
 			memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
 			WPA_ParseRSN(pBSSList, pRSNWPA);
@@ -548,7 +573,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	if (pRSN) {
 		unsigned int uLen = pRSN->len + 2;
 		if (uLen <= (uIELength -
-				(unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
+			     (unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
 			pBSSList->wRSNLen = uLen;
 			memcpy(pBSSList->byRSNIE, pRSN, uLen);
 			WPA2vParseRSN(pBSSList, pRSN);
@@ -631,7 +656,8 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
 		if (pMgmt->sNodeDBTable[ii].bActive) {
 			if (pMgmt->sNodeDBTable[ii].uInActiveCount > BigestCount) {
-				BigestCount = pMgmt->sNodeDBTable[ii].uInActiveCount;
+				BigestCount =
+					pMgmt->sNodeDBTable[ii].uInActiveCount;
 				SelectIndex = ii;
 			}
 		} else {
@@ -642,7 +668,8 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 	/* if not found replace uInActiveCount with the largest one. */
 	if (ii == (MAX_NODE_NUM + 1)) {
 		*puNodeIndex = SelectIndex;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
+		DBG_PRT(MSG_LEVEL_DEBUG,
+			KERN_INFO "Replace inactive node = %d\n", SelectIndex);
 		/* clear ps buffer */
 		if (pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue.next) {
 			while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)))
@@ -681,7 +708,8 @@ void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 	/* clear context */
 	memset(&pMgmt->sNodeDBTable[uNodeIndex], 0, sizeof(KnownNodeDB));
 	/* clear tx bit map */
-	pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[uNodeIndex].wAID >> 3] &=  ~byMask[pMgmt->sNodeDBTable[uNodeIndex].wAID & 7];
+	pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[uNodeIndex].wAID >> 3] &=
+		~byMask[pMgmt->sNodeDBTable[uNodeIndex].wAID & 7];
 }
 
 /*
@@ -709,8 +737,8 @@ void BSSvUpdateAPNode(struct vnt_private *pDevice,
 						(PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates,
 						uRateLen);
 	pMgmt->abyCurrExtSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES) pExtSuppRates,
-						(PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates,
-						uRateLen);
+						   (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates,
+						   uRateLen);
 	RATEvParseMaxRate((void *) pDevice,
 			  (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates,
 			  (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates,
@@ -720,13 +748,17 @@ void BSSvUpdateAPNode(struct vnt_private *pDevice,
 			  &(pMgmt->sNodeDBTable[0].wSuppRate),
 			  &(pMgmt->sNodeDBTable[0].byTopCCKBasicRate),
 			  &(pMgmt->sNodeDBTable[0].byTopOFDMBasicRate));
-	memcpy(pMgmt->sNodeDBTable[0].abyMACAddr, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
+	memcpy(pMgmt->sNodeDBTable[0].abyMACAddr, pMgmt->abyCurrBSSID,
+	       WLAN_ADDR_LEN);
 	pMgmt->sNodeDBTable[0].wTxDataRate = pMgmt->sNodeDBTable[0].wMaxSuppRate;
-	pMgmt->sNodeDBTable[0].bShortPreamble = WLAN_GET_CAP_INFO_SHORTPREAMBLE(*pwCapInfo);
+	pMgmt->sNodeDBTable[0].bShortPreamble =
+			WLAN_GET_CAP_INFO_SHORTPREAMBLE(*pwCapInfo);
 	pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
 	/* Auto rate fallback function initiation.
 	 * RATEbInit(pDevice); */
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d\n", pMgmt->sNodeDBTable[0].wTxDataRate);
+	DBG_PRT(MSG_LEVEL_DEBUG,
+		KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d\n",
+		pMgmt->sNodeDBTable[0].wTxDataRate);
 
 }
 
@@ -811,7 +843,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	if (pDevice->byReAssocCount > 0) {
 		pDevice->byReAssocCount++;
-		if (pDevice->byReAssocCount > 10 && pDevice->bLinkPass != true) {  /* 10 sec timeout */
+		if (pDevice->byReAssocCount > 10 &&
+		    pDevice->bLinkPass != true) { /* 10 sec timeout */
 			printk("Re-association timeout!!!\n");
 			pDevice->byReAssocCount = 0;
 			/* if (pDevice->bWPASuppWextEnabled == true) */
@@ -820,7 +853,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 				memset(&wrqu, 0, sizeof(wrqu));
 				wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 				PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
-				wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
+				wireless_send_event(pDevice->dev, SIOCGIWAP,
+						    &wrqu, NULL);
 			}
 		} else if (pDevice->bLinkPass == true) {
 			pDevice->byReAssocCount = 0;
@@ -838,26 +872,33 @@ void BSSvSecondCallBack(struct work_struct *work)
 			pMgmt->sNodeDBTable[ii].uInActiveCount++;
 
 			if (ii > 0) {
-				if (pMgmt->sNodeDBTable[ii].uInActiveCount > MAX_INACTIVE_COUNT) {
+				if (pMgmt->sNodeDBTable[ii].uInActiveCount >
+						MAX_INACTIVE_COUNT) {
 					BSSvRemoveOneNode(pDevice, ii);
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-						"Inactive timeout [%d] sec, STA index = [%d] remove\n", MAX_INACTIVE_COUNT, ii);
+						"Inactive timeout [%d] sec, STA index = [%d] remove\n",
+						MAX_INACTIVE_COUNT, ii);
 					continue;
 				}
 
-				if (pMgmt->sNodeDBTable[ii].eNodeState >= NODE_ASSOC) {
+				if (pMgmt->sNodeDBTable[ii].eNodeState >=
+						NODE_ASSOC) {
 
 					pDevice->uAssocCount++;
 
 					/* check if Non ERP exist */
-					if (pMgmt->sNodeDBTable[ii].uInActiveCount < ERP_RECOVER_COUNT) {
+					if (pMgmt->sNodeDBTable[ii].uInActiveCount <
+							ERP_RECOVER_COUNT) {
 						if (!pMgmt->sNodeDBTable[ii].bShortPreamble) {
-							pDevice->byERPFlag |= WLAN_SET_ERP_BARKER_MODE(1);
+							pDevice->byERPFlag |=
+								WLAN_SET_ERP_BARKER_MODE(1);
 							uLongPreambleSTACnt++;
 						}
 						if (!pMgmt->sNodeDBTable[ii].bERPExist) {
-							pDevice->byERPFlag |= WLAN_SET_ERP_NONERP_PRESENT(1);
-							pDevice->byERPFlag |= WLAN_SET_ERP_USE_PROTECTION(1);
+							pDevice->byERPFlag |=
+								WLAN_SET_ERP_NONERP_PRESENT(1);
+							pDevice->byERPFlag |=
+								WLAN_SET_ERP_USE_PROTECTION(1);
 						}
 						if (!pMgmt->sNodeDBTable[ii].bShortSlotTime)
 							uNonShortSlotSTACnt++;
@@ -886,11 +927,16 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 			/* check if pending PS queue */
 			if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending\n",
-						   ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
-				if (ii > 0 && pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15) {
+				DBG_PRT(MSG_LEVEL_DEBUG,
+					KERN_INFO "Index= %d, Queue = %d pending\n",
+					ii,
+					pMgmt->sNodeDBTable[ii].wEnQueueCnt);
+				if (ii > 0 &&
+				    pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15) {
 					BSSvRemoveOneNode(pDevice, ii);
-					DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove\n", ii);
+					DBG_PRT(MSG_LEVEL_NOTICE,
+						KERN_INFO "Pending many queues PS STA Index = %d remove\n",
+						ii);
 					continue;
 				}
 			}
@@ -898,7 +944,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	}
 
-	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->byBBType == BB_TYPE_11G) {
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP &&
+	    pDevice->byBBType == BB_TYPE_11G) {
 
 		/* on/off protect mode */
 		if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
@@ -950,7 +997,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 	pCurrSSID = (PWLAN_IE_SSID) pMgmt->abyCurrSSID;
 
 	if (pMgmt->eCurrMode == WMAC_MODE_STANDBY ||
-		pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
+	    pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 
 		if (pMgmt->sNodeDBTable[0].bActive) { /* Assoc with BSS */
 
@@ -959,52 +1006,71 @@ void BSSvSecondCallBack(struct work_struct *work)
 				s_vCheckPreEDThreshold(pDevice);
 			}
 
-			if (pMgmt->sNodeDBTable[0].uInActiveCount >= (LOST_BEACON_COUNT/2) &&
-				pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) {
+			if (pMgmt->sNodeDBTable[0].uInActiveCount >=
+							(LOST_BEACON_COUNT/2) &&
+			    pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) {
 				pDevice->byBBVGANew = pDevice->abyBBVGA[0];
 				bScheduleCommand((void *) pDevice,
-					WLAN_CMD_CHANGE_BBSENSITIVITY,
-					NULL);
+						 WLAN_CMD_CHANGE_BBSENSITIVITY,
+						 NULL);
 			}
 
-			if (pMgmt->sNodeDBTable[0].uInActiveCount >= LOST_BEACON_COUNT) {
+			if (pMgmt->sNodeDBTable[0].uInActiveCount >=
+					LOST_BEACON_COUNT) {
 				pMgmt->sNodeDBTable[0].bActive = false;
 				pMgmt->eCurrMode = WMAC_MODE_STANDBY;
 				pMgmt->eCurrState = WMAC_STATE_IDLE;
 				netif_stop_queue(pDevice->dev);
 				pDevice->bLinkPass = false;
-				ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+				ControlvMaskByte(pDevice,
+						 MESSAGE_REQUEST_MACREG,
+						 MAC_REG_PAPEDELAY, LEDSTS_STS,
+						 LEDSTS_SLOW);
 				pDevice->bRoaming = true;
 				pDevice->bIsRoaming = false;
 
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost AP beacon [%d] sec, disconnected !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
+				DBG_PRT(MSG_LEVEL_NOTICE,
+					KERN_INFO "Lost AP beacon [%d] sec, disconnected !\n",
+					pMgmt->sNodeDBTable[0].uInActiveCount);
 				/* let wpa supplicant know AP may disconnect */
 				{
 					union iwreq_data  wrqu;
 					memset(&wrqu, 0, sizeof(wrqu));
 						wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 					PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
-					wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
+					wireless_send_event(pDevice->dev,
+							    SIOCGIWAP,
+							    &wrqu,
+							    NULL);
 				}
 			}
 		} else if (pItemSSID->len != 0) {
 			/* Davidwang */
-			if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming);
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming);
-				if ((pDevice->bRoaming == true) && (pDevice->bIsRoaming == true)) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fast   Roaming ...\n");
-					BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
+			if ((pDevice->bEnableRoaming == true) &&
+			    (!(pMgmt->Cisco_cckm))) {
+				DBG_PRT(MSG_LEVEL_DEBUG,
+					KERN_INFO "bRoaming %d, !\n",
+					pDevice->bRoaming);
+				DBG_PRT(MSG_LEVEL_DEBUG,
+					KERN_INFO "bIsRoaming %d, !\n",
+					pDevice->bIsRoaming);
+				if ((pDevice->bRoaming == true) &&
+				    (pDevice->bIsRoaming == true)) {
+					DBG_PRT(MSG_LEVEL_DEBUG,
+						KERN_INFO "Fast   Roaming ...\n");
+					BSSvClearBSSList((void *) pDevice,
+							 pDevice->bLinkPass);
 					bScheduleCommand((void *) pDevice,
-						WLAN_CMD_BSSID_SCAN,
-						pMgmt->abyDesireSSID);
+							 WLAN_CMD_BSSID_SCAN,
+							 pMgmt->abyDesireSSID);
 					bScheduleCommand((void *) pDevice,
-						WLAN_CMD_SSID,
-						pMgmt->abyDesireSSID);
+							 WLAN_CMD_SSID,
+							 pMgmt->abyDesireSSID);
 					pDevice->uAutoReConnectTime = 0;
 					pDevice->uIsroamingTime = 0;
 					pDevice->bRoaming = false;
-				} else if (pDevice->bRoaming == false && pDevice->bIsRoaming == true) {
+				} else if (pDevice->bRoaming == false &&
+					   pDevice->bIsRoaming == true) {
 					pDevice->uIsroamingTime++;
 					if (pDevice->uIsroamingTime >= 20)
 						pDevice->bIsRoaming = false;
@@ -1017,10 +1083,13 @@ void BSSvSecondCallBack(struct work_struct *work)
 			} else {
 				/* mike use old encryption status for wpa reauthen */
 				if (pDevice->bWPADEVUp)
-					pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
+					pDevice->eEncryptionStatus =
+						pDevice->eOldEncryptionStatus;
 
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming ...\n");
-				BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
+				DBG_PRT(MSG_LEVEL_DEBUG,
+					KERN_INFO "Roaming ...\n");
+				BSSvClearBSSList((void *) pDevice,
+						 pDevice->bLinkPass);
 				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 				bScheduleCommand((void *) pDevice,
 						 WLAN_CMD_BSSID_SCAN,
@@ -1035,14 +1104,18 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 		/* if adhoc started which essid is NULL string, rescanning. */
-		if (pMgmt->eCurrState == WMAC_STATE_STARTED && pCurrSSID->len == 0) {
+		if (pMgmt->eCurrState == WMAC_STATE_STARTED &&
+		    pCurrSSID->len == 0) {
 			if (pDevice->uAutoReConnectTime < 10) {
 				pDevice->uAutoReConnectTime++;
 			} else {
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scanning ...\n");
+				DBG_PRT(MSG_LEVEL_NOTICE,
+					KERN_INFO "Adhoc re-scanning ...\n");
 				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
-				bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
-				bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
+				bScheduleCommand((void *) pDevice,
+						 WLAN_CMD_BSSID_SCAN, NULL);
+				bScheduleCommand((void *) pDevice,
+						 WLAN_CMD_SSID, NULL);
 				pDevice->uAutoReConnectTime = 0;
 			}
 		}
@@ -1052,13 +1125,19 @@ void BSSvSecondCallBack(struct work_struct *work)
 				s_vCheckSensitivity(pDevice);
 				s_vCheckPreEDThreshold(pDevice);
 			}
-			if (pMgmt->sNodeDBTable[0].uInActiveCount >= ADHOC_LOST_BEACON_COUNT) {
-				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost other STA beacon [%d] sec, started !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
+			if (pMgmt->sNodeDBTable[0].uInActiveCount >=
+						ADHOC_LOST_BEACON_COUNT) {
+				DBG_PRT(MSG_LEVEL_NOTICE,
+					KERN_INFO "Lost other STA beacon [%d] sec, started !\n",
+					pMgmt->sNodeDBTable[0].uInActiveCount);
 				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 				pMgmt->eCurrState = WMAC_STATE_STARTED;
 				netif_stop_queue(pDevice->dev);
 				pDevice->bLinkPass = false;
-				ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+				ControlvMaskByte(pDevice,
+						 MESSAGE_REQUEST_MACREG,
+						 MAC_REG_PAPEDELAY, LEDSTS_STS,
+						 LEDSTS_SLOW);
 			}
 		}
 	}
@@ -1129,16 +1208,19 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 				/* transmit success, TxAttempts at least plus one */
 				pMgmt->sNodeDBTable[0].uTxOk[MAX_RATE]++;
 				if ((byFallBack == AUTO_FB_NONE) ||
-					 (wRate < RATE_18M)) {
+				    (wRate < RATE_18M)) {
 					wFallBackRate = wRate;
 				} else if (byFallBack == AUTO_FB_0) {
 					if (byTxRetry < 5)
-						wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
+						wFallBackRate =
+							awHWRetry0[wRate-RATE_18M][byTxRetry];
 					else
-						wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
+						wFallBackRate =
+							awHWRetry0[wRate-RATE_18M][4];
 				} else if (byFallBack == AUTO_FB_1) {
 					if (byTxRetry < 5)
-						wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
+						wFallBackRate =
+							awHWRetry1[wRate-RATE_18M][byTxRetry];
 					else
 						wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
 				}
@@ -1150,7 +1232,7 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 			if (byTxRetry != 0) {
 				pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE] += byTxRetry;
 				if (byFallBack == AUTO_FB_NONE ||
-					wRate < RATE_18M) {
+				    wRate < RATE_18M) {
 					pMgmt->sNodeDBTable[0].uTxFail[wRate] += byTxRetry;
 				} else if (byFallBack == AUTO_FB_0) {
 					for (ii = 0; ii < byTxRetry; ii++) {
@@ -1190,14 +1272,18 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 					wFallBackRate = wRate;
 				} else if (byFallBack == AUTO_FB_0) {
 					if (byTxRetry < 5)
-						wFallBackRate = awHWRetry0[wRate-RATE_18M][byTxRetry];
+						wFallBackRate =
+							awHWRetry0[wRate-RATE_18M][byTxRetry];
 					else
-						wFallBackRate = awHWRetry0[wRate-RATE_18M][4];
+						wFallBackRate =
+							awHWRetry0[wRate-RATE_18M][4];
 				} else if (byFallBack == AUTO_FB_1) {
 					if (byTxRetry < 5)
-						wFallBackRate = awHWRetry1[wRate-RATE_18M][byTxRetry];
+						wFallBackRate =
+							awHWRetry1[wRate-RATE_18M][byTxRetry];
 					else
-						wFallBackRate = awHWRetry1[wRate-RATE_18M][4];
+						wFallBackRate =
+							awHWRetry1[wRate-RATE_18M][4];
 				}
 				pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wFallBackRate]++;
 			} else {
@@ -1207,7 +1293,7 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 			if (byTxRetry != 0) {
 				pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE] += byTxRetry;
 				if ((byFallBack == AUTO_FB_NONE) ||
-					(wRate < RATE_18M)) {
+				    (wRate < RATE_18M)) {
 					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate] += byTxRetry;
 				} else if (byFallBack == AUTO_FB_0) {
 					for (ii = 0; ii < byTxRetry; ii++) {
@@ -1259,7 +1345,9 @@ void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 			/* check if sTxPSQueue has been initial */
 			if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next) {
 				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue))) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS skb != NULL %d\n", ii);
+					DBG_PRT(MSG_LEVEL_DEBUG,
+						KERN_INFO "PS skb != NULL %d\n",
+						ii);
 					dev_kfree_skb(skb);
 				}
 			}
@@ -1275,8 +1363,10 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 	int ii;
 
 	if (pMgmt->eCurrState == WMAC_STATE_ASSOC ||
-		(pMgmt->eCurrMode == WMAC_MODE_IBSS_STA && pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
-		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
+	    (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA &&
+	     pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
+		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID,
+					       (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
 		if (pBSSList) {
 			/* Update BB register if RSSI is too strong */
 			signed long    LocalldBmAverage = 0;
@@ -1290,15 +1380,22 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 			if (uNumofdBm > 0) {
 				LocalldBmAverage = LocalldBmAverage/uNumofdBm;
 				for (ii = 0; ii < BB_VGA_LEVEL; ii++) {
-					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"LocalldBmAverage:%ld, %ld %02x\n", LocalldBmAverage, pDevice->ldBmThreshold[ii], pDevice->abyBBVGA[ii]);
+					DBG_PRT(MSG_LEVEL_DEBUG,
+						KERN_INFO"LocalldBmAverage:%ld, %ld %02x\n",
+						LocalldBmAverage,
+						pDevice->ldBmThreshold[ii],
+						pDevice->abyBBVGA[ii]);
 					if (LocalldBmAverage < pDevice->ldBmThreshold[ii]) {
-						pDevice->byBBVGANew = pDevice->abyBBVGA[ii];
+						pDevice->byBBVGANew =
+							pDevice->abyBBVGA[ii];
 						break;
 					}
 				}
-				if (pDevice->byBBVGANew != pDevice->byBBVGACurrent) {
+				if (pDevice->byBBVGANew !=
+						pDevice->byBBVGACurrent) {
 					pDevice->uBBVGADiffCount++;
-					if (pDevice->uBBVGADiffCount >= BB_VGA_CHANGE_THRESHOLD)
+					if (pDevice->uBBVGADiffCount >=
+							BB_VGA_CHANGE_THRESHOLD)
 						bScheduleCommand(pDevice,
 							WLAN_CMD_CHANGE_BBSENSITIVITY,
 							NULL);
@@ -1365,10 +1462,14 @@ static void s_vCheckPreEDThreshold(struct vnt_private *pDevice)
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
 	if (pMgmt->eCurrState == WMAC_STATE_ASSOC ||
-		(pMgmt->eCurrMode == WMAC_MODE_IBSS_STA && pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
-		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
+	    (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA &&
+	     pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
+		pBSSList = BSSpAddrIsInBSSList(pDevice,
+					       pMgmt->abyCurrBSSID,
+					       (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
 		if (pBSSList) {
-			pDevice->byBBPreEDRSSI = (u8) (~(pBSSList->ldBmAverRange) + 1);
+			pDevice->byBBPreEDRSSI =
+				(u8) (~(pBSSList->ldBmAverRange) + 1);
 			BBvUpdatePreEDThreshold(pDevice, false);
 		}
 	}
-- 
1.8.1.2

