Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3LDMFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:05:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54795 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab3LDMFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:05:09 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, horms@verge.net.au,
        Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 04 Dec 2013 21:05:56 +0900
Message-Id: <20131204120556.29642.27021.sendpatchset@w520>
In-Reply-To: <20131204120537.29642.942.sendpatchset@w520>
References: <20131204120537.29642.942.sendpatchset@w520>
Subject: [PATCH 02/02] irqchip: renesas-irqc: Enable mask on suspend
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when lazy interrupt disable has been enabled in the driver
then extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells
the core that only IRQs marked as wakeups need to stay enabled
during Suspend-to-RAM.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/irqchip/irq-renesas-irqc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0002/drivers/irqchip/irq-renesas-irqc.c
+++ work/drivers/irqchip/irq-renesas-irqc.c	2013-12-04 18:15:48.000000000 +0900
@@ -213,7 +213,7 @@ static int irqc_probe(struct platform_de
 	irq_chip->irq_mask = irqc_irq_disable;
 	irq_chip->irq_unmask = irqc_irq_enable;
 	irq_chip->irq_set_type = irqc_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      p->number_of_irqs,
