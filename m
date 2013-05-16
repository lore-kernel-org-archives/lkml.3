Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3EPLP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:27 -0400
Received: from sauhun.de ([89.238.76.85]:56218 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab3EPLPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:22 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 22/33] drivers/usb/gadget: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:50 +0200
Message-Id: <1368702961-4325-23-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/usb/gadget/bcm63xx_udc.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/gadget/bcm63xx_udc.c b/drivers/usb/gadget/bcm63xx_udc.c
index 6e65182..7922977 100644
--- a/drivers/usb/gadget/bcm63xx_udc.c
+++ b/drivers/usb/gadget/bcm63xx_udc.c
@@ -2334,21 +2334,11 @@ static int bcm63xx_udc_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "error finding USBD resource\n");
-		return -ENXIO;
-	}
-
 	udc->usbd_regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(udc->usbd_regs))
 		return PTR_ERR(udc->usbd_regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!res) {
-		dev_err(dev, "error finding IUDMA resource\n");
-		return -ENXIO;
-	}
-
 	udc->iudma_regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(udc->iudma_regs))
 		return PTR_ERR(udc->iudma_regs);
-- 
1.7.10.4

