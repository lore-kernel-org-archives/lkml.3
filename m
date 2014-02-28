Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaB1Hb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:31:27 -0500
Received: from nm20-vm5.bullet.mail.gq1.yahoo.com ([98.136.217.36]:45480 "EHLO
	nm20-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbaB1HbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:31:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=FMTdWsnfs250tBs/W1Z4h5jboK/ArZUCybDp8DHOLqYoIoHtq3DjbxuLW7EneYJKSQe1ogFhCC89g/Gid0haFN4vOVC084LF5dA6RmcGE+vqkZM1k6qkim30dwZfnqwyWUTGMeegItjWYYsaDJjXPlpGh8qnOotWQr9gXdR2hf4=;
X-Yahoo-Newman-Id: 77545.4483.bm@smtp210.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QV6ySSEVM1kyC9AFjjYd1eONGE_GTj.RfDYXZK5egImkYiG
 Q6CtYUMwe3H0B4vuOJ6Mng2fnQweyJP3uXIhLYfcmZZb6SPtyVr5yDw0HTmA
 Ji8DgZQa7BG5pYdzzz1zn6FvDm1sRJCYD9TemMjTnU2ogZS63WCxn5TnC_Eo
 E9qFCEMShb_u5oa38SvpMs7fnNyAGbLCKS0864Mo3TmSWS9hIEVpCXPy_yqK
 0QrqZVoz41SleD0A2biLpotJ4DxDI4rGaCbyhxAdCgzKl7eKLXh1ZjIVFBpa
 2g786ja5Dux8KmK44VZFkAXH8UZ.sj_E7tDvKDYo0_57sESJBpiqcmCsjX84
 sUL_eam9v8UhwB9wb8NYHA2r1QneASwRmCi8IwLnjfa4uGv9MeawyJNa0L.A
 d7cLTZC7WAlF8zUPjyP_nVn9QkpuBSefSsLeA4E4U68NTeULNwGjD4N0vJ0T
 vTSV_3QnP.mDuwOELbww3bAzZI0MaHJWoNCWQWq65kceMLkfKN_qHQmREccO
 n1M4FyXe.AEhGnBo1fZTWvY8h9QEQwB0-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp210.mail.gq1.yahoo.com with SMTP; 27 Feb 2014 23:31:24 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>,
        Chase Southwood <chase.southwoo@yahoo.com>
Subject: [PATCH 1/2] Staging: comedi: addi-data: fix lines that are over 80 characters
Date: Fri, 28 Feb 2014 01:31:20 -0600
Message-Id: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwdrv_apci1564.c had numerous lines over the column limit.  This patch
splits all such lines to bring them in compliance with coding style.

Signed-off-by: Chase Southwood <chase.southwoo@yahoo.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 50 ++++++++++++++++------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 2b47fa1..77030c5 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -324,11 +324,15 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
 			APCI1564_TCW_PROG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER +
+			APCI1564_TCW_PROG);
 
 		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
 		if (data[1] == 1) {
-			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER +
+				APCI1564_TCW_PROG);
 			outl(0x0,
 				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 				APCI1564_DIGITAL_IP_IRQ);
@@ -352,7 +356,9 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 				devpriv->iobase + APCI1564_COUNTER4 +
 				APCI1564_TCW_IRQ);
 		} else {
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* disable Timer interrupt */
+			/* disable Timer interrupt */
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER +
+				APCI1564_TCW_PROG);
 		}
 
 		/*  Loading Timebase */
@@ -370,7 +376,9 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			APCI1564_TCW_PROG);
 		ul_Command1 =
 			(ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* mode 2 */
+		/* mode 2 */
+		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER +
+			APCI1564_TCW_PROG);
 	} else if (data[0] == ADDIDATA_COUNTER) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
 		devpriv->b_ModeSelectRegister = data[5];
@@ -380,7 +388,9 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			inl(devpriv->iobase + ((data[5] - 1) * 0x20) +
 			APCI1564_TCW_PROG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->iobase + ((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl(ul_Command1, devpriv->iobase + ((data[5] - 1) * 0x20) +
+			APCI1564_TCW_PROG);
 
 		/* Set the reload value */
 		outl(data[3],
@@ -457,7 +467,9 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
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
@@ -678,13 +690,18 @@ static void v_APCI1564_Interrupt(int irq, void *d)
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
@@ -829,14 +846,19 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
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
-- 
1.8.5.3

