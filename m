Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaADP0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:26:45 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49424 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984AbaADP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:26:14 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] Staging: vt6656: Remove explicit comparisons against NULL
Date: Sat,  4 Jan 2014 16:25:17 +0100
Message-Id: <1388849118-11994-13-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicit comparisons of pointers agains NULL
(like if (p != NULL) ...) are not as readable as the implicit
comparison (like if (p) ...). This patch converts all these explicit
comparisons to implicit ones.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index b71bc33..6662d6e 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -100,18 +100,18 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 	int ii = 0;
 	int jj = 0;
 
-	if (pbyDesireBSSID != NULL) {
+	if (pbyDesireBSSID) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
 		if (!is_broadcast_ether_addr(pbyDesireBSSID) &&
 			memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)
 				pbyBSSID = pbyDesireBSSID;
 	}
-	if (pbyDesireSSID != NULL &&
+	if (pbyDesireSSID &&
 	    ((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
 		pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
 
-	if (pbyBSSID != NULL && pDevice->bRoaming == false) {
+	if (pbyBSSID && pDevice->bRoaming == false) {
 		/* match BSSID first */
 		for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 			pCurrBSS = &(pMgmt->sBSSList[ii]);
@@ -121,7 +121,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			if (pCurrBSS->bActive &&
 			    pCurrBSS->bSelected == false &&
 			    ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
-				if (pSSID != NULL) {
+				if (pSSID) {
 					/* compare ssid */
 					if (!memcmp(pSSID->abySSID,
 						     ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
@@ -155,7 +155,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			pCurrBSS->bSelected = false;
 			if (pCurrBSS->bActive) {
 
-				if (pSSID != NULL &&
+				if (pSSID &&
 				    /* matched SSID */
 				    (memcmp(pSSID->abySSID,
 					    ((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
@@ -190,7 +190,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 					pCurrBSS->abyBSSID);
 				jj++;
 
-				if (pSelect == NULL)
+				if (!pSelect)
 					pSelect = pCurrBSS;
 				/* compare RSSI, select the strongest signal */
 				else if (pCurrBSS->uRSSI < pSelect->uRSSI)
@@ -200,7 +200,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 
 		pDevice->bSameBSSMaxNum = jj;
 
-		if (pSelect != NULL) {
+		if (pSelect) {
 			pSelect->bSelected = true;
 			if (pDevice->bRoaming == false) {
 				/* Einsn Add @20070907 */
@@ -342,7 +342,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 		pSuppRates->len = WLAN_RATES_MAXLEN;
 	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
 
-	if (pExtSuppRates != NULL) {
+	if (pExtSuppRates) {
 		if (pExtSuppRates->len > WLAN_RATES_MAXLEN)
 			pExtSuppRates->len = WLAN_RATES_MAXLEN;
 		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
@@ -375,7 +375,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 
 	WPA_ClearRSN(pBSSList);
 
-	if (pRSNWPA != NULL) {
+	if (pRSNWPA) {
 		unsigned int uLen = pRSNWPA->len + 2;
 
 		if (uLen <= (uIELength -
@@ -388,7 +388,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 
 	WPA2_ClearRSN(pBSSList);
 
-	if (pRSN != NULL) {
+	if (pRSN) {
 		unsigned int uLen = pRSN->len + 2;
 
 		if (uLen <= (uIELength -
@@ -487,7 +487,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	signed long ldBm, ldBmSum;
 	bool bParsingQuiet = false;
 
-	if (pBSSList == NULL)
+	if (!pBSSList)
 		return false;
 
 	pBSSList->qwBSSTimestamp = cpu_to_le64(qwTimestamp);
@@ -504,7 +504,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 		memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
 	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
 
-	if (pExtSuppRates != NULL)
+	if (pExtSuppRates)
 		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
 	else
 		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
@@ -533,7 +533,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 
 	WPA_ClearRSN(pBSSList); /* mike update */
 
-	if (pRSNWPA != NULL) {
+	if (pRSNWPA) {
 		unsigned int uLen = pRSNWPA->len + 2;
 		if (uLen <= (uIELength -
 				(unsigned int) (u32) ((u8 *) pRSNWPA - pbyIEs))) {
@@ -545,7 +545,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 
 	WPA2_ClearRSN(pBSSList); /* mike update */
 
-	if (pRSN != NULL) {
+	if (pRSN) {
 		unsigned int uLen = pRSN->len + 2;
 		if (uLen <= (uIELength -
 				(unsigned int) (u32) ((u8 *) pRSN - pbyIEs))) {
@@ -644,8 +644,8 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 		*puNodeIndex = SelectIndex;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
 		/* clear ps buffer */
-		if (pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue.next != NULL) {
-			while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)) != NULL)
+		if (pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue.next) {
+			while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue)))
 				dev_kfree_skb(skb);
 		}
 	} else {
@@ -676,7 +676,7 @@ void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[uNodeIndex].sTxPSQueue)) != NULL)
+	while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[uNodeIndex].sTxPSQueue)))
 		dev_kfree_skb(skb);
 	/* clear context */
 	memset(&pMgmt->sNodeDBTable[uNodeIndex], 0, sizeof(KnownNodeDB));
@@ -1257,8 +1257,8 @@ void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 	for (ii = uStartIndex; ii < (MAX_NODE_NUM + 1); ii++) {
 		if (pMgmt->sNodeDBTable[ii].bActive) {
 			/* check if sTxPSQueue has been initial */
-			if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next != NULL) {
-				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL) {
+			if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next) {
+				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue))) {
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS skb != NULL %d\n", ii);
 					dev_kfree_skb(skb);
 				}
@@ -1277,7 +1277,7 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 	if (pMgmt->eCurrState == WMAC_STATE_ASSOC ||
 		(pMgmt->eCurrMode == WMAC_MODE_IBSS_STA && pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
 		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
-		if (pBSSList != NULL) {
+		if (pBSSList) {
 			/* Update BB register if RSSI is too strong */
 			signed long    LocalldBmAverage = 0;
 			signed long    uNumofdBm = 0;
@@ -1367,7 +1367,7 @@ static void s_vCheckPreEDThreshold(struct vnt_private *pDevice)
 	if (pMgmt->eCurrState == WMAC_STATE_ASSOC ||
 		(pMgmt->eCurrMode == WMAC_MODE_IBSS_STA && pMgmt->eCurrState == WMAC_STATE_JOINTED)) {
 		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
-		if (pBSSList != NULL) {
+		if (pBSSList) {
 			pDevice->byBBPreEDRSSI = (u8) (~(pBSSList->ldBmAverRange) + 1);
 			BBvUpdatePreEDThreshold(pDevice, false);
 		}
-- 
1.8.1.2

