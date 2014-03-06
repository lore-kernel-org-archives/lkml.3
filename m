Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaCFH0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:26:17 -0500
Received: from nm30-vm1.bullet.mail.gq1.yahoo.com ([98.136.216.192]:24677 "EHLO
	nm30-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbaCFH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:26:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=fQrPfwfgimplfXCHarAABBuCknhLW5NsoBpxoqSx/Wm/TwLIQIkoq4bWVMmOoXTLUk8YVWjQOHpGpsSay7Q06nM3L3sfonkH91Ly3gRekTIkvothXAEFudgGyuBKiNMEiyuA+Zk5KodNtv3nkjJOxjDTOzcNRiVEfR1+Sg6Nb2s=;
X-Yahoo-Newman-Id: 682478.3720.bm@smtp221.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Hz0cCdYVM1lTQuCJQGH5v_zQm0mXB3Ax698mrn.hH6nZR_a
 V7W4lpK2LhvZwFPe_oVSGJATt6QhIL_wA1Sh0T6mKM7BCnGFsJfpgL0ANB4o
 4P6KqLKttFcGVf1NXdYbX4.GgnNESN2ZBzexL3WNcWNSv2PstxQnND3X03Ba
 2j6shKMN6MWvv1X1oQ9f9A771g0hfTxe1etT_6Xwf92BmxgKxsGgoCdssB6C
 ClyW3FmwK4KhfmT1mK2FJsQ0maJq.iYY35_b9qazJ_et4zlusyHo46BSnAvf
 9oBUuUAx1nChJgKhqOn9VbpsRvfwMaDZCGGiEgEmbw_VRtzn8uR_8TaEz5y8
 ThMfFsu8WkL52hUL29TVVdemtlIO1Xk9icC.2tQkolRNZVSsMkxvOcIhYOD_
 RUu74Cti3LWvEikcRiZT8EHa7E3NFQfsdrTyvb.ghAxxa.Ax9R3x9vjc1ELv
 dWiVyfEaClhM8a0Y9JpjX272HftU2KDUzejtEAak5zYn76mOBlgNT6cj_CSd
 fqh5BsYrFkq5Jl3XvgbOw12v4qmTTEq4.p3._
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp221.mail.gq1.yahoo.com with SMTP; 06 Mar 2014 07:26:15 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 4/5] Staging: comedi: addi-data: tidy up timer register map defines in hwdrv_apci1564.c
Date: Thu,  6 Mar 2014 01:26:11 -0600
Message-Id: <1394090771-7985-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for hwdrv_apci1564.c fixes the register map defines for the
timer registers such that they are all the real offsets to each register,
rather than a mix of real offsets and adders to those offsets.
Additionally, the defines have been renamed to assist with shortening
some lines in excess of 80 characters.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 82 +++++++++-------------
 1 file changed, 33 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 91ca091..85e29b9 100644
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
 #define APCI1564_WDOG_IRQ_REG			0x3c
 #define APCI1564_WDOG_WARN_TIMEVAL_REG	0x40
 #define APCI1564_WDOG_WARN_TIMEBASE_REG	0x44
+#define APCI1564_TIMER_REG				0x48
+#define APCI1564_TIMER_RELOAD_REG			0x4c
+#define APCI1564_TIMER_TIMEBASE_REG			0x50
+#define APCI1564_TIMER_CTRL_REG			0x54
+#define APCI1564_TIMER_STATUS_REG			0x58
+#define APCI1564_TIMER_IRQ_REG				0x5c
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

