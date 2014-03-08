Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaCHAlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:41:44 -0500
Received: from nm14-vm2.bullet.mail.gq1.yahoo.com ([98.136.218.253]:40371 "EHLO
	nm14-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbaCHAln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:41:43 -0500
X-Yahoo-Newman-Id: 358250.63721.bm@smtp201.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: x96.rnUVM1l1M71GZj1FvPo97uG7bkiGqDJyJYH_bLGez1x
 yb6mv12WxxvnHfcHKjfL.g3fzO.l3mgz54bMBHRe8y1fvoag8rcx0CQL.lDk
 .GAJfCeeIRS7JMKS3yhb1jIiwPHAnPFm04g3jvB9JoE1gpo70mJ2F9OeBl3i
 pRgPJKBjNKc77AvN3itS9L35hVMRVvkDTDW3wB2muaUWq.v7a3mhfrgo7gss
 UBc1f1XiMIuNXIi6efbSzozg8A6g0OgyEjD.rqQ0mtinQE9yoGnpjouD8a0R
 mBQAsCN6BKIRa4fTxskgccPi2pZOt8IRB.54b6DXAU8OeF6eATVp4zuyGUvP
 7y3pn7AFH886g8G.4c7Sw7k9oqTBABlEDxGV6A_TrM9T4LrUbWAwE._Pn_BJ
 Pjsigf.urXjpFMfTN_tGos.fR6.uJnidlMvTNxs7EDL9CXn9kMMiDNcLKS3q
 XnMhAjcTlXnQ24mpbsuBLZepSoc1fVvsOZJV_K3lsQ4ITHLrVzsu5JivB3sO
 8VqNBQLv4hPxhLmcTiJ_xFK1QYd62m1dMKvjb
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp201.mail.gq1.yahoo.com with SMTP; 08 Mar 2014 00:41:42 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v3 1/5] Staging: comedi: addi-data: tidy up digital input register map defines in hwdrv_apci1564.c
Date: Fri,  7 Mar 2014 18:41:37 -0600
Message-Id: <1394239297-25885-1-git-send-email-chase.southwood@yahoo.com>
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

3: Fixed indentation (again)

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
+#define APCI1564_DI_REG					0x04
+#define APCI1564_DI_INT_MODE1_REG			0x08
+#define APCI1564_DI_INT_MODE2_REG			0x0c
+#define APCI1564_DI_INT_STATUS_REG			0x10
+#define APCI1564_DI_IRQ_REG				0x14
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

