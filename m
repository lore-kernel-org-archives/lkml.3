Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaAGMNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:13:43 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:51690 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbaAGMMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:40 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCHv2 3/7] vt6655: remove unnecessary braces in wroute.c
Date: Tue,  7 Jan 2014 13:11:47 +0100
Message-Id: <1389096711-8595-4-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

This patch removes some unnecessary braces concerning if-statements in the file
wroute.c

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/wroute.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index 2e94efb..fdc13df 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
@@ -90,9 +90,8 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 
 	cbFrameBodySize = uDataLen - ETH_HLEN;
 
-	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN) {
+	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN)
 		cbFrameBodySize += 8;
-	}
 
 	if (pDevice->bEncryptionEnable == true) {
 		bNeedEncryption = true;
@@ -124,18 +123,17 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 
 	uMACfragNum = cbGetFragCount(pDevice, pTransmitKey, cbFrameBodySize, &pDevice->sTxEthHeader);
 
-	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA)) {
+	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA))
 		return false;
-	}
+
 	byPktType = pDevice->byPacketType;
 
 	if (pDevice->bFixRate) {
 		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
-			if (pDevice->uConnectionRate >= RATE_11M) {
+			if (pDevice->uConnectionRate >= RATE_11M)
 				pDevice->wCurrentRate = RATE_11M;
-			} else {
+			else
 				pDevice->wCurrentRate = pDevice->uConnectionRate;
-			}
 		} else {
 			if ((pDevice->eCurrentPHYType == PHY_TYPE_11A) &&
 			    (pDevice->uConnectionRate <= RATE_6M)) {
-- 
1.8.1.2

