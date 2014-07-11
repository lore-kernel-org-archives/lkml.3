Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaGKEDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:03:06 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54369 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaGKEDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:03:05 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/4] staging: comedi: addi_apci_1564: remove null check of devpriv in apci1564_detach()
Date: Thu, 10 Jul 2014 23:02:27 -0500
Message-Id: <ac33ad4ded5ce641af0fabd22d5029c3d08ef4a1.1405050794.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405050794.git.chase.southwood@gmail.com>
References: <cover.1405050794.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to test whether devpriv is null in this function.  The
check looks left over and we can just remove it.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index e3dcab7..f91aedd 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -433,14 +433,10 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 static void apci1564_detach(struct comedi_device *dev)
 {
-	struct apci1564_private *devpriv = dev->private;
-
-	if (devpriv) {
-		if (dev->iobase)
-			apci1564_reset(dev);
-		if (dev->irq)
-			free_irq(dev->irq, dev);
-	}
+	if (dev->iobase)
+		apci1564_reset(dev);
+	if (dev->irq)
+		free_irq(dev->irq, dev);
 	comedi_pci_disable(dev);
 }
 
-- 
2.0.1

