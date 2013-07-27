Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3G0TgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:36:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61629 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3G0TfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:35:22 -0400
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tulinizer@gmail.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Lilis Iskandar <veeableful@gmail.com>
Subject: [PATCH v2 3/5] Staging: bcm: LeakyBucket: Fixed C99 comments
Date: Sun, 28 Jul 2013 03:34:45 +0800
Message-Id: <1374953687-14386-3-git-send-email-veeableful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
References: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed C99 comments

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/LeakyBucket.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index 52e6e05..75d77c2e 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -117,7 +117,7 @@ static INT SendPacketFromQueue(struct bcm_mini_adapter *Adapter,/**<Logical Adap
 
 	if (psSF->liDrainCalculated == 0)
 		psSF->liDrainCalculated = jiffies;
-	///send the packet to the fifo..
+	/* send the packet to the fifo.. */
 	PktLen = Packet->len;
 	Status = SetupNextSend(Adapter, Packet, psSF->usVCID_Value);
 	if (Status == 0) {
@@ -151,7 +151,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "%zd ====>", (psSF-Adapter->PackInfo));
-	if ((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount)) { //Get data packet
+	if ((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount)) { /* Get data packet */
 		if (!psSF->ucDirection)
 			return;
 
@@ -159,7 +159,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 		if (Adapter->IdleMode || Adapter->bPreparingForLowPowerMode)
 			return;	/* in idle mode */
 
-		// Check for Free Descriptors
+		/* Check for Free Descriptors */
 		if (atomic_read(&Adapter->CurrNumFreeTxDesc) <= MINIMUM_PENDING_DESCRIPTORS) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " No Free Tx Descriptor(%d) is available for Data pkt..", atomic_read(&Adapter->CurrNumFreeTxDesc));
 			return;
@@ -193,9 +193,11 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For Queue: %zd\n", psSF-Adapter->PackInfo);
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nAvailable Tokens = %d required = %d\n",
 					psSF->uiCurrentTokenCount, iPacketLen);
-				//this part indicates that because of non-availability of the tokens
-				//pkt has not been send out hence setting the pending flag indicating the host to send it out
-				//first next iteration  .
+				/*
+				this part indicates that because of non-availability of the tokens
+				pkt has not been send out hence setting the pending flag indicating the host to send it out
+				first next iteration.
+				*/
 				psSF->uiPendedLast = TRUE;
 				spin_unlock_bh(&psSF->SFQueueLock);
 			}
@@ -286,7 +288,7 @@ VOID transmit_packets(struct bcm_mini_adapter *Adapter)
 
 	while (uiPrevTotalCount > 0 && !Adapter->device_removed) {
 		exit_flag = TRUE;
-			//second iteration to parse non-pending queues
+		/* second iteration to parse non-pending queues */
 		for (iIndex = HiPriority; iIndex >= 0; iIndex--) {
 			if (!uiPrevTotalCount || (TRUE == Adapter->device_removed))
 				break;
-- 
1.8.3.1

