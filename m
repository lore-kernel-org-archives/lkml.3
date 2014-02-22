Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaBVDUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 22:20:47 -0500
Received: from nm21-vm4.bullet.mail.gq1.yahoo.com ([98.136.217.51]:28198 "EHLO
	nm21-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbaBVDUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 22:20:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=Hhbrqns/kPO6MAV+yZG+QVk7mvVRV5ir8cfGz+6SzXoDOQD3/rhHqBmNmMHJnW3S8eK1qL7Yk/3cOrTFNCXTRahUv+EoUMDdDv43THzgH4fZppAHT62MpLw9yk8qPUlkpFHdVNdtxeKg2LEdWp6b+vbhF5RGjXw3meWiqMb1QPw=;
X-Yahoo-Newman-Id: 535350.13621.bm@smtp239.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: X414C_gVM1nm5tzjcwghAbwWiFdUFm6PoqWrRTjMTQ5OYC4
 QuXYrLdAz9uUDWIYsY6myeOsrmT5raTUS3zOx4AwCTj891OEsW4.JEn_qixz
 ledrf3N7vEf7ZEKBjbHjeaMpuSfmlWkqGDZLrmQso9.z5TEYEALR1rpVYj0Y
 TiXl5yA9lGP.Ww5b.VuJdYnk8tyGCxGlp0zbW86q3YVUbaywInX9aZMwVkhE
 ag_pS6q1DejRtIhzQqP4RNT59masM_GmwHgyR0dGbDgu2IrxSRiQCvDZFmmm
 cnydt74ldBrt6hyRcGexp.k1E1Jg3hvS1y9xAAd_VVHJzSffba9MnvINECxO
 T1q1E7h6QgeEdo_S2K2GAa9lPgnlvkbuWLxyrURHxwA3yn.J8qLK.uNqxzJC
 MdKFQPQYU43hIipmCyMIiX0G5ttGfKp4.rQDEkn0R5bDxgOpT8C0c0vrKlWk
 Mp4ArHkkNDnzJ900ohzV89yhtf4eL2ESCYLopmpZYtKEaqoTilwsJFFq4MK5
 AKiiMuJegoVd5UqRW7QNcfr3HiZDMRdqBxG4CkI9olGT6OUdJ
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@166.217.5.107 with plain [98.139.211.125])
        by smtp239.mail.gq1.yahoo.com with SMTP; 22 Feb 2014 03:20:45 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 1/3] Staging: comedi: addi-data: comment cleanup in hwdrv_apci035.c
Date: Fri, 21 Feb 2014 21:20:29 -0600
Message-Id: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch further cleans up the comments in hwdrv_apci035.c, converting
them to kernel style and removing some commented conditional statements
that are unused.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

I decided to return to the first driver I touched.  I found some more
things that could be cleaned up a little.

 .../comedi/drivers/addi-data/hwdrv_apci035.c       | 106 +++++++--------------
 1 file changed, 32 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 8ce3335..7c40535 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -188,17 +188,14 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	/************************/
+
 	/* Set the reload value */
-	/************************/
 	outl(data[3], devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 4);
-	/*********************/
+
 	/* Set the time unit */
