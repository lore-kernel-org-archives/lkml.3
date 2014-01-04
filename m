Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaADPZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:25:42 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49277 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713AbaADPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:25:40 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] Staging: vt6656: Adjust comments in bssdb.c
Date: Sat,  4 Jan 2014 16:25:07 +0100
Message-Id: <1388849118-11994-3-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

Changes C99-style comments to C89-style ones to conform to the linux
coding guidelines. Additionally removes plus and minus signs from the
function description comments.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 218 +++++++++++++++++------------------------
 1 file changed, 91 insertions(+), 127 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index a670272..d727662 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -36,7 +36,6 @@
  * Author: Lyndon Chen
  *
  * Date: July 17, 2002
- *
  */
 
 #include "tmacro.h"
@@ -60,7 +59,7 @@
 #include "power.h"
 
 static int msglevel =MSG_LEVEL_INFO;
-//static int msglevel =MSG_LEVEL_DEBUG;
+/* static int msglevel =MSG_LEVEL_DEBUG; */
 
 static const u16 awHWRetry0[5][5] = {
 			{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
@@ -81,16 +80,13 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice);
 static void s_vCheckPreEDThreshold(struct vnt_private *pDevice);
 static void s_uCalculateLinkQual(struct vnt_private *pDevice);
 
-/*+
- *
+/*
  * Routine Description:
  *	  Search known BSS list for Desire SSID or BSSID.
  *
  * Return Value:
  *	  PTR to KnownBSS or NULL
- *
--*/
-
+ */
 PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			    u8 *pbyDesireBSSID, u8 *pbyDesireSSID,
 			    CARD_PHY_TYPE ePhyType)
