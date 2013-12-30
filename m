Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3L3O6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:58:47 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:49026 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870Ab3L3O6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:58:46 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Dec 2013 09:58:45 EST
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH 2/7] vt6655: Fix most of checkpatch.pl errors in wroute
Date: Mon, 30 Dec 2013 15:52:32 +0100
Message-Id: <1388415157-17615-3-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wroute.h: Fixed all line-over-80-character errors. No errors remain.
wroute.c: Fixed line-over-80-character errors, bracing errors
	  and C99-comments.
	  Three warnings remain, fixing them would deteriorate readability.
	  One warning on a memory barrier without comment in line 189
	  will be fixed in a later commit because it's purpose is not
	  yet known.

Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/wroute.c | 71 ++++++++++++++++++++++++-----------------
 drivers/staging/vt6655/wroute.h |  3 +-
 2 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index 85302c5..f8899b6 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
@@ -44,7 +44,7 @@
 
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
+/* static int          msglevel                =MSG_LEVEL_DEBUG; */
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
@@ -63,7 +63,8 @@ static int msglevel = MSG_LEVEL_INFO;
  * Return Value: true if packet duplicate; otherwise false
  *
  */
-bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uDataLen, unsigned int uNodeIndex)
+bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData,
+		 unsigned int uDataLen, unsigned int uNodeIndex)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PSTxDesc        pHeadTD, pLastTD;
@@ -78,7 +79,8 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 	unsigned char *pbyBSSID;
 
 	if (AVAIL_TD(pDevice, TYPE_AC0DMA) <= 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Relay can't allocate TD1..\n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Relay can't allocate TD1..\n");
 		return false;
 	}
 
@@ -86,22 +88,25 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 
 	pHeadTD->m_td1TD1.byTCR = (TCR_EDP | TCR_STP);
 
-	memcpy(pDevice->sTxEthHeader.abyDstAddr, (unsigned char *)pbySkbData, ETH_HLEN);
+	memcpy(pDevice->sTxEthHeader.abyDstAddr,
+	       (unsigned char *)pbySkbData, ETH_HLEN);
 
 	cbFrameBodySize = uDataLen - ETH_HLEN;
 
-	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN) {
+	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN)
 		cbFrameBodySize += 8;
-	}
 
 	if (pDevice->bEncryptionEnable == true) {
 		bNeedEncryption = true;
 
-		// get group key
+		/* get group key */
 		pbyBSSID = pDevice->abyBroadcastAddr;
-		if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
+		if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID,
+				       GROUP_KEY, &pTransmitKey) == false) {
 			pTransmitKey = NULL;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "KEY is NULL. [%d]\n", pDevice->pMgmt->eCurrMode);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG
+				"KEY is NULL. [%d]\n",
+				pDevice->pMgmt->eCurrMode);
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Get GTK.\n");
 		}
@@ -110,11 +115,16 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 	if (pDevice->bEnableHostWEP) {
 		if (uNodeIndex < MAX_NODE_NUM + 1) {
 			pTransmitKey = &STempKey;
-			pTransmitKey->byCipherSuite = pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
-			pTransmitKey->dwKeyIndex = pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex;
-			pTransmitKey->uKeyLength = pMgmt->sNodeDBTable[uNodeIndex].uWepKeyLength;
-			pTransmitKey->dwTSC47_16 = pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16;
-			pTransmitKey->wTSC15_0 = pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0;
+			pTransmitKey->byCipherSuite =
+				pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
+			pTransmitKey->dwKeyIndex =
+				pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex;
+			pTransmitKey->uKeyLength =
+				pMgmt->sNodeDBTable[uNodeIndex].uWepKeyLength;
+			pTransmitKey->dwTSC47_16 =
+				pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16;
+			pTransmitKey->wTSC15_0 =
+				pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0;
 			memcpy(pTransmitKey->abyKey,
 			       &pMgmt->sNodeDBTable[uNodeIndex].abyWepKey[0],
 			       pTransmitKey->uKeyLength
@@ -122,20 +132,21 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 		}
 	}
 
-	uMACfragNum = cbGetFragCount(pDevice, pTransmitKey, cbFrameBodySize, &pDevice->sTxEthHeader);
+	uMACfragNum = cbGetFragCount(pDevice, pTransmitKey,
+				     cbFrameBodySize,
+				     &pDevice->sTxEthHeader);
 
-	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA)) {
+	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA))
 		return false;
-	}
 	byPktType = (unsigned char)pDevice->byPacketType;
 
 	if (pDevice->bFixRate) {
 		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
-			if (pDevice->uConnectionRate >= RATE_11M) {
+			if (pDevice->uConnectionRate >= RATE_11M)
 				pDevice->wCurrentRate = RATE_11M;
-			} else {
-				pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
-			}
+			else
+				pDevice->wCurrentRate =
+					(unsigned short)pDevice->uConnectionRate;
 		} else {
 			if ((pDevice->eCurrentPHYType == PHY_TYPE_11A) &&
 			    (pDevice->uConnectionRate <= RATE_6M)) {
@@ -144,25 +155,27 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 				if (pDevice->uConnectionRate >= RATE_54M)
 					pDevice->wCurrentRate = RATE_54M;
 				else
-					pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
+					pDevice->wCurrentRate =
+						(unsigned short)pDevice->uConnectionRate;
 			}
 		}
 	} else {
-		pDevice->wCurrentRate = pDevice->pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate;
+		pDevice->wCurrentRate =
+			pDevice->pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate;
 	}
 
 	if (pDevice->wCurrentRate <= RATE_11M)
 		byPktType = PK_TYPE_11B;
 
-	vGenerateFIFOHeader(pDevice, byPktType, pDevice->pbyTmpBuff, bNeedEncryption,
-			    cbFrameBodySize, TYPE_AC0DMA, pHeadTD,
-			    &pDevice->sTxEthHeader, pbySkbData, pTransmitKey, uNodeIndex,
-			    &uMACfragNum,
+	vGenerateFIFOHeader(pDevice, byPktType, pDevice->pbyTmpBuff,
+			    bNeedEncryption, cbFrameBodySize, TYPE_AC0DMA,
+			    pHeadTD, &pDevice->sTxEthHeader, pbySkbData,
+			    pTransmitKey, uNodeIndex, &uMACfragNum,
 			    &cbHeaderSize
 );
 
 	if (MACbIsRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PS)) {
-		// Disable PS
+		/* Disable PS */
 		MACbPSWakeup(pDevice->PortOffset);
 	}
 
@@ -170,7 +183,7 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 
 	pLastTD = pHeadTD;
 	for (ii = 0; ii < uMACfragNum; ii++) {
-		// Poll Transmit the adapter
+		/* Poll Transmit the adapter */
 		wmb();
 		pHeadTD->m_td0TD0.f1Owner = OWNED_BY_NIC;
 		wmb();
diff --git a/drivers/staging/vt6655/wroute.h b/drivers/staging/vt6655/wroute.h
index 3abc1d3..b4faafe 100644
--- a/drivers/staging/vt6655/wroute.h
+++ b/drivers/staging/vt6655/wroute.h
@@ -39,6 +39,7 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uDataLen, unsigned int uNodeIndex);
+bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData,
+		 unsigned int uDataLen, unsigned int uNodeIndex);
 
 #endif /* __WROUTE_H__ */
-- 
1.8.1.2

