Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaB1JP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:15:59 -0500
Received: from nm14-vm5.bullet.mail.gq1.yahoo.com ([98.136.218.77]:21530 "EHLO
	nm14-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbaB1JPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:15:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=WWJ02CrASVjYC68yNQyZ3FKCjJrQ3pndCfga/SIL1d/bwVM17fmrhD8BqP/xdpNlTCMuXJPvQ2hYI2OM5UzfRFetuDn5cYg9cgE7n6mq6AOFaDbRe4EasG8OkroMpVHfikHxr3+FrpZ9+58k0+6STBES9G5K3OgBkLizzIcil9k=;
X-Yahoo-Newman-Id: 247715.78904.bm@smtp223.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9EeHD5YVM1km8QNAjBRvsOUVzpl35ADn6K0STQ6jSYOIhYb
 9lhPJ7jn4wav.uLcj0Y6iro4fdtA.uEz7urCdGqM1dZJ9CmnBA6WrHOlJNmi
 ZxySbe1a.KP5mKnOYKFHgxFiABZKoJYsCGdxVQs8476vt0vjNU2h60surx2g
 r8.haeFw3n9eJegsTFjNtrcf0FWu7K1LP2Jd1L8H.gGmLSHVTGH05.thN6Sw
 lKs8hPLd1123nvDuBscKC5bEFVwhbOimxsehFZ3_pQsB1XbZy_Tn3ONzUKDq
 5ls.9ujZN5pi5b_WsWMFdYtqmhgTb_wxF.PevLgALcdQKlztnKlBhNakP3FG
 mHHfovBEkMnB745j6BgMqEmBktbAj.tgODFKYsXI7d6tr94HNmO9fFygnDO.
 YZF9xhbFXfwEAWufXyu9vBDRftI53gVMb6j9PFCJTrU3htO.xO3otZ52519Z
 afcdahGrRKdyexwbJcoll_fbjiyPMtR4BMD53fTAJNiIyRwwPOH1KFlbj6gG
 V2fkEQcabAHmu.D6Cl6B9o7Qf7z6xfsQQ6nSx
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp223.mail.gq1.yahoo.com with SMTP; 28 Feb 2014 09:15:51 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 1/2 v2] Staging: comedi: fix lines that are over 80 characters
Date: Fri, 28 Feb 2014 03:15:45 -0600
Message-Id: <1393578945-20488-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a simple helper function, outl_1564_timer(), to
allow several lines which violate the character limit to be shortened.
A handful of other lines that are too long are appropriately split as
well.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
2: introduced outl_1564_timer() at the suggestion of Dan.
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 83 +++++++++++++---------
 1 file changed, 49 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 2b47fa1..d958d3c 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -99,6 +99,9 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_TCW_WARN_TIMEVAL			24
 #define APCI1564_TCW_WARN_TIMEBASE			28
 
+/* Helper functions */
+static void outl_1564_timer(struct addi_private *, unsigned int, unsigned int);
+
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
@@ -324,11 +327,13 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
 			APCI1564_TCW_PROG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 
 		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
 		if (data[1] == 1) {
-			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			outl_1564_timer(devpriv, 0x02, APCI1564_TCW_PROG);
 			outl(0x0,
 				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 				APCI1564_DIGITAL_IP_IRQ);
@@ -352,25 +357,23 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 				devpriv->iobase + APCI1564_COUNTER4 +
 				APCI1564_TCW_IRQ);
 		} else {
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* disable Timer interrupt */
+			/* disable Timer interrupt */
+			outl_1564_timer(devpriv, 0x0, APCI1564_TCW_PROG);
 		}
 
 		/*  Loading Timebase */
-		outl(data[2],
-			devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_TIMEBASE);
+		outl_1564_timer(devpriv, data[2], APCI1564_TCW_TIMEBASE);
 
 		/* Loading the Reload value */
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl_1564_timer(devpriv, data[3], APCI1564_TCW_RELOAD_VALUE);
 
 		ul_Command1 =
 			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
 			APCI1564_TCW_PROG);
 		ul_Command1 =
 			(ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* mode 2 */
+		/* mode 2 */
+		outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 	} else if (data[0] == ADDIDATA_COUNTER) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
 		devpriv->b_ModeSelectRegister = data[5];
