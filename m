Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaCFH0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:26:32 -0500
Received: from nm18-vm4.bullet.mail.gq1.yahoo.com ([98.136.217.219]:38169 "EHLO
	nm18-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbaCFH0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:26:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=PVp8e/hCA60MRnL6jtMruvRX4WeoOLZD+CX4rerN04s/jr10TDYP3I7XQQ4I+7O1K2OU8Hg5bjA6bQyG+JNK6iq1M7yd/EgccjHAezwMZFup3qIK7+ShK5DyEmdCMhrbr48LAWNieqmIsnx/sJa7K3AJwdHPhlOXNrh7eGJruos=;
X-Yahoo-Newman-Id: 482108.6480.bm@smtp218.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3IfZxXEVM1nW_f7hnTduzGnpHfP3cjd1SYpM2vb4ZfPq0GI
 ntP5Gt7aYtYzFTgX4zuxOrblbJLA11oi3lhp6VVPxV3qkoAIXb92lG._tqPM
 CIWW5K6nDucFrAAtOMKf3QEjz7.vM4RnP3PAZDmNG2NwCl4MK1BbpHlMg7WD
 OBqLHNMmQ4ezdG5NPbZa9PZtVxecwYCtBDfjOki3tyi3Qi1ex0eQ3FuW5.04
 0yc8PzuSUZB8iOqjZPHOdRK0vwbYZT80trXPV0dh4gortZQxGYcFPu9ghnoe
 LGfIMjbguogTl4.NPu.7TR_LmICXcNCaKYcUa7a3hvo1jg2uNctENGl.KPF.
 .sw9bYtnXCkEsMM5QPd0uwcsgTc3ZZwcISsBsuPSObNUqEExNuG9wlu6iVAJ
 rdfHEaUp6AcUBkYsWaen6MEe8Z85mgCpBzixCDzJNqeqHFmxEWGu8fXHMkV5
 234f6GFFMkzJ87xEirYIETJVVpnV6R2iSAq4I1zE1iPpSS.P3.HNHCYplmMG
 EIQPttfyUfin2Nk34.HpS8Ej_dtBs3crZ81K6
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp218.mail.gq1.yahoo.com with SMTP; 06 Mar 2014 07:26:29 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 5/5] Staging: comedi: addi-data: tidy up counter register map defines in hwdrv_apci1564.c
Date: Thu,  6 Mar 2014 01:26:23 -0600
Message-Id: <1394090783-8030-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for hwdrv_apci1564.c fixes the register map defines for the
digital input registers such that they are all the real offsets to each
register, rather than a mix of real offsets and adders to those offsets.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 101 +++++++++------------
 1 file changed, 44 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 85e29b9..2519472 100644
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
 #define APCI1564_TIMER_WARN_TIMEVAL_REG	0x60
 #define APCI1564_TIMER_WARN_TIMEBASE_REG	0x64
 
+/*
+ * devpriv->iobase Register Map
+ */
+#define APCI1564_TCW_REG(x)				(0x00 + ((x) * 0x20))
+#define APCI1564_TCW_RELOAD_REG(x)			(0x04 + ((x) * 0x20))
+#define APCI1564_TCW_TIMEBASE_REG(x)			(0x08 + ((x) * 0x20))
+#define APCI1564_TCW_CTRL_REG(x)			(0x0c + ((x) * 0x20))
+#define APCI1564_TCW_STATUS_REG(x)			(0x10 + ((x) * 0x20))
+#define APCI1564_TCW_IRQ_REG(x)			(0x14 + ((x) * 0x20))
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
@@ -603,14 +602,14 @@ static void v_APCI1564_Interrupt(int irq, void *d)
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
@@ -661,19 +660,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
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
 
@@ -683,19 +679,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
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
 
@@ -705,19 +698,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
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
 
@@ -727,19 +717,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
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
@@ -781,9 +768,9 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
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

