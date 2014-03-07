Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaCGIhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:37:54 -0500
Received: from nm23-vm8.bullet.mail.gq1.yahoo.com ([98.136.217.87]:30382 "EHLO
	nm23-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbaCGIhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:37:51 -0500
X-Yahoo-Newman-Id: 902688.53370.bm@smtp239.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6geIu6AVM1ky6JAcbLNhks7_64j08aQZCGY_6MA6Cg3c0RG
 86ds7Ji_MQVLXovQgJlcPAspc.cwhIqIRiCTZ4A4bzFB1qSXQP204sowusyz
 veY_gNWab.oqTKYH4ept88BjAALR9bePK7.Xy0i8J2eV5fMj0_KsI8YWd9Ue
 BwTbZtGhoHNfzBXIf1YmUwTJVy3sOK.CbcsRMJHo_Hg6EXdJqwlED6CpZoxT
 X8a_h_Qyw6c32JofV9_wCQqb_g4FxjcauqLFByHdxKsf9JMKLjAalu5Ns2i9
 xZ50LDAbsbALDAKdhvbwrdlfAKROFWdC86RxJusHQmd2bz.R8pDHNs8MPagZ
 HC1xQ_6oWVAMlWv71Pozs6gZb3b2ZSoV28jmfa5fd449rO7rIb4hxOmhRk.M
 4eKC_gfSjfUJ4e4Le5BFIJNarXJFlH8zS3PCr_LuzU1Oc6fWxOinzZ58Ou_5
 ltV_D0WV4SQt8TVCxD41p118tonQ1w2CPdt_BYvDiutxkcNTfKqnKv1BE1ex
 8qVZgXxMVTIKK9a0K.0MHCOgJRYf4QRhQNPz.5Q--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp239.mail.gq1.yahoo.com with SMTP; 07 Mar 2014 08:37:50 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH  v2 4/5] Staging: comedi: addi-data: tidy up timer register map defines in hwdrv_apci1564.c
Date: Fri,  7 Mar 2014 02:37:45 -0600
Message-Id: <1394181465-17108-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for fixes the register map defines for the timer registers such
that they are all the real offsets to each register, rather than a mix of
real offsets and adders to those offsets.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Simplified commit message, fixed indentation and whitespace damage.
I have test applied this patch, it should work now.

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 82 +++++++++-------------
 1 file changed, 33 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 8ff8693..2a3523f 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -65,7 +65,6 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define ADDIDATA_TIMER					0
 #define ADDIDATA_COUNTER				1
 #define ADDIDATA_WATCHDOG				2
-#define APCI1564_TIMER					0x48
 #define APCI1564_COUNTER1				0x0
 #define APCI1564_COUNTER2				0x20
 #define APCI1564_COUNTER3				0x40
@@ -99,6 +98,14 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_WDOG_IRQ_REG					0x3c
 #define APCI1564_WDOG_WARN_TIMEVAL_REG			0x40
 #define APCI1564_WDOG_WARN_TIMEBASE_REG		0x44
+#define APCI1564_TIMER_REG						0x48
+#define APCI1564_TIMER_RELOAD_REG				0x4c
+#define APCI1564_TIMER_TIMEBASE_REG			0x50
+#define APCI1564_TIMER_CTRL_REG				0x54
+#define APCI1564_TIMER_STATUS_REG				0x58
+#define APCI1564_TIMER_IRQ_REG					0x5c
+#define APCI1564_TIMER_WARN_TIMEVAL_REG		0x60
+#define APCI1564_TIMER_WARN_TIMEBASE_REG		0x64
 
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
@@ -297,15 +304,15 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_WDOG_RELOAD_REG);
 	} else if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
-		ul_Command1 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_PROG);
+		ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 
 		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
 		if (data[1] == 1) {
-			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG);
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_IRQ_REG);
@@ -322,25 +329,20 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 				devpriv->iobase + APCI1564_COUNTER4 +
 				APCI1564_TCW_IRQ);
 		} else {
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* disable Timer interrupt */
+			/* disable Timer interrupt */
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 		}
 
 		/*  Loading Timebase */
-		outl(data[2],
-			devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_TIMEBASE);
+		outl(data[2], devpriv->i_IobaseAmcc + APCI1564_TIMER_TIMEBASE_REG);
 
 		/* Loading the Reload value */
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_TIMER_RELOAD_REG);
 
-		ul_Command1 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_PROG);
-		ul_Command1 =
-			(ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* mode 2 */
+		ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+		ul_Command1 = (ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
+		/* mode 2 */
+		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 	} else if (data[0] == ADDIDATA_COUNTER) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
 		devpriv->b_ModeSelectRegister = data[5];
@@ -443,25 +445,17 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		if (data[1] == 1) {
-			ul_Command1 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
 
 			/* Enable the Timer */
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 		} else if (data[1] == 0) {
 			/* Stop The Timer */
 
-			ul_Command1 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 		}
 	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
@@ -521,12 +515,10 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
-		data[0] =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_TRIG_STATUS) & 0x1;
+		data[0] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_STATUS_REG) & 0x1;
 
 		/*  Stores the Actual value of the Timer */
-		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER);
+		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_REG);
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		/*  Read the Counter Actual Value. */
 		data[0] =
@@ -610,9 +602,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG) & 0x01;
 	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG) & 0x01;
-	ui_Timer =
-		inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-		APCI1564_TCW_IRQ) & 0x01;
+	ui_Timer = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_IRQ_REG) & 0x01;
 	ui_C1 = inl(devpriv->iobase + APCI1564_COUNTER1 +
 		APCI1564_TCW_IRQ) & 0x1;
 	ui_C2 = inl(devpriv->iobase + APCI1564_COUNTER2 +
@@ -653,21 +643,15 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		if (devpriv->b_TimerSelectMode) {
 
 			/*  Disable Timer Interrupt */
-			ul_Command2 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			     APCI1564_TCW_PROG);
+			ul_Command2 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Timer Interrupt */
 
-			outl(ul_Command2,
-			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			     APCI1564_TCW_PROG);
+			outl(ul_Command2, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 		}
 	}
 
@@ -794,8 +778,8 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 	/* Disables the interrupt. */
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_RELOAD_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_REG);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 
 	outl(0x0, devpriv->iobase + APCI1564_COUNTER1 + APCI1564_TCW_PROG);
 	outl(0x0, devpriv->iobase + APCI1564_COUNTER2 + APCI1564_TCW_PROG);
-- 
1.8.5.3