@@ -380,7 +383,9 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			inl(devpriv->iobase + ((data[5] - 1) * 0x20) +
 			APCI1564_TCW_PROG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->iobase + ((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl(ul_Command1, devpriv->iobase + ((data[5] - 1) * 0x20) +
+			APCI1564_TCW_PROG);
 
 		/* Set the reload value */
 		outl(data[3],
@@ -457,7 +462,9 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
 		case 0:	/* stop the watchdog */
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);	/* disable the watchdog */
+			/* disable the watchdog */
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
+				APCI1564_TCW_PROG);
 			break;
 		case 1:	/* start the watchdog */
 			outl(0x0001,
@@ -484,9 +491,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
 
 			/* Enable the Timer */
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 		} else if (data[1] == 0) {
 			/* Stop The Timer */
 
@@ -494,9 +499,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
 				APCI1564_TCW_PROG);
 			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 		}
 	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
@@ -678,13 +681,18 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 			APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
 		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
-		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + APCI1564_DIGITAL_IP_IRQ);	/* enable the interrupt */
+		/*  send signal to the sample */
+		send_sig(SIGIO, devpriv->tsk_Current, 0);
+		/* enable the interrupt */
+		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
+			APCI1564_DIGITAL_IP_IRQ);
 		return;
 	}
 
 	if (ui_DO == 1) {
-		/*  Check for Digital Output interrupt Type - 1: Vcc interrupt 2: CC interrupt. */
+		/*  Check for Digital Output interrupt Type	*/
+		/*  1: Vcc interrupt						*/
+		/*  2: CC interrupt							*/
 		ui_Type =
 			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
 			APCI1564_DIGITAL_OP_INTERRUPT_STATUS) & 0x3;
@@ -705,18 +713,14 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 			ul_Command2 =
 				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
 				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			     APCI1564_TCW_PROG);
+			outl_1564_timer(devpriv, 0x0, APCI1564_TCW_PROG);
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Timer Interrupt */
 
-			outl(ul_Command2,
-			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			     APCI1564_TCW_PROG);
+			outl_1564_timer(devpriv, ul_Command2, APCI1564_TCW_PROG);
 		}
 	}
 
@@ -829,19 +833,24 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_IRQ);	/* disable the interrupts */
-	inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_STATUS);	/* Reset the interrupt status register */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);	/* Disable the and/or interrupt */
+	/* disable the interrupts */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_IRQ);
+	/* Reset the interrupt status register */
+	inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
+	/* Disable the and/or interrupt */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
 	devpriv->b_DigitalOutputRegister = 0;
 	ui_Type = 0;
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP);	/* Resets the output channels */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_INTERRUPT);	/* Disables the interrupt. */
+	/* Resets the output channels */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP);
+	/* Disables the interrupt. */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_INTERRUPT);
 	outl(0x0,
 		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
 		APCI1564_TCW_RELOAD_VALUE);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);
+	outl_1564_timer(devpriv, 0x0, 0x0);
+	outl_1564_timer(devpriv, 0x0, APCI1564_TCW_PROG);
 
 	outl(0x0, devpriv->iobase + APCI1564_COUNTER1 + APCI1564_TCW_PROG);
 	outl(0x0, devpriv->iobase + APCI1564_COUNTER2 + APCI1564_TCW_PROG);
@@ -849,3 +858,9 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 	outl(0x0, devpriv->iobase + APCI1564_COUNTER4 + APCI1564_TCW_PROG);
 	return 0;
 }
+
+static void outl_1564_timer(struct addi_private *devpriv, unsigned int cmd,
+				unsigned int reg)
+{
+	outl(cmd, devpriv->i_IobaseAmcc + APCI1564_TIMER + reg);
+}
-- 
1.8.5.3

