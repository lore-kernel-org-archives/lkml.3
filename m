Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaCAK3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 05:29:06 -0500
Received: from nm2-vm5.bullet.mail.gq1.yahoo.com ([98.136.218.132]:38173 "EHLO
	nm2-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbaCAK2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 05:28:46 -0500
X-Yahoo-Newman-Id: 558603.19701.bm@smtp235.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ermXynAVM1ktaY7o4rDmP5w1VKyhiwbRB7AGMNxkTUSJdys
 kNHTYYwaJ4jjp2eEMtnJCDa7mDgCZzUhtULw1sFbwg9mHS3bVnQGIFMKja6H
 d.W5r_w7UdrAE3P2NKKN1bggCwjN2kIu1UhDupWWt_wdA6G0.D3eyzNu.kol
 mCfHK6K2UUIIKv7EumOKd6FmVUeucPAeQp_st4fxwb_.Xz2iQ7xKCPS0LTri
 DkK_PbddJSeQ76uCaw4efOAYxOeGmqIp3eiXcf42g.Tal0zrvJYjQIth2wsG
 oBpubVEXd.FZuzLMIiictjh_ZyJZn40bBXjSkYCC6yJoUw49UdVSCbh5UFl_
 jzKbwnPQgw0qLlY6t69buiK3vDc5Nz6YKwqJ86JGAVyRvXvI.k5zwJqpLNkp
 hPPcxafMtPVVA2X2ntk.Ij6xlp_FNAbWKjZQyWVR9tfiMMpg82fYX3rQzbdC
 nqZhZAFj4YQnib2Ooul1B2yedHL1DYMNIji0A1HBSkYcT5GbDjeWKwA.Iua_
 Nuw_Ig6Kx8d4RFH.MW8IjEuozIJRdkZuJJtqXBw--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp235.mail.gq1.yahoo.com with SMTP; 01 Mar 2014 10:28:45 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 2/2] Staging: comedi: use outl_1564_* and inl_1564_* helper functions in hwdrv_apci1564.c
Date: Sat,  1 Mar 2014 04:28:40 -0600
Message-Id: <1393669720-20153-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use these inl and outl helper functions to improve code
readability and shorten several lines to under the character limit.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
I checked over this all several times so I hope it is correct.  I welcome
feedback on anything here

Thanks,
Chase

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 204 ++++++++-------------
 1 file changed, 77 insertions(+), 127 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 282a744..e627e586 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -191,31 +191,21 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 	if (data[0] == ADDIDATA_ENABLE) {
 		data[2] = data[2] << 4;
 		data[3] = data[3] << 4;
-		outl(data[2],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+		outl_1564_digital_ip(devpriv, data[2],
+							APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
+		outl_1564_digital_ip(devpriv, data[3],
+							APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
 		if (data[1] == ADDIDATA_OR) {
-			outl(0x4,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
+			outl_1564_digital_ip(devpriv, 0x4, APCI1564_DIGITAL_IP_IRQ);
 		} else {
-			outl(0x6,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
+			outl_1564_digital_ip(devpriv, 0x6, APCI1564_DIGITAL_IP_IRQ);
 		}
 	} else {
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
+		outl_1564_digital_ip(devpriv, 0x0,
+							APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
+		outl_1564_digital_ip(devpriv, 0x0,
+							APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+		outl_1564_digital_ip(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
 	}
 
 	return insn->n;
@@ -228,7 +218,7 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 
-	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP);
+	data[1] = inl_digital_ip(devpriv, 0x0);
 
 	return insn->n;
 }
@@ -287,12 +277,9 @@ static int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev,
 	else
 		ul_Command = ul_Command & 0xFFFFFFFD;
 
-	outl(ul_Command,
-		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_INTERRUPT);
+	outl_1564_digital_op(devpriv, ul_Command, APCI1564_DIGITAL_OP_INTERRUPT);
 	ui_InterruptData =
-		inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_INTERRUPT);
+		inl_1564_digital_op(devpriv, APCI1564_DIGITAL_OP_INTERRUPT);
 	devpriv->tsk_Current = current;
 	return insn->n;
 }
@@ -304,12 +291,10 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 
-	s->state = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_RW);
+	s->state = inl_1564_digital_op(devpriv, APCI1564_DIGITAL_OP_RW);
 
 	if (comedi_dio_update_state(s, data))
-		outl(s->state, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_RW);
+		outl_1564_digital_op(devpriv, s->state, APCI1564_DIGITAL_OP_RW);
 
 	data[1] = s->state;
 
@@ -359,34 +344,25 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		devpriv->b_TimerSelectMode = ADDIDATA_WATCHDOG;
 
 		/* Disable the watchdog */
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_PROG);
+		outl_1564_digital_op_watchdog(devpriv, 0x0, APCI1564_TCW_PROG);
 		/* Loading the Reload value */
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl_1564_digital_op_watchdog(devpriv, data[3],
+									 APCI1564_TCW_RELOAD_VALUE);
 	} else if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
 		ul_Command1 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_PROG);
