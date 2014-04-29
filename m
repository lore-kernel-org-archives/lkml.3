Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbaD2Ift (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:35:49 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:59773 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007AbaD2Ifp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:35:45 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 4/6 v2] staging: comedi: addi_apci_1564: simplify the PCI bar reading and don't read the unused bars
Date: Tue, 29 Apr 2014 03:35:42 -0500
Message-Id: <1398760542-18886-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398562636-5900-1-git-send-email-chase.southwood@gmail.com>
References: <1398562636-5900-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver only uses PCI bar 1 (devpriv->i_IobaseAmcc), and PCI bar 2
(dev->iobase) doon't bother reading the unused PCI bars.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
2: Bad PCI bar numbers corrected.

 drivers/staging/comedi/drivers/addi_apci_1564.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index fe42f9d..7e42d47 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -65,15 +65,8 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	if (this_board->i_IorangeBase1)
-		dev->iobase = pci_resource_start(pcidev, 1);
-	else
-		dev->iobase = pci_resource_start(pcidev, 0);
-
-	devpriv->iobase = dev->iobase;
-	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);
-	devpriv->i_IobaseAddon = pci_resource_start(pcidev, 2);
-	devpriv->i_IobaseReserved = pci_resource_start(pcidev, 3);
+	dev->iobase = pci_resource_start(pcidev, 1);
+	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);
 
 	/* Initialize parameters that can be overridden in EEPROM */
 	devpriv->s_EeParameters.i_NbrAiChannel = this_board->i_NbrAiChannel;
-- 
1.9.0

