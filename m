Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaCGIhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:37:12 -0500
Received: from nm24-vm4.bullet.mail.gq1.yahoo.com ([98.136.217.99]:25631 "EHLO
	nm24-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaCGIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:37:10 -0500
X-Yahoo-Newman-Id: 752577.73597.bm@smtp212.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zfSMdUIVM1nz8FI9b9O00f5TMBGOHb4ovWZ.CogbSk9CrT2
 dMZENkSjNMMQ0jItx38Hnv_ALwRsus1lUXXt5qcs.g8_0OsqMLEjaZlYvOKj
 H1jM_.olI9ryr.1u508uPNxv6w8IflUdy.Wcn0Hba1xfXiXjLZ.LcJ0m0nDv
 uIwh4DWWptAQXZbtvbPXc9CI9dgbs6ai1umV64lLeJgCjynoqLutw88HdryF
 PIp4mzr6OEHm92VDLbg3b.roMw_vXV1cks0P5eaAih0coj9vqgxke2Q7RlAY
 8i4SqTVkIeio4WHMTYskDinNHAsfiE6A1A6NQCIchilIorRdOC_yi9OYhS2W
 5H29kbQndOsEJyO1urEAN0O0ugRKfvcnw8J97YWpF8UhIMMi97owbfjfLrDi
 OqdfUHSR187WQG.uuBUNt_Ni_dadLoxLF9c5HK.NiDuacA9cXns7D6nDtiCG
 YdDMRQ6fDqGhqEq.TMl4hmVLa99TfsTKXiBH8o8lxXEn_lsd2J9BFPeCnUlr
 bhYGB4jWfi2mkIydW9AF3MNIDGhcfzBRuG75L
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp212.mail.gq1.yahoo.com with SMTP; 07 Mar 2014 00:37:09 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2 1/5] Staging: comedi: addi-data: tidy up digital input register map defines in hwdrv_apci1564.c
Date: Fri,  7 Mar 2014 02:37:05 -0600
Message-Id: <1394181425-16973-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the register map defines for the digital input registers
such that they are all the real offsets to each register, rather than a
mix of real offsets and adders to those offsets.

Further, some of the old defines were being used incorrectly in the
i_APCI1564_Reset() function.  Upon swapping the old defines out for the
new ones in this function, their use has been corrected.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Simplified commit message, fixed indentation.

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 78 +++++++++-------------
 1 file changed, 31 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 2b47fa1..2c2bbd8 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -47,11 +47,6 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_ADDRESS_RANGE				128
 
 /* DIGITAL INPUT-OUTPUT DEFINE */
-/* Input defines */
-#define APCI1564_DIGITAL_IP				0x04
-#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1		4
-#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2		8
-#define APCI1564_DIGITAL_IP_IRQ				16
 
 /* Output defines */
 #define APCI1564_DIGITAL_OP				0x18
@@ -63,9 +58,6 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define ADDIDATA_OR					0
 #define ADDIDATA_AND					1
 
-/* Digital Input Interrupt Status */
-#define APCI1564_DIGITAL_IP_INTERRUPT_STATUS		12
-
 /* Digital Output Interrupt Status */
 #define APCI1564_DIGITAL_OP_INTERRUPT_STATUS		8
 
@@ -99,6 +91,15 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_TCW_WARN_TIMEVAL			24
 #define APCI1564_TCW_WARN_TIMEBASE			28
 
+/*
+ * devpriv->i_IobaseAmcc Register Map
+ */
+#define APCI1564_DI_REG						0x04
+#define APCI1564_DI_INT_MODE1_REG				0x08
+#define APCI1564_DI_INT_MODE2_REG				0x0c
+#define APCI1564_DI_INT_STATUS_REG				0x10
+#define APCI1564_DI_IRQ_REG					0x14
+
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
@@ -143,31 +144,17 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 	if (data[0] == ADDIDATA_ENABLE) {
 		data[2] = data[2] << 4;
 		data[3] = data[3] << 4;
-		outl(data[2],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+		outl(data[2], devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
+		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
 		if (data[1] == ADDIDATA_OR) {
-			outl(0x4,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
+			outl(0x4, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 		} else {
-			outl(0x6,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
+			outl(0x6, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
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
+		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
+		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
+		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 	}
 
 	return insn->n;
@@ -180,7 +167,7 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 
-	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP);
+	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DI_REG);
 
 	return insn->n;
 }
@@ -329,9 +316,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
 		if (data[1] == 1) {
 			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
-			outl(0x0,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 			outl(0x0,
 				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
 				APCI1564_DIGITAL_OP_IRQ);
@@ -648,8 +633,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
 	unsigned int ul_Command2 = 0;
 
-	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-		APCI1564_DIGITAL_IP_IRQ) & 0x01;
+	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG) & 0x01;
 	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
 		APCI1564_DIGITAL_OP_IRQ) & 0x01;
 	ui_Timer =
@@ -669,17 +653,14 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	}
 
 	if (ui_DI == 1) {
-		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
+		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 		ui_InterruptStatus_1564 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
+			inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
 		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + APCI1564_DIGITAL_IP_IRQ);	/* enable the interrupt */
+		/* enable the interrupt */
+		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 		return;
 	}
 
@@ -829,10 +810,13 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_IRQ);	/* disable the interrupts */
-	inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_STATUS);	/* Reset the interrupt status register */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);	/* Disable the and/or interrupt */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+	/* disable the interrupts */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+	/* Reset the interrupt status register */
+	inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
+	/* Disable the and/or interrupt */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
 	devpriv->b_DigitalOutputRegister = 0;
 	ui_Type = 0;
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP);	/* Resets the output channels */
-- 
1.8.5.3

