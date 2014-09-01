Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaIADiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:38:52 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43396 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaIADit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:38:49 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 4/4] staging: comedi: hwdrv_apci1500: miscellaneous cleanup
Date: Sun, 31 Aug 2014 22:38:42 -0500
Message-Id: <ecfa1ef80108f8408f25e716cc4501319a5b8b02.1409542016.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409542016.git.chase.southwood@gmail.com>
References: <cover.1409542016.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch completes two final matters of cleanup which are each too small
for their own patch.  It corrects a couple of indentation issues and
removes a return statement at the end of a void function.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../staging/comedi/drivers/addi-data/hwdrv_apci1500.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index d98636b..e637be1 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -986,7 +986,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 
 	devpriv->tsk_Current = current;
 
-/* Selection of the input clock */
+	/* Selection of the input clock */
 	if (data[0] == 0 || data[0] == 1 || data[0] == 2) {
 		outw(data[0], devpriv->i_IobaseAddon + APCI1500_CLK_SELECT);
 	} else {
@@ -2180,7 +2180,6 @@ static void apci1500_interrupt(int irq, void *d)
 			"Interrupt from unknown source\n");
 
 	}
-	return;
 }
 
 static int apci1500_reset(struct comedi_device *dev)
@@ -2329,36 +2328,36 @@ static int apci1500_reset(struct comedi_device *dev)
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* reset all the digital outputs */
 	outw(0x0, devpriv->i_IobaseAddon + APCI1500_DIGITAL_OP);
-/* Disable the board interrupt */
+	/* Disable the board interrupt */
 	/* Selects the master interrupt control register */
 	outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/* Deactivates all interrupts */
+	/* Deactivates all interrupts */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port A */
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/* Deactivates all interrupts */
+	/* Deactivates all interrupts */
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port B */
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/* Deactivates all interrupts */
+	/* Deactivates all interrupts */
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of timer 1 */
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/* Deactivates all interrupts */
+	/* Deactivates all interrupts */
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of timer 2 */
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/* Deactivates all interrupts */
+	/* Deactivates all interrupts */
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/* Selects the command and status register of timer 3*/
+	/* Selects the command and status register of timer 3*/
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/* Deactivates all interrupts */
+	/* Deactivates all interrupts */
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	return 0;
 }
-- 
2.1.0