@@ -119,7 +115,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 	}
 
 	if ((pbyBSSID != NULL)&&(pDevice->bRoaming == false)) {
-		// match BSSID first
+		/* match BSSID first */
 		for (ii = 0; ii <MAX_BSS_NUM; ii++) {
 			pCurrBSS = &(pMgmt->sBSSList[ii]);
 
@@ -129,7 +125,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 				(pCurrBSS->bSelected == false)) {
 				if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
 					if (pSSID != NULL) {
-						// compare ssid
+						/* compare ssid */
 						if ( !memcmp(pSSID->abySSID,
 							((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
 							pSSID->len)) {
@@ -154,31 +150,31 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			}
 		}
 	} else {
-		// ignore BSSID
+		/* ignore BSSID */
 		for (ii = 0; ii <MAX_BSS_NUM; ii++) {
 			pCurrBSS = &(pMgmt->sBSSList[ii]);
 
-			//2007-0721-01<Mark>by MikeLiu
-			//   if ((pCurrBSS->bActive) &&
-			//		  (pCurrBSS->bSelected == false)) {
+			/* 2007-0721-01<Mark>by MikeLiu
+			 *   if ((pCurrBSS->bActive) &&
+			 *		  (pCurrBSS->bSelected == false)) { */
 
 			pCurrBSS->bSelected = false;
 			if (pCurrBSS->bActive) {
 
 				if (pSSID != NULL) {
-					// matched SSID
+					/* matched SSID */
 					if (memcmp(pSSID->abySSID,
 						((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
 						pSSID->len) ||
 						(pSSID->len != ((PWLAN_IE_SSID)pCurrBSS->abySSID)->len)) {
-						// SSID not match skip this BSS
+						/* SSID not match skip this BSS */
 						continue;
 					  }
 				}
 				if (((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
 					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
 					){
-					// Type not match skip this BSS
+					/* Type not match skip this BSS */
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSS type mismatch.... Config[%d] BSS[0x%04x]\n", pMgmt->eConfigMode, pCurrBSS->wCapInfo);
 					continue;
 				}
@@ -186,7 +182,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 				if (ePhyType != PHY_TYPE_AUTO) {
 					if (((ePhyType == PHY_TYPE_11A) && (PHY_TYPE_11A != pCurrBSS->eNetworkTypeInUse)) ||
 						((ePhyType != PHY_TYPE_11A) && (PHY_TYPE_11A == pCurrBSS->eNetworkTypeInUse))) {
-						// PhyType not match skip this BSS
+						/* PhyType not match skip this BSS */
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Physical type mismatch.... ePhyType[%d] BSS[%d]\n", ePhyType, pCurrBSS->eNetworkTypeInUse);
 						continue;
 					}
@@ -201,7 +197,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 				if (pSelect == NULL) {
 					pSelect = pCurrBSS;
 				} else {
-					// compare RSSI, select the strongest signal
+					/* compare RSSI, select the strongest signal */
 					if (pCurrBSS->uRSSI < pSelect->uRSSI) {
 						pSelect = pCurrBSS;
 					}
@@ -214,7 +210,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		if (pSelect != NULL) {
 			pSelect->bSelected = true;
 			if (pDevice->bRoaming == false)  {
-				// Einsn Add @20070907
+				/* Einsn Add @20070907 */
 				memcpy(pbyDesireSSID,pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
 			}
 
@@ -225,16 +221,13 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 
 }
 
-/*+
- *
+/*
  * Routine Description:
  *	  Clear BSS List
  *
  * Return Value:
  *	  None.
- *
--*/
-
+ */
 void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -246,12 +239,13 @@ void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 				ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
 				pMgmt->abyCurrBSSID)) {
 
-				//mike mark:
-				//there are two BSSID's in list. If that AP is
-				//in hidden ssid mode, one SSID is null, but
-				//other's might not be obvious, so if it
-				//associate's with your STA, you must keep the
-				//two of them!!  bKeepCurrBSSID = false;
+				/* mike mark:
+				 * there are two BSSID's in list. If that AP is
+				 * in hidden ssid mode, one SSID is null, but
+				 * other's might not be obvious, so if it
+				 * associate's with your STA, you must keep the
+				 * two of them!!  bKeepCurrBSSID = false;
+				 */
 
 				continue;
 			}
@@ -263,15 +257,13 @@ void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 	BSSvClearAnyBSSJoinRecord(pDevice);
 }
 
-/*+
- *
+/*
  * Routine Description:
  *	  search BSS list by BSSID & SSID if matched
  *
  * Return Value:
  *	  true if found.
- *
--*/
+ */
 PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
 			      u8 *abyBSSID,
 			      PWLAN_IE_SSID pSSID)
@@ -297,16 +289,13 @@ PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
 	return NULL;
 };
 
-/*+
- *
+/*
  * Routine Description:
  *	  Insert a BSS set into known BSS list
  *
  * Return Value:
  *	  true if success.
- *
--*/
-
+ */
 int BSSbInsertToBSSList(struct vnt_private *pDevice,
 			u8 *abyBSSIDAddr,
 			u64 qwTimestamp,
@@ -344,7 +333,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get free KnowBSS node failed.\n");
 		return false;
 	}
-	// save the BSS info
+	/* save the BSS info */
 	pBSSList->bActive = true;
 	memcpy( pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
 	pBSSList->qwBSSTimestamp = cpu_to_le64(qwTimestamp);
@@ -374,7 +363,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	pBSSList->sERP.byERP = psERP->byERP;
 	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
-	// Check if BSS is 802.11a/b/g
+	/* Check if BSS is 802.11a/b/g */
 	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
 		pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
 	} else {
@@ -392,7 +381,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
 		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-		// assoc with BSS
+		/* assoc with BSS */
 		if (pBSSList == pMgmt->pCurrBSS) {
 			bParsingQuiet = true;
 		}
@@ -455,7 +444,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	}
 
 	if (pDevice->bUpdateBBVGA) {
-		// Monitor if RSSI is too strong.
+		/* Monitor if RSSI is too strong. */
 		pBSSList->byRSSIStatCnt = 0;
 		RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &pBSSList->ldBmMAX);
 		pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
@@ -472,17 +461,14 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	return true;
 }
 
-/*+
- *
+/*
  * Routine Description:
  *	  Update BSS set in known BSS list
  *
  * Return Value:
  *	  true if success.
- *
--*/
-// TODO: input structure modify
-
+ */
+/* TODO: input structure modify */
 int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 			u64 qwTimestamp,
 			u16 wBeaconInterval,
@@ -534,7 +520,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	pBSSList->sERP.byERP = psERP->byERP;
 	pBSSList->sERP.bERPExist = psERP->bERPExist;
 
-	// Check if BSS is 802.11a/b/g
+	/* Check if BSS is 802.11a/b/g */
 	if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
 		pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
 	} else {
@@ -553,13 +539,13 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
 		(pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-		// assoc with BSS
+		/* assoc with BSS */
 		if (pBSSList == pMgmt->pCurrBSS) {
 			bParsingQuiet = true;
 		}
 	}
 
-	WPA_ClearRSN(pBSSList); //mike update
+	WPA_ClearRSN(pBSSList); /* mike update */
 
 	if (pRSNWPA != NULL) {
 		unsigned int uLen = pRSNWPA->len + 2;
@@ -571,7 +557,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 		}
 	}
 
-	WPA2_ClearRSN(pBSSList); //mike update
+	WPA2_ClearRSN(pBSSList); /* mike update */
 
 	if (pRSN != NULL) {
 		unsigned int uLen = pRSN->len + 2;
@@ -585,7 +571,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 
 	if (pRxPacket->uRSSI != 0) {
 		RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &ldBm);
-		// Monitor if RSSI is too strong.
+		/* Monitor if RSSI is too strong. */
 		pBSSList->byRSSIStatCnt++;
 		pBSSList->byRSSIStatCnt %= RSSI_STAT_COUNT;
 		pBSSList->ldBmAverage[pBSSList->byRSSIStatCnt] = ldBm;
@@ -610,16 +596,13 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	return true;
 }
 
-/*+
- *
+/*
  * Routine Description:
  *	  Search Node DB table to find the index of matched DstAddr
  *
  * Return Value:
  *	  None
- *
--*/
-
+ */
 int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
 		      u8 *abyDstAddr,
 		      u32 *puNodeIndex)
@@ -627,7 +610,7 @@ int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	unsigned int ii;
 
-	// Index = 0 reserved for AP Node
+	/* Index = 0 reserved for AP Node */
 	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
 		if (pMgmt->sNodeDBTable[ii].bActive) {
 			if (ether_addr_equal(abyDstAddr,
@@ -641,16 +624,14 @@ int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
 	return false;
 };
 
-/*+
- *
+/*
  * Routine Description:
  *	  Find an empty node and allocate it; if no empty node
  *	  is found, then use the most inactive one.
  *
  * Return Value:
  *	  None
- *
--*/
+ */
 void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -659,8 +640,8 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 	u32 SelectIndex;
 	struct sk_buff *skb;
 
-	// Index = 0 reserved for AP Node (In STA mode)
-	// Index = 0 reserved for Broadcast/MultiCast (In AP mode)
+	/* Index = 0 reserved for AP Node (In STA mode)
+	   Index = 0 reserved for Broadcast/MultiCast (In AP mode) */
 	SelectIndex = 1;
 	for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
 		if (pMgmt->sNodeDBTable[ii].bActive) {
@@ -674,11 +655,11 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 		}
 	}
 
-	// if not found replace uInActiveCount with the largest one.
+	/* if not found replace uInActiveCount with the largest one. */
 	if ( ii == (MAX_NODE_NUM + 1)) {
 		*puNodeIndex = SelectIndex;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
-		// clear ps buffer
+		/* clear ps buffer */
 		if (pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue.next != NULL) {
 			while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)) != NULL)
 				dev_kfree_skb(skb);
@@ -691,24 +672,21 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 	memset(&pMgmt->sNodeDBTable[*puNodeIndex], 0, sizeof(KnownNodeDB));
 	pMgmt->sNodeDBTable[*puNodeIndex].bActive = true;
 	pMgmt->sNodeDBTable[*puNodeIndex].uRatePollTimeout = FALLBACK_POLL_SECOND;
-	// for AP mode PS queue
+	/* for AP mode PS queue */
 	skb_queue_head_init(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue);
 	pMgmt->sNodeDBTable[*puNodeIndex].byAuthSequence = 0;
 	pMgmt->sNodeDBTable[*puNodeIndex].wEnQueueCnt = 0;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create node index = %d\n", ii);
 };
 
-/*+
- *
+/*
  * Routine Description:
  *	  Remove Node by NodeIndex
  *
  *
  * Return Value:
  *	  None
- *
--*/
-
+ */
 void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -717,22 +695,20 @@ void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 
 	while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[uNodeIndex].sTxPSQueue)) != NULL)
 		dev_kfree_skb(skb);
-	// clear context
+	/* clear context */
 	memset(&pMgmt->sNodeDBTable[uNodeIndex], 0, sizeof(KnownNodeDB));
-	// clear tx bit map
+	/* clear tx bit map */
 	pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[uNodeIndex].wAID >> 3] &=  ~byMask[pMgmt->sNodeDBTable[uNodeIndex].wAID & 7];
 };
