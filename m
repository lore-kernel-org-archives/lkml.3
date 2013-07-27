Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab3G0TfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:35:13 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54285 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3G0TfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:35:11 -0400
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tulinizer@gmail.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Lilis Iskandar <veeableful@gmail.com>
Subject: [PATCH v2 1/5] Staging: bcm: LeakyBucket: Fixed spacing/tabing issues
Date: Sun, 28 Jul 2013 03:34:43 +0800
Message-Id: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I'm using git send-email now (previously Evolution). Fingers
crossed there won't be any more formatting issues. I also tested the
patches by emailing them to myself and use git am.

Joe, I don't understand what you mean by mentioning "git diff -w".
Perhaps you can clarify it for me? Sorry :(

Summary:
The series of patches fixes coding style issues. This one fixes
spacing/tabbing issues.

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/LeakyBucket.c | 170 +++++++++++++++++++-------------------
 1 file changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index 877cf0b..ee1d9f6 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -17,30 +17,30 @@
 
 static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
 {
-	ULONG 	liCurrentTime;
-	INT 	i = 0;
+	ULONG liCurrentTime;
+	INT i = 0;
 	struct timeval tv;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL,
 			"=====>\n");
-	if(NULL == Adapter)
+	if (NULL == Adapter)
 	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, 
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS,
 				DBG_LVL_ALL, "Adapter found NULL!\n");
 		return;
 	}
 
 	do_gettimeofday(&tv);
-	for(i = 0; i < NO_OF_QUEUES; i++)
+	for (i = 0; i < NO_OF_QUEUES; i++)
 	{
-		if(TRUE == Adapter->PackInfo[i].bValid &&
+		if (TRUE == Adapter->PackInfo[i].bValid &&
 			(1 == Adapter->PackInfo[i].ucDirection))
 		{
 			liCurrentTime = ((tv.tv_sec-
 				Adapter->PackInfo[i].stLastUpdateTokenAt.tv_sec)*1000 +
 				(tv.tv_usec-Adapter->PackInfo[i].stLastUpdateTokenAt.tv_usec)/
 				1000);
-			if(0!=liCurrentTime)
+			if (0 != liCurrentTime)
 			{
 				Adapter->PackInfo[i].uiCurrentTokenCount += (ULONG)
 					((Adapter->PackInfo[i].uiMaxAllowedRate) *
@@ -48,7 +48,7 @@ static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
 				memcpy(&Adapter->PackInfo[i].stLastUpdateTokenAt,
 					&tv, sizeof(struct timeval));
 				Adapter->PackInfo[i].liLastUpdateTokenAt = liCurrentTime;
-				if((Adapter->PackInfo[i].uiCurrentTokenCount) >=
+				if ((Adapter->PackInfo[i].uiCurrentTokenCount) >=
 				Adapter->PackInfo[i].uiMaxBucketSize)
 				{
 					Adapter->PackInfo[i].uiCurrentTokenCount =
@@ -57,7 +57,7 @@ static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
 			}
 		}
 	}
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "<=====\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "<=====\n");
 	return;
 
 }
@@ -79,33 +79,33 @@ static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
 ***********************************************************************/
 static ULONG GetSFTokenCount(struct bcm_mini_adapter *Adapter, struct bcm_packet_info *psSF)
 {
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow ===>");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow ===>");
 	/* Validate the parameters */
-	if(NULL == Adapter || (psSF < Adapter->PackInfo &&
+	if (NULL == Adapter || (psSF < Adapter->PackInfo &&
 		(uintptr_t)psSF > (uintptr_t) &Adapter->PackInfo[HiPriority]))
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Got wrong Parameters:Adapter: %p, QIndex: %zd\n", Adapter, (psSF-Adapter->PackInfo));
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Got wrong Parameters:Adapter: %p, QIndex: %zd\n", Adapter, (psSF-Adapter->PackInfo));
 		return 0;
 	}
 
-	if(FALSE != psSF->bValid && psSF->ucDirection)
+	if (FALSE != psSF->bValid && psSF->ucDirection)
 	{
-		if(0 != psSF->uiCurrentTokenCount)
+		if (0 != psSF->uiCurrentTokenCount)
 		{
 				return psSF->uiCurrentTokenCount;
 		}
 		else
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "Not enough tokens in queue %zd Available %u\n",
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "Not enough tokens in queue %zd Available %u\n",
 				psSF-Adapter->PackInfo, psSF->uiCurrentTokenCount);
 			psSF->uiPendedLast = 1;
 		}
 	}
 	else
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Queue %zd not valid\n", psSF-Adapter->PackInfo);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Queue %zd not valid\n", psSF-Adapter->PackInfo);
 	}
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow <===");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow <===");
 	return 0;
 }
 
