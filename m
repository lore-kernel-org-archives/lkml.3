Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaEVAkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:40:40 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59815 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEVAkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:40:39 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/2] staging: comedi: addi_apci_1564: move apci1564_di_insn_bits() to addi_apci_1564.c
Date: Wed, 21 May 2014 19:40:09 -0500
Message-Id: <1400719209-21452-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is already compliant with the comedi API and is behaving as
comedi core expects.  This patch moves it out of
addi-data/hwdrv_apci1564.c and into the driver proper since no further
work needs to be done on it.

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 12 ------------
 drivers/staging/comedi/drivers/addi_apci_1564.c           | 12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index b3c3f60..533d156 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -129,18 +129,6 @@ static int apci1564_di_config(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int apci1564_di_insn_bits(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn,
-				 unsigned int *data)
-{
-	struct addi_private *devpriv = dev->private;
-
-	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DI_REG);
-
-	return insn->n;
-}
-
 /*
  * Configures The Digital Output Subdevice.
  *
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index cbccbb6..fe477cc5 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -14,6 +14,18 @@ static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 	return IRQ_RETVAL(1);
 }
 
+static int apci1564_di_insn_bits(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn,
+				 unsigned int *data)
+{
+	struct addi_private *devpriv = dev->private;
+
+	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DI_REG);
+
+	return insn->n;
+}
+
 static int apci1564_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
-- 
1.9.0

