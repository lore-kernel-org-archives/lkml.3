Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaAGMNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:13:22 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:40794 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbaAGMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:38 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCHv2 4/7] vt6655: fix indentation in wroute.c
Date: Tue,  7 Jan 2014 13:11:48 +0100
Message-Id: <1389096711-8595-5-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

This patch fixes indentation style belonging to function calls as well as some
run-away closing parentheses when calling functions.

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/wroute.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index fdc13df..c39d5ed 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
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
+		DBG_PRT(MSG_LEVEL_DEBUG,
+			KERN_INFO "Relay can't allocate TD1..\n");
 		return false;
 	}
 
@@ -98,9 +100,12 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 
 		// get group key
 		pbyBSSID = pDevice->abyBroadcastAddr;
-		if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
+		if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID,
+		    GROUP_KEY, &pTransmitKey) == false) {
 			pTransmitKey = NULL;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "KEY is NULL. [%d]\n", pDevice->pMgmt->eCurrMode);
+			DBG_PRT(MSG_LEVEL_DEBUG,
+				KERN_DEBUG "KEY is NULL. [%d]\n",
+				pDevice->pMgmt->eCurrMode);
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG "Get GTK.\n");
 		}
@@ -116,12 +121,12 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 			pTransmitKey->wTSC15_0 = pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0;
 			memcpy(pTransmitKey->abyKey,
 			       &pMgmt->sNodeDBTable[uNodeIndex].abyWepKey[0],
-			       pTransmitKey->uKeyLength
-);
+			       pTransmitKey->uKeyLength);
 		}
 	}
 
-	uMACfragNum = cbGetFragCount(pDevice, pTransmitKey, cbFrameBodySize, &pDevice->sTxEthHeader);
+	uMACfragNum = cbGetFragCount(pDevice, pTransmitKey,
+				     cbFrameBodySize, &pDevice->sTxEthHeader);
 
 	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA))
 		return false;
@@ -152,12 +157,11 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 	if (pDevice->wCurrentRate <= RATE_11M)
 		byPktType = PK_TYPE_11B;
 
-	vGenerateFIFOHeader(pDevice, byPktType, pDevice->pbyTmpBuff, bNeedEncryption,
-			    cbFrameBodySize, TYPE_AC0DMA, pHeadTD,
-			    &pDevice->sTxEthHeader, pbySkbData, pTransmitKey, uNodeIndex,
-			    &uMACfragNum,
-			    &cbHeaderSize
-);
+	vGenerateFIFOHeader(pDevice, byPktType, pDevice->pbyTmpBuff,
+			    bNeedEncryption, cbFrameBodySize, TYPE_AC0DMA,
+			    pHeadTD, &pDevice->sTxEthHeader, pbySkbData,
+			    pTransmitKey, uNodeIndex, &uMACfragNum,
+			    &cbHeaderSize);
 
 	if (MACbIsRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PS)) {
 		// Disable PS
-- 
1.8.1.2

