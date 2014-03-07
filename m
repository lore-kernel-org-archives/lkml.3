Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaCGIiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:38:08 -0500
Received: from nm15-vm3.bullet.mail.gq1.yahoo.com ([98.137.176.75]:42606 "EHLO
	nm15-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbaCGIiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:38:03 -0500
X-Yahoo-Newman-Id: 589926.53375.bm@smtp239.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: y7Dt3RAVM1knD8R7ONdo_AWw_9VofAPpKIsafc_PgGRNiPF
 9yjOoFqj1VFvKC6B283975P.DuVBpQ.hDOnFRcPVmo3Pwqq_oBSb2Cwgp_zd
 BuHP9Xb7WSKH8hka4FwdEcs21GVMty96a93getVhARG3T_OV2doCPO7pFp9d
 nCNiK1d07x8heKq85l7Z0qt39Wdu2hifi5s_wmujXiN.1cX0k9QbAxVhVGou
 3Q0m2R21OseI9hL.QpC_XfQn7TqaM3x63H7wKDapAKTFK3f.1TY2mDTArDNv
 Du7dYpLRU6WlhS5rfrdrWQGjXI88NXqDhUlUl0RkPHnFXbeSTrzM9V4.O3LW
 WkicAvIL_0_qDTP.PwAcbQd6nF_gaO8drsn6dteid.MKYa__lIH61aW9.vXC
 t4SmxepWrhDxsXqsZmsvwZn3z40BQR8liYEKmODSPm9qoCEh.Ik42Hcz6cL6
 orQAyUrfBm5jHVg9F3FAZuB76v4Sr4iY_hk9UWpeWACHTM7pX3YxtxWPAX7S
 ghN7btU9c1mfwFyBpISNrljPQCncgbv_90W7Bsw--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp239.mail.gq1.yahoo.com with SMTP; 07 Mar 2014 08:38:01 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2 5/5] Staging: comedi: addi-data: tidy up counter register map defines in hwdrv_apci1564.c
Date: Fri,  7 Mar 2014 02:37:56 -0600
Message-Id: <1394181476-17153-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the register map defines for the counter registers such
that they are all the real offsets to each register, rather than a mix of
real offsets and adders to those offsets.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Simplified commit message, fixed indentation and whitespace damage.
I have test applied this patch, it should work now.
v2 also fixes several build breakages, and I have compile tested as well.
Everything should be fixed.

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 143 +++++++++------------
 1 file changed, 60 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 2a3523f..e2d3433 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -61,22 +61,13 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_DIGITAL_OP_CC_INTERRUPT_DISABLE	0xfffffffd
 
 /* TIMER COUNTER WATCHDOG DEFINES */
-
 #define ADDIDATA_TIMER					0
 #define ADDIDATA_COUNTER				1
 #define ADDIDATA_WATCHDOG				2
-#define APCI1564_COUNTER1				0x0
-#define APCI1564_COUNTER2				0x20
-#define APCI1564_COUNTER3				0x40
-#define APCI1564_COUNTER4				0x60
-#define APCI1564_TCW_SYNC_ENABLEDISABLE			0
-#define APCI1564_TCW_RELOAD_VALUE			4
-#define APCI1564_TCW_TIMEBASE				8
-#define APCI1564_TCW_PROG				12
-#define APCI1564_TCW_TRIG_STATUS			16
-#define APCI1564_TCW_IRQ				20
-#define APCI1564_TCW_WARN_TIMEVAL			24
-#define APCI1564_TCW_WARN_TIMEBASE			28
+#define APCI1564_COUNTER1				0
+#define APCI1564_COUNTER2				1
+#define APCI1564_COUNTER3				2
+#define APCI1564_COUNTER4				3
 
 /*
  * devpriv->i_IobaseAmcc Register Map
@@ -107,6 +98,18 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_TIMER_WARN_TIMEVAL_REG		0x60
 #define APCI1564_TIMER_WARN_TIMEBASE_REG		0x64
 
+/*
+ * devpriv->iobase Register Map
+ */
+#define APCI1564_TCW_REG(x)					(0x00 + ((x) * 0x20))
+#define APCI1564_TCW_RELOAD_REG(x)				(0x04 + ((x) * 0x20))
+#define APCI1564_TCW_TIMEBASE_REG(x)			(0x08 + ((x) * 0x20))
+#define APCI1564_TCW_CTRL_REG(x)				(0x0c + ((x) * 0x20))
+#define APCI1564_TCW_STATUS_REG(x)				(0x10 + ((x) * 0x20))
+#define APCI1564_TCW_IRQ_REG(x)				(0x14 + ((x) * 0x20))
+#define APCI1564_TCW_WARN_TIMEVAL_REG(x)		(0x18 + ((x) * 0x20))
+#define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
+
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
@@ -317,17 +320,13 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG);
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_IRQ_REG);
 			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER1 +
-				APCI1564_TCW_IRQ);
+				devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1));
 			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER2 +
-				APCI1564_TCW_IRQ);
+				devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER2));
 			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER3 +
-				APCI1564_TCW_IRQ);
+				devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER3));
 			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER4 +
