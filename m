Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3CFGKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:10:54 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38934 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3CFGKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:10:22 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 06 Mar 2013 15:16:08 +0900
Message-Id: <20130306061608.5231.23213.sendpatchset@w520>
Subject: [PATCH] irqchip: intc-irqpin: Initial DT support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add initial DT support to the INTC External IRQ Pin
driver. At this point only hardware with 4-bit wide
sense registers is supported via DT.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/irqchip/irq-renesas-intc-irqpin.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- 0001/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ work/drivers/irqchip/irq-renesas-intc-irqpin.c	2013-03-06 14:59:58.000000000 +0900
@@ -278,6 +278,7 @@ static int intc_irqpin_irq_domain_map(st
 
 static struct irq_domain_ops intc_irqpin_irq_domain_ops = {
 	.map	= intc_irqpin_irq_domain_map,
+	.xlate  = irq_domain_xlate_twocell,
 };
 
 static int intc_irqpin_probe(struct platform_device *pdev)
@@ -437,11 +438,19 @@ static int intc_irqpin_remove(struct pla
 	return 0;
 }
 
+static const struct of_device_id intc_irqpin_dt_ids[] = {
+	{ .compatible = "renesas,intc-irqpin", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, intc_irqpin_dt_ids);
+
 static struct platform_driver intc_irqpin_device_driver = {
 	.probe		= intc_irqpin_probe,
 	.remove		= intc_irqpin_remove,
 	.driver		= {
 		.name	= "renesas_intc_irqpin",
+		.of_match_table = intc_irqpin_dt_ids,
+		.owner  = THIS_MODULE,
 	}
 };
 
