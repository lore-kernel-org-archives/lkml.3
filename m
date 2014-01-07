Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaAGMNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:13:12 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:36633 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbaAGMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:38 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCHv2 2/7] vt6655: remove casts in wroute.c
Date: Tue,  7 Jan 2014 13:11:46 +0100
Message-Id: <1389096711-8595-3-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

The file wroute.c contained some silly casts. This patch removes them.

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/wroute.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index 85302c5..2e94efb 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
@@ -86,7 +86,7 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 
 	pHeadTD->m_td1TD1.byTCR = (TCR_EDP | TCR_STP);
 
-	memcpy(pDevice->sTxEthHeader.abyDstAddr, (unsigned char *)pbySkbData, ETH_HLEN);
+	memcpy(pDevice->sTxEthHeader.abyDstAddr, pbySkbData, ETH_HLEN);
 
 	cbFrameBodySize = uDataLen - ETH_HLEN;
 
@@ -127,14 +127,14 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA)) {
 		return false;
 	}
-	byPktType = (unsigned char)pDevice->byPacketType;
+	byPktType = pDevice->byPacketType;
 
 	if (pDevice->bFixRate) {
 		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
 			if (pDevice->uConnectionRate >= RATE_11M) {
 				pDevice->wCurrentRate = RATE_11M;
 			} else {
-				pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
+				pDevice->wCurrentRate = pDevice->uConnectionRate;
 			}
 		} else {
 			if ((pDevice->eCurrentPHYType == PHY_TYPE_11A) &&
@@ -144,7 +144,7 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
 				if (pDevice->uConnectionRate >= RATE_54M)
 					pDevice->wCurrentRate = RATE_54M;
 				else
-					pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
+					pDevice->wCurrentRate = pDevice->uConnectionRate;
 			}
 		}
 	} else {
-- 
1.8.1.2

