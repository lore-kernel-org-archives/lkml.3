Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaCHAmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:42:10 -0500
Received: from nm5-vm10.bullet.mail.gq1.yahoo.com ([98.136.218.185]:33623 "EHLO
	nm5-vm10.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbaCHAmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:42:06 -0500
X-Yahoo-Newman-Id: 123430.66989.bm@smtp202.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JBNCyNMVM1lQHnrLSdGOI6jVaCofo_hsKu27oW6SU_Dmm7E
 A41xF8jImMPLEUE8uDhqLhOPZbNT3v3TS_hj0qfsng3pMoo4An2YEUT3oHrZ
 UVTXTYMG7xQInk45MAM5GpVI.EN60EcwhUT5_lSIKWHkdl75cTjmm1n7rNBh
 qkrN3kLZV34qO4eLhgfKZggAuy_Z2oiE5hdvjfQgbK8Ubw3knwjL3hoBCrUb
 dslGyRf8i31ALYvd8kctS_xhjvICtBvagGJ7YDKKr0lVTwBQEW1qN7WvLYrR
 Vmrf_UL50M32p82FF2HnkHtO_7QO4pGkusOBbKB4IEAoS7Rm6WrTg0XqsyhG
 5KXJp2N0CIPya9cpIt.C8CC0X4p3oIvXDx9Zfr8GVrxjVLX_6EY9De7jkxMo
 MFSPJTLsFJj2c.0jOOUba8Q4macyxeYizbcLYywCPxE0xhcVK7x_HIfGp_YK
 4yiYedX4LR.qupKZVEptYUtwZ2Ws2uIkzNWORthdyGXpXYl5P3FAbo1O_Y6N
 GXUP6iRnB2bEmoNdgMv.1M1G.tb0XMQ8MQh4LEg--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp202.mail.gq1.yahoo.com with SMTP; 07 Mar 2014 16:42:06 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v3 3/5] Staging: comedi: addi-data: tidy up watchdog register
Date: Fri,  7 Mar 2014 18:42:00 -0600
Message-Id: <1394239320-25975-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for fixes the register map defines for the watchdog registers
such that they are all the real offsets to each register, rather than a
mix of real offsets and adders to those offsets.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Simplified commit message, fixed indentation and whitespace damage.
I have test applied this patch, it should work now.

3: Fixed indentation (again)

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 48 ++++++++--------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index d493d01..8ff8693 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -65,7 +65,6 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define ADDIDATA_TIMER					0
 #define ADDIDATA_COUNTER				1
 #define ADDIDATA_WATCHDOG				2
-#define APCI1564_DIGITAL_OP_WATCHDOG			0x28
 #define APCI1564_TIMER					0x48
 #define APCI1564_COUNTER1				0x0
 #define APCI1564_COUNTER2				0x20
@@ -92,6 +91,14 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_DO_INT_CTRL_REG			0x1c
 #define APCI1564_DO_INT_STATUS_REG			0x20
 #define APCI1564_DO_IRQ_REG				0x24
+#define APCI1564_WDOG_REG				0x28
+#define APCI1564_WDOG_RELOAD_REG			0x2c
+#define APCI1564_WDOG_TIMEBASE_REG			0x30
+#define APCI1564_WDOG_CTRL_REG				0x34
+#define APCI1564_WDOG_STATUS_REG			0x38
+#define APCI1564_WDOG_IRQ_REG				0x3c
+#define APCI1564_WDOG_WARN_TIMEVAL_REG			0x40
+#define APCI1564_WDOG_WARN_TIMEBASE_REG			0x44
 
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
@@ -285,13 +292,9 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		devpriv->b_TimerSelectMode = ADDIDATA_WATCHDOG;
 
 		/* Disable the watchdog */
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_PROG);
+		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
 		/* Loading the Reload value */
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_WDOG_RELOAD_REG);
 	} else if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
 		ul_Command1 =
@@ -305,10 +308,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG);
-			outl(0x0,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_IRQ);
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_IRQ_REG);
 			outl(0x0,
 				devpriv->iobase + APCI1564_COUNTER1 +
 				APCI1564_TCW_IRQ);
@@ -427,19 +427,14 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
 		case 0:	/* stop the watchdog */
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);	/* disable the watchdog */
+			/* disable the watchdog */
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
 			break;
 		case 1:	/* start the watchdog */
-			outl(0x0001,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_PROG);
+			outl(0x0001, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
 			break;
 		case 2:	/* Software trigger */
-			outl(0x0201,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_PROG);
+			outl(0x0201, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
 			break;
 		default:
 			dev_err(dev->class_dev, "Specified functionality does not exist.\n");
@@ -522,13 +517,8 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		/*  Stores the status of the Watchdog */
-		data[0] =
-			inl(devpriv->i_IobaseAmcc +
-			APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_TRIG_STATUS) & 0x1;
-		data[1] =
-			inl(devpriv->i_IobaseAmcc +
-			APCI1564_DIGITAL_OP_WATCHDOG);
+		data[0] = inl(devpriv->i_IobaseAmcc + APCI1564_WDOG_STATUS_REG) & 0x1;
+		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
 		data[0] =
@@ -803,9 +793,7 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
 	/* Disables the interrupt. */
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
-	outl(0x0,
-		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-		APCI1564_TCW_RELOAD_VALUE);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_RELOAD_REG);
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER);
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);
 
-- 
1.8.5.3

