Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3EJIR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:27 -0400
Received: from sauhun.de ([89.238.76.85]:60556 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab3EJIRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:25 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [RFC 29/42] drivers/usb/gadget: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:14 +0200
Message-Id: <1368173847-5661-30-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
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

