Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3EBLPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:15:25 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65129 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3EBLPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:15:23 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: paulz@synopsys.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] staging: dwc2: use devm_ioremap_resource()
Date: Thu,  2 May 2013 13:23:17 +0200
Message-Id: <1367493798-32354-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/staging/dwc2/pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dwc2/pci.c b/drivers/staging/dwc2/pci.c
index 69c65eb..407e021 100644
--- a/drivers/staging/dwc2/pci.c
+++ b/drivers/staging/dwc2/pci.c
@@ -134,9 +134,9 @@ static int dwc2_driver_probe(struct pci_dev *dev,
 	pci_set_power_state(dev, PCI_D0);
 
 	hsotg->dev = &dev->dev;
-	hsotg->regs = devm_request_and_ioremap(&dev->dev, &dev->resource[0]);
-	if (!hsotg->regs)
-		return -ENOMEM;
+	hsotg->regs = devm_ioremap_resource(&dev->dev, &dev->resource[0]);
+	if (IS_ERR(hsotg->regs))
+		return PTR_ERR(hsotg->regs);
 
 	dev_dbg(&dev->dev, "mapped PA %08lx to VA %p\n",
 		(unsigned long)pci_resource_start(dev, 0), hsotg->regs);
-- 
1.7.10.4

