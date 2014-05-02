Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaEBUkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:40:45 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36634 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaEBUko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:40:44 -0400
From: Greg DeAngelis <gdeangel@gmail.com>
To: gregkh@linuxfoundation.org, lisa@xenapiadmin.com
Cc: gdeangel@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: bcm: fix lines over 80 characters
Date: Fri,  2 May 2014 16:40:30 -0400
Message-Id: <1399063230-62795-1-git-send-email-gdeangel@gmail.com>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Greg DeAngelis <gdeangel@gmail.com>
---
 drivers/staging/bcm/Transmit.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmit.c
index 2ed4836..4976746 100644
--- a/drivers/staging/bcm/Transmit.c
+++ b/drivers/staging/bcm/Transmit.c
@@ -46,12 +46,14 @@ int SendControlPacket(struct bcm_mini_adapter *Adapter, char *pControlPacket)
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_CONTROL, DBG_LVL_ALL, "Tx");
 	if (!pControlPacket || !Adapter) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_CONTROL, DBG_LVL_ALL, "Got NULL Control Packet or Adapter");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_CONTROL, DBG_LVL_ALL,
+				"Got NULL Control Packet or Adapter");
 		return STATUS_FAILURE;
 	}
 	if ((atomic_read(&Adapter->CurrNumFreeTxDesc) <
 			((PLeader->PLength-1)/MAX_DEVICE_DESC_SIZE)+1))	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_CONTROL, DBG_LVL_ALL, "NO FREE DESCRIPTORS TO SEND CONTROL PACKET");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_CONTROL, DBG_LVL_ALL,
+				"NO FREE DESCRIPTORS TO SEND CONTROL PACKET");
 		return STATUS_FAILURE;
 	}
 
@@ -109,7 +111,8 @@ int SetupNextSend(struct bcm_mini_adapter *Adapter,  struct sk_buff *Packet, USH
 			(UINT *)&Packet->len, Adapter->PackInfo[QueueIndex].bEthCSSupport);
 
 	if (status != STATUS_SUCCESS) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "PHS Transmit failed..\n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,
+				"PHS Transmit failed..\n");
 		goto errExit;
 	}
 
@@ -217,12 +220,15 @@ int tx_pkt_handler(struct bcm_mini_adapter *Adapter /**< pointer to adapter obje
 			Adapter->LinkStatus == SYNC_UP_REQUEST &&
 			!Adapter->bSyncUpRequestSent) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Calling LinkMessage");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS,
+					DBG_LVL_ALL, "Calling LinkMessage");
 			LinkMessage(Adapter);
 		}
 
 		if ((Adapter->IdleMode || Adapter->bShutStatus) && atomic_read(&Adapter->TotalPacketCount)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Device in Low Power mode...waking up");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX,
+					TX_PACKETS, DBG_LVL_ALL,
+					"Device in Low Power mode...waking up");
 			Adapter->usIdleModePattern = ABORT_IDLE_MODE;
 			Adapter->bWakeUpDevice = TRUE;
 			wake_up(&Adapter->process_rx_cntrlpkt);
@@ -232,7 +238,8 @@ int tx_pkt_handler(struct bcm_mini_adapter *Adapter /**< pointer to adapter obje
 		atomic_set(&Adapter->TxPktAvail, 0);
 	}
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Exiting the tx thread..\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL,
+			"Exiting the tx thread..\n");
 	Adapter->transmit_packet_thread = NULL;
 	return 0;
 }
-- 
1.7.10.4

