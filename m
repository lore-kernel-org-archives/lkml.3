Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829Ab3IXHqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:46:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57150 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXHqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:46:16 -0400
Message-ID: <1380008771.28920.1.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: adi2: Convert to devm_ioremap_resource
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sonic Zhang <sonic.zhang@analog.com>, linux-kernel@vger.kernel.org
Date: Tue, 24 Sep 2013 15:46:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-adi2.c | 38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 7a24e59..f2aa877 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -855,22 +855,9 @@ static int adi_gpio_pint_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "Invalid mem resource\n");
-		return -ENODEV;
-	}
-
-	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-				     pdev->name)) {
-		dev_err(dev, "Region already claimed\n");
-		return -EBUSY;
-	}
-
-	pint->base = devm_ioremap(dev, res->start, resource_size(res));
-	if (!pint->base) {
-		dev_err(dev, "Could not ioremap\n");
-		return -ENOMEM;
-	}
+	pint->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(pint->base))
+		return PTR_ERR(pint->base);
 
 	pint->regs = (struct gpio_pint_regs *)pint->base;
 
@@ -984,22 +971,9 @@ static int adi_gpio_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "Invalid mem resource\n");
-		return -ENODEV;
-	}
-
-	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-				     pdev->name)) {
-		dev_err(dev, "Region already claimed\n");
-		return -EBUSY;
-	}
-
-	port->base = devm_ioremap(dev, res->start, resource_size(res));
-	if (!port->base) {
-		dev_err(dev, "Could not ioremap\n");
-		return -ENOMEM;
-	}
+	port->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(port->base))
+		return PTR_ERR(port->base);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res)
-- 
1.8.1.2



