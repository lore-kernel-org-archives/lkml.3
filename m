Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaBSHhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:37:04 -0500
Received: from nm25-vm8.bullet.mail.gq1.yahoo.com ([98.136.217.119]:29506 "EHLO
	nm25-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaBSHhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:37:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=bMQ7wsOIXmfMOVpt8YZSefk6MK4nVCagybNNH0AOlA0j6PGJr/242PGakswx8GUtpcBwbwueZLa0Z7HpHgQ23TSt5qYJ09/Ei6QA1bRhPorE/h/B4qK5vf6v4UUuRRdB7OgnMHsnVUX4yv1vRBHA84r4FZ2yMf0z/AwnjLNdPOw=;
X-Yahoo-Newman-Id: 764104.55891.bm@smtp228.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: r_CQGv4VM1mDkKVnR2PiJ7oqzl26f5Buw5QIp.Q4ZKBboLU
 So99owcr4FWnjPzWFjHlWu_boypEflkmwjHRRch3X8Xq3wWIp4dMsGXTVQ1Q
 0G6vIzfJacnZeGBVrJAf4sqOPFumKHRyYJ3PqUKPem0Th7c7Z2sXoHV2k_J8
 5z_K2Ml4Vu7xQcc98Fl4CZsVS.XSYgN0.MNNfNy3AxqqcVTmFP_fliNRwK5L
 4HrxviKHjowdjCBDmwtWT0UWfeiiEm9FWCyPdMeNtXjVbqiI5zdQ_m0Lhil2
 boEy0WityJvzDlNX8n0rQo9y1AMZKWvPOi5rHuPQjrlVhBh6TKiqHRK.fDbC
 LTx2px8E6gR.hFGrkQx1r6o259FiVutWVYqINaDdH4JRnQwhxJx6sooL14RM
 rBKfLE2EcBzaataWsMlywmwjXNaKm59NSwXzgjGBsJWzbPMu8_B_LXPeBnuk
 fbWOGIlHdnl8vSlrXQEGzenCE.FWp9ymyRK1bgHQUh.zhyEFNn4bXjIqfO2S
 El9xLNnFW7GB8gFqsvdxmjZ5sPi.SUM3GTgfRTg--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp228.mail.gq1.yahoo.com with SMTP; 19 Feb 2014 07:37:00 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 1/4] Staging: comedi: addi-data: cleanup comments in hwdrv_apci1564.c
Date: Wed, 19 Feb 2014 01:36:46 -0600
Message-Id: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwdrv_apci1564.c had a lot of commented out conditional statements that
were often identical to other un-commented out statements nearby, so it
should be safe to just delete all of these commented out lines.  This
patch also converts the remaining comments to the preferred kernel style
for comments.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

Moving onto a new addi-data driver.  Generally mostly the same issues
though.

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 93 +++++++++-------------
 1 file changed, 38 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 8466854..ff556cc 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -138,9 +138,8 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 	struct addi_private *devpriv = dev->private;
 
 	devpriv->tsk_Current = current;
-   /*******************************/
+
 	/* Set the digital input logic */
-   /*******************************/
 	if (data[0] == ADDIDATA_ENABLE) {
 		data[2] = data[2] << 4;
 		data[3] = data[3] << 4;
@@ -154,13 +153,13 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 			outl(0x4,
 				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 				APCI1564_DIGITAL_IP_IRQ);
-		}		/*  if  (data[1] == ADDIDATA_OR) */
+		}
 		else {
 			outl(0x6,
 				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 				APCI1564_DIGITAL_IP_IRQ);
-		}		/*  else if  (data[1] == ADDIDATA_OR) */
-	}			/*  if  (data[0] == ADDIDATA_ENABLE) */
+		}
+	}
 	else {
 		outl(0x0,
 			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
@@ -171,7 +170,7 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 		outl(0x0,
 			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 			APCI1564_DIGITAL_IP_IRQ);
-	}			/*  else if  (data[0] == ADDIDATA_ENABLE) */
+	}
 
 	return insn->n;
 }
@@ -225,25 +224,25 @@ static int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev,
 		comedi_error(dev,
 			"Not a valid Data !!! ,Data should be 1 or 0\n");
 		return -EINVAL;
