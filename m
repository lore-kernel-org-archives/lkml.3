Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab3GZOVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:21:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56288 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3GZOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:21:33 -0400
Message-ID: <1374848487.13685.4.camel@desktop>
Subject: [PATCH 3/5] Staging: bcm: LeakyBucket: Fixed C99 comments
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jamesceri@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Jul 2013 22:21:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed C99 comments

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/LeakyBucket.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/LeakyBucket.c
b/drivers/staging/bcm/LeakyBucket.c
index 52e6e05..75d77c2e 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -117,7 +117,7 @@ static INT SendPacketFromQueue(struct
bcm_mini_adapter *Adapter,/**<Logical Adap
 
 	if (psSF->liDrainCalculated == 0)
 		psSF->liDrainCalculated = jiffies;
-	///send the packet to the fifo..
+	/* send the packet to the fifo.. */
 	PktLen = Packet->len;
 	Status = SetupNextSend(Adapter, Packet, psSF->usVCID_Value);
 	if (Status == 0) {
@@ -151,7 +151,7 @@ static VOID CheckAndSendPacketFromIndex(struct
bcm_mini_adapter *Adapter, struct
 
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "%zd
====>", (psSF-Adapter->PackInfo));
-	if ((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus
&& atomic_read(&psSF->uiPerSFTxResourceCount)) { //Get data packet
+	if ((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus
&& atomic_read(&psSF->uiPerSFTxResourceCount)) { /* Get data packet */
 		if (!psSF->ucDirection)
 			return;
 
@@ -159,7 +159,7 @@ static VOID CheckAndSendPacketFromIndex(struct
bcm_mini_adapter *Adapter, struct
 		if (Adapter->IdleMode || Adapter->bPreparingForLowPowerMode)
 			return;	/* in idle mode */
 
-		// Check for Free Descriptors
+		/* Check for Free Descriptors */
 		if (atomic_read(&Adapter->CurrNumFreeTxDesc) <=
MINIMUM_PENDING_DESCRIPTORS) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " No
Free Tx Descriptor(%d) is available for Data pkt..",
atomic_read(&Adapter->CurrNumFreeTxDesc));
 			return;
@@ -193,9 +193,11 @@ static VOID CheckAndSendPacketFromIndex(struct
bcm_mini_adapter *Adapter, struct
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For
Queue: %zd\n", psSF-Adapter->PackInfo);
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL,
"\nAvailable Tokens = %d required = %d\n",
 					psSF->uiCurrentTokenCount, iPacketLen);
-				//this part indicates that because of non-availability of the
tokens
-				//pkt has not been send out hence setting the pending flag
indicating the host to send it out
-				//first next iteration  .
+				/*
+				this part indicates that because of non-availability of the tokens
+				pkt has not been send out hence setting the pending flag indicating
the host to send it out
+				first next iteration.
+				*/
 				psSF->uiPendedLast = TRUE;
 				spin_unlock_bh(&psSF->SFQueueLock);
 			}
@@ -286,7 +288,7 @@ VOID transmit_packets(struct bcm_mini_adapter
*Adapter)
 
 	while (uiPrevTotalCount > 0 && !Adapter->device_removed) {
 		exit_flag = TRUE;
-			//second iteration to parse non-pending queues
+		/* second iteration to parse non-pending queues */
 		for (iIndex = HiPriority; iIndex >= 0; iIndex--) {
 			if (!uiPrevTotalCount || (TRUE == Adapter->device_removed))
 				break;
-- 
1.8.3.1



