Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3KMW7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:59:33 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42631 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3KMW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:59:16 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 14 Nov 2013 07:59:55 +0900
Message-Id: <20131113225955.21449.34737.sendpatchset@w520>
In-Reply-To: <20131113225927.21449.78044.sendpatchset@w520>
References: <20131113225927.21449.78044.sendpatchset@w520>
Subject: [PATCH 03/03] gpio: em: Use lazy disable and mask on suspend
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Set the ->irq_enable() and ->irq_disable() methods to NULL
to enable lazy disable of interrupts. Also extend the code
to set IRQCHIP_MASK_ON_SUSPEND which tells the core that
only IRQs marked as wakeups need to stay enabled during
Suspend-to-RAM.

Tested on the KZM9D board with GPIO-keys.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-em.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- 0006/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2013-11-13 22:18:21.000000000 +0900
@@ -336,10 +336,8 @@ static int em_gio_probe(struct platform_
 	irq_chip->name = name;
 	irq_chip->irq_mask = em_gio_irq_disable;
 	irq_chip->irq_unmask = em_gio_irq_enable;
-	irq_chip->irq_enable = em_gio_irq_enable;
-	irq_chip->irq_disable = em_gio_irq_disable;
 	irq_chip->irq_set_type = em_gio_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      pdata->number_of_pins,