-	}			/*  if  ((data[0]!=0) && (data[0]!=1)) */
+	}
 	if (data[0]) {
 		devpriv->b_OutputMemoryStatus = ADDIDATA_ENABLE;
-	}			/*  if  (data[0]) */
+	}
 	else {
 		devpriv->b_OutputMemoryStatus = ADDIDATA_DISABLE;
-	}			/*  else if  (data[0]) */
+	}
 	if (data[1] == ADDIDATA_ENABLE) {
 		ul_Command = ul_Command | 0x1;
-	}			/*  if  (data[1] == ADDIDATA_ENABLE) */
+	}
 	else {
 		ul_Command = ul_Command & 0xFFFFFFFE;
-	}			/*  else if  (data[1] == ADDIDATA_ENABLE) */
+	}
 	if (data[2] == ADDIDATA_ENABLE) {
 		ul_Command = ul_Command | 0x2;
-	}			/*  if  (data[2] == ADDIDATA_ENABLE) */
+	}
 	else {
 		ul_Command = ul_Command & 0xFFFFFFFD;
-	}			/*  else if  (data[2] == ADDIDATA_ENABLE) */
+	}
 	outl(ul_Command,
 		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
 		APCI1564_DIGITAL_OP_INTERRUPT);
@@ -323,7 +322,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		outl(data[3],
 			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
 			APCI1564_TCW_RELOAD_VALUE);
-	}			/*  if  (data[0]==ADDIDATA_WATCHDOG) */
+	}
 	else if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
 		ul_Command1 =
@@ -357,13 +356,12 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			outl(0x0,
 				devpriv->iobase + APCI1564_COUNTER4 +
 				APCI1564_TCW_IRQ);
-		}		/*  if  (data[1]==1) */
+		}
 		else {
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* disable Timer interrupt */
-		}		/*  else if  (data[1]==1) */
+		}
 
 		/*  Loading Timebase */
-
 		outl(data[2],
 			devpriv->i_IobaseAmcc + APCI1564_TIMER +
 			APCI1564_TCW_TIMEBASE);
@@ -379,7 +377,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		ul_Command1 =
 			(ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
 		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* mode 2 */
-	}			/*  else if  (data[0]==ADDIDATA_TIMER) */
+	}
 	else if (data[0] == ADDIDATA_COUNTER) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
 		devpriv->b_ModeSelectRegister = data[5];
@@ -391,14 +389,11 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
 		outl(ul_Command1, devpriv->iobase + ((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);	/* Stop The Timer */
 
-      /************************/
 		/* Set the reload value */
-      /************************/
 		outl(data[3],
 			devpriv->iobase + ((data[5] - 1) * 0x20) +
 			APCI1564_TCW_RELOAD_VALUE);
 
-      /******************************/
 		/* Set the mode :             */
 		/* - Disable the hardware     */
 		/* - Disable the counter mode */
@@ -406,7 +401,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		/* - Disable the reset        */
 		/* - Disable the timer mode   */
 		/* - Enable the counter mode  */
-      /******************************/
+
 		ul_Command1 =
 			(ul_Command1 & 0xFFFC19E2UL) | 0x80000UL |
 			(unsigned int) ((unsigned int) data[4] << 16UL);
@@ -420,17 +415,15 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			devpriv->iobase + ((data[5] - 1) * 0x20) +
 			APCI1564_TCW_PROG);
 
-      /*****************************/
 		/* Set the Up/Down selection */
-      /*****************************/
 		ul_Command1 = (ul_Command1 & 0xFFFBF9FFUL) | (data[6] << 18);
 		outl(ul_Command1,
 			devpriv->iobase + ((data[5] - 1) * 0x20) +
 			APCI1564_TCW_PROG);
-	}			/*  else if  (data[0]==ADDIDATA_COUNTER) */
+	}
 	else {
 		printk(" Invalid subdevice.");
-	}			/*  else if  (data[0]==ADDIDATA_WATCHDOG) */
+	}
 
 	return insn->n;
 }
@@ -489,8 +482,8 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 		default:
 			printk("\nSpecified functionality does not exist\n");
 			return -EINVAL;
-		}		/*  switch (data[1]) */
-	}			/*  if  (devpriv->b_TimerSelectMode==ADDIDATA_WATCHDOG) */
+		}
+	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		if (data[1] == 1) {
 			ul_Command1 =
@@ -502,7 +495,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 			outl(ul_Command1,
 				devpriv->i_IobaseAmcc + APCI1564_TIMER +
 				APCI1564_TCW_PROG);
-		}		/*  if  (data[1]==1) */
+		}
 		else if (data[1] == 0) {
 			/* Stop The Timer */
 
@@ -513,8 +506,8 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 			outl(ul_Command1,
 				devpriv->i_IobaseAmcc + APCI1564_TIMER +
 				APCI1564_TCW_PROG);
-		}		/*  else if(data[1]==0) */
-	}			/*  if  (devpriv->b_TimerSelectMode==ADDIDATA_TIMER) */
+		}
+	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		ul_Command1 =
 			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
