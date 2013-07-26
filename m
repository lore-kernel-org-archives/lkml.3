Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3GZM7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:59:46 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62766 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3GZM7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:59:45 -0400
Message-ID: <1374843573.1802.3.camel@desktop>
Subject: [PATCH 1/2] Staging: bcm: InterfaceIdleMode: Fixed spacing/tabing
 issues
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, klmckinney1@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Jul 2013 20:59:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing/tabing issues.

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/InterfaceIdleMode.c | 38
++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceIdleMode.c
b/drivers/staging/bcm/InterfaceIdleMode.c
index 5347828..0c93048 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -52,18 +52,18 @@ int InterfaceIdleModeRespond(struct bcm_mini_adapter
*Adapter, unsigned int *pui
 
 	if (ntohl(*puiBuffer) == GO_TO_IDLE_MODE_PAYLOAD) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "
Got GO_TO_IDLE_MODE_PAYLOAD(210) Msg Subtype");
-		if (ntohl(*(puiBuffer+1)) == 0 ) {
+		if (ntohl(*(puiBuffer+1)) == 0) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Got IDLE MODE WAKE UP Response From F/W");
 
-			status = wrmalt (Adapter, SW_ABORT_IDLEMODE_LOC, &uiRegRead,
sizeof(uiRegRead));
+			status = wrmalt(Adapter, SW_ABORT_IDLEMODE_LOC, &uiRegRead,
sizeof(uiRegRead));
 			if (status) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "wrm failed while
clearing Idle Mode Reg");
 				return status;
 			}
 
 			if (Adapter->ulPowerSaveMode ==
DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING) {
-				uiRegRead = 0x00000000 ;
-				status = wrmalt (Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR,
&uiRegRead, sizeof(uiRegRead));
+				uiRegRead = 0x00000000;
+				status = wrmalt(Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR,
&uiRegRead, sizeof(uiRegRead));
 				if (status) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "wrm failed while
clearing Idle Mode	Reg");
 					return status;
@@ -98,11 +98,11 @@ int InterfaceIdleModeRespond(struct bcm_mini_adapter
*Adapter, unsigned int *pui
 			if (TRUE == Adapter->IdleMode)
 			{
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Device is already in Idle mode....");
-				return status ;
+				return status;
 			}
 
 			uiRegRead = 0;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Got Req from F/W to go in IDLE mode \n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Got Req from F/W to go in IDLE mode\n");
 
 			if (Adapter->chip_id == BCS220_2 ||
 				Adapter->chip_id == BCS220_2BC ||
@@ -119,7 +119,7 @@ int InterfaceIdleModeRespond(struct bcm_mini_adapter
*Adapter, unsigned int *pui
 
 				uiRegRead |= (1<<17);
 
-				status = wrmalt (Adapter, HPM_CONFIG_MSW, &uiRegRead,
sizeof(uiRegRead));
+				status = wrmalt(Adapter, HPM_CONFIG_MSW, &uiRegRead,
sizeof(uiRegRead));
 				if (status) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "wrm failed while
clearing Idle Mode Reg\n");
 					return status;
@@ -137,19 +137,19 @@ int InterfaceIdleModeRespond(struct
bcm_mini_adapter *Adapter, unsigned int *pui
 
 static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter,
unsigned int Pattern)
 {
-	int 	status = STATUS_SUCCESS;
+	int status = STATUS_SUCCESS;
 	unsigned int value;
-	unsigned int chip_id ;
+	unsigned int chip_id;
 	unsigned long timeout = 0, itr = 0;
 
-	int 	lenwritten = 0;
+	int lenwritten = 0;
 	unsigned char aucAbortPattern[8] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF};
 	struct bcm_interface_adapter *psInterfaceAdapter =
Adapter->pvInterfaceAdapter;
 
 	/* Abort Bus suspend if its already suspended */
 	if ((TRUE == psInterfaceAdapter->bSuspended) && (TRUE ==
Adapter->bDoSuspend)) {
 		status = usb_autopm_get_interface(psInterfaceAdapter->interface);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Bus got wakeup..Aborting Idle mode... status:%d \n", status);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Bus got wakeup..Aborting Idle mode... status:%d\n", status);
 
 	}
 
@@ -179,7 +179,7 @@ static int InterfaceAbortIdlemode(struct
bcm_mini_adapter *Adapter, unsigned int
 		 * To be Done in Thread Context.
 		 * Not using Asynchronous Mechanism.
 		 */
-		status = usb_interrupt_msg (psInterfaceAdapter->udev,
+		status = usb_interrupt_msg(psInterfaceAdapter->udev,
 			usb_sndintpipe(psInterfaceAdapter->udev,
 			psInterfaceAdapter->sIntrOut.int_out_endpointAddr),
 			aucAbortPattern,
@@ -195,16 +195,16 @@ static int InterfaceAbortIdlemode(struct
bcm_mini_adapter *Adapter, unsigned int
 
 		/* mdelay(25); */
 
-		timeout = jiffies +  msecs_to_jiffies(50) ;
-		while ( timeout > jiffies ) {
-			itr++ ;
+		timeout = jiffies +  msecs_to_jiffies(50);
+		while (timeout > jiffies) {
+			itr++;
 			rdmalt(Adapter, CHIP_ID_REG, &chip_id, sizeof(UINT));
 			if (0xbece3200 == (chip_id&~(0xF0)))
 				chip_id = chip_id&~(0xF0);
 			if (chip_id == Adapter->chip_id)
 				break;
 		}
-		if (timeout < jiffies )
+		if (timeout < jiffies)
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Not able to read chip-id even after 25 msec");
 		else
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Number of completed iteration to read chip-id :%lu", itr);
@@ -242,14 +242,14 @@ void InterfaceHandleShutdownModeWakeup(struct
bcm_mini_adapter *Adapter)
 		uiRegVal = 0;
 		Status = wrmalt(Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR,
&uiRegVal, sizeof(uiRegVal));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,"WRM to
DEBUG_INTERRUPT_GENERATOR_REGISTOR Failed with err :%d", Status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM to
DEBUG_INTERRUPT_GENERATOR_REGISTOR Failed with err :%d", Status);
 			return;
 		}
 	}
 
-    else {
+	else {
 
-        /* clear Interrupt EP registers. */
+	/* clear Interrupt EP registers. */
 		bytes = rdmalt(Adapter, DEVICE_INT_OUT_EP_REG0, &uiRegVal,
sizeof(uiRegVal));
 		if (bytes < 0) {
 			Status = bytes;
-- 
1.8.3.1