@@ -118,31 +118,31 @@ static INT SendPacketFromQueue(struct bcm_mini_adapter *Adapter,/**<Logical Adap
 			struct bcm_packet_info *psSF, /**<Queue identifier*/
 			       struct sk_buff*  Packet)	/**<Pointer to the packet to be sent*/
 {
-	INT  	Status=STATUS_FAILURE;
-	UINT uiIndex =0,PktLen = 0;
+	INT Status = STATUS_FAILURE;
+	UINT uiIndex = 0, PktLen = 0;
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "=====>");
-	if(!Adapter || !Packet || !psSF)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "=====>");
+	if (!Adapter || !Packet || !psSF)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "Got NULL Adapter or Packet");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "Got NULL Adapter or Packet");
 		return -EINVAL;
 	}
 
-	if(psSF->liDrainCalculated==0)
+	if (psSF->liDrainCalculated == 0)
 	{
 		psSF->liDrainCalculated = jiffies;
 	}
 	///send the packet to the fifo..
 	PktLen = Packet->len;
 	Status = SetupNextSend(Adapter, Packet, psSF->usVCID_Value);
-	if(Status == 0)
+	if (Status == 0)
 	{
-		for(uiIndex = 0 ; uiIndex < MIBS_MAX_HIST_ENTRIES ; uiIndex++)
-		{	if((PktLen <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) && (PktLen > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
+		for (uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
+		{	if ((PktLen <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) && (PktLen > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
 				Adapter->aTxPktSizeHist[uiIndex]++;
 		}
 	}
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "<=====");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, SEND_QUEUE, DBG_LVL_ALL, "<=====");
 	return Status;
 }
 
@@ -160,48 +160,48 @@ static INT SendPacketFromQueue(struct bcm_mini_adapter *Adapter,/**<Logical Adap
 ****************************************************************************/
 static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct bcm_packet_info *psSF)
 {
-	struct sk_buff	*QueuePacket=NULL;
-	char 			*pControlPacket = NULL;
-	INT				Status=0;
-	int				iPacketLen=0;
+	struct sk_buff *QueuePacket = NULL;
+	char *pControlPacket = NULL;
+	INT Status = 0;
+	int iPacketLen = 0;
 
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "%zd ====>", (psSF-Adapter->PackInfo));
-	if((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount))//Get data packet
-  	{
-		if(!psSF->ucDirection )
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "%zd ====>", (psSF-Adapter->PackInfo));
+	if ((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount))//Get data packet
+	{
+		if (!psSF->ucDirection)
 			return;
 
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "UpdateTokenCount ");
-		if(Adapter->IdleMode || Adapter->bPreparingForLowPowerMode)
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "UpdateTokenCount ");
+		if (Adapter->IdleMode || Adapter->bPreparingForLowPowerMode)
 			return;	/* in idle mode */
 
 		// Check for Free Descriptors
-		if(atomic_read(&Adapter->CurrNumFreeTxDesc) <= MINIMUM_PENDING_DESCRIPTORS)
+		if (atomic_read(&Adapter->CurrNumFreeTxDesc) <= MINIMUM_PENDING_DESCRIPTORS)
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " No Free Tx Descriptor(%d) is available for Data pkt..",atomic_read(&Adapter->CurrNumFreeTxDesc));
-			return ;
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " No Free Tx Descriptor(%d) is available for Data pkt..", atomic_read(&Adapter->CurrNumFreeTxDesc));
+			return;
 		}
 
 		spin_lock_bh(&psSF->SFQueueLock);
