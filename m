Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaAHWRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:17:15 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36672 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192AbaAHWPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:15:54 -0500
From: Matthias Oefelein <ma.oefelein@arcor.de>
To: ma.oefelein@arcor.de
Cc: linux-kernel@rmueck.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] beeceem: Fix broken indentations in InterfaceRx.c
Date: Wed,  8 Jan 2014 23:15:07 +0100
Message-Id: <1389219310-8015-4-git-send-email-ma.oefelein@arcor.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
References: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch reports a lot of spaces at the beginning of lines and other wrong indentations. This patch fixes these issues.

Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>

---
 drivers/staging/bcm/InterfaceRx.c | 55 ++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index aa1df66..5ebcf9b 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -19,14 +19,14 @@ GetBulkInRcb(struct bcm_interface_adapter *psIntfAdapter)
 	UINT index = 0;
 
 	if((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
-		(psIntfAdapter->psAdapter->StopAllXaction == false))
+	   (psIntfAdapter->psAdapter->StopAllXaction == false))
 	{
 		index = atomic_read(&psIntfAdapter->uCurrRcb);
 		pRcb = &psIntfAdapter->asUsbRcb[index];
 		pRcb->bUsed = TRUE;
 		pRcb->psIntfAdapter = psIntfAdapter;
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Got Rx desc %d used %d",
-			index, atomic_read(&psIntfAdapter->uNumRcbUsed));
+				index, atomic_read(&psIntfAdapter->uNumRcbUsed));
 		index = (index + 1) % MAXIMUM_USB_RCB;
 		atomic_set(&psIntfAdapter->uCurrRcb, index);
 		atomic_inc(&psIntfAdapter->uNumRcbUsed);
@@ -52,13 +52,12 @@ static void read_bulk_callback(struct urb *urb)
 		pr_info(PFX "%s: rx urb status %d length %d\n",
 			Adapter->dev->name, urb->status, urb->actual_length);
 
-	if((Adapter->device_removed == TRUE)  ||
-		(TRUE == Adapter->bEndPointHalted) ||
-		(0 == urb->actual_length)
-		)
+	if((Adapter->device_removed == TRUE) ||
+	   (TRUE == Adapter->bEndPointHalted) ||
+	   (0 == urb->actual_length))
 	{
-	 	pRcb->bUsed = false;
- 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
+		pRcb->bUsed = false;
+		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 
@@ -74,7 +73,7 @@ static void read_bulk_callback(struct urb *urb)
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Rx URB has got cancelled. status :%d", urb->status);
 		}
 		pRcb->bUsed = false;
- 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
+		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		urb->status = STATUS_SUCCESS;
 		return;
 	}
@@ -119,14 +118,14 @@ static void read_bulk_callback(struct urb *urb)
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
-    /* If it is a control Packet, then call handle_bcm_packet ()*/
+	/* If it is a control Packet, then call handle_bcm_packet ()*/
 	if((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
-	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
+	   (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
 	{
-	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
 		*(PUSHORT)skb->data = pLeader->Status;
-       	memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
-			(sizeof(struct bcm_leader)), pLeader->PLength);
+		memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
+		       (sizeof(struct bcm_leader)), pLeader->PLength);
 		skb->len = pLeader->PLength + sizeof(USHORT);
 
 		spin_lock(&Adapter->control_queue_lock);
@@ -139,10 +138,10 @@ static void read_bulk_callback(struct urb *urb)
 	else
 	{
 		/*
-		  * Data Packet, Format a proper Ethernet Header
-        	  * and give it to the stack
-		  */
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
+		 * Data Packet, Format a proper Ethernet Header
+		 * and give it to the stack
+		 */
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
 		skb_reserve(skb, 2 + SKB_RESERVE_PHS_BYTES);
 		memcpy(skb->data+ETH_HLEN, (PUCHAR)urb->transfer_buffer + sizeof(struct bcm_leader), pLeader->PLength);
 		skb->dev = Adapter->dev;
@@ -151,14 +150,14 @@ static void read_bulk_callback(struct urb *urb)
 		skb_put (skb, pLeader->PLength + ETH_HLEN);
 		Adapter->PackInfo[QueueIndex].uiTotalRxBytes += pLeader->PLength;
 		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes += pLeader->PLength;
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
 
 		if(netif_running(Adapter->dev))
 		{
 			/* Moving ahead by ETH_HLEN to the data ptr as received from FW */
 			skb_pull(skb, ETH_HLEN);
 			PHSReceive(Adapter, pLeader->Vcid, skb, &skb->len,
-					NULL, bHeaderSupressionEnabled);
+				   NULL, bHeaderSupressionEnabled);
 
 			if(!Adapter->PackInfo[QueueIndex].bEthCSSupport)
 			{
@@ -177,7 +176,7 @@ static void read_bulk_callback(struct urb *urb)
 		}
 		else
 		{
-		    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "i/f not up hance freeing SKB...");
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "i/f not up hance freeing SKB...");
 			dev_kfree_skb(skb);
 		}
 
@@ -186,12 +185,12 @@ static void read_bulk_callback(struct urb *urb)
 
 		for(uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
 		{
-			if((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1))
-				&& (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
+			if((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) &&
+			   (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
 				Adapter->aRxPktSizeHist[uiIndex]++;
 		}
 	}
- 	Adapter->PrevNumRecvDescs++;
+	Adapter->PrevNumRecvDescs++;
 	pRcb->bUsed = false;
 	atomic_dec(&psIntfAdapter->uNumRcbUsed);
 }
@@ -201,10 +200,8 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 	struct urb *urb = pRcb->urb;
 	int retval = 0;
 
-	usb_fill_bulk_urb(urb, psIntfAdapter->udev, usb_rcvbulkpipe(
-			psIntfAdapter->udev, psIntfAdapter->sBulkIn.bulk_in_endpointAddr),
-		  	urb->transfer_buffer, BCM_USB_MAX_READ_LENGTH, read_bulk_callback,
-			pRcb);
+	usb_fill_bulk_urb(urb, psIntfAdapter->udev, usb_rcvbulkpipe(psIntfAdapter->udev, psIntfAdapter->sBulkIn.bulk_in_endpointAddr),
+			  urb->transfer_buffer, BCM_USB_MAX_READ_LENGTH, read_bulk_callback, pRcb);
 	if(false == psIntfAdapter->psAdapter->device_removed &&
 	   false == psIntfAdapter->psAdapter->bEndPointHalted &&
 	   false == psIntfAdapter->bSuspended &&
@@ -258,7 +255,7 @@ bool InterfaceRx (struct bcm_interface_adapter *psIntfAdapter)
 		//atomic_inc(&psIntfAdapter->uNumRcbUsed);
 		ReceiveRcb(psIntfAdapter, pRcb);
 		RxDescCount--;
-    }
+	}
 	return TRUE;
 }
 
-- 
1.8.1.2

