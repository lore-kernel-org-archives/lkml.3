Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaBPIkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 03:40:20 -0500
Received: from nm23-vm2.bullet.mail.gq1.yahoo.com ([98.136.217.81]:41627 "EHLO
	nm23-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbaBPIkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 03:40:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=flBk9JTrUt7NVUpBSTiJ2Cyx8lP3RQoa7mX7rrlJbpDKrkA0w8qC8ddce9k3B/TQsrsoPIhc1bOWVZ5U8qmvrn2vxov8JAEgOwi+6qqLqf3NSkVpHXyhitcy1Csdwl8NYJZpiVbB+YLx4hqm+hN3V8CT3NGaplAT/V2V7QQrems=;
X-Yahoo-Newman-Id: 573349.36510.bm@smtp213.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tgAviz4VM1lI8jLo9_dnSTuwM5rKIaFLka55lfOqa5.uHvN
 oE61Q_9mOzHjdhT7W6Ff5gexbCSx3u3DLNkOGMx7qHzU6hy2BUD5fNGK_MCX
 R2x9rH27jpNg.x3ypw_tCcmVBOFewHxbRlbV..54uLvHHVix3JWi1WyPchO_
 mWUQxD4HZnS33tuXTRf43RkPaMHVTCQPcyhiFs1YKPZ118lG7UWjoM3E_mT9
 PzfQlcowyng8kgDg3GPvSxR_nE63Suw9PlHYy3dSkA59NV9KrE0YuTyiG430
 BAewuP1g63WQbj6VSr5kzQ3W8vy2BTO9KCwTWi8A8eJOgl.qykBWfSqdLbWl
 A5enElmfGme5debBhXXRkAaPvlLC7JRN8nEX.F9LCoTxgPOirAJY.j44RFtk
 rwKk9BQ4uZ6E4pkMy6sHrxhX12PGi5F.ELcAKGU5vRbS5jNxb9zh13pqBHUK
 7DoERcUC01zDb8Uj15nRL1T9JTnxetb7DxQFsObpEp4E37NjDC9yb3Hak95A
 rQuTj6YukyFm8uOSc9QBgo1W6QinRqDS2HBPP5g--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp213.mail.gq1.yahoo.com with SMTP; 16 Feb 2014 08:40:17 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 1/4] Staging: comedi: addi-data: fix brace-related coding style issues in hwdrv_apci035.c
Date: Sun, 16 Feb 2014 02:40:06 -0600
Message-Id: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for hwdrv_apci035 removes some unneeded braces, and moves some
improperly placed braces to the correct position, as found by checkpatch.
It also removes a commented out if-statement that I found whilst cleaning
braces that is identical to another un-commented if-statement directly
above it, so it is just added clutter and so we can delete it to clean up
further.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
So I decided to venture into addi-data today and found that most of the
files in there are very messy from a style standpoint.  This is the first
(of probably a few) patchsets to try and clean those files up a bit.  I
hope that this will be helpful!

 .../comedi/drivers/addi-data/hwdrv_apci035.c       | 49 ++++++++++------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 1128c22..584a1d5 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -177,11 +177,11 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 	devpriv->tsk_Current = current;
 	devpriv->b_TimerSelectMode = data[0];
 	i_WatchdogNbr = data[1];
-	if (data[0] == 0) {
+	if (data[0] == 0)
 		ui_Mode = 2;
-	} else {
+	else
 		ui_Mode = 0;
-	}
+
 /* ui_Command = inl(devpriv->iobase+((i_WatchdogNbr-1)*32)+12); */
 	ui_Command = 0;
 /* ui_Command = ui_Command & 0xFFFFF9FEUL; */
@@ -366,8 +366,7 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	}
 
-	if (data[0] == 0)	/* Stop The Watchdog */
-	{
+	if (data[0] == 0) {
 		/* Stop The Watchdog */
 		ui_Command = 0;
 /*
@@ -377,15 +376,15 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 		outl(ui_Command,
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	}			/*   if (data[1]==0) */
-	if (data[0] == 3)	/* stop all Watchdogs */
-	{
+	if (data[0] == 3) {
+		/* stop all Watchdogs */
 		ui_Command = 0;
 		for (i_Count = 1; i_Count <= 4; i_Count++) {
-			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
+			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
 				ui_Command = 0x2UL;
-			} else {
+			else
 				ui_Command = 0x10UL;
-			}
+
 			i_WatchdogNbr = i_Count;
 			outl(ui_Command,
 				devpriv->iobase + ((i_WatchdogNbr - 1) * 32) +
@@ -393,30 +392,29 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 		}
 
 	}
-	if (data[0] == 4)	/* start all Watchdogs */
-	{
+	if (data[0] == 4) {
+		/* start all Watchdogs */
 		ui_Command = 0;
 		for (i_Count = 1; i_Count <= 4; i_Count++) {
-			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
+			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
 				ui_Command = 0x1UL;
-			} else {
+			else
 				ui_Command = 0x8UL;
-			}
+
 			i_WatchdogNbr = i_Count;
 			outl(ui_Command,
 				devpriv->iobase + ((i_WatchdogNbr - 1) * 32) +
 				0);
 		}
 	}
-	if (data[0] == 5)	/* trigger all Watchdogs */
-	{
+	if (data[0] == 5) {
+		/* trigger all Watchdogs */
 		ui_Command = 0;
 		for (i_Count = 1; i_Count <= 4; i_Count++) {
-			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
+			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
 				ui_Command = 0x4UL;
-			} else {
+			else
 				ui_Command = 0x20UL;
-			}
 
 			i_WatchdogNbr = i_Count;
 			outl(ui_Command,
@@ -488,11 +486,9 @@ static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
 	/* Get the overflow status */
 	/***************************/
 	data[3] = ((ui_Status >> 0) & 1);
-	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
+	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER)
 		data[4] = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 0);
 
-	}			/*   if  (devpriv->b_TimerSelectMode==ADDIDATA_TIMER) */
-
 	return insn->n;
 }
 
@@ -655,8 +651,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
 	ui_StatusRegister2 =
 		inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 20);
 
-	if ((((ui_StatusRegister1) & 0x8) == 0x8))	/* Test if warning relay interrupt */
-	{
+	/* Test if warning relay interrupt */
+	if ((((ui_StatusRegister1) & 0x8) == 0x8)) {
 	/**********************************/
 		/* Disable the temperature warning */
 	/**********************************/
@@ -675,9 +671,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
 	}			/* if (((ui_StatusRegister1 & 0x8) == 0x8)) */
 
 	else {
-		if ((ui_StatusRegister2 & 0x1) == 0x1) {
+		if ((ui_StatusRegister2 & 0x1) == 0x1)
 			send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-		}
 	}			/* else if (((ui_StatusRegister1 & 0x8) == 0x8)) */
 
 	return;
-- 
1.8.5.3

