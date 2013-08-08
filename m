Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3HHRDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:03:03 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54244 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3HHRDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:03:01 -0400
Message-ID: <5203CF41.4040607@gmail.com>
Date: Thu, 08 Aug 2013 18:02:57 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, Linux-kernel <linux-kernel@vger.kernel.org>
CC: Linux-Devel <devel@driverdev.osuosl.org>
Subject: [PATCH 1/2] Staging: BCM: removed whitespaces and Errors.
Content-Type: multipart/mixed;
 boundary="------------070001090807090304030002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070001090807090304030002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------070001090807090304030002
Content-Type: text/x-patch;
 name="0001-Staging-BCM-removed-whitespaces-and-Errors.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Staging-BCM-removed-whitespaces-and-Errors.patch"

>From 6e70cd8754968f37e82f6a4d8b9dffffa75ff6e0 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Thu, 8 Aug 2013 16:09:46 +0100
Subject: [PATCH 1/2] Staging: BCM: removed whitespaces and Errors.

BCM Driver had a lot of whitespaces and errors.
Some of them are removed by this patch.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/bcm/InterfaceDld.c      |    2 +-
 drivers/staging/bcm/InterfaceIdleMode.c |   16 ++---
 drivers/staging/bcm/InterfaceIsr.c      |  109 ++++++++++++++-----------------
 drivers/staging/bcm/InterfaceMisc.c     |    2 +-
 drivers/staging/bcm/headers.h           |    4 +-
 5 files changed, 59 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/InterfaceDld.c