-		QueuePacket=psSF->FirstTxQueue;
+		QueuePacket = psSF->FirstTxQueue;
 
-		if(QueuePacket)
+		if (QueuePacket)
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Dequeuing Data Packet");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Dequeuing Data Packet");
 
-			if(psSF->bEthCSSupport)
+			if (psSF->bEthCSSupport)
 				iPacketLen = QueuePacket->len;
 			else
 				iPacketLen = QueuePacket->len-ETH_HLEN;
 
-			iPacketLen<<=3;
-			if(iPacketLen <= GetSFTokenCount(Adapter, psSF))
+			iPacketLen <<= 3;
+			if (iPacketLen <= GetSFTokenCount(Adapter, psSF))
 			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Allowed bytes %d",
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Allowed bytes %d",
 					(iPacketLen >> 3));
 
-				DEQUEUEPACKET(psSF->FirstTxQueue,psSF->LastTxQueue);
+				DEQUEUEPACKET(psSF->FirstTxQueue, psSF->LastTxQueue);
 				psSF->uiCurrentBytesOnHost -= (QueuePacket->len);
 				psSF->uiCurrentPacketsOnHost--;
 				atomic_dec(&Adapter->TotalPacketCount);
@@ -212,8 +212,8 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 			}
 			else
 			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For Queue: %zd\n", psSF-Adapter->PackInfo);
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nAvailable Tokens = %d required = %d\n",
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For Queue: %zd\n", psSF-Adapter->PackInfo);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nAvailable Tokens = %d required = %d\n",
 					psSF->uiCurrentTokenCount, iPacketLen);
 				//this part indicates that because of non-availability of the tokens
 				//pkt has not been send out hence setting the pending flag indicating the host to send it out
@@ -230,22 +230,22 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 	else
 	{
 
-		if((atomic_read(&Adapter->CurrNumFreeTxDesc) > 0 ) &&
+		if ((atomic_read(&Adapter->CurrNumFreeTxDesc) > 0) &&
 			(atomic_read(&Adapter->index_rd_txcntrlpkt) !=
 			 atomic_read(&Adapter->index_wr_txcntrlpkt))
 			)
 		{
 			pControlPacket = Adapter->txctlpacket
 			[(atomic_read(&Adapter->index_rd_txcntrlpkt)%MAX_CNTRL_PKTS)];
-			if(pControlPacket)
+			if (pControlPacket)
 			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Sending Control packet");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Sending Control packet");
 				Status = SendControlPacket(Adapter, pControlPacket);
-				if(STATUS_SUCCESS==Status)
+				if (STATUS_SUCCESS == Status)
 				{
 					spin_lock_bh(&psSF->SFQueueLock);
 					psSF->NumOfPacketsSent++;
-					psSF->uiSentBytes+=((struct bcm_leader *)pControlPacket)->PLength;
+					psSF->uiSentBytes += ((struct bcm_leader *)pControlPacket)->PLength;
 					psSF->uiSentPackets++;
 					atomic_dec(&Adapter->TotalPacketCount);
 					psSF->uiCurrentBytesOnHost -= ((struct bcm_leader *)pControlPacket)->PLength;
@@ -254,11 +254,11 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 					spin_unlock_bh(&psSF->SFQueueLock);
 				}
 				else
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "SendControlPacket Failed\n");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "SendControlPacket Failed\n");
 			}
 			else
 			{
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " Control Pkt is not available, Indexing is wrong....");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " Control Pkt is not available, Indexing is wrong....");
 			}
 	   	}
 	}
