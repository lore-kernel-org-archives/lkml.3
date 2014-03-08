Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaCHAl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:41:58 -0500
Received: from nm9-vm1.bullet.mail.gq1.yahoo.com ([98.136.218.240]:45041 "EHLO
	nm9-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbaCHAlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:41:55 -0500
X-Yahoo-Newman-Id: 837850.69754.bm@smtp227.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: U1EgezoVM1lPXulNUudKYYcg8MF2umEmeMAEqz7WILHhjmV
 rhTSJ83f59hElQYgvsLaJpUtXqyj2jLFNvL.zMxdgI4FoItZJYb2StVKbk8e
 U0OWIdLiSnhXWp5b.z7WPY0FaSDMvoAvxHHAIMKwS0Dpj9Y4ZS1Nr.3nAkRb
 DfbPYt1cyz1B_6QfC3Wuqajdkck0EqnqJlgeviLWRAVjjUvjd0vYXYMjFz_Z
 efMDBzYrkHwikrssLeg7POQTmXsMhBuLoC12kDzC6Wh1A8mI4UEcPWiejP8m
 40xxoT2b2.fHsQQfK7VWP11yLL28sUWBBN4Z4KMIG7eDuwI9Tzt_RK06er1n
 3.FBKhL7Swa8R6.UaLV3aRGEZjLU15m1EKdqX.O2.DLy8f5He5htIdl0LOq3
 Kampx.2N5ppsRaX37TzkpsE9qVtv0KohK5HD_2gJXFYKFbZbQqwTHBIHQOBl
 iiokutCW.7C.33S7ACcq26blX8uqUwhblyZbpJEd.QwN1qXZys7.sVpdxKik
 fxFLg8.sMvWo1Nu_oUY0tQdshgGCdRtx5gUKw
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp227.mail.gq1.yahoo.com with SMTP; 08 Mar 2014 00:41:54 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v3 2/5] Staging: comedi: addi-data: tidy up digital output register map defines in hwdrv_apci1564.c
Date: Fri,  7 Mar 2014 18:41:48 -0600
Message-Id: <1394239308-25930-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the register map defines for the digital output registers
such that they are all the real offsets to each register, rather than a
mix of real offsets and adders to those offsets.

Further, some of the old defines were being used incorrectly in the
i_APCI1564_Reset() function.  Upon swapping the old defines out for the
new ones in this function, their use has been corrected.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Simplified commit message, fixed indentation and whitespace damage.
I have test applied this patch, it should work now.

3: Fixed indentation (again)

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 50 +++++++---------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 2c2bbd8..d493d01 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -46,21 +46,10 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 
 #define APCI1564_ADDRESS_RANGE				128
 
-/* DIGITAL INPUT-OUTPUT DEFINE */
-
-/* Output defines */
-#define APCI1564_DIGITAL_OP				0x18
-#define APCI1564_DIGITAL_OP_RW				0
-#define APCI1564_DIGITAL_OP_INTERRUPT			4
-#define APCI1564_DIGITAL_OP_IRQ				12
-
 /* Digital Input IRQ Function Selection */
 #define ADDIDATA_OR					0
 #define ADDIDATA_AND					1
 
-/* Digital Output Interrupt Status */
-#define APCI1564_DIGITAL_OP_INTERRUPT_STATUS		8
-
 /* Digital Input Interrupt Enable Disable. */
 #define APCI1564_DIGITAL_IP_INTERRUPT_ENABLE		0x4
 #define APCI1564_DIGITAL_IP_INTERRUPT_DISABLE		0xfffffffb
@@ -99,6 +88,10 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_DI_INT_MODE2_REG			0x0c
 #define APCI1564_DI_INT_STATUS_REG			0x10
 #define APCI1564_DI_IRQ_REG				0x14
+#define APCI1564_DO_REG					0x18
+#define APCI1564_DO_INT_CTRL_REG			0x1c
+#define APCI1564_DO_INT_STATUS_REG			0x20
+#define APCI1564_DO_IRQ_REG				0x24
 
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
@@ -226,12 +219,8 @@ static int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev,
 	else
 		ul_Command = ul_Command & 0xFFFFFFFD;
 
-	outl(ul_Command,
-		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_INTERRUPT);
-	ui_InterruptData =
-		inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_INTERRUPT);
+	outl(ul_Command, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
+	ui_InterruptData = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
 	devpriv->tsk_Current = current;
 	return insn->n;
 }
@@ -243,12 +232,10 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 
-	s->state = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_RW);
+	s->state = inl(devpriv->i_IobaseAmcc + APCI1564_DO_REG);
 
 	if (comedi_dio_update_state(s, data))
-		outl(s->state, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_RW);
+		outl(s->state, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
 
 	data[1] = s->state;
 
@@ -317,9 +304,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		if (data[1] == 1) {
 			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-			outl(0x0,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-				APCI1564_DIGITAL_OP_IRQ);
+			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG);
 			outl(0x0,
 				devpriv->i_IobaseAmcc +
 				APCI1564_DIGITAL_OP_WATCHDOG +
@@ -634,8 +619,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	unsigned int ul_Command2 = 0;
 
 	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG) & 0x01;
-	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_IRQ) & 0x01;
+	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG) & 0x01;
 	ui_Timer =
 		inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
 		APCI1564_TCW_IRQ) & 0x01;
@@ -666,13 +650,9 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 	if (ui_DO == 1) {
 		/*  Check for Digital Output interrupt Type - 1: Vcc interrupt 2: CC interrupt. */
-		ui_Type =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_INTERRUPT_STATUS) & 0x3;
+		ui_Type = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_STATUS_REG) & 0x3;
 		/* Disable the  Interrupt */
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_INTERRUPT);
+		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
 
 		/* Sends signal to user space */
 		send_sig(SIGIO, devpriv->tsk_Current, 0);
@@ -819,8 +799,10 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
 	devpriv->b_DigitalOutputRegister = 0;
 	ui_Type = 0;
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP);	/* Resets the output channels */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_INTERRUPT);	/* Disables the interrupt. */
+	/* Resets the output channels */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
+	/* Disables the interrupt. */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
 	outl(0x0,
 		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
 		APCI1564_TCW_RELOAD_VALUE);
-- 
1.8.5.3