@@ -522,16 +515,16 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 		if (data[1] == 1) {
 			/* Start the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
-		}		/*  if  (data[1] == 1) */
+		}
 		else if (data[1] == 0) {
 			/*  Stops the Counter subdevice */
 			ul_Command1 = 0;
 
-		}		/*  else if  (data[1] == 0) */
+		}
 		else if (data[1] == 2) {
 			/*  Clears the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x400;
-		}		/*  else if  (data[1] == 3) */
+		}
 		outl(ul_Command1,
 			devpriv->iobase + ((devpriv->b_ModeSelectRegister -
 					1) * 0x20) + APCI1564_TCW_PROG);
@@ -577,7 +570,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 		data[1] =
 			inl(devpriv->i_IobaseAmcc +
 			APCI1564_DIGITAL_OP_WATCHDOG);
-	}			/*  if  (devpriv->b_TimerSelectMode==ADDIDATA_WATCHDOG) */
+	}
 	else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
 		data[0] =
@@ -586,7 +579,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 		/*  Stores the Actual value of the Timer */
 		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER);
-	}			/*  else if  (devpriv->b_TimerSelectMode==ADDIDATA_TIMER) */
+	}
 	else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		/*  Read the Counter Actual Value. */
 		data[0] =
@@ -597,31 +590,23 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
 					1) * 0x20) + APCI1564_TCW_TRIG_STATUS);
 
-      /***********************************/
 		/* Get the software trigger status */
-      /***********************************/
 		data[1] = (unsigned char) ((ul_Command1 >> 1) & 1);
 
-      /***********************************/
 		/* Get the hardware trigger status */
-      /***********************************/
 		data[2] = (unsigned char) ((ul_Command1 >> 2) & 1);
 
-      /*********************************/
 		/* Get the software clear status */
-      /*********************************/
 		data[3] = (unsigned char) ((ul_Command1 >> 3) & 1);
 
-      /***************************/
 		/* Get the overflow status */
-      /***************************/
 		data[4] = (unsigned char) ((ul_Command1 >> 0) & 1);
-	}			/*  else  if  (devpriv->b_TimerSelectMode==ADDIDATA_COUNTER) */
+	}
 	else if ((devpriv->b_TimerSelectMode != ADDIDATA_TIMER)
 		&& (devpriv->b_TimerSelectMode != ADDIDATA_WATCHDOG)
 		&& (devpriv->b_TimerSelectMode != ADDIDATA_COUNTER)) {
 		printk("\n Invalid Subdevice !!!\n");
-	}			/*  else if ((devpriv->b_TimerSelectMode!=ADDIDATA_TIMER) && (devpriv->b_TimerSelectMode!=ADDIDATA_WATCHDOG)&& (devpriv->b_TimerSelectMode!=ADDIDATA_COUNTER)) */
+	}
 	return insn->n;
 }
 
@@ -695,7 +680,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && ui_C1 == 0
 		&& ui_C2 == 0 && ui_C3 == 0 && ui_C4 == 0) {
 		printk("\nInterrupt from unknown source\n");
-	}			/*  if(ui_DI==0 && ui_DO==0 && ui_Timer==0 && ui_C1==0 && ui_C2==0 && ui_C3==0 && ui_C4==0) */
+	}
 
 	if (ui_DI == 1) {
 		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
@@ -724,8 +709,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 		/* Sends signal to user space */
 		send_sig(SIGIO, devpriv->tsk_Current, 0);
-
-	}			/*  if  (ui_DO) */
+	}
 
 	if (ui_Timer == 1) {
 		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
@@ -748,8 +732,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
 			     APCI1564_TCW_PROG);
 		}
-	}/* if  (ui_Timer == 1) */
-
+	}
 
 	if (ui_C1 == 1) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
@@ -771,7 +754,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 			     devpriv->iobase + APCI1564_COUNTER1 +
 			     APCI1564_TCW_PROG);
 		}
-	} /* if  (ui_C1 == 1) */
+	}
 
 	if (ui_C2 == 1) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
@@ -793,7 +776,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 			     devpriv->iobase + APCI1564_COUNTER2 +
 			     APCI1564_TCW_PROG);
 		}
-	} /*  if  ((ui_C2 == 1) */
+	}
 
 	if (ui_C3 == 1) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
@@ -815,7 +798,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 			     devpriv->iobase + APCI1564_COUNTER3 +
 			     APCI1564_TCW_PROG);
 		}
-	}	/*  if ((ui_C3 == 1) */
+	}
 
 	if (ui_C4 == 1) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
@@ -837,7 +820,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 			     devpriv->iobase + APCI1564_COUNTER4 +
 			     APCI1564_TCW_PROG);
 		}
-	}	/*  if (ui_C4 == 1) */
+	}
 	return;
 }
 
-- 
1.8.5.3

