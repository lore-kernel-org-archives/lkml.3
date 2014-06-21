Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaFUWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 18:25:57 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35784 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaFUWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 18:25:56 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v3 2/5] staging: comedi: addi_apci_1564: remove unused static variables
Date: Sat, 21 Jun 2014 17:25:17 -0500
Message-Id: <1403389517-20162-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403389429-19793-1-git-send-email-chase.southwood@gmail.com>
References: <1403389429-19793-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global variables ui_InterruptStatus_1564 and ui_InterruptData are both
set but never used.  Just remove them from the driver.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 19de400..95038f2 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -90,8 +90,7 @@
 #define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
 
 /* Global variables */
-static unsigned int ui_InterruptStatus_1564;
-static unsigned int ui_InterruptData, ui_Type;
+static unsigned int ui_Type;
 
 /*
  * Configures the digital input Subdevice
@@ -160,7 +159,6 @@ static int apci1564_do_config(struct comedi_device *dev,
 		ul_Command = ul_Command & 0xFFFFFFFD;
 
 	outl(ul_Command, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
-	ui_InterruptData = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
 	devpriv->tsk_Current = current;
 	return insn->n;
 }
@@ -428,9 +426,6 @@ static void apci1564_interrupt(int irq, void *d)
 	if (ui_DI == 1) {
 		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-		ui_InterruptStatus_1564 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
-		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
 		/* send signal to the sample */
 		send_sig(SIGIO, devpriv->tsk_Current, 0);
 		/* enable the interrupt */
-- 
1.9.3