+			inl_1564_timer(devpriv, APCI1564_TCW_PROG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 
 		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
 		if (data[1] == 1) {
-			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
-			outl(0x0,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
-			outl(0x0,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-				APCI1564_DIGITAL_OP_IRQ);
-			outl(0x0,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_IRQ);
+			/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			outl_1564_timer(devpriv, 0x02, APCI1564_TCW_PROG);
+			outl_1564_digital_ip(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
+			outl_1564_digital_op(devpriv, 0x0, APCI1564_DIGITAL_OP_IRQ);
+			outl_1564_digital_op_watchdog(devpriv, 0x0, APCI1564_TCW_IRQ);
 			outl(0x0,
 				devpriv->iobase + APCI1564_COUNTER1 +
 				APCI1564_TCW_IRQ);
@@ -400,25 +376,22 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
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
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_PROG);
+			inl_1564_timer(devpriv, APCI1564_TCW_PROG);
 		ul_Command1 =
 			(ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* mode 2 */
+		/* mode 2 */
+		outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 	} else if (data[0] == ADDIDATA_COUNTER) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
 		devpriv->b_ModeSelectRegister = data[5];
@@ -505,19 +478,14 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
 		case 0:	/* stop the watchdog */
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);	/* disable the watchdog */
+			/* disable the watchdog */
+			outl_1564_digital_op_watchdog(devpriv, 0x0, APCI1564_TCW_PROG);
 			break;
 		case 1:	/* start the watchdog */
-			outl(0x0001,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_PROG);
+			outl_1564_digital_op_watchdog(devpriv, 0x0001, APCI1564_TCW_PROG);
 			break;
 		case 2:	/* Software trigger */
-			outl(0x0201,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_PROG);
+			outl_1564_digital_op_watchdog(devpriv, 0x0201, APCI1564_TCW_PROG);
 			break;
 		default:
 			dev_err(dev->class_dev, "Specified functionality does not exist.\n");
@@ -527,24 +495,18 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		if (data[1] == 1) {
 			ul_Command1 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+				inl_1564_timer(devpriv, APCI1564_TCW_PROG);
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
 
 			/* Enable the Timer */
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 		} else if (data[1] == 0) {
 			/* Stop The Timer */
 
 			ul_Command1 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+				inl_1564_timer(devpriv, APCI1564_TCW_PROG);
 			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl_1564_timer(devpriv, ul_Command1, APCI1564_TCW_PROG);
 		}
 	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
@@ -601,20 +563,16 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		/*  Stores the status of the Watchdog */
 		data[0] =
-			inl(devpriv->i_IobaseAmcc +
-			APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_TRIG_STATUS) & 0x1;
+			inl_1564_digital_op_watchdog(devpriv, APCI1564_TCW_TRIG_STATUS) & 0x1;
 		data[1] =
-			inl(devpriv->i_IobaseAmcc +
-			APCI1564_DIGITAL_OP_WATCHDOG);
+			inl_1564_digital_op_watchdog(devpriv, 0x0);
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
 		data[0] =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_TRIG_STATUS) & 0x1;
+			inl_1564_timer(devpriv, APCI1564_TCW_TRIG_STATUS) & 0x1;
 
 		/*  Stores the Actual value of the Timer */
-		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER);
+		data[1] = inl_1564_timer(devpriv, 0x0);
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		/*  Read the Counter Actual Value. */
 		data[0] =
