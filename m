Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3L3Lqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:46:38 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44245 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755855Ab3L3LqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:46:21 -0500
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: ma.oefelein@arcor.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] beeceem: Replace C99-style comments with C89 pendants in InterfaceTx.c
Date: Mon, 30 Dec 2013 12:44:24 +0100
Message-Id: <1388403864-19990-5-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
References: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch complains about the use of //-comments, thus they are replaced by C89-style comments.

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/staging/bcm/InterfaceTx.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/InterfaceTx.c
index 682dfa4..ea7707b 100644
--- a/drivers/staging/bcm/InterfaceTx.c
+++ b/drivers/staging/bcm/InterfaceTx.c
@@ -32,11 +32,11 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 		if (((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
 			(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE))) {
 			bpowerDownMsg = TRUE;
-			//This covers the bus err while Idle Request msg sent down.
+			/* This covers the bus err while Idle Request msg sent down. */
 			if (urb->status != STATUS_SUCCESS) {
 				psAdapter->bPreparingForLowPowerMode = false;
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Idle Mode Request msg failed to reach to Modem");
-				//Signalling the cntrl pkt path in Ioctl
+				/* Signalling the cntrl pkt path in Ioctl */
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 				StartInterruptUrb(psIntfAdapter);
 				goto err_exit;
@@ -44,11 +44,11 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 
 			if (psAdapter->bDoSuspend == false) {
 				psAdapter->IdleMode = TRUE;
-				//since going in Idle mode completed hence making this var false;
+				/* since going in Idle mode completed hence making this var false */
 				psAdapter->bPreparingForLowPowerMode = false;
 
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Host Entered in Idle Mode State...");
-				//Signalling the cntrl pkt path in Ioctl
+				/* Signalling the cntrl pkt path in Ioctl*/
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 			}
 
@@ -56,11 +56,11 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			(pControlMsg->szData[0] == LINK_UP_ACK) &&
 			(pControlMsg->szData[1] == LINK_SHUTDOWN_REQ_FROM_FIRMWARE)  &&
 			(pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER)) {
-			//This covers the bus err while shutdown Request msg sent down.
+			/* This covers the bus err while shutdown Request msg sent down. */
 			if (urb->status != STATUS_SUCCESS) {
 				psAdapter->bPreparingForLowPowerMode = false;
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Shutdown Request Msg failed to reach to Modem");
-				//Signalling the cntrl pkt path in Ioctl
+				/* Signalling the cntrl pkt path in Ioctl */
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 				StartInterruptUrb(psIntfAdapter);
 				goto err_exit;
@@ -69,16 +69,16 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 			bpowerDownMsg = TRUE;
 			if (psAdapter->bDoSuspend == false) {
 				psAdapter->bShutStatus = TRUE;
-				//since going in shutdown mode completed hence making this var false;
+				/* since going in shutdown mode completed hence making this var false */
 				psAdapter->bPreparingForLowPowerMode = false;
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Host Entered in shutdown Mode State...");
-				//Signalling the cntrl pkt path in Ioctl
+				/* Signalling the cntrl pkt path in Ioctl */
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 			}
 		}
 
 		if (psAdapter->bDoSuspend && bpowerDownMsg) {
-			//issuing bus suspend request
+			/* issuing bus suspend request */
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Issuing the Bus suspend request to USB stack");
 			psIntfAdapter->bPreparingForBusSuspend = TRUE;
 			schedule_work(&psIntfAdapter->usbSuspendWork);
@@ -129,7 +129,7 @@ static int TransmitTcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_u
 	urb->transfer_buffer_length = len;
 
 	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Sending Bulk out packet\n");
-	//For T3B,INT OUT end point will be used as bulk out end point
+	/* For T3B,INT OUT end point will be used as bulk out end point */
 	if ((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE)) {
 		usb_fill_int_urb(urb, psIntfAdapter->udev,
 			psIntfAdapter->sBulkOut.bulk_out_pipe,
-- 
1.7.10.4