-				APCI1564_TCW_IRQ);
+				devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER4));
 		} else {
 			/* disable Timer interrupt */
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
@@ -348,16 +347,13 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		devpriv->b_ModeSelectRegister = data[5];
 
 		/* First Stop The Counter */
-		ul_Command1 =
-			inl(devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		ul_Command1 = inl(devpriv->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->iobase + ((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl(ul_Command1, devpriv->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
 
 		/* Set the reload value */
-		outl(data[3],
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl(data[3], devpriv->iobase + APCI1564_TCW_RELOAD_REG(data[5] - 1));
 
 		/* Set the mode :             */
 		/* - Disable the hardware     */
@@ -370,21 +366,15 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		ul_Command1 =
 			(ul_Command1 & 0xFFFC19E2UL) | 0x80000UL |
 			(unsigned int) ((unsigned int) data[4] << 16UL);
-		outl(ul_Command1,
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		outl(ul_Command1, devpriv->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
 
 		/*  Enable or Disable Interrupt */
 		ul_Command1 = (ul_Command1 & 0xFFFFF9FD) | (data[1] << 1);
-		outl(ul_Command1,
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		outl(ul_Command1, devpriv->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
 
 		/* Set the Up/Down selection */
 		ul_Command1 = (ul_Command1 & 0xFFFBF9FFUL) | (data[6] << 18);
-		outl(ul_Command1,
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		outl(ul_Command1, devpriv->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
 	} else {
 		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
@@ -460,8 +450,8 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		ul_Command1 =
-			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) + APCI1564_TCW_PROG);
+			inl(devpriv->iobase +
+				APCI1564_TCW_CTRL_REG(devpriv->b_ModeSelectRegister - 1));
 		if (data[1] == 1) {
 			/* Start the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
@@ -474,9 +464,9 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x400;
 		}
 		outl(ul_Command1,
-			devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) + APCI1564_TCW_PROG);
-	}			/*  if (devpriv->b_TimerSelectMode==ADDIDATA_COUNTER) */
+			devpriv->iobase +
+			APCI1564_TCW_CTRL_REG(devpriv->b_ModeSelectRegister - 1));
+	}
 	return insn->n;
 }
 
@@ -522,12 +512,11 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		/*  Read the Counter Actual Value. */
 		data[0] =
-			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) +
-			APCI1564_TCW_SYNC_ENABLEDISABLE);
+			inl(devpriv->iobase +
+				APCI1564_TCW_REG(devpriv->b_ModeSelectRegister - 1));
 		ul_Command1 =
-			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) + APCI1564_TCW_TRIG_STATUS);
+			inl(devpriv->iobase +
+				APCI1564_TCW_STATUS_REG(devpriv->b_ModeSelectRegister - 1));
 
 		/* Get the software trigger status */
 		data[1] = (unsigned char) ((ul_Command1 >> 1) & 1);
@@ -603,14 +592,14 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG) & 0x01;
 	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG) & 0x01;
 	ui_Timer = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_IRQ_REG) & 0x01;
-	ui_C1 = inl(devpriv->iobase + APCI1564_COUNTER1 +
-		APCI1564_TCW_IRQ) & 0x1;
-	ui_C2 = inl(devpriv->iobase + APCI1564_COUNTER2 +
-		APCI1564_TCW_IRQ) & 0x1;
-	ui_C3 = inl(devpriv->iobase + APCI1564_COUNTER3 +
-		APCI1564_TCW_IRQ) & 0x1;
-	ui_C4 = inl(devpriv->iobase + APCI1564_COUNTER4 +
-		APCI1564_TCW_IRQ) & 0x1;
+	ui_C1 =
+		inl(devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1)) & 0x1;
+	ui_C2 =
+		inl(devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER2)) & 0x1;
+	ui_C3 =
+		inl(devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER3)) & 0x1;
+	ui_C4 =
+		inl(devpriv->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER4)) & 0x1;
 	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && ui_C1 == 0
 		&& ui_C2 == 0 && ui_C3 == 0 && ui_C4 == 0) {
 		dev_err(dev->class_dev, "Interrupt from unknown source.\n");
@@ -661,19 +650,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER1 +
-				    APCI1564_TCW_PROG);
+				inl(devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
 			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER1 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER1 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
 		}
 	}
 
@@ -683,19 +669,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER2 +
-				    APCI1564_TCW_PROG);
+				inl(devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
 			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER2 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER2 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
 		}
 	}
 
@@ -705,19 +688,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER3 +
-				    APCI1564_TCW_PROG);
+				inl(devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
 			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER3 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER3 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
 		}
 	}
 
@@ -727,19 +707,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER4 +
-				    APCI1564_TCW_PROG);
+				inl(devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
 			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER4 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER4 +
-			     APCI1564_TCW_PROG);
+			     devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
 		}
 	}
 	return;
@@ -781,9 +758,9 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_REG);
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER1 + APCI1564_TCW_PROG);
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER2 + APCI1564_TCW_PROG);
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER3 + APCI1564_TCW_PROG);
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER4 + APCI1564_TCW_PROG);
+	outl(0x0, devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
+	outl(0x0, devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
+	outl(0x0, devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+	outl(0x0, devpriv->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
 	return 0;
 }
-- 
1.8.5.3

