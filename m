Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3GZOUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:20:22 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41836 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3GZOUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:20:21 -0400
Message-ID: <1374848415.13685.3.camel@desktop>
Subject: [PATCH 2/5] Staging: bcm: LeakyBucket: Fixed brace issues
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jamesceri@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Jul 2013 22:20:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed brace issues

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/LeakyBucket.c | 118 +++++++++++++-------------------------
 1 file changed, 39 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index ee1d9f6..52e6e05 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -23,34 +23,29 @@ static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL,
 			"=====>\n");
-	if (NULL == Adapter)
-	{
+	if (NULL == Adapter) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS,
 				DBG_LVL_ALL, "Adapter found NULL!\n");
 		return;
 	}
 
 	do_gettimeofday(&tv);
-	for (i = 0; i < NO_OF_QUEUES; i++)
-	{
+	for (i = 0; i < NO_OF_QUEUES; i++) {
 		if (TRUE == Adapter->PackInfo[i].bValid &&
-			(1 == Adapter->PackInfo[i].ucDirection))
-		{
+		    (1 == Adapter->PackInfo[i].ucDirection)) {
 			liCurrentTime = ((tv.tv_sec-
 				Adapter->PackInfo[i].stLastUpdateTokenAt.tv_sec)*1000 +
 				(tv.tv_usec-Adapter->PackInfo[i].stLastUpdateTokenAt.tv_usec)/
 				1000);
-			if (0 != liCurrentTime)
-			{
+			if (0 != liCurrentTime) {
 				Adapter->PackInfo[i].uiCurrentTokenCount += (ULONG)
 					((Adapter->PackInfo[i].uiMaxAllowedRate) *
 					((ULONG)((liCurrentTime)))/1000);
 				memcpy(&Adapter->PackInfo[i].stLastUpdateTokenAt,
 					&tv, sizeof(struct timeval));
 				Adapter->PackInfo[i].liLastUpdateTokenAt = liCurrentTime;
-				if ((Adapter->PackInfo[i].uiCurrentTokenCount) >=
-				Adapter->PackInfo[i].uiMaxBucketSize)
-				{
+				if (Adapter->PackInfo[i].uiCurrentTokenCount >=
+				    Adapter->PackInfo[i].uiMaxBucketSize) {
 					Adapter->PackInfo[i].uiCurrentTokenCount =
 						Adapter->PackInfo[i].uiMaxBucketSize;
 				}
@@ -82,27 +77,20 @@ static ULONG GetSFTokenCount(struct bcm_mini_adapter *Adapter, struct bcm_packet
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow ===>");
 	/* Validate the parameters */
 	if (NULL == Adapter || (psSF < Adapter->PackInfo &&
-		(uintptr_t)psSF > (uintptr_t) &Adapter->PackInfo[HiPriority]))
-	{
+	    (uintptr_t)psSF > (uintptr_t) &Adapter->PackInfo[HiPriority])) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Got wrong Parameters:Adapter: %p, QIndex: %zd\n", Adapter, (psSF-Adapter->PackInfo));
 		return 0;
 	}
 
-	if (FALSE != psSF->bValid && psSF->ucDirection)
-	{
-		if (0 != psSF->uiCurrentTokenCount)
-		{
+	if (FALSE != psSF->bValid && psSF->ucDirection) {
+		if (0 != psSF->uiCurrentTokenCount) {
 				return psSF->uiCurrentTokenCount;
-		}
-		else
-		{
+		} else {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "Not enough tokens in queue %zd Available %u\n",
 				psSF-Adapter->PackInfo, psSF->uiCurrentTokenCount);
 			psSF->uiPendedLast = 1;
 		}
-	}
-	else
-	{
+	} else {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Queue %zd not valid\n", psSF-Adapter->PackInfo);
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow <===");
@@ -122,23 +110,19 @@ static INT SendPacketFromQueue(struct bcm_mini_adapter *Adapter,/**<Logical Adap
 	UINT uiIndex = 0, PktLen = 0;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "=====>");
-	if (!Adapter || !Packet || !psSF)
-	{
+	if (!Adapter || !Packet || !psSF) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "Got NULL Adapter or Packet");
 		return -EINVAL;
 	}
 
 	if (psSF->liDrainCalculated == 0)
-	{
 		psSF->liDrainCalculated = jiffies;
-	}
 	///send the packet to the fifo..
 	PktLen = Packet->len;
 	Status = SetupNextSend(Adapter, Packet, psSF->usVCID_Value);
-	if (Status == 0)
-	{
-		for (uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
-		{	if ((PktLen <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) && (PktLen > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
+	if (Status == 0) {
+		for (uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++) {
+			if ((PktLen <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) && (PktLen > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
 				Adapter->aTxPktSizeHist[uiIndex]++;
 		}
 	}
@@ -167,8 +151,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "%zd ====>", (psSF-Adapter->PackInfo));
-	if ((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount))//Get data packet
-	{
+	if ((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount)) { //Get data packet
 		if (!psSF->ucDirection)
 			return;
 
@@ -177,8 +160,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 			return;	/* in idle mode */
 
 		// Check for Free Descriptors
-		if (atomic_read(&Adapter->CurrNumFreeTxDesc) <= MINIMUM_PENDING_DESCRIPTORS)
-		{
+		if (atomic_read(&Adapter->CurrNumFreeTxDesc) <= MINIMUM_PENDING_DESCRIPTORS) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " No Free Tx Descriptor(%d) is available for Data pkt..", atomic_read(&Adapter->CurrNumFreeTxDesc));
 			return;
 		}
@@ -186,8 +168,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 		spin_lock_bh(&psSF->SFQueueLock);
 		QueuePacket = psSF->FirstTxQueue;
 
-		if (QueuePacket)
-		{
+		if (QueuePacket) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Dequeuing Data Packet");
 
 			if (psSF->bEthCSSupport)
@@ -196,8 +177,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 				iPacketLen = QueuePacket->len-ETH_HLEN;
 
 			iPacketLen <<= 3;
-			if (iPacketLen <= GetSFTokenCount(Adapter, psSF))
-			{
+			if (iPacketLen <= GetSFTokenCount(Adapter, psSF)) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Allowed bytes %d",
 					(iPacketLen >> 3));
 
@@ -209,9 +189,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 
 			   	Status = SendPacketFromQueue(Adapter, psSF, QueuePacket);
 				psSF->uiPendedLast = FALSE;
-			}
-			else
-			{
+			} else {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For Queue: %zd\n", psSF-Adapter->PackInfo);
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nAvailable Tokens = %d required = %d\n",
 					psSF->uiCurrentTokenCount, iPacketLen);
@@ -221,28 +199,20 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 				psSF->uiPendedLast = TRUE;
 				spin_unlock_bh(&psSF->SFQueueLock);
 			}
-		}
-		else
-		{
+		} else {
 			spin_unlock_bh(&psSF->SFQueueLock);
 		}
-	}
-	else
-	{
+	} else {
 
 		if ((atomic_read(&Adapter->CurrNumFreeTxDesc) > 0) &&
-			(atomic_read(&Adapter->index_rd_txcntrlpkt) !=
-			 atomic_read(&Adapter->index_wr_txcntrlpkt))
-			)
-		{
+		    (atomic_read(&Adapter->index_rd_txcntrlpkt) !=
+		     atomic_read(&Adapter->index_wr_txcntrlpkt))) {
 			pControlPacket = Adapter->txctlpacket
 			[(atomic_read(&Adapter->index_rd_txcntrlpkt)%MAX_CNTRL_PKTS)];
-			if (pControlPacket)
-			{
+			if (pControlPacket) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Sending Control packet");
 				Status = SendControlPacket(Adapter, pControlPacket);
-				if (STATUS_SUCCESS == Status)
-				{
+				if (STATUS_SUCCESS == Status) {
 					spin_lock_bh(&psSF->SFQueueLock);
 					psSF->NumOfPacketsSent++;
 					psSF->uiSentBytes += ((struct bcm_leader *)pControlPacket)->PLength;
@@ -252,12 +222,10 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 					psSF->uiCurrentPacketsOnHost--;
 					atomic_inc(&Adapter->index_rd_txcntrlpkt);
 					spin_unlock_bh(&psSF->SFQueueLock);
-				}
-				else
+				} else {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "SendControlPacket Failed\n");
-			}
-			else
-			{
+				}
+			} else {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " Control Pkt is not available, Indexing is wrong....");
 			}
 	   	}
@@ -284,13 +252,11 @@ VOID transmit_packets(struct bcm_mini_adapter *Adapter)
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "=====>");
 
-	if (NULL == Adapter)
-	{
+	if (NULL == Adapter) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Got NULL Adapter");
 		return;
 	}
-	if (Adapter->device_removed == TRUE)
-	{
+	if (Adapter->device_removed == TRUE) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Device removed");
 		return;
 	}
@@ -305,34 +271,29 @@ VOID transmit_packets(struct bcm_mini_adapter *Adapter)
 
 	uiPrevTotalCount = atomic_read(&Adapter->TotalPacketCount);
 
-	for (iIndex = HiPriority; iIndex >= 0; iIndex--)
-	{
+	for (iIndex = HiPriority; iIndex >= 0; iIndex--) {
 		if (!uiPrevTotalCount || (TRUE == Adapter->device_removed))
 				break;
 
 		if (Adapter->PackInfo[iIndex].bValid &&
-			Adapter->PackInfo[iIndex].uiPendedLast &&
-			Adapter->PackInfo[iIndex].uiCurrentBytesOnHost)
-		{
+		    Adapter->PackInfo[iIndex].uiPendedLast &&
+		    Adapter->PackInfo[iIndex].uiCurrentBytesOnHost) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Calling CheckAndSendPacketFromIndex..");
 			CheckAndSendPacketFromIndex(Adapter, &Adapter->PackInfo[iIndex]);
 			uiPrevTotalCount--;
 		}
 	}
 
-	while (uiPrevTotalCount > 0 && !Adapter->device_removed)
-	{
+	while (uiPrevTotalCount > 0 && !Adapter->device_removed) {
 		exit_flag = TRUE;
 			//second iteration to parse non-pending queues
-		for (iIndex = HiPriority; iIndex >= 0; iIndex--)
-		{
+		for (iIndex = HiPriority; iIndex >= 0; iIndex--) {
 			if (!uiPrevTotalCount || (TRUE == Adapter->device_removed))
 				break;
 
 			if (Adapter->PackInfo[iIndex].bValid &&
-				Adapter->PackInfo[iIndex].uiCurrentBytesOnHost &&
-				!Adapter->PackInfo[iIndex].uiPendedLast)
-			{
+			    Adapter->PackInfo[iIndex].uiCurrentBytesOnHost &&
+			    !Adapter->PackInfo[iIndex].uiPendedLast) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Calling CheckAndSendPacketFromIndex..");
 				CheckAndSendPacketFromIndex(Adapter, &Adapter->PackInfo[iIndex]);
 				uiPrevTotalCount--;
@@ -340,8 +301,7 @@ VOID transmit_packets(struct bcm_mini_adapter *Adapter)
 			}
 		}
 
-		if (Adapter->IdleMode || Adapter->bPreparingForLowPowerMode)
-		{
+		if (Adapter->IdleMode || Adapter->bPreparingForLowPowerMode) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "In Idle Mode\n");
 			break;
 		}
-- 
1.8.3.1



