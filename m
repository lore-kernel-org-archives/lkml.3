Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3KMW7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:59:06 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64919 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3KMW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:58:57 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 14 Nov 2013 07:59:36 +0900
Message-Id: <20131113225936.21449.29529.sendpatchset@w520>
In-Reply-To: <20131113225927.21449.78044.sendpatchset@w520>
References: <20131113225927.21449.78044.sendpatchset@w520>
Subject: [PATCH 01/03] gpio: rcar: Use lazy disable and mask on suspend
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Set the ->irq_enable() and ->irq_disable() methods to NULL
to enable lazy disable of interrupts. Also extend the code
to set IRQCHIP_MASK_ON_SUSPEND which tells the core that
only IRQs marked as wakeups need to stay enabled during
Suspend-to-RAM.

Tested on the Lager board with GPIO-keys and Suspend-to-RAM.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-rcar.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- 0001/drivers/gpio/gpio-rcar.c
+++ work/drivers/gpio/gpio-rcar.c	2013-11-13 19:26:26.000000000 +0900
@@ -368,10 +368,9 @@ static int gpio_rcar_probe(struct platfo
 	irq_chip->name = name;
 	irq_chip->irq_mask = gpio_rcar_irq_disable;
 	irq_chip->irq_unmask = gpio_rcar_irq_enable;
-	irq_chip->irq_enable = gpio_rcar_irq_enable;
-	irq_chip->irq_disable = gpio_rcar_irq_disable;
 	irq_chip->irq_set_type = gpio_rcar_irq_set_type;
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED;
+	irq_chip->flags	|= IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      p->config.number_of_pins,
