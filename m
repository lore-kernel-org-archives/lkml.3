Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3L3LqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:46:09 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44213 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517Ab3L3LqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:46:06 -0500
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: ma.oefelein@arcor.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] beeceem: Fix several whitespace issues in InterfaceTx.c
Date: Mon, 30 Dec 2013 12:44:21 +0100
Message-Id: <1388403864-19990-2-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
References: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch takes care of the following issues:
	- missing spaces at variable assignments
	- missing spaces between function arguments
	- spaces at the beginning of a line where tabs should be
	- prohibited spaces before a (semi)colon 

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/staging/bcm/InterfaceTx.c |   64 ++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/InterfaceTx.c
index b9c2784..f76de85 100644
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
 
 	if(urb->status != STATUS_SUCCESS)
 	{
 		if(urb->status == -EPIPE)
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
 
@@ -38,12 +38,12 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE)))
 
 		{
-			bpowerDownMsg = TRUE ;
+			bpowerDownMsg = TRUE;
 			//This covers the bus err while Idle Request msg sent down.
 			if(urb->status != STATUS_SUCCESS)
 			{
-				psAdapter->bPreparingForLowPowerMode = false ;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Idle Mode Request msg failed to reach to Modem");
+				psAdapter->bPreparingForLowPowerMode = false;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Idle Mode Request msg failed to reach to Modem");
 				//Signalling the cntrl pkt path in Ioctl
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 				StartInterruptUrb(psIntfAdapter);
@@ -54,9 +54,9 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
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
@@ -70,21 +70,21 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			//This covers the bus err while shutdown Request msg sent down.
 			if(urb->status != STATUS_SUCCESS)
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
+			bpowerDownMsg = TRUE;
 			if(psAdapter->bDoSuspend == false)
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
@@ -93,7 +93,7 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 		if(psAdapter->bDoSuspend && bpowerDownMsg)
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
+			urb->transfer_buffer, urb->transfer_dma);
 }
 
 
@@ -113,13 +113,13 @@ static struct bcm_usb_tcb *GetBulkOutTcb(struct bcm_interface_adapter *psIntfAda
 	UINT index = 0;
 
 	if((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
-		(psIntfAdapter->psAdapter->StopAllXaction ==false))
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
@@ -135,21 +135,21 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 	int retval = 0;
 
 	urb->transfer_buffer = usb_alloc_coherent(psIntfAdapter->udev, len,
- 						GFP_ATOMIC, &urb->transfer_dma);
+						GFP_ATOMIC, &urb->transfer_dma);
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
 	if((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE))
 	{
 		usb_fill_int_urb(urb, psIntfAdapter->udev,
-	    	psIntfAdapter->sBulkOut.bulk_out_pipe,
+			psIntfAdapter->sBulkOut.bulk_out_pipe,
 			urb->transfer_buffer, len, write_bulk_callback, pTcb,
 			psIntfAdapter->sBulkOut.int_out_interval);
 	}
@@ -169,10 +169,10 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
 		if (retval)
 		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
 			if(retval == -EPIPE)
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
+	pTcb = GetBulkOutTcb(psIntfAdapter);
 	if(pTcb == NULL)
 	{
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "No URB to transmit packet, dropping packet");
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "No URB to transmit packet, dropping packet");
 		return -EFAULT;
 	}
 	return TransmitTcb(psIntfAdapter, pTcb, data, len);
-- 
1.7.10.4