index 348ad75..fe7fb4c 100644
--- a/drivers/staging/bcm/InterfaceDld.c
+++ b/drivers/staging/bcm/InterfaceDld.c
@@ -115,7 +115,7 @@ int InterfaceFileReadbackFromChip(PVOID arg, struct file *flp, unsigned int on_c
 			while (len) {
 				if (*(unsigned int *)&buff_readback[len] != *(unsigned int *)&buff[len]) {
 					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Firmware Download is not proper %d", fw_down);
-					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Val from Binary %x, Val From Read Back %x ", *(unsigned int *)&buff[len], *(unsigned int*)&buff_readback[len]);
+					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Val from Binary %x, Val From Read Back %x ", *(unsigned int *)&buff[len], *(unsigned int *)&buff_readback[len]);
 					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "len =%x!!!", len);
 					Status = -EIO;
 					goto exit;
diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index 5347828..22150db 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -52,7 +52,7 @@ int InterfaceIdleModeRespond(struct bcm_mini_adapter *Adapter, unsigned int *pui
 
 	if (ntohl(*puiBuffer) == GO_TO_IDLE_MODE_PAYLOAD) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, " Got GO_TO_IDLE_MODE_PAYLOAD(210) Msg Subtype");
-		if (ntohl(*(puiBuffer+1)) == 0 ) {
+		if (ntohl(*(puiBuffer+1)) == 0) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Got IDLE MODE WAKE UP Response From F/W");
 
 			status = wrmalt (Adapter, SW_ABORT_IDLEMODE_LOC, &uiRegRead, sizeof(uiRegRead));
@@ -95,8 +95,7 @@ int InterfaceIdleModeRespond(struct bcm_mini_adapter *Adapter, unsigned int *pui
 			wake_up(&Adapter->lowpower_mode_wait_queue);
 
 		} else {
-			if (TRUE == Adapter->IdleMode)
-			{
+			if (TRUE == Adapter->IdleMode) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Device is already in Idle mode....");
 				return status ;
 			}
@@ -168,8 +167,7 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter, unsigned int
 	if (Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING) {
 		value = 0x80000000;
 		status = wrmalt(Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR, &value, sizeof(value));
-		if (status)
-		{
+		if (status) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Register failed");
 			return status;
 		}
@@ -196,7 +194,7 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter, unsigned int
 		/* mdelay(25); */
 
 		timeout = jiffies +  msecs_to_jiffies(50) ;
-		while ( timeout > jiffies ) {
+		while (timeout > jiffies) {
 			itr++ ;
 			rdmalt(Adapter, CHIP_ID_REG, &chip_id, sizeof(UINT));
 			if (0xbece3200 == (chip_id&~(0xF0)))
@@ -204,7 +202,7 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter, unsigned int
 			if (chip_id == Adapter->chip_id)
 				break;
 		}
-		if (timeout < jiffies )
+		if (timeout < jiffies)
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Not able to read chip-id even after 25 msec");
 		else
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Number of completed iteration to read chip-id :%lu", itr);
@@ -242,14 +240,14 @@ void InterfaceHandleShutdownModeWakeup(struct bcm_mini_adapter *Adapter)
 		uiRegVal = 0;
 		Status = wrmalt(Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR, &uiRegVal, sizeof(uiRegVal));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,"WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Failed with err :%d", Status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Failed with err :%d", Status);
 			return;
 		}
 	}
 
     else {
 
-        /* clear Interrupt EP registers. */
+		/* clear Interrupt EP registers. */
 		bytes = rdmalt(Adapter, DEVICE_INT_OUT_EP_REG0, &uiRegVal, sizeof(uiRegVal));
 		if (bytes < 0) {
 			Status = bytes;
diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
index 8322f1b..2c8b801 100644
--- a/drivers/staging/bcm/InterfaceIsr.c
+++ b/drivers/staging/bcm/InterfaceIsr.c
@@ -11,101 +11,92 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 		pr_info(PFX "%s: interrupt status %d\n",
 			Adapter->dev->name, status);
 
-	if(Adapter->device_removed == TRUE)
-	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Device has Got Removed.");
+	if (Adapter->device_removed == TRUE) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Device has Got Removed.");
 		return ;
 	}
 
-	if(((Adapter->bPreparingForLowPowerMode == TRUE) && (Adapter->bDoSuspend == TRUE)) ||
+	if (((Adapter->bPreparingForLowPowerMode == TRUE) && (Adapter->bDoSuspend == TRUE)) ||
 		psIntfAdapter->bSuspended ||
-		psIntfAdapter->bPreparingForBusSuspend)
-	{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt call back is called while suspending the device");
-			return ;
+		psIntfAdapter->bPreparingForBusSuspend) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Interrupt call back is called while suspending the device");
+			return;
 	}
 
-	//BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "interrupt urb status %d", status);
-	switch (status) {
+	/*BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "interrupt urb status %d", status);*/
+		switch (status)
 	    /* success */
-	    case STATUS_SUCCESS:
-		if ( urb->actual_length )
-		{
+		case STATUS_SUCCESS:
+		if (urb->actual_length) {
 
-			if(psIntfAdapter->ulInterruptData[1] & 0xFF)
-			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Got USIM interrupt");
+			if (psIntfAdapter->ulInterruptData[1] & 0xFF) {
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Got USIM interrupt");
 			}
 
-			if(psIntfAdapter->ulInterruptData[1] & 0xFF00)
-			{
+			if (psIntfAdapter->ulInterruptData[1] & 0xFF00) {
 				atomic_set(&Adapter->CurrNumFreeTxDesc,
 					(psIntfAdapter->ulInterruptData[1] & 0xFF00) >> 8);
 				atomic_set (&Adapter->uiMBupdate, TRUE);
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "TX mailbox contains %d",
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "TX mailbox contains %d",
 					atomic_read(&Adapter->CurrNumFreeTxDesc));
 			}
-			if(psIntfAdapter->ulInterruptData[1] >> 16)
-			{
-				Adapter->CurrNumRecvDescs=
+			if (psIntfAdapter->ulInterruptData[1] >> 16) {
+				Adapter->CurrNumRecvDescs =
 					(psIntfAdapter->ulInterruptData[1]  >> 16);
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"RX mailbox contains %d",
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "RX mailbox contains %d",
 					Adapter->CurrNumRecvDescs);
 				InterfaceRx(psIntfAdapter);
 			}
-			if(Adapter->fw_download_done &&
+			if (Adapter->fw_download_done &&
 				!Adapter->downloadDDR &&
-				atomic_read(&Adapter->CurrNumFreeTxDesc))
-			{
-				psIntfAdapter->psAdapter->downloadDDR +=1;
+				atomic_read(&Adapter->CurrNumFreeTxDesc)) {
+				psIntfAdapter->psAdapter->downloadDDR += 1;
 				wake_up(&Adapter->tx_packet_wait_queue);
 			}
-			if(FALSE == Adapter->waiting_to_fw_download_done)
-			{
+			if (FALSE == Adapter->waiting_to_fw_download_done) {
 				Adapter->waiting_to_fw_download_done = TRUE;
 				wake_up(&Adapter->ioctl_fw_dnld_wait_queue);
 			}
-			if(!atomic_read(&Adapter->TxPktAvail))
-			{
+			if (!atomic_read(&Adapter->TxPktAvail)) {
 				atomic_set(&Adapter->TxPktAvail, 1);
 				wake_up(&Adapter->tx_packet_wait_queue);
 			}
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Firing interrupt in URB");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Firing interrupt in URB");
 		}
 		break;
-		case -ENOENT :
+		case -ENOENT:
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"URB has got disconnected ....");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "URB has got disconnected ....");
 			return ;
 		}
 		case -EINPROGRESS:
 		{
-			//This situation may happened when URBunlink is used. for detail check usb_unlink_urb documentation.
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occurred... something very bad is going on");
-			break ;
-			//return;
+			/*This situation may happened when URBunlink is used. for detail check usb_unlink_urb documentation.*/
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Impossibe condition has occurred... something very bad is going on");
+			break;
+			/*return;*/
 		}
 		case -EPIPE:
 		{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt IN endPoint  has got halted/stalled...need to clear this");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Interrupt IN endPoint  has got halted/stalled...need to clear this");
 				Adapter->bEndPointHalted = TRUE ;
 				wake_up(&Adapter->tx_packet_wait_queue);
 				urb->status = STATUS_SUCCESS ;
 				return;
 		}
 	    /* software-driven interface shutdown */
-	    case -ECONNRESET: //URB got unlinked.
-	    case -ESHUTDOWN:		// hardware gone. this is the serious problem.
-	    						//Occurs only when something happens with the host controller device
-	    case -ENODEV : //Device got removed
-		case -EINVAL : //Some thing very bad happened with the URB. No description is available.
-	    	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"interrupt urb error %d", status);
+	    case -ECONNRESET: /*URB got unlinked.*/
+	    case -ESHUTDOWN:		/* hardware gone. this is the serious problem.*/
+		/* Occurs only when something happens with the host controller device*/
+	    case -ENODEV: /* Device got removed */
+		case -EINVAL: /* Some thing very bad happened with the URB. No description is available.*/
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "interrupt urb error %d", status);
 			urb->status = STATUS_SUCCESS ;
-			break ;
-			//return;
+			break;
+			/*return;*/
 	    default:
-			//This is required to check what is the defaults conditions when it occurs..
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"GOT DEFAULT INTERRUPT URB STATUS :%d..Please Analyze it...", status);
+			/*This is required to check what is the defaults conditions when it occurs..*/
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "GOT DEFAULT INTERRUPT URB STATUS :%d..Please Analyze it...", status);
 		break;
 	}
 
