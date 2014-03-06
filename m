Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaCFHdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:33:37 -0500
Received: from nm16-vm5.bullet.mail.gq1.yahoo.com ([98.137.177.253]:28405 "EHLO
	nm16-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbaCFHdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:33:36 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 02:33:35 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=MFpSCbTPdV30r6naW8M/vrZEG87Wt23DqorOp5XZyvrIA1Il5xebXbBgLyBo+gYFJYApvDZ7e/er//4fzcyyBvk5LPqOhjnipJqdenpusrIOZDoHylssFGBcjThJ4vxRhdttgZLUAoFMvLP2MjUCAwyzmHWr7EGqg4LEPgNU8mw=;
X-Yahoo-Newman-Id: 892332.66821.bm@smtp218.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rSCxuVQVM1k7.n1EWt4nVtd7sEEoFB5p2JvhhtkgBOyKktB
 LWBsg3ABoU0eSsrT2ClLsNFOnCnarhDy6zZ6yAE_JkckU1YeQqr233yfIpv4
 s9bxq4NjtXRFIxR9OjpXEQF35JqHDMrZZ6ZSajOzW2JmGohim5P22fzjjls6
 xB4KDlw.1f8Lx46.cDr8HRFc0ejz19AA7MRNsSOZ9OnmClw3JnCjCp5XeV.Z
 Tb4GaV7xb2kkDYe7lao8WA_Vb44z1AokmNQunFQb7AFehq5xuV5.CCRnI2PG
 rBO0dwE885OuiMmS2TKg4rBAlQDHIPSV1pz8UaIoaLwbze_QR9THj6nFf1lP
 A356FBKPfJ6HFmr1BAQde6ufQNP5qclBvseq01FXbNI0XczdURUuMJr.vaH7
 7JbteFZlbafng5SZn3p3SPCWdw4kx36e.Z6hPV0ixkVU9r_QlHyD8P2517lr
 cIUcyEcXVkk0ifce5CY5E7oeijzPyn8gd2lLj1jMlsUSW6g5ptGzF8hqC5qp
 ql2.HX9AfmYWRMwO.dDLuTh_LJ6AkcHJjWCnotQ--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp218.mail.gq1.yahoo.com with SMTP; 06 Mar 2014 07:26:03 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 3/5] Staging: comedi: addi-data: tidy up watchdog register map defines in hwdrv_apci1564.c
Date: Thu,  6 Mar 2014 01:25:52 -0600
Message-Id: <1394090752-7940-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for hwdrv_apci1564.c fixes the register map defines for the
watchdog registers such that they are all the real offsets to each
register, rather than a mix of real offsets and adders to those offsets.
Additionally, the defines have been renamed to assist with shortening
some lines in excess of 80 characters.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 48 ++++++++--------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index d17c37b..91ca091 100644
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
 #define APCI1564_DO_INT_CTRL_REG		0x1c
 #define APCI1564_DO_INT_STATUS_REG		0x20
 #define APCI1564_DO_IRQ_REG				0x24
+#define APCI1564_WDOG_REG				0x28
+#define APCI1564_WDOG_RELOAD_REG			0x2c
+#define APCI1564_WDOG_TIMEBASE_REG			0x30
+#define APCI1564_WDOG_CTRL_REG				0x34
+#define APCI1564_WDOG_STATUS_REG			0x38
+#define APCI1564_WDOG_IRQ_REG				0x3c
+#define APCI1564_WDOG_WARN_TIMEVAL_REG			0x40
+#define APCI1564_WDOG_WARN_TIMEBASE_REG		0x44
 
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