-/*+
- *
+
+/*
  * Routine Description:
  *	  Update AP Node content in Index 0 of KnownNodeDB
  *
  *
  * Return Value:
  *	  None
- *
--*/
-
+ */
 void BSSvUpdateAPNode(struct vnt_private *pDevice,
 		      u16 *pwCapInfo,
 		      PWLAN_IE_SUPP_RATES pSuppRates,
@@ -766,23 +742,20 @@ void BSSvUpdateAPNode(struct vnt_private *pDevice,
 	pMgmt->sNodeDBTable[0].wTxDataRate = pMgmt->sNodeDBTable[0].wMaxSuppRate;
 	pMgmt->sNodeDBTable[0].bShortPreamble = WLAN_GET_CAP_INFO_SHORTPREAMBLE(*pwCapInfo);
 	pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
-	// Auto rate fallback function initiation.
-	// RATEbInit(pDevice);
+	/* Auto rate fallback function initiation.
+	 * RATEbInit(pDevice); */
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d \n", pMgmt->sNodeDBTable[0].wTxDataRate);
 
 };
 
-/*+
- *
+/*
  * Routine Description:
  *	  Add Multicast Node content in Index 0 of KnownNodeDB
  *
  *
  * Return Value:
  *	  None
- *
--*/
-
+ */
 void BSSvAddMulticastNode(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -807,8 +780,7 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
 
 };
 
-/*+
- *
+/*
  * Routine Description:
  *
  *
@@ -817,9 +789,7 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
  *
  * Return Value:
  *	  none.
- *
--*/
-
+ */
 void BSSvSecondCallBack(struct work_struct *work)
 {
 	struct vnt_private *pDevice = container_of(work,
@@ -838,7 +808,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	pDevice->uAssocCount = 0;
 
-	//Power Saving Mode Tx Burst
+	/* Power Saving Mode Tx Burst */
 	if ( pDevice->bEnablePSMode == true ) {
 		pDevice->ulPSModeWaitTx++;
 		if ( pDevice->ulPSModeWaitTx >= 2 ) {
@@ -854,16 +824,16 @@ void BSSvSecondCallBack(struct work_struct *work)
 		pDevice->wUseProtectCntDown --;
 	}
 	else {
-		// disable protect mode
+		/* disable protect mode */
 		pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
 	}
 
 	if(pDevice->byReAssocCount > 0) {
 		pDevice->byReAssocCount++;
-		if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  //10 sec timeout
+		if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  /* 10 sec timeout */
 			printk("Re-association timeout!!!\n");
 			pDevice->byReAssocCount = 0;
-			// if(pDevice->bWPASuppWextEnabled == true)
+			/* if(pDevice->bWPASuppWextEnabled == true) */
 			{
 				union iwreq_data  wrqu;
 				memset(&wrqu, 0, sizeof (wrqu));
@@ -883,7 +853,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 	for (ii = 0; ii < (MAX_NODE_NUM + 1); ii++) {
 
 		if (pMgmt->sNodeDBTable[ii].bActive) {
-			// Increase in-activity counter
+			/* Increase in-activity counter */
 			pMgmt->sNodeDBTable[ii].uInActiveCount++;
 
 			if (ii > 0) {
@@ -898,7 +868,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 					pDevice->uAssocCount++;
 
-					// check if Non ERP exist
+					/* check if Non ERP exist */
 					if (pMgmt->sNodeDBTable[ii].uInActiveCount < ERP_RECOVER_COUNT) {
 						if (!pMgmt->sNodeDBTable[ii].bShortPreamble) {
 							pDevice->byERPFlag |= WLAN_SET_ERP_BARKER_MODE(1);
@@ -913,21 +883,21 @@ void BSSvSecondCallBack(struct work_struct *work)
 					}
 				}
 
-				// check if any STA in PS mode
+				/* check if any STA in PS mode */
 				if (pMgmt->sNodeDBTable[ii].bPSEnable)
 					uSleepySTACnt++;
 
 			}
 
-			// Rate fallback check
+			/* Rate fallback check */
 			if (!pDevice->bFixRate) {
 				if (ii > 0) {
-					// ii = 0 for multicast node (AP & Adhoc)
+					/* ii = 0 for multicast node (AP & Adhoc) */
 					RATEvTxRateFallBack((void *)pDevice,
 						&(pMgmt->sNodeDBTable[ii]));
 				}
 				else {
-					// ii = 0 reserved for unicast AP node (Infra STA)
+					/* ii = 0 reserved for unicast AP node (Infra STA) */
 					if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
 						RATEvTxRateFallBack((void *)pDevice,
 							&(pMgmt->sNodeDBTable[ii]));
@@ -935,7 +905,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 			}
 
-			// check if pending PS queue
+			/* check if pending PS queue */
 			if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending \n",
 						   ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
@@ -951,7 +921,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->byBBType == BB_TYPE_11G)) {
 
-		// on/off protect mode
+		/* on/off protect mode */
 		if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
 			if (!pDevice->bProtectMode) {
 				MACvEnableProtectMD(pDevice);
@@ -964,7 +934,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				pDevice->bProtectMode = false;
 			}
 		}
-		// on/off short slot time
+		/* on/off short slot time */
 
 		if (uNonShortSlotSTACnt > 0) {
 			if (pDevice->bShortSlotTime) {
@@ -981,7 +951,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 			}
 		}
 
-		// on/off barker long preamble mode
+		/* on/off barker long preamble mode */
 
 		if (uLongPreambleSTACnt > 0) {
 			if (!pDevice->bBarkerPreambleMd) {
@@ -998,7 +968,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 	}
 
-	// Check if any STA in PS mode, enable DTIM multicast deliver
+	/* Check if any STA in PS mode, enable DTIM multicast deliver */
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
 		if (uSleepySTACnt > 0)
 			pMgmt->sNodeDBTable[0].bPSEnable = true;
@@ -1012,7 +982,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 	if ((pMgmt->eCurrMode == WMAC_MODE_STANDBY) ||
 		(pMgmt->eCurrMode == WMAC_MODE_ESS_STA)) {
 
-		if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
+		if (pMgmt->sNodeDBTable[0].bActive) { /* Assoc with BSS */
 
 			if (pDevice->bUpdateBBVGA) {
 				s_vCheckSensitivity(pDevice);
@@ -1049,7 +1019,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 			}
 		}
 		else if (pItemSSID->len != 0) {
-			//Davidwang
+			/* Davidwang */
 			if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming );
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
@@ -1075,12 +1045,12 @@ void BSSvSecondCallBack(struct work_struct *work)
 			else {
 				if (pDevice->uAutoReConnectTime < 10) {
 					pDevice->uAutoReConnectTime++;
-					//network manager support need not do Roaming scan???
+					/* network manager support need not do Roaming scan??? */
 					if(pDevice->bWPASuppWextEnabled ==true)
 						pDevice->uAutoReConnectTime = 0;
 				}
 				else {
-					//mike use old encryption status for wpa reauthen
+					/* mike use old encryption status for wpa reauthen */
 					if(pDevice->bWPADEVUp)
 						pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
 
@@ -1100,7 +1070,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 	}
 
 	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-		// if adhoc started which essid is NULL string, rescanning.
+		/* if adhoc started which essid is NULL string, rescanning. */
 		if ((pMgmt->eCurrState == WMAC_STATE_STARTED) && (pCurrSSID->len == 0)) {
 			if (pDevice->uAutoReConnectTime < 10) {
 				pDevice->uAutoReConnectTime++;
@@ -1152,8 +1122,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 	schedule_delayed_work(&pDevice->second_callback_work, HZ);
 }
 
-/*+
- *
+/*
  * Routine Description:
  *
  *
@@ -1162,9 +1131,7 @@ void BSSvSecondCallBack(struct work_struct *work)
  *
  * Return Value:
  *	  none.
- *
--*/
-
+ */
 void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -1193,12 +1160,12 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 		byFallBack = AUTO_FB_NONE;
 	}
 
-	// Only Unicast using support rates
+	/* Only Unicast using support rates */
 	if (wFIFOCtl & FIFOCTL_NEEDACK) {
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 			pMgmt->sNodeDBTable[0].uTxAttempts += 1;
 			if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
-				// transmit success, TxAttempts at least plus one
+				/* transmit success, TxAttempts at least plus one */
 				pMgmt->sNodeDBTable[0].uTxOk[MAX_RATE]++;
 				if ( (byFallBack == AUTO_FB_NONE) ||
 					 (wRate < RATE_18M) ) {
@@ -1256,7 +1223,7 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 						  &uNodeIndex)) {
 				pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
 				if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
-					// transmit success, TxAttempts at least plus one
+					/* transmit success, TxAttempts at least plus one */
 					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
 					if ( (byFallBack == AUTO_FB_NONE) ||
 						(wRate < RATE_18M) ) {
@@ -1307,8 +1274,7 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 	}
 }
 
-/*+
- *
+/*
  * Routine Description:
  *	  Clear Nodes & skb in DB Table
  *
@@ -1322,9 +1288,7 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
  *
  * Return Value:
  *	  None.
- *
--*/
-
+ */
 void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -1333,7 +1297,7 @@ void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 
 	for (ii = uStartIndex; ii < (MAX_NODE_NUM + 1); ii++) {
 		if (pMgmt->sNodeDBTable[ii].bActive) {
-			// check if sTxPSQueue has been initial
+			/* check if sTxPSQueue has been initial */
 			if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next != NULL) {
 				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL){
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS skb != NULL %d\n", ii);
-- 
1.8.1.2

