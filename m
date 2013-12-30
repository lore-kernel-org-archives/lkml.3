Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3L3LqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:46:17 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44224 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810Ab3L3LqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:46:15 -0500
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: ma.oefelein@arcor.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] beeceem: Add spaces before opening parentheses in if-conditionals in InterfaceTx.c
Date: Mon, 30 Dec 2013 12:44:22 +0100
Message-Id: <1388403864-19990-3-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
References: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds spaces before the opening parentheses of if-conditionals to comply with offical code styling guidelines.

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/staging/bcm/InterfaceTx.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/InterfaceTx.c
index f76de85..10774d9 100644
--- a/drivers/staging/bcm/InterfaceTx.c
+++ b/drivers/staging/bcm/InterfaceTx.c
@@ -13,9 +13,9 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 	if (unlikely(netif_msg_tx_done(Adapter)))
 		pr_info(PFX "%s: transmit status %d\n", Adapter->dev->name, urb->status);
 
-	if(urb->status != STATUS_SUCCESS)
+	if (urb->status != STATUS_SUCCESS)
 	{
-		if(urb->status == -EPIPE)
+		if (urb->status == -EPIPE)
 		{
 			psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 			wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
@@ -31,16 +31,16 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 
 
 
-	if(TRUE == psAdapter->bPreparingForLowPowerMode)
+	if (TRUE == psAdapter->bPreparingForLowPowerMode)
 	{
 
-		if(((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
+		if (((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
 			(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE)))
 
 		{
 			bpowerDownMsg = TRUE;
 			//This covers the bus err while Idle Request msg sent down.
-			if(urb->status != STATUS_SUCCESS)
+			if (urb->status != STATUS_SUCCESS)
 			{
 				psAdapter->bPreparingForLowPowerMode = false;
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Idle Mode Request msg failed to reach to Modem");
@@ -50,7 +50,7 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 				goto err_exit;
 			}
 
-			if(psAdapter->bDoSuspend == false)
+			if (psAdapter->bDoSuspend == false)
 			{
 				psAdapter->IdleMode = TRUE;
 				//since going in Idle mode completed hence making this var false;
@@ -62,13 +62,13 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
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
 				psAdapter->bPreparingForLowPowerMode = false;
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Shutdown Request Msg failed to reach to Modem");
@@ -79,7 +79,7 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			}
 
 			bpowerDownMsg = TRUE;
-			if(psAdapter->bDoSuspend == false)
+			if (psAdapter->bDoSuspend == false)
 			{
 				psAdapter->bShutStatus = TRUE;
 				//since going in shutdown mode completed hence making this var false;
@@ -90,7 +90,7 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			}
 		}
 
-		if(psAdapter->bDoSuspend && bpowerDownMsg)
+		if (psAdapter->bDoSuspend && bpowerDownMsg)
 		{
 			//issuing bus suspend request
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Issuing the Bus suspend request to USB stack");
@@ -112,7 +112,7 @@ static struct bcm_usb_tcb *GetBulkOutTcb(struct bcm_interface_adapter *psIntfAda
 	struct bcm_usb_tcb *pTcb = NULL;
 	UINT index = 0;
 
-	if((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
+	if ((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
 		(psIntfAdapter->psAdapter->StopAllXaction == false))
 	{
 		index = atomic_read(&psIntfAdapter->uCurrTcb);
@@ -146,7 +146,7 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 
 	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Sending Bulk out packet\n");
 	//For T3B,INT OUT end point will be used as bulk out end point
-	if((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE))
+	if ((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE))
 	{
 		usb_fill_int_urb(urb, psIntfAdapter->udev,
 			psIntfAdapter->sBulkOut.bulk_out_pipe,
@@ -161,7 +161,7 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 	}
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP; /* For DMA transfer */
 
-	if(false == psIntfAdapter->psAdapter->device_removed &&
+	if (false == psIntfAdapter->psAdapter->device_removed &&
 	   false == psIntfAdapter->psAdapter->bEndPointHalted &&
 	   false == psIntfAdapter->bSuspended &&
 	   false == psIntfAdapter->bPreparingForBusSuspend)
@@ -170,7 +170,7 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 		if (retval)
 		{
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
-			if(retval == -EPIPE)
+			if (retval == -EPIPE)
 			{
 				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
@@ -186,7 +186,7 @@ int InterfaceTransmitPacket(PVOID arg, PVOID data, UINT len)
 
 	struct bcm_interface_adapter *psIntfAdapter = arg;
 	pTcb = GetBulkOutTcb(psIntfAdapter);
-	if(pTcb == NULL)
+	if (pTcb == NULL)
 	{
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "No URB to transmit packet, dropping packet");
 		return -EFAULT;
-- 
1.7.10.4

