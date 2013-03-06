Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3CFGRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:17:54 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48409 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3CFGRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:17:52 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 06 Mar 2013 15:23:39 +0900
Message-Id: <20130306062339.5262.30625.sendpatchset@w520>
Subject: [PATCH] irqchip: irqc: Add DT support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add DT support to the IRQC External IRQ Pin driver.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/irqchip/irq-renesas-irqc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- 0001/drivers/irqchip/irq-renesas-irqc.c
+++ work/drivers/irqchip/irq-renesas-irqc.c	2013-03-06 15:01:42.000000000 +0900
@@ -145,6 +145,7 @@ static int irqc_irq_domain_map(struct ir
 
 static struct irq_domain_ops irqc_irq_domain_ops = {
 	.map	= irqc_irq_domain_map,
+	.xlate  = irq_domain_xlate_twocell,
 };
 
 static int irqc_probe(struct platform_device *pdev)
@@ -273,11 +274,19 @@ static int irqc_remove(struct platform_d
 	return 0;
 }
 
+static const struct of_device_id irqc_dt_ids[] = {
+	{ .compatible = "renesas,irqc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, irqc_dt_ids);
+
 static struct platform_driver irqc_device_driver = {
 	.probe		= irqc_probe,
 	.remove		= irqc_remove,
 	.driver		= {
 		.name	= "renesas_irqc",
+		.of_match_table	= irqc_dt_ids,
+		.owner	= THIS_MODULE,
 	}
 };
 
