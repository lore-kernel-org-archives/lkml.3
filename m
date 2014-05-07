Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaEGHEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:04:32 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60584 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbaEGHEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:04:31 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/2] staging: comedi: addi_apci_1564: remove boardinfo
Date: Wed,  7 May 2014 02:04:17 -0500
Message-Id: <1399446257-30707-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
References: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver only supports a single board type.  Remove the boardinfo and
its use in the driver.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index d7a5c2f..cbccbb6 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -8,16 +8,6 @@
 
 #include "addi-data/hwdrv_apci1564.c"
 
-static const struct addi_board apci1564_boardtypes[] = {
-	{
-		.pc_DriverName		= "apci1564",
-		.i_NbrDiChannel		= 32,
-		.i_NbrDoChannel		= 32,
-		.i_DoMaxdata		= 0xffffffff,
-		.i_Timer		= 1,
-	},
-};
-
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	apci1564_interrupt(irq, d);
@@ -60,12 +50,11 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 				      unsigned long context_unused)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	const struct addi_board *this_board = comedi_board(dev);
 	struct addi_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
-	dev->board_name = this_board->pc_DriverName;
+	dev->board_name = dev->driver->driver_name;
 
 	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
 	if (!devpriv)
-- 
1.9.0

