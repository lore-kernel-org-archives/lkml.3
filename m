Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaAHWQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:16:40 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36693 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932322AbaAHWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:15:56 -0500
From: Matthias Oefelein <ma.oefelein@arcor.de>
To: ma.oefelein@arcor.de
Cc: linux-kernel@rmueck.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] beeceem: Fix newline issues at opening braces of conditional statements in InterfaceRx.c
Date: Wed,  8 Jan 2014 23:15:09 +0100
Message-Id: <1389219310-8015-6-git-send-email-ma.oefelein@arcor.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
References: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In InterfaceRx.c, opening braces of (if-)conditionals are mostly dislocated, meaning they are found behind an extra line break after the conditional statement.
This patch moves the opening braces accordingly as specified by the official conding style guidelines.

Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>

---
 drivers/staging/bcm/InterfaceRx.c | 66 +++++++++++++--------------------------
 1 file changed, 21 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index 12921a4..b556d73 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -19,8 +19,7 @@ GetBulkInRcb(struct bcm_interface_adapter *psIntfAdapter)
 	UINT index = 0;
 
 	if ((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
-	    (psIntfAdapter->psAdapter->StopAllXaction == false))
-	{
+	    (psIntfAdapter->psAdapter->StopAllXaction == false)) {
 		index = atomic_read(&psIntfAdapter->uCurrRcb);
 		pRcb = &psIntfAdapter->asUsbRcb[index];
 		pRcb->bUsed = TRUE;
@@ -54,22 +53,17 @@ static void read_bulk_callback(struct urb *urb)
 
 	if ((Adapter->device_removed == TRUE) ||
 	    (TRUE == Adapter->bEndPointHalted) ||
-	    (0 == urb->actual_length))
-	{
+	    (0 == urb->actual_length)) {
 		pRcb->bUsed = false;
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 
-	if (urb->status != STATUS_SUCCESS)
-	{
-		if (urb->status == -EPIPE)
-		{
+	if (urb->status != STATUS_SUCCESS) {
+		if (urb->status == -EPIPE) {
 			Adapter->bEndPointHalted = TRUE;
 			wake_up(&Adapter->tx_packet_wait_queue);
-		}
-		else
-		{
+		} else {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Rx URB has got cancelled. status :%d", urb->status);
 		}
 		pRcb->bUsed = false;
@@ -78,22 +72,19 @@ static void read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	if (Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
-	{
+	if (Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode)) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "device is going in low power mode while PMU option selected..hence rx packet should not be process");
 		return;
 	}
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read back done len %d\n", pLeader->PLength);
-	if (!pLeader->PLength)
-	{
+	if (!pLeader->PLength) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Length 0");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Status:0x%hX, Length:0x%hX, VCID:0x%hX", pLeader->Status, pLeader->PLength, pLeader->Vcid);
-	if (MAX_CNTL_PKT_SIZE < pLeader->PLength)
-	{
+	if (MAX_CNTL_PKT_SIZE < pLeader->PLength) {
 		if (netif_msg_rx_err(Adapter))
 			pr_info(PFX "%s: corrupted leader length...%d\n",
 				Adapter->dev->name, pLeader->PLength);
@@ -103,8 +94,7 @@ static void read_bulk_callback(struct urb *urb)
 	}
 
 	QueueIndex = SearchVcid(Adapter, pLeader->Vcid);
-	if (QueueIndex < NO_OF_QUEUES)
-	{
+	if (QueueIndex < NO_OF_QUEUES) {
 		bHeaderSupressionEnabled =
 			Adapter->PackInfo[QueueIndex].bHeaderSuppressionEnabled;
 		bHeaderSupressionEnabled =
@@ -112,16 +102,14 @@ static void read_bulk_callback(struct urb *urb)
 	}
 
 	skb = dev_alloc_skb(pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
-	if (!skb)
-	{
+	if (!skb) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! Dropping the Packet");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 	/* If it is a control Packet, then call handle_bcm_packet ()*/
 	if ((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
-	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
-	{
+	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F))) {
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
 		*(PUSHORT)skb->data = pLeader->Status;
 		memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
@@ -134,9 +122,7 @@ static void read_bulk_callback(struct urb *urb)
 
 		atomic_inc(&Adapter->cntrlpktCnt);
 		wake_up(&Adapter->process_rx_cntrlpkt);
-	}
-	else
-	{
+	} else {
 		/*
 		 * Data Packet, Format a proper Ethernet Header
 		 * and give it to the stack
@@ -152,15 +138,13 @@ static void read_bulk_callback(struct urb *urb)
 		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes += pLeader->PLength;
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
 
-		if (netif_running(Adapter->dev))
-		{
+		if (netif_running(Adapter->dev)) {
 			/* Moving ahead by ETH_HLEN to the data ptr as received from FW */
 			skb_pull(skb, ETH_HLEN);
 			PHSReceive(Adapter, pLeader->Vcid, skb, &skb->len,
 				   NULL, bHeaderSupressionEnabled);
 
-			if (!Adapter->PackInfo[QueueIndex].bEthCSSupport)
-			{
+			if (!Adapter->PackInfo[QueueIndex].bEthCSSupport) {
 				skb_push(skb, ETH_HLEN);
 
 				memcpy(skb->data, skb->dev->dev_addr, 6);
@@ -173,9 +157,7 @@ static void read_bulk_callback(struct urb *urb)
 
 			skb->protocol = eth_type_trans(skb, Adapter->dev);
 			process_done = netif_rx(skb);
-		}
-		else
-		{
+		} else {
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "i/f not up hance freeing SKB...");
 			dev_kfree_skb(skb);
 		}
@@ -183,8 +165,7 @@ static void read_bulk_callback(struct urb *urb)
 		++Adapter->dev->stats.rx_packets;
 		Adapter->dev->stats.rx_bytes += pLeader->PLength;
 
-		for (uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
-		{
+		for (uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++) {
 			if ((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) &&
 			    (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
 				Adapter->aRxPktSizeHist[uiIndex]++;
@@ -205,15 +186,12 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 	if (false == psIntfAdapter->psAdapter->device_removed &&
 	    false == psIntfAdapter->psAdapter->bEndPointHalted &&
 	    false == psIntfAdapter->bSuspended &&
-	    false == psIntfAdapter->bPreparingForBusSuspend)
-	{
+	    false == psIntfAdapter->bPreparingForBusSuspend) {
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
-		if (retval)
-		{
+		if (retval) {
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
 			//if this return value is because of pipe halt. need to clear this.
-			if (retval == -EPIPE)
-			{
+			if (retval == -EPIPE) {
 				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
@@ -244,11 +222,9 @@ bool InterfaceRx(struct bcm_interface_adapter *psIntfAdapter)
 
 //	RxDescCount = psIntfAdapter->psAdapter->CurrNumRecvDescs -
 //				psIntfAdapter->psAdapter->PrevNumRecvDescs;
-	while (RxDescCount)
-	{
+	while (RxDescCount) {
 		pRcb = GetBulkInRcb(psIntfAdapter);
-		if (pRcb == NULL)
-		{
+		if (pRcb == NULL) {
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "Unable to get Rcb pointer");
 			return false;
 		}
-- 
1.8.1.2

