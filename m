Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbaGRBpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:45:12 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:43628 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbaGRBpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:45:10 -0400
From: Khoa Mai <mdk194@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Christian Bay <christian.bay@studium.fau.de>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Martin Gumbrecht <martin.gumbrecht@googlemail.com>,
        Luis Ortega <luiorpe1@gmail.com>, Joe Perches <joe@perches.com>,
        Lilis Iskandar <veeableful@gmail.com>, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Khoa Mai <mdk194@gmail.com>
Subject: [PATCH 1/2] staging: bcm: Qos.c: Fix coding style
Date: Fri, 18 Jul 2014 04:45:04 +0300
Message-Id: <1405647905-21092-1-git-send-email-mdk194@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix C99 comment

Signed-off-by: Khoa Mai <mdk194@gmail.com>
---
 drivers/staging/bcm/Qos.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index c5213b3..e3cbcb1 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -322,8 +322,8 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 	spin_lock_bh(&Adapter->PackInfo[iIndex].SFQueueLock);
 
 	while (1) {
-//	while((UINT)Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost >
-//		SF_MAX_ALLOWED_PACKETS_TO_BACKUP) {
+	/* while((UINT)Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost > */
+	/* 	SF_MAX_ALLOWED_PACKETS_TO_BACKUP) { */
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "uiCurrentBytesOnHost:%x uiMaxBucketSize :%x",
 		Adapter->PackInfo[iIndex].uiCurrentBytesOnHost,
@@ -379,7 +379,7 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "=====>");
 
-//	down(&Adapter->data_packet_queue_lock);
+	/* down(&Adapter->data_packet_queue_lock); */
 	for (iQIndex = LowPriority; iQIndex < HiPriority; iQIndex++) {
 		struct net_device_stats *netstats = &Adapter->dev->stats;
 
@@ -413,7 +413,7 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 		}
 		spin_unlock_bh(&Adapter->PackInfo[iQIndex].SFQueueLock);
 	}
-//	up(&Adapter->data_packet_queue_lock);
+	/* up(&Adapter->data_packet_queue_lock); */
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "<=====");
 }
 
@@ -765,7 +765,7 @@ static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter, PVOID pvEthPayload
 			/* 802.1Q VLAN Header */
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802QVLANFrame;
 			u16Etype = ((struct bcm_eth_q_frame *)pvEthPayload)->EthType;
-			//((ETH_CS_802_Q_FRAME*)pvEthPayload)->UserPriority
+			/* ((ETH_CS_802_Q_FRAME*)pvEthPayload)->UserPriority */
 		} else {
 			pstEthCsPktInfo->eNwpktEthFrameType = eEthOtherFrame;
 			u16Etype = ntohs(u16Etype);
-- 
2.0.1

