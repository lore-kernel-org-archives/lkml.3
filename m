Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3L3LqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:46:23 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44235 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853Ab3L3LqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:46:18 -0500
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: ma.oefelein@arcor.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] beeceem: Fix position of braces in conditional statements in InterfaceTx.c
Date: Mon, 30 Dec 2013 12:44:23 +0100
Message-Id: <1388403864-19990-4-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
References: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This corrects the position of (opening) braces in if-conditionals to make checkpatch shut up.

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/staging/bcm/InterfaceTx.c |   63 ++++++++++++-------------------------
 1 file changed, 20 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/InterfaceTx.c
index 10774d9..682dfa4 100644
--- a/drivers/staging/bcm/InterfaceTx.c
+++ b/drivers/staging/bcm/InterfaceTx.c
@@ -13,15 +13,11 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 	if (unlikely(netif_msg_tx_done(Adapter)))
 		pr_info(PFX "%s: transmit status %d\n", Adapter->dev->name, urb->status);
 
-	if (urb->status != STATUS_SUCCESS)
-	{
-		if (urb->status == -EPIPE)
-		{
+	if (urb->status != STATUS_SUCCESS) {
+		if (urb->status == -EPIPE) {
 			psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 			wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
-		}
-		else
-		{
+		} else {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Tx URB has got cancelled. status :%d", urb->status);
 		}
 	}
@@ -31,17 +27,13 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 
 
 
-	if (TRUE == psAdapter->bPreparingForLowPowerMode)
-	{
+	if (TRUE == psAdapter->bPreparingForLowPowerMode) {
 
 		if (((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
-			(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE)))
-
-		{
+			(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE))) {
 			bpowerDownMsg = TRUE;
 			//This covers the bus err while Idle Request msg sent down.
-			if (urb->status != STATUS_SUCCESS)
-			{
+			if (urb->status != STATUS_SUCCESS) {
 				psAdapter->bPreparingForLowPowerMode = false;
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Idle Mode Request msg failed to reach to Modem");
 				//Signalling the cntrl pkt path in Ioctl
@@ -50,8 +42,7 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 				goto err_exit;
 			}
 
-			if (psAdapter->bDoSuspend == false)
-			{
+			if (psAdapter->bDoSuspend == false) {
 				psAdapter->IdleMode = TRUE;
 				//since going in Idle mode completed hence making this var false;
 				psAdapter->bPreparingForLowPowerMode = false;
@@ -61,15 +52,12 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 			}
 
-		}
-		else if ((pControlMsg->Leader.Status == LINK_UP_CONTROL_REQ) &&
+		} else if ((pControlMsg->Leader.Status == LINK_UP_CONTROL_REQ) &&
 			(pControlMsg->szData[0] == LINK_UP_ACK) &&
 			(pControlMsg->szData[1] == LINK_SHUTDOWN_REQ_FROM_FIRMWARE)  &&
-			(pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER))
-		{
+			(pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER)) {
 			//This covers the bus err while shutdown Request msg sent down.
-			if (urb->status != STATUS_SUCCESS)
-			{
+			if (urb->status != STATUS_SUCCESS) {
 				psAdapter->bPreparingForLowPowerMode = false;
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Shutdown Request Msg failed to reach to Modem");
 				//Signalling the cntrl pkt path in Ioctl
@@ -79,8 +67,7 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			}
 
 			bpowerDownMsg = TRUE;
-			if (psAdapter->bDoSuspend == false)
-			{
+			if (psAdapter->bDoSuspend == false) {
 				psAdapter->bShutStatus = TRUE;
 				//since going in shutdown mode completed hence making this var false;
 				psAdapter->bPreparingForLowPowerMode = false;
@@ -90,8 +77,7 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			}
 		}
 
-		if (psAdapter->bDoSuspend && bpowerDownMsg)
-		{
+		if (psAdapter->bDoSuspend && bpowerDownMsg) {
 			//issuing bus suspend request
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Issuing the Bus suspend request to USB stack");
 			psIntfAdapter->bPreparingForBusSuspend = TRUE;
@@ -113,8 +99,7 @@ static struct bcm_usb_tcb *GetBulkOutTcb(struct bcm_interface_adapter *psIntfAda
 	UINT index = 0;
 
 	if ((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
-		(psIntfAdapter->psAdapter->StopAllXaction == false))
-	{
+		(psIntfAdapter->psAdapter->StopAllXaction == false)) {
 		index = atomic_read(&psIntfAdapter->uCurrTcb);
 		pTcb = &psIntfAdapter->asUsbTcb[index];
 		pTcb->bUsed = TRUE;
@@ -136,8 +121,7 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 
 	urb->transfer_buffer = usb_alloc_coherent(psIntfAdapter->udev, len,
 						GFP_ATOMIC, &urb->transfer_dma);
-	if (!urb->transfer_buffer)
-	{
+	if (!urb->transfer_buffer) {
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "Error allocating memory\n");
 		return  -ENOMEM;
 	}
@@ -146,15 +130,12 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 
 	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Sending Bulk out packet\n");
 	//For T3B,INT OUT end point will be used as bulk out end point
-	if ((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE))
-	{
+	if ((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE)) {
 		usb_fill_int_urb(urb, psIntfAdapter->udev,
 			psIntfAdapter->sBulkOut.bulk_out_pipe,
 			urb->transfer_buffer, len, write_bulk_callback, pTcb,
 			psIntfAdapter->sBulkOut.int_out_interval);
-	}
-	else
-	{
+	} else {
 	usb_fill_bulk_urb(urb, psIntfAdapter->udev,
 		  psIntfAdapter->sBulkOut.bulk_out_pipe,
 		  urb->transfer_buffer, len, write_bulk_callback, pTcb);
@@ -164,14 +145,11 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 	if (false == psIntfAdapter->psAdapter->device_removed &&
 	   false == psIntfAdapter->psAdapter->bEndPointHalted &&
 	   false == psIntfAdapter->bSuspended &&
-	   false == psIntfAdapter->bPreparingForBusSuspend)
-	{
+	   false == psIntfAdapter->bPreparingForBusSuspend) {
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
-		if (retval)
-		{
+		if (retval) {
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
-			if (retval == -EPIPE)
-			{
+			if (retval == -EPIPE) {
 				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
@@ -186,8 +164,7 @@ int InterfaceTransmitPacket(PVOID arg, PVOID data, UINT len)
 
 	struct bcm_interface_adapter *psIntfAdapter = arg;
 	pTcb = GetBulkOutTcb(psIntfAdapter);
-	if (pTcb == NULL)
-	{
+	if (pTcb == NULL) {
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "No URB to transmit packet, dropping packet");
 		return -EFAULT;
 	}
-- 
1.7.10.4