@@ -277,79 +277,79 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 ********************************************************************/
 VOID transmit_packets(struct bcm_mini_adapter *Adapter)
 {
-	UINT 	uiPrevTotalCount = 0;
+	UINT uiPrevTotalCount = 0;
 	int iIndex = 0;
 
-	BOOLEAN exit_flag = TRUE ;
+	BOOLEAN exit_flag = TRUE;
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "=====>");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "=====>");
 
-	if(NULL == Adapter)
+	if (NULL == Adapter)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX,TX_PACKETS, DBG_LVL_ALL, "Got NULL Adapter");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Got NULL Adapter");
 		return;
 	}
-	if(Adapter->device_removed == TRUE)
+	if (Adapter->device_removed == TRUE)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Device removed");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Device removed");
 		return;
 	}
 
-    BCM_DEBUG_PRINT (Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nUpdateTokenCount ====>\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nUpdateTokenCount ====>\n");
 
 	UpdateTokenCount(Adapter);
 
-    BCM_DEBUG_PRINT (Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nPruneQueueAllSF ====>\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nPruneQueueAllSF ====>\n");
 
 	PruneQueueAllSF(Adapter);
 
 	uiPrevTotalCount = atomic_read(&Adapter->TotalPacketCount);
 
-	for(iIndex=HiPriority;iIndex>=0;iIndex--)
+	for (iIndex = HiPriority; iIndex >= 0; iIndex--)
 	{
-		if(	!uiPrevTotalCount || (TRUE == Adapter->device_removed))
+		if (!uiPrevTotalCount || (TRUE == Adapter->device_removed))
 				break;
 
-		if(Adapter->PackInfo[iIndex].bValid &&
+		if (Adapter->PackInfo[iIndex].bValid &&
 			Adapter->PackInfo[iIndex].uiPendedLast &&
 			Adapter->PackInfo[iIndex].uiCurrentBytesOnHost)
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Calling CheckAndSendPacketFromIndex..");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Calling CheckAndSendPacketFromIndex..");
 			CheckAndSendPacketFromIndex(Adapter, &Adapter->PackInfo[iIndex]);
 			uiPrevTotalCount--;
 		}
 	}
 
-	while(uiPrevTotalCount > 0 && !Adapter->device_removed)
+	while (uiPrevTotalCount > 0 && !Adapter->device_removed)
 	{
-		exit_flag = TRUE ;
+		exit_flag = TRUE;
 			//second iteration to parse non-pending queues
-		for(iIndex=HiPriority;iIndex>=0;iIndex--)
+		for (iIndex = HiPriority; iIndex >= 0; iIndex--)
 		{
-			if( !uiPrevTotalCount || (TRUE == Adapter->device_removed))
-					break;
+			if (!uiPrevTotalCount || (TRUE == Adapter->device_removed))
+				break;
 
-			if(Adapter->PackInfo[iIndex].bValid &&
+			if (Adapter->PackInfo[iIndex].bValid &&
 				Adapter->PackInfo[iIndex].uiCurrentBytesOnHost &&
-				!Adapter->PackInfo[iIndex].uiPendedLast )
+				!Adapter->PackInfo[iIndex].uiPendedLast)
 			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Calling CheckAndSendPacketFromIndex..");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Calling CheckAndSendPacketFromIndex..");
 				CheckAndSendPacketFromIndex(Adapter, &Adapter->PackInfo[iIndex]);
 				uiPrevTotalCount--;
 				exit_flag = FALSE;
 			}
 		}
 
-		if(Adapter->IdleMode || Adapter->bPreparingForLowPowerMode)
+		if (Adapter->IdleMode || Adapter->bPreparingForLowPowerMode)
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "In Idle Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "In Idle Mode\n");
 			break;
 		}
-		if(exit_flag == TRUE )
-		    break ;
-	}/* end of inner while loop */
+		if (exit_flag == TRUE)
+		    break;
+	} /* end of inner while loop */
 
-	update_per_cid_rx  (Adapter);
+	update_per_cid_rx(Adapter);
 	Adapter->txtransmit_running = 0;
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "<======");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "<======");
 }
-- 
1.8.3.1

