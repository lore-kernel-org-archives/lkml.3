Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3KTAWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:22:39 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58901 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3KTAWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:22:36 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 20 Nov 2013 09:23:17 +0900
Message-Id: <20131120002317.27342.34257.sendpatchset@w520>
In-Reply-To: <20131120002259.27342.35575.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
Subject: [PATCH 02/05 v2] gpio: rcar: Enable mask on suspend
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when lazy interrupt disable has been enabled in the driver
then extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells
the core that only IRQs marked as wakeups need to stay enabled
during Suspend-to-RAM.

Tested on the Lager board with GPIO-keys and Suspend-to-RAM.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-rcar.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 0008/drivers/gpio/gpio-rcar.c
+++ work/drivers/gpio/gpio-rcar.c	2013-11-20 08:30:28.000000000 +0900
@@ -369,7 +369,8 @@ static int gpio_rcar_probe(struct platfo
 	irq_chip->irq_mask = gpio_rcar_irq_disable;
 	irq_chip->irq_unmask = gpio_rcar_irq_enable;
 	irq_chip->irq_set_type = gpio_rcar_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED
+			 | IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      p->config.number_of_pins,
