Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3KTAXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:23:08 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56360 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3KTAXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:23:03 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 20 Nov 2013 09:23:44 +0900
Message-Id: <20131120002344.27342.23018.sendpatchset@w520>
In-Reply-To: <20131120002259.27342.35575.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
Subject: [PATCH 05/05 v2] gpio: em: Enable mask on suspend
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when lazy interrupt disable has been enabled in the driver
then extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells
the core that only IRQs marked as wakeups need to stay enabled
during Suspend-to-RAM.

Tested on the KZM9D board with GPIO-keys.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-em.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0011/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2013-11-20 08:33:47.000000000 +0900
@@ -337,7 +337,7 @@ static int em_gio_probe(struct platform_
 	irq_chip->irq_mask = em_gio_irq_disable;
 	irq_chip->irq_unmask = em_gio_irq_enable;
 	irq_chip->irq_set_type = em_gio_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      pdata->number_of_pins,