@@ -696,13 +654,9 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
 	unsigned int ul_Command2 = 0;
 
-	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-		APCI1564_DIGITAL_IP_IRQ) & 0x01;
-	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_IRQ) & 0x01;
-	ui_Timer =
-		inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-		APCI1564_TCW_IRQ) & 0x01;
+	ui_DI = inl_1564_digital_ip(devpriv, APCI1564_DIGITAL_IP_IRQ) & 0x01;
+	ui_DO = inl_1564_digital_op(devpriv, APCI1564_DIGITAL_OP_IRQ) & 0x01;
+	ui_Timer = inl_1564_timer(devpriv, APCI1564_TCW_IRQ) & 0x01;
 	ui_C1 = inl(devpriv->iobase + APCI1564_COUNTER1 +
 		APCI1564_TCW_IRQ) & 0x1;
 	ui_C2 = inl(devpriv->iobase + APCI1564_COUNTER2 +
@@ -717,29 +671,23 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	}
 
 	if (ui_DI == 1) {
-		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
+		ui_DI = inl_1564_digital_ip(devpriv, APCI1564_DIGITAL_IP_IRQ);
+		outl_1564_digital_ip(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
 		ui_InterruptStatus_1564 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
+			inl_1564_digital_ip(devpriv, APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
 		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + APCI1564_DIGITAL_IP_IRQ);	/* enable the interrupt */
+		/* enable the interrupt */
+		outl_1564_digital_ip(devpriv, ui_DI, APCI1564_DIGITAL_IP_IRQ);
 		return;
 	}
 
 	if (ui_DO == 1) {
 		/*  Check for Digital Output interrupt Type - 1: Vcc interrupt 2: CC interrupt. */
 		ui_Type =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_INTERRUPT_STATUS) & 0x3;
+			inl_1564_digital_op(devpriv, APCI1564_DIGITAL_OP_INTERRUPT_STATUS) & 0x3;
 		/* Disable the  Interrupt */
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_INTERRUPT);
+		outl_1564_digital_op(devpriv, 0x0, APCI1564_DIGITAL_OP_INTERRUPT);
 
 		/* Sends signal to user space */
 		send_sig(SIGIO, devpriv->tsk_Current, 0);
@@ -751,20 +699,15 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 			/*  Disable Timer Interrupt */
 			ul_Command2 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			     APCI1564_TCW_PROG);
+				inl_1564_timer(devpriv, APCI1564_TCW_PROG);
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
 
@@ -877,19 +820,26 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_IRQ);	/* disable the interrupts */
-	inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_STATUS);	/* Reset the interrupt status register */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);	/* Disable the and/or interrupt */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+	/* disable the interrupts */
+	outl_1564_digital_ip(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
+	/* Reset the interrupt status register */
+	inl_1564_digital_ip(devpriv, APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
+	/* Disable the and/or interrupt */
+	outl_1564_digital_ip(devpriv, 0x0, APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
+	outl_1564_digital_ip(devpriv, 0x0, APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+
 	devpriv->b_DigitalOutputRegister = 0;
 	ui_Type = 0;
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP);	/* Resets the output channels */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_INTERRUPT);	/* Disables the interrupt. */
-	outl(0x0,
-		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-		APCI1564_TCW_RELOAD_VALUE);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);
+
+	/* Resets the output channels */
+	outl_1564_digital_op(devpriv, 0x0, APCI1564_DIGITAL_OP_RW);
+	/* Disables the interrupt. */
+	outl_1564_digital_op(devpriv, 0x0, APCI1564_DIGITAL_OP_INTERRUPT);
+
+	outl_1564_digital_op_watchdog(devpriv, 0x0, APCI1564_TCW_RELOAD_VALUE);
+
+	outl_1564_timer(devpriv, 0x0, 0x0);
+	outl_1564_timer(devpriv, 0x0, APCI1564_TCW_PROG);
 
 	outl(0x0, devpriv->iobase + APCI1564_COUNTER1 + APCI1564_TCW_PROG);
 	outl(0x0, devpriv->iobase + APCI1564_COUNTER2 + APCI1564_TCW_PROG);
-- 
1.8.5.3

