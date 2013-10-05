Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3JECSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 22:18:44 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:41008 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JECSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 22:18:42 -0400
From: Fabio Estevam <festevam@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] irqchip: irq-gic: Make local functions static
Date: Fri,  4 Oct 2013 23:12:20 -0300
Message-Id: <1380939140-12864-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following sparse warnings:

drivers/irqchip/irq-gic.c:651:6: warning: symbol 'gic_raise_softirq' was not declared. Should it be static?
drivers/irqchip/irq-gic.c:831:29: warning: symbol 'gic_irq_domain_ops' was not declared. Should it be static?
drivers/irqchip/irq-gic.c:935:12: warning: symbol 'gic_of_init' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/irqchip/irq-gic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 6365b59..7d6bc22 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -648,7 +648,7 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 #endif
 
 #ifdef CONFIG_SMP
-void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
+static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
 	int cpu;
 	unsigned long flags, map = 0;
@@ -828,7 +828,7 @@ static struct notifier_block gic_cpu_notifier = {
 };
 #endif
 
-const struct irq_domain_ops gic_irq_domain_ops = {
+static const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
 };
@@ -932,7 +932,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_OF
 static int gic_cnt __initdata;
 
-int __init gic_of_init(struct device_node *node, struct device_node *parent)
+static int __init gic_of_init(struct device_node *node,
+			      struct device_node *parent)
 {
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
-- 
1.8.1.2

