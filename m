Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3CML0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:26:35 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54852 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3CML0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:26:33 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 13 Mar 2013 20:32:23 +0900
Message-Id: <20130313113223.30133.50623.sendpatchset@w520>
In-Reply-To: <20130313113203.30133.49539.sendpatchset@w520>
References: <20130313113203.30133.49539.sendpatchset@w520>
Subject: [PATCH 02/03] gpio: rcar: Use IRQCHIP_SET_TYPE_MASKED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Set the flag IRQCHIP_SET_TYPE_MASKED in gpio-rcar.c to 
force mask of the interrupt while configuring trigger
settings.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-rcar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0004/drivers/gpio/gpio-rcar.c
+++ work/drivers/gpio/gpio-rcar.c	2013-03-13 19:42:56.000000000 +0900
@@ -301,7 +301,7 @@ static int gpio_rcar_probe(struct platfo
 	irq_chip->irq_enable = gpio_rcar_irq_enable;
 	irq_chip->irq_disable = gpio_rcar_irq_disable;
 	irq_chip->irq_set_type = gpio_rcar_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      p->config.number_of_pins,
