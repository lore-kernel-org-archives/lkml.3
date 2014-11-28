Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaK1Nz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:55:59 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37138 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaK1NvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:10 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/17] net2280: Remove module parameter use_msi
Date: Fri, 28 Nov 2014 14:50:48 +0100
Message-Id: <1417182662-7405-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parameter use_msi was used to enable msi irq on usb338x chips, it was
enabled by default.

There is no reason to prefer non-msi irq on usb338x, and it falls back
to non msi on error.

Therefore remove this option.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 27b94c6..fc5c0a2 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -88,11 +88,9 @@ static const char *const ep_name[] = {
  * These two parameters let you use PIO or more aggressive DMA.
  */
 static bool use_dma = true;
-static bool use_msi = true;
 
 /* "modprobe net2280 use_dma=n" etc */
 module_param(use_dma, bool, 0444);
-module_param(use_msi, bool, 0444);
 
 /* mode 0 == ep-{a,b,c,d} 1K fifo each
  * mode 1 == ep-{a,b} 2K fifo each, ep-{c,d} unavailable
@@ -3426,7 +3424,7 @@ static void net2280_remove(struct pci_dev *pdev)
 	}
 	if (dev->got_irq)
 		free_irq(pdev->irq, dev);
-	if (use_msi && dev->quirks & PLX_SUPERSPEED)
+	if (dev->quirks & PLX_SUPERSPEED)
 		pci_disable_msi(pdev);
 	if (dev->regs)
 		iounmap(dev->regs);
@@ -3549,7 +3547,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto done;
 	}
 
-	if (use_msi && (dev->quirks & PLX_SUPERSPEED))
+	if (dev->quirks & PLX_SUPERSPEED)
 		if (pci_enable_msi(pdev))
 			ep_err(dev, "Failed to enable MSI mode\n");
 
-- 
2.1.3