@@ -117,9 +108,8 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 int CreateInterruptUrb(struct bcm_interface_adapter *psIntfAdapter)
 {
 	psIntfAdapter->psInterruptUrb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!psIntfAdapter->psInterruptUrb)
-	{
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Cannot allocate interrupt urb");
+	if (!psIntfAdapter->psInterruptUrb) {
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Cannot allocate interrupt urb");
 		return -ENOMEM;
 	}
 	psIntfAdapter->psInterruptUrb->transfer_buffer =
@@ -137,7 +127,7 @@ int CreateInterruptUrb(struct bcm_interface_adapter *psIntfAdapter)
 					read_int_callback, psIntfAdapter,
 					psIntfAdapter->sIntrIn.int_in_interval);
 
-	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt Interval: %d\n",
+	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Interrupt Interval: %d\n",
 				psIntfAdapter->sIntrIn.int_in_interval);
 	return 0;
 }
@@ -147,18 +137,15 @@ INT StartInterruptUrb(struct bcm_interface_adapter *psIntfAdapter)
 {
 	INT status = 0;
 
-	if( FALSE == psIntfAdapter->psAdapter->device_removed &&
+	if (FALSE == psIntfAdapter->psAdapter->device_removed &&
 		FALSE == psIntfAdapter->psAdapter->bEndPointHalted &&
 		FALSE == psIntfAdapter->bSuspended &&
 		FALSE == psIntfAdapter->bPreparingForBusSuspend &&
-		FALSE == psIntfAdapter->psAdapter->StopAllXaction)
-	{
+		FALSE == psIntfAdapter->psAdapter->StopAllXaction) {
 		status = usb_submit_urb(psIntfAdapter->psInterruptUrb, GFP_ATOMIC);
-		if (status)
-		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Cannot send int urb %d\n", status);
-			if(status == -EPIPE)
-			{
+		if (status) {
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Cannot send int urb %d\n", status);
+			if (status == -EPIPE) {
 				psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/InterfaceMisc.c
index afca010..d9fa2bb 100644
--- a/drivers/staging/bcm/InterfaceMisc.c
+++ b/drivers/staging/bcm/InterfaceMisc.c
@@ -104,7 +104,7 @@ int BcmRDM(void *arg,
 	void *buff,
 	int len)
 {
-	return InterfaceRDM((struct bcm_interface_adapter*)arg, addr, buff, len);
+	return InterfaceRDM((struct bcm_interface_adapter *)arg, addr, buff, len);
 }
 
 int BcmWRM(void *arg,
diff --git a/drivers/staging/bcm/headers.h b/drivers/staging/bcm/headers.h
index da47db8..b7327ed 100644
--- a/drivers/staging/bcm/headers.h
+++ b/drivers/staging/bcm/headers.h
@@ -1,6 +1,6 @@
 
 /*******************************************************************
-* 		Headers.h
+*			Headers.h
 *******************************************************************/
 #ifndef __HEADERS_H__
 #define __HEADERS_H__
@@ -34,7 +34,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/usb.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <net/ip.h>
 
 #include "Typedefs.h"
-- 
1.7.10.4


--------------070001090807090304030002--
