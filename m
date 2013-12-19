Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3LSLW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:22:26 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:54980 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab3LSLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:22:24 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 06:22:23 EST
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, Matthias Oefelein <ma.oefelein@arcor.de>
Subject: [PATCH] beeceem: checkpatch whitespace cleanups
Date: Thu, 19 Dec 2013 12:13:14 +0100
Message-Id: <1387451594-23168-1-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains several whitespace cleanups for the beeceem driver that have been reported by checkpatch.
Subsequent patches will fix other issues that checkpatch complains about and which still remain after applying this patch.

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/staging/bcm/InterfaceRx.c | 142 +++++++++++++++++++-------------------
 drivers/staging/bcm/InterfaceTx.c |  98 +++++++++++++-------------
 2 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index f2973f5..08ef323 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -1,11 +1,11 @@
 #include "headers.h"
 
-static int SearchVcid(struct bcm_mini_adapter *Adapter,unsigned short usVcid)
+static int SearchVcid(struct bcm_mini_adapter *Adapter, unsigned short usVcid)
 {
-	int iIndex=0;
+	int iIndex = 0;
 
-	for(iIndex=(NO_OF_QUEUES-1);iIndex>=0;iIndex--)
-		if(Adapter->PackInfo[iIndex].usVCID_Value == usVcid)
+	for (iIndex = (NO_OF_QUEUES-1); iIndex >= 0; iIndex--)
+		if (Adapter->PackInfo[iIndex].usVCID_Value == usVcid)
 			return iIndex;
 	return NO_OF_QUEUES+1;
 
@@ -18,14 +18,14 @@ GetBulkInRcb(struct bcm_interface_adapter *psIntfAdapter)
 	struct bcm_usb_rcb *pRcb = NULL;
 	UINT index = 0;
 
-	if((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
+	if ((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
 		(psIntfAdapter->psAdapter->StopAllXaction == false))
 	{
 		index = atomic_read(&psIntfAdapter->uCurrRcb);
 		pRcb = &psIntfAdapter->asUsbRcb[index];
 		pRcb->bUsed = TRUE;
-		pRcb->psIntfAdapter= psIntfAdapter;
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Got Rx desc %d used %d",
+		pRcb->psIntfAdapter = psIntfAdapter;
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Got Rx desc %d used %d",
 			index, atomic_read(&psIntfAdapter->uNumRcbUsed));
 		index = (index + 1) % MAXIMUM_USB_RCB;
 		atomic_set(&psIntfAdapter->uCurrRcb, index);
@@ -40,7 +40,7 @@ static void read_bulk_callback(struct urb *urb)
 	struct sk_buff *skb = NULL;
 	bool bHeaderSupressionEnabled = false;
 	int QueueIndex = NO_OF_QUEUES + 1;
-	UINT uiIndex=0;
+	UINT uiIndex = 0;
 	int process_done = 1;
 	//int idleflag = 0 ;
 	struct bcm_usb_rcb *pRcb = (struct bcm_usb_rcb *)urb->context;
@@ -52,48 +52,48 @@ static void read_bulk_callback(struct urb *urb)
 		pr_info(PFX "%s: rx urb status %d length %d\n",
 			Adapter->dev->name, urb->status, urb->actual_length);
 
-	if((Adapter->device_removed == TRUE)  ||
+	if ((Adapter->device_removed == TRUE)  ||
 		(TRUE == Adapter->bEndPointHalted) ||
 		(0 == urb->actual_length)
 		)
 	{
-	 	pRcb->bUsed = false;
- 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
+		pRcb->bUsed = false;
+		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 
-	if(urb->status != STATUS_SUCCESS)
+	if (urb->status != STATUS_SUCCESS)
 	{
-		if(urb->status == -EPIPE)
+		if (urb->status == -EPIPE)
 		{
-			Adapter->bEndPointHalted = TRUE ;
+			Adapter->bEndPointHalted = TRUE;
 			wake_up(&Adapter->tx_packet_wait_queue);
 		}
 		else
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL,"Rx URB has got cancelled. status :%d", urb->status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Rx URB has got cancelled. status :%d", urb->status);
 		}
 		pRcb->bUsed = false;
- 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
-		urb->status = STATUS_SUCCESS ;
-		return ;
+		atomic_dec(&psIntfAdapter->uNumRcbUsed);
+		urb->status = STATUS_SUCCESS;
+		return;
 	}
 
-	if(Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
+	if (Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL,"device is going in low power mode while PMU option selected..hence rx packet should not be process");
-		return ;
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "device is going in low power mode while PMU option selected..hence rx packet should not be process");
+		return;
 	}
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read back done len %d\n", pLeader->PLength);
-	if(!pLeader->PLength)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read back done len %d\n", pLeader->PLength);
+	if (!pLeader->PLength)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Length 0");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Length 0");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Status:0x%hX, Length:0x%hX, VCID:0x%hX", pLeader->Status,pLeader->PLength,pLeader->Vcid);
-	if(MAX_CNTL_PKT_SIZE < pLeader->PLength)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Status:0x%hX, Length:0x%hX, VCID:0x%hX", pLeader->Status, pLeader->PLength, pLeader->Vcid);
+	if (MAX_CNTL_PKT_SIZE < pLeader->PLength)
 	{
 		if (netif_msg_rx_err(Adapter))
 			pr_info(PFX "%s: corrupted leader length...%d\n",
@@ -103,8 +103,8 @@ static void read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	QueueIndex = SearchVcid( Adapter,pLeader->Vcid);
-	if(QueueIndex < NO_OF_QUEUES)
+	QueueIndex = SearchVcid(Adapter, pLeader->Vcid);
+	if (QueueIndex < NO_OF_QUEUES)
 	{
 		bHeaderSupressionEnabled =
 			Adapter->PackInfo[QueueIndex].bHeaderSuppressionEnabled;
@@ -112,25 +112,25 @@ static void read_bulk_callback(struct urb *urb)
 			bHeaderSupressionEnabled & Adapter->bPHSEnabled;
 	}
 
-	skb = dev_alloc_skb (pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
-	if(!skb)
+	skb = dev_alloc_skb(pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
+	if (!skb)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! Dropping the Packet");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! Dropping the Packet");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
     /* If it is a control Packet, then call handle_bcm_packet ()*/
-	if((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
+	if ((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
 	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
 	{
-	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
 		*(PUSHORT)skb->data = pLeader->Status;
-       	memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
-			(sizeof(struct bcm_leader)), pLeader->PLength);
+		memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
+		       (sizeof(struct bcm_leader)), pLeader->PLength);
 		skb->len = pLeader->PLength + sizeof(USHORT);
 
 		spin_lock(&Adapter->control_queue_lock);
-		ENQUEUEPACKET(Adapter->RxControlHead,Adapter->RxControlTail,skb);
+		ENQUEUEPACKET(Adapter->RxControlHead, Adapter->RxControlTail, skb);
 		spin_unlock(&Adapter->control_queue_lock);
 
 		atomic_inc(&Adapter->cntrlpktCnt);
@@ -139,28 +139,28 @@ static void read_bulk_callback(struct urb *urb)
 	else
 	{
 		/*
-		  * Data Packet, Format a proper Ethernet Header
-        	  * and give it to the stack
-		  */
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
+		 * Data Packet, Format a proper Ethernet Header
+		 * and give it to the stack
+		 */
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
 		skb_reserve(skb, 2 + SKB_RESERVE_PHS_BYTES);
 		memcpy(skb->data+ETH_HLEN, (PUCHAR)urb->transfer_buffer + sizeof(struct bcm_leader), pLeader->PLength);
 		skb->dev = Adapter->dev;
 
 		/* currently skb->len has extra ETH_HLEN bytes in the beginning */
-		skb_put (skb, pLeader->PLength + ETH_HLEN);
-		Adapter->PackInfo[QueueIndex].uiTotalRxBytes+=pLeader->PLength;
-		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes+= pLeader->PLength;
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
+		skb_put(skb, pLeader->PLength + ETH_HLEN);
+		Adapter->PackInfo[QueueIndex].uiTotalRxBytes += pLeader->PLength;
+		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes += pLeader->PLength;
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
 
-		if(netif_running(Adapter->dev))
+		if (netif_running(Adapter->dev))
 		{
 			/* Moving ahead by ETH_HLEN to the data ptr as received from FW */
 			skb_pull(skb, ETH_HLEN);
 			PHSReceive(Adapter, pLeader->Vcid, skb, &skb->len,
-					NULL,bHeaderSupressionEnabled);
+					NULL, bHeaderSupressionEnabled);
 
-			if(!Adapter->PackInfo[QueueIndex].bEthCSSupport)
+			if (!Adapter->PackInfo[QueueIndex].bEthCSSupport)
 			{
 				skb_push(skb, ETH_HLEN);
 
@@ -169,7 +169,7 @@ static void read_bulk_callback(struct urb *urb)
 				(*(skb->data+11))++;
 				*(skb->data+12) = 0x08;
 				*(skb->data+13) = 0x00;
-				pLeader->PLength+=ETH_HLEN;
+				pLeader->PLength += ETH_HLEN;
 			}
 
 			skb->protocol = eth_type_trans(skb, Adapter->dev);
@@ -177,21 +177,21 @@ static void read_bulk_callback(struct urb *urb)
 		}
 		else
 		{
-		    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "i/f not up hance freeing SKB...");
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "i/f not up hance freeing SKB...");
 			dev_kfree_skb(skb);
 		}
 
 		++Adapter->dev->stats.rx_packets;
 		Adapter->dev->stats.rx_bytes += pLeader->PLength;
 
-		for(uiIndex = 0 ; uiIndex < MIBS_MAX_HIST_ENTRIES ; uiIndex++)
+		for (uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
 		{
-			if((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1))
+			if ((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1))
 				&& (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
 				Adapter->aRxPktSizeHist[uiIndex]++;
 		}
 	}
- 	Adapter->PrevNumRecvDescs++;
+	Adapter->PrevNumRecvDescs++;
 	pRcb->bUsed = false;
 	atomic_dec(&psIntfAdapter->uNumRcbUsed);
 }
@@ -203,21 +203,21 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 
 	usb_fill_bulk_urb(urb, psIntfAdapter->udev, usb_rcvbulkpipe(
 			psIntfAdapter->udev, psIntfAdapter->sBulkIn.bulk_in_endpointAddr),
-		  	urb->transfer_buffer, BCM_USB_MAX_READ_LENGTH, read_bulk_callback,
+			urb->transfer_buffer, BCM_USB_MAX_READ_LENGTH, read_bulk_callback,
 			pRcb);
-	if(false == psIntfAdapter->psAdapter->device_removed &&
-	   false == psIntfAdapter->psAdapter->bEndPointHalted &&
-	   false == psIntfAdapter->bSuspended &&
-	   false == psIntfAdapter->bPreparingForBusSuspend)
+	if (false == psIntfAdapter->psAdapter->device_removed &&
+	    false == psIntfAdapter->psAdapter->bEndPointHalted &&
+	    false == psIntfAdapter->bSuspended &&
+	    false == psIntfAdapter->bPreparingForBusSuspend)
 	{
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
 		if (retval)
 		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
 			//if this return value is because of pipe halt. need to clear this.
-			if(retval == -EPIPE)
+			if (retval == -EPIPE)
 			{
-				psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
+				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
 
@@ -227,38 +227,38 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 }
 
 /*
-Function:				InterfaceRx
+Function:		InterfaceRx
 
-Description:			This is the hardware specific Function for Receiving
-						data packet/control packets from the device.
+Description:		This is the hardware specific Function for Receiving
+			data packet/control packets from the device.
 
-Input parameters:		IN struct bcm_mini_adapter *Adapter   - Miniport Adapter Context
+Input parameters:	IN struct bcm_mini_adapter *Adapter   - Miniport Adapter Context
 
 
 
-Return:				TRUE  - If Rx was successful.
-					Other - If an error occurred.
+Return:			TRUE  - If Rx was successful.
+			Other - If an error occurred.
 */
 
-bool InterfaceRx (struct bcm_interface_adapter *psIntfAdapter)
+bool InterfaceRx(struct bcm_interface_adapter *psIntfAdapter)
 {
 	USHORT RxDescCount = NUM_RX_DESC - atomic_read(&psIntfAdapter->uNumRcbUsed);
 	struct bcm_usb_rcb *pRcb = NULL;
 
 //	RxDescCount = psIntfAdapter->psAdapter->CurrNumRecvDescs -
 //				psIntfAdapter->psAdapter->PrevNumRecvDescs;
-	while(RxDescCount)
+	while (RxDescCount)
 	{
 		pRcb = GetBulkInRcb(psIntfAdapter);
-		if(pRcb == NULL)
+		if (pRcb == NULL)
 		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "Unable to get Rcb pointer");
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "Unable to get Rcb pointer");
 			return false;
 		}
 		//atomic_inc(&psIntfAdapter->uNumRcbUsed);
 		ReceiveRcb(psIntfAdapter, pRcb);
 		RxDescCount--;
-    }
+	}
 	return TRUE;
 }
 
diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/InterfaceTx.c
index b9c2784..aa6e173 100644
--- a/drivers/staging/bcm/InterfaceTx.c
+++ b/drivers/staging/bcm/InterfaceTx.c
@@ -3,26 +3,26 @@
 /*this is transmit call-back(BULK OUT)*/
 static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 {
-	struct bcm_usb_tcb *pTcb= (struct bcm_usb_tcb *)urb->context;
+	struct bcm_usb_tcb *pTcb = (struct bcm_usb_tcb *)urb->context;
 	struct bcm_interface_adapter *psIntfAdapter = pTcb->psIntfAdapter;
 	struct bcm_link_request *pControlMsg = (struct bcm_link_request *)urb->transfer_buffer;
-	struct bcm_mini_adapter *psAdapter = psIntfAdapter->psAdapter ;
-	bool bpowerDownMsg = false ;
+	struct bcm_mini_adapter *psAdapter = psIntfAdapter->psAdapter;
+	bool bpowerDownMsg = false;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-    if (unlikely(netif_msg_tx_done(Adapter)))
-	    pr_info(PFX "%s: transmit status %d\n", Adapter->dev->name, urb->status);
+	if (unlikely(netif_msg_tx_done(Adapter)))
+		pr_info(PFX "%s: transmit status %d\n", Adapter->dev->name, urb->status);
 
-	if(urb->status != STATUS_SUCCESS)
+	if (urb->status != STATUS_SUCCESS)
 	{
-		if(urb->status == -EPIPE)
+		if (urb->status == -EPIPE)
 		{
-			psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
+			psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 			wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 		}
 		else
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Tx URB has got cancelled. status :%d", urb->status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Tx URB has got cancelled. status :%d", urb->status);
 		}
 	}
 
@@ -31,69 +31,69 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 
 
 
-	if(TRUE == psAdapter->bPreparingForLowPowerMode)
+	if (TRUE == psAdapter->bPreparingForLowPowerMode)
 	{
 
-		if(((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
+		if (((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
 			(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE)))
 
 		{
-			bpowerDownMsg = TRUE ;
+			bpowerDownMsg = TRUE;
 			//This covers the bus err while Idle Request msg sent down.
-			if(urb->status != STATUS_SUCCESS)
+			if (urb->status != STATUS_SUCCESS)
 			{
-				psAdapter->bPreparingForLowPowerMode = false ;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Idle Mode Request msg failed to reach to Modem");
+				psAdapter->bPreparingForLowPowerMode = false;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Idle Mode Request msg failed to reach to Modem");
 				//Signalling the cntrl pkt path in Ioctl
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 				StartInterruptUrb(psIntfAdapter);
 				goto err_exit;
 			}
 
-			if(psAdapter->bDoSuspend == false)
+			if (psAdapter->bDoSuspend == false)
 			{
 				psAdapter->IdleMode = TRUE;
 				//since going in Idle mode completed hence making this var false;
-				psAdapter->bPreparingForLowPowerMode = false ;
+				psAdapter->bPreparingForLowPowerMode = false;
 
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Host Entered in Idle Mode State...");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Host Entered in Idle Mode State...");
 				//Signalling the cntrl pkt path in Ioctl
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 			}
 
 		}
-		else if((pControlMsg->Leader.Status == LINK_UP_CONTROL_REQ) &&
+		else if ((pControlMsg->Leader.Status == LINK_UP_CONTROL_REQ) &&
 			(pControlMsg->szData[0] == LINK_UP_ACK) &&
 			(pControlMsg->szData[1] == LINK_SHUTDOWN_REQ_FROM_FIRMWARE)  &&
 			(pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER))
 		{
 			//This covers the bus err while shutdown Request msg sent down.
-			if(urb->status != STATUS_SUCCESS)
+			if (urb->status != STATUS_SUCCESS)
 			{
-				psAdapter->bPreparingForLowPowerMode = false ;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Shutdown Request Msg failed to reach to Modem");
+				psAdapter->bPreparingForLowPowerMode = false;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Shutdown Request Msg failed to reach to Modem");
 				//Signalling the cntrl pkt path in Ioctl
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 				StartInterruptUrb(psIntfAdapter);
 				goto err_exit;
 			}
 
-			bpowerDownMsg = TRUE ;
-			if(psAdapter->bDoSuspend == false)
+			bpowerDownMsg = TRUE;
+			if (psAdapter->bDoSuspend == false)
 			{
 				psAdapter->bShutStatus = TRUE;
 				//since going in shutdown mode completed hence making this var false;
-				psAdapter->bPreparingForLowPowerMode = false ;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Host Entered in shutdown Mode State...");
+				psAdapter->bPreparingForLowPowerMode = false;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Host Entered in shutdown Mode State...");
 				//Signalling the cntrl pkt path in Ioctl
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 			}
 		}
 
-		if(psAdapter->bDoSuspend && bpowerDownMsg)
+		if (psAdapter->bDoSuspend && bpowerDownMsg)
 		{
 			//issuing bus suspend request
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Issuing the Bus suspend request to USB stack");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Issuing the Bus suspend request to USB stack");
 			psIntfAdapter->bPreparingForBusSuspend = TRUE;
 			schedule_work(&psIntfAdapter->usbSuspendWork);
 
@@ -101,9 +101,9 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 
 	}
 
-err_exit :
+err_exit:
 	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
- 			urb->transfer_buffer, urb->transfer_dma);
+			  urb->transfer_buffer, urb->transfer_dma);
 }
 
 
@@ -112,14 +112,14 @@ static struct bcm_usb_tcb *GetBulkOutTcb(struct bcm_interface_adapter *psIntfAda
 	struct bcm_usb_tcb *pTcb = NULL;
 	UINT index = 0;
 
-	if((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
-		(psIntfAdapter->psAdapter->StopAllXaction ==false))
+	if ((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
+		(psIntfAdapter->psAdapter->StopAllXaction == false))
 	{
 		index = atomic_read(&psIntfAdapter->uCurrTcb);
 		pTcb = &psIntfAdapter->asUsbTcb[index];
 		pTcb->bUsed = TRUE;
-		pTcb->psIntfAdapter= psIntfAdapter;
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Got Tx desc %d used %d",
+		pTcb->psIntfAdapter = psIntfAdapter;
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Got Tx desc %d used %d",
 			index, atomic_read(&psIntfAdapter->uNumTcbUsed));
 		index = (index + 1) % MAXIMUM_USB_TCB;
 		atomic_set(&psIntfAdapter->uCurrTcb, index);
@@ -135,23 +135,23 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 	int retval = 0;
 
 	urb->transfer_buffer = usb_alloc_coherent(psIntfAdapter->udev, len,
- 						GFP_ATOMIC, &urb->transfer_dma);
+						  GFP_ATOMIC, &urb->transfer_dma);
 	if (!urb->transfer_buffer)
 	{
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "Error allocating memory\n");
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "Error allocating memory\n");
 		return  -ENOMEM;
 	}
 	memcpy(urb->transfer_buffer, data, len);
 	urb->transfer_buffer_length = len;
 
-	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Sending Bulk out packet\n");
+	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Sending Bulk out packet\n");
 	//For T3B,INT OUT end point will be used as bulk out end point
-	if((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE))
+	if ((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE))
 	{
 		usb_fill_int_urb(urb, psIntfAdapter->udev,
-	    	psIntfAdapter->sBulkOut.bulk_out_pipe,
-			urb->transfer_buffer, len, write_bulk_callback, pTcb,
-			psIntfAdapter->sBulkOut.int_out_interval);
+				 psIntfAdapter->sBulkOut.bulk_out_pipe,
+				 urb->transfer_buffer, len, write_bulk_callback,
+				 pTcb, psIntfAdapter->sBulkOut.int_out_interval);
 	}
 	else
 	{
@@ -161,7 +161,7 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 	}
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP; /* For DMA transfer */
 
-	if(false == psIntfAdapter->psAdapter->device_removed &&
+	if (false == psIntfAdapter->psAdapter->device_removed &&
 	   false == psIntfAdapter->psAdapter->bEndPointHalted &&
 	   false == psIntfAdapter->bSuspended &&
 	   false == psIntfAdapter->bPreparingForBusSuspend)
@@ -169,10 +169,10 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
 		if (retval)
 		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
-			if(retval == -EPIPE)
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
+			if (retval == -EPIPE)
 			{
-				psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
+				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
 		}
@@ -182,13 +182,13 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 
 int InterfaceTransmitPacket(PVOID arg, PVOID data, UINT len)
 {
-	struct bcm_usb_tcb *pTcb= NULL;
+	struct bcm_usb_tcb *pTcb = NULL;
 
 	struct bcm_interface_adapter *psIntfAdapter = arg;
-	pTcb= GetBulkOutTcb(psIntfAdapter);
-	if(pTcb == NULL)
+	pTcb = GetBulkOutTcb(psIntfAdapter);
+	if (pTcb == NULL)
 	{
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "No URB to transmit packet, dropping packet");
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "No URB to transmit packet, dropping packet");
 		return -EFAULT;
 	}
 	return TransmitTcb(psIntfAdapter, pTcb, data, len);
-- 
1.8.1.2