-	/*********************/
 	outl(data[2], devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 8);
 	if (data[0] == ADDIDATA_TIMER) {
 
-		/******************************/
 		/* Set the mode :             */
 		/* - Disable the hardware     */
 		/* - Disable the counter mode */
@@ -206,23 +203,19 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 		/* - Disable the reset        */
 		/* - Enable the timer mode    */
 		/* - Set the timer mode       */
-		/******************************/
 
 		ui_Command =
 			(ui_Command & 0xFFF719E2UL) | ui_Mode << 13UL | 0x10UL;
 
-	}			/* if (data[0] == ADDIDATA_TIMER) */
-	else {
+	} else {
 		if (data[0] == ADDIDATA_WATCHDOG) {
 
-			/******************************/
 			/* Set the mode :             */
 			/* - Disable the hardware     */
 			/* - Disable the counter mode */
 			/* - Disable the warning      */
 			/* - Disable the reset        */
 			/* - Disable the timer mode   */
-			/******************************/
 
 			ui_Command = ui_Command & 0xFFF819E2UL;
 
@@ -234,73 +227,61 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	/********************************/
+
 	/* Disable the hardware trigger */
-	/********************************/
 	ui_Command = ui_Command & 0xFFFFF89FUL;
 	if (data[4] == ADDIDATA_ENABLE) {
-		/**********************************/
+
 		/* Set the hardware trigger level */
-		/**********************************/
 		ui_Command = ui_Command | (data[5] << 5);
 	}
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	/*****************************/
+
 	/* Disable the hardware gate */
-	/*****************************/
 	ui_Command = ui_Command & 0xFFFFF87FUL;
 	if (data[6] == ADDIDATA_ENABLE) {
-		/*******************************/
+
 		/* Set the hardware gate level */
-		/*******************************/
 		ui_Command = ui_Command | (data[7] << 7);
 	}
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	/*******************************/
+
 	/* Disable the hardware output */
-	/*******************************/
 	ui_Command = ui_Command & 0xFFFFF9FBUL;
-	/*********************************/
+
 	/* Set the hardware output level */
-	/*********************************/
 	ui_Command = ui_Command | (data[8] << 2);
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	if (data[9] == ADDIDATA_ENABLE) {
-		/************************/
+
 		/* Set the reload value */
-		/************************/
 		outl(data[11],
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 24);
-		/**********************/
+
 		/* Set the time unite */
-		/**********************/
 		outl(data[10],
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 28);
 	}
 
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	/*******************************/
+
 	/* Disable the hardware output */
-	/*******************************/
 	ui_Command = ui_Command & 0xFFFFF9F7UL;
-	/*********************************/
+
 	/* Set the hardware output level */
-	/*********************************/
 	ui_Command = ui_Command | (data[12] << 3);
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	/*************************************/
-	/**  Enable the watchdog interrupt  **/
-	/*************************************/
+
+	/* Enable the watchdog interrupt */
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	/*******************************/
+
 	/* Set the interrupt selection */
-	/*******************************/
 	ui_Status = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 16);
 
 	ui_Command = (ui_Command & 0xFFFFF9FDUL) | (data[13] << 1);
@@ -348,19 +329,17 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 	if (data[0] == 1) {
 		ui_Command =
 			inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-		/**********************/
+
 		/* Start the hardware */
-		/**********************/
 		ui_Command = (ui_Command & 0xFFFFF9FFUL) | 0x1UL;
 		outl(ui_Command,
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	}			/*  if  (data[0]==1) */
+	}
 	if (data[0] == 2) {
 		ui_Command =
 			inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-		/***************************/
+
 		/* Set the trigger command */
-		/***************************/
 		ui_Command = (ui_Command & 0xFFFFF9FFUL) | 0x200UL;
 		outl(ui_Command,
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
@@ -375,7 +354,7 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 		*/
 		outl(ui_Command,
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	}			/*   if (data[1]==0) */
+	}
 	if (data[0] == 3) {
 		/* stop all Watchdogs */
 		ui_Command = 0;
@@ -463,28 +442,19 @@ static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
 
 	i_WatchdogNbr = insn->unused[0];
 
-	/******************/
 	/* Get the status */
-	/******************/
-
 	ui_Status = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 16);
 
-	/***********************************/
 	/* Get the software trigger status */
-	/***********************************/
-
 	data[0] = ((ui_Status >> 1) & 1);
-	/***********************************/
+
 	/* Get the hardware trigger status */
-	/***********************************/
 	data[1] = ((ui_Status >> 2) & 1);
-	/*********************************/
+
 	/* Get the software clear status */
-	/*********************************/
 	data[2] = ((ui_Status >> 3) & 1);
-	/***************************/
+
 	/* Get the overflow status */
-	/***************************/
 	data[3] = ((ui_Status >> 0) & 1);
 	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER)
 		data[4] = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 0);
@@ -525,9 +495,8 @@ static int i_APCI035_ConfigAnalogInput(struct comedi_device *dev,
 	devpriv->tsk_Current = current;
 	outl(0x200 | 0, devpriv->iobase + 128 + 0x4);
 	outl(0, devpriv->iobase + 128 + 0);
-	/********************************/
+
 	/* Initialise the warning value */
-	/********************************/
 	outl(0x300 | 0, devpriv->iobase + 128 + 0x4);
 	outl((data[0] << 8), devpriv->iobase + 128 + 0);
 	outl(0x200000UL, devpriv->iobase + 128 + 12);
@@ -564,18 +533,13 @@ static int i_APCI035_ReadAnalogInput(struct comedi_device *dev,
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_CommandRegister = 0;
 
-	/******************/
 	/*  Set the start */
-	/******************/
 	ui_CommandRegister = 0x80000;
-	/******************************/
+
 	/* Write the command register */
-	/******************************/
 	outl(ui_CommandRegister, devpriv->iobase + 128 + 8);
 
-	/***************************************/
 	/* Read the digital value of the input */
-	/***************************************/
 	data[0] = inl(devpriv->iobase + 128 + 28);
 	return insn->n;
 }
@@ -640,40 +604,34 @@ static void v_APCI035_Interrupt(int irq, void *d)
 		i_WatchdogNbr = i_Flag;
 		i_Flag = i_Flag + 1;
 	}
-	/**************************************/
+
 	/* Read the interrupt status register of temperature Warning */
-	/**************************************/
 	ui_StatusRegister1 = inl(devpriv->iobase + 128 + 16);
-	/**************************************/
-	/* Read the interrupt status register for Watchdog/timer */
-	/**************************************/
 
+	/* Read the interrupt status register for Watchdog/timer */
 	ui_StatusRegister2 =
 		inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 20);
 
 	/* Test if warning relay interrupt */
 	if ((((ui_StatusRegister1) & 0x8) == 0x8)) {
-		/**********************************/
+
 		/* Disable the temperature warning */
-		/**********************************/
 		ui_ReadCommand = inl(devpriv->iobase + 128 + 12);
 		ui_ReadCommand = ui_ReadCommand & 0xFFDF0000UL;
 		outl(ui_ReadCommand, devpriv->iobase + 128 + 12);
-		/***************************/
+
 		/* Read the channel number */
-		/***************************/
 		ui_ChannelNumber = inl(devpriv->iobase + 128 + 60);
-		/**************************************/
+
 		/* Read the digital temperature value */
-		/**************************************/
 		ui_DigitalTemperature = inl(devpriv->iobase + 128 + 60);
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-	}			/* if (((ui_StatusRegister1 & 0x8) == 0x8)) */
+	}
 
 	else {
 		if ((ui_StatusRegister2 & 0x1) == 0x1)
 			send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-	}			/* else if (((ui_StatusRegister1 & 0x8) == 0x8)) */
+	}
 
 	return;
 }
-- 
1.8.5.3

