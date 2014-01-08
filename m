Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaAHWRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:17:18 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36661 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756768AbaAHWPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:15:54 -0500
From: Matthias Oefelein <ma.oefelein@arcor.de>
To: ma.oefelein@arcor.de
Cc: linux-kernel@rmueck.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] beeceem: Fix missing spaces between function arguments in InterfaceRx.c
Date: Wed,  8 Jan 2014 23:15:06 +0100
Message-Id: <1389219310-8015-3-git-send-email-ma.oefelein@arcor.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
References: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix adds missing spaces after commas in function calls/definitions.

Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>

---
 drivers/staging/bcm/InterfaceRx.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index 55f7436..aa1df66 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -1,6 +1,6 @@
 #include "headers.h"
 
-static int SearchVcid(struct bcm_mini_adapter *Adapter,unsigned short usVcid)
+static int SearchVcid(struct bcm_mini_adapter *Adapter, unsigned short usVcid)
 {
 	int iIndex = 0;
 
@@ -25,7 +25,7 @@ GetBulkInRcb(struct bcm_interface_adapter *psIntfAdapter)
 		pRcb = &psIntfAdapter->asUsbRcb[index];
 		pRcb->bUsed = TRUE;
 		pRcb->psIntfAdapter = psIntfAdapter;
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Got Rx desc %d used %d",
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Got Rx desc %d used %d",
 			index, atomic_read(&psIntfAdapter->uNumRcbUsed));
 		index = (index + 1) % MAXIMUM_USB_RCB;
 		atomic_set(&psIntfAdapter->uCurrRcb, index);
@@ -71,7 +71,7 @@ static void read_bulk_callback(struct urb *urb)
 		}
 		else
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL,"Rx URB has got cancelled. status :%d", urb->status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Rx URB has got cancelled. status :%d", urb->status);
 		}
 		pRcb->bUsed = false;
  		atomic_dec(&psIntfAdapter->uNumRcbUsed);
@@ -81,18 +81,18 @@ static void read_bulk_callback(struct urb *urb)
 
 	if(Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL,"device is going in low power mode while PMU option selected..hence rx packet should not be process");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "device is going in low power mode while PMU option selected..hence rx packet should not be process");
 		return;
 	}
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read back done len %d\n", pLeader->PLength);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read back done len %d\n", pLeader->PLength);
 	if(!pLeader->PLength)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Length 0");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Length 0");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Status:0x%hX, Length:0x%hX, VCID:0x%hX", pLeader->Status,pLeader->PLength,pLeader->Vcid);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Status:0x%hX, Length:0x%hX, VCID:0x%hX", pLeader->Status, pLeader->PLength, pLeader->Vcid);
 	if(MAX_CNTL_PKT_SIZE < pLeader->PLength)
 	{
 		if (netif_msg_rx_err(Adapter))
@@ -103,7 +103,7 @@ static void read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	QueueIndex = SearchVcid( Adapter,pLeader->Vcid);
+	QueueIndex = SearchVcid( Adapter, pLeader->Vcid);
 	if(QueueIndex < NO_OF_QUEUES)
 	{
 		bHeaderSupressionEnabled =
@@ -115,7 +115,7 @@ static void read_bulk_callback(struct urb *urb)
 	skb = dev_alloc_skb (pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
 	if(!skb)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! Dropping the Packet");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! Dropping the Packet");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
@@ -123,14 +123,14 @@ static void read_bulk_callback(struct urb *urb)
 	if((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
 	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
 	{
-	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
+	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
 		*(PUSHORT)skb->data = pLeader->Status;
        	memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
 			(sizeof(struct bcm_leader)), pLeader->PLength);
 		skb->len = pLeader->PLength + sizeof(USHORT);
 
 		spin_lock(&Adapter->control_queue_lock);
-		ENQUEUEPACKET(Adapter->RxControlHead,Adapter->RxControlTail,skb);
+		ENQUEUEPACKET(Adapter->RxControlHead, Adapter->RxControlTail, skb);
 		spin_unlock(&Adapter->control_queue_lock);
 
 		atomic_inc(&Adapter->cntrlpktCnt);
@@ -142,7 +142,7 @@ static void read_bulk_callback(struct urb *urb)
 		  * Data Packet, Format a proper Ethernet Header
         	  * and give it to the stack
 		  */
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
 		skb_reserve(skb, 2 + SKB_RESERVE_PHS_BYTES);
 		memcpy(skb->data+ETH_HLEN, (PUCHAR)urb->transfer_buffer + sizeof(struct bcm_leader), pLeader->PLength);
 		skb->dev = Adapter->dev;
@@ -151,14 +151,14 @@ static void read_bulk_callback(struct urb *urb)
 		skb_put (skb, pLeader->PLength + ETH_HLEN);
 		Adapter->PackInfo[QueueIndex].uiTotalRxBytes += pLeader->PLength;
 		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes += pLeader->PLength;
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
 
 		if(netif_running(Adapter->dev))
 		{
 			/* Moving ahead by ETH_HLEN to the data ptr as received from FW */
 			skb_pull(skb, ETH_HLEN);
 			PHSReceive(Adapter, pLeader->Vcid, skb, &skb->len,
-					NULL,bHeaderSupressionEnabled);
+					NULL, bHeaderSupressionEnabled);
 
 			if(!Adapter->PackInfo[QueueIndex].bEthCSSupport)
 			{
@@ -177,7 +177,7 @@ static void read_bulk_callback(struct urb *urb)
 		}
 		else
 		{
-		    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "i/f not up hance freeing SKB...");
+		    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "i/f not up hance freeing SKB...");
 			dev_kfree_skb(skb);
 		}
 
@@ -213,7 +213,7 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
 		if (retval)
 		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
 			//if this return value is because of pipe halt. need to clear this.
 			if(retval == -EPIPE)
 			{
@@ -252,7 +252,7 @@ bool InterfaceRx (struct bcm_interface_adapter *psIntfAdapter)
 		pRcb = GetBulkInRcb(psIntfAdapter);
 		if(pRcb == NULL)
 		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "Unable to get Rcb pointer");
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "Unable to get Rcb pointer");
 			return false;
 		}
 		//atomic_inc(&psIntfAdapter->uNumRcbUsed);
-- 
1.8.1.2

