Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaAIK4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:56:39 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:26773 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753469AbaAIKzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:55:24 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 1/6] usb: gadget: gr_udc: Make struct platform_device variable name clearer
Date: Thu,  9 Jan 2014 11:54:13 +0100
Message-Id: <1389264858-32664-2-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
References: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename struct platform_device pointers from ofdev to pdev for clarity.
Suggested by Mark Rutland.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/usb/gadget/gr_udc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index 914cbd8..e66dcf0 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -2071,9 +2071,9 @@ static int gr_udc_init(struct gr_udc *dev)
 	return 0;
 }
 
-static int gr_remove(struct platform_device *ofdev)
+static int gr_remove(struct platform_device *pdev)
 {
-	struct gr_udc *dev = dev_get_drvdata(&ofdev->dev);
+	struct gr_udc *dev = dev_get_drvdata(&pdev->dev);
 
 	if (dev->added)
 		usb_del_gadget_udc(&dev->gadget); /* Shuts everything down */
@@ -2083,7 +2083,7 @@ static int gr_remove(struct platform_device *ofdev)
 	gr_dfs_delete(dev);
 	if (dev->desc_pool)
 		dma_pool_destroy(dev->desc_pool);
-	dev_set_drvdata(&ofdev->dev, NULL);
+	dev_set_drvdata(&pdev->dev, NULL);
 
 	gr_free_request(&dev->epi[0].ep, &dev->ep0reqi->req);
 	gr_free_request(&dev->epo[0].ep, &dev->ep0reqo->req);
@@ -2096,7 +2096,7 @@ static int gr_request_irq(struct gr_udc *dev, int irq)
 					 IRQF_SHARED, driver_name, dev);
 }
 
-static int gr_probe(struct platform_device *ofdev)
+static int gr_probe(struct platform_device *pdev)
 {
 	struct gr_udc *dev;
 	struct resource *res;
@@ -2104,12 +2104,12 @@ static int gr_probe(struct platform_device *ofdev)
 	int retval;
 	u32 status;
 
-	dev = devm_kzalloc(&ofdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
-	dev->dev = &ofdev->dev;
+	dev->dev = &pdev->dev;
 
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(dev->dev, res);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
@@ -2138,7 +2138,7 @@ static int gr_probe(struct platform_device *ofdev)
 	spin_lock_init(&dev->lock);
 	dev->regs = regs;
 
-	dev_set_drvdata(&ofdev->dev, dev);
+	dev_set_drvdata(&pdev->dev, dev);
 
 	/* Determine number of endpoints and data interface mode */
 	status = gr_read32(&dev->regs->status);
@@ -2210,7 +2210,7 @@ out:
 	spin_unlock(&dev->lock);
 
 	if (retval)
-		gr_remove(ofdev);
+		gr_remove(pdev);
 
 	return retval;
 }
-- 
1.7.10.4

