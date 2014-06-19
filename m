Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966186AbaFSVgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:36:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:55681 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaFSVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:41 -0400
Message-Id: <20140619212713.219411832@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 05/13] irqchip: spear_shirq: Namespace cleanup
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-namespace-cleanup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct members of the shirq block struct are named to confuse the
hell out of the casual reader. Clean it up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |  106 +++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -47,20 +47,20 @@ struct shirq_regs {
 /*
  * struct spear_shirq: shared irq structure
  *
- * irq_base: base irq in linux domain
- * irq_nr: no. of shared interrupts in a particular block
- * irq_bit_off: starting bit offset in the status register
- * invalid_irq: irq group is currently disabled
- * base: base address of shared irq register
- * regs: register configuration for shared irq block
+ * base:	Base register address
+ * regs:	Register configuration for shared irq block
+ * virq_base:	Base virtual interrupt number
+ * nr_irqs:	Number of interrupts handled by this block
+ * offset:	Bit offset of the first interrupt
+ * disabled:	Group is disabled, but accounted
  */
 struct spear_shirq {
-	u32 irq_base;
-	u32 irq_nr;
-	u32 irq_bit_off;
-	int invalid_irq;
-	void __iomem *base;
-	struct shirq_regs regs;
+	void __iomem		*base;
+	struct shirq_regs	regs;
+	u32			virq_base;
+	u32			nr_irqs;
+	u32			offset;
+	bool			disabled;
 };
 
 static DEFINE_SPINLOCK(lock);
@@ -70,8 +70,8 @@ static DEFINE_SPINLOCK(lock);
 #define SPEAR300_INT_STS_MASK_REG	0x58
 
 static struct spear_shirq spear300_shirq_ras1 = {
-	.irq_nr = 9,
-	.irq_bit_off = 0,
+	.offset		= 0,
+	.nr_irqs	= 9,
 	.regs = {
 		.enb_reg = SPEAR300_INT_ENB_MASK_REG,
 		.status_reg = SPEAR300_INT_STS_MASK_REG,
@@ -87,8 +87,8 @@ static struct spear_shirq *spear300_shir
 #define SPEAR310_INT_STS_MASK_REG	0x04
 
 static struct spear_shirq spear310_shirq_ras1 = {
-	.irq_nr = 8,
-	.irq_bit_off = 0,
+	.offset		= 0,
+	.nr_irqs	= 8,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -97,8 +97,8 @@ static struct spear_shirq spear310_shirq
 };
 
 static struct spear_shirq spear310_shirq_ras2 = {
-	.irq_nr = 5,
-	.irq_bit_off = 8,
+	.offset		= 8,
+	.nr_irqs	= 5,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -107,8 +107,8 @@ static struct spear_shirq spear310_shirq
 };
 
 static struct spear_shirq spear310_shirq_ras3 = {
-	.irq_nr = 1,
-	.irq_bit_off = 13,
+	.offset		= 13,
+	.nr_irqs	= 1,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -117,8 +117,8 @@ static struct spear_shirq spear310_shirq
 };
 
 static struct spear_shirq spear310_shirq_intrcomm_ras = {
-	.irq_nr = 3,
-	.irq_bit_off = 14,
+	.offset		= 14,
+	.nr_irqs	= 3,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR310_INT_STS_MASK_REG,
@@ -139,8 +139,8 @@ static struct spear_shirq *spear310_shir
 #define SPEAR320_INT_ENB_MASK_REG		0x08
 
 static struct spear_shirq spear320_shirq_ras1 = {
-	.irq_nr = 3,
-	.irq_bit_off = 7,
+	.offset		= 7,
+	.nr_irqs	= 3,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
@@ -150,8 +150,8 @@ static struct spear_shirq spear320_shirq
 };
 
 static struct spear_shirq spear320_shirq_ras2 = {
-	.irq_nr = 1,
-	.irq_bit_off = 10,
+	.offset		= 10,
+	.nr_irqs	= 1,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
@@ -161,9 +161,9 @@ static struct spear_shirq spear320_shirq
 };
 
 static struct spear_shirq spear320_shirq_ras3 = {
-	.irq_nr = 7,
-	.irq_bit_off = 0,
-	.invalid_irq = 1,
+	.offset		= 0,
+	.nr_irqs	= 7,
+	.disabled	= 1,
 	.regs = {
 		.enb_reg = SPEAR320_INT_ENB_MASK_REG,
 		.reset_to_enb = 1,
@@ -174,8 +174,8 @@ static struct spear_shirq spear320_shirq
 };
 
 static struct spear_shirq spear320_shirq_intrcomm_ras = {
-	.irq_nr = 11,
-	.irq_bit_off = 11,
+	.offset		= 11,
+	.nr_irqs	= 11,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
@@ -194,7 +194,7 @@ static struct spear_shirq *spear320_shir
 static void shirq_irq_mask_unmask(struct irq_data *d, bool mask)
 {
 	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
-	u32 val, offset = d->irq - shirq->irq_base;
+	u32 val, offset = d->irq - shirq->virq_base;
 	unsigned long flags;
 
 	if (shirq->regs.enb_reg == -1)
@@ -204,9 +204,9 @@ static void shirq_irq_mask_unmask(struct
 	val = readl(shirq->base + shirq->regs.enb_reg);
 
 	if (mask ^ shirq->regs.reset_to_enb)
-		val &= ~(0x1 << shirq->irq_bit_off << offset);
+		val &= ~(0x1 << shirq->offset << offset);
 	else
-		val |= 0x1 << shirq->irq_bit_off << offset;
+		val |= 0x1 << shirq->offset << offset;
 
 	writel(val, shirq->base + shirq->regs.enb_reg);
 	spin_unlock_irqrestore(&lock, flags);
@@ -239,17 +239,17 @@ static void shirq_handler(unsigned irq,
 	chip = irq_get_chip(irq);
 	chip->irq_ack(&desc->irq_data);
 
-	mask = ((0x1 << shirq->irq_nr) - 1) << shirq->irq_bit_off;
+	mask = ((0x1 << shirq->nr_irqs) - 1) << shirq->offset;
 	while ((val = readl(shirq->base + shirq->regs.status_reg) &
 				mask)) {
 
-		val >>= shirq->irq_bit_off;
-		for (i = 0, j = 1; i < shirq->irq_nr; i++, j <<= 1) {
+		val >>= shirq->offset;
+		for (i = 0, j = 1; i < shirq->nr_irqs; i++, j <<= 1) {
 
 			if (!(j & val))
 				continue;
 
-			generic_handle_irq(shirq->irq_base + i);
+			generic_handle_irq(shirq->virq_base + i);
 
 			/* clear interrupt */
 			if (shirq->regs.clear_reg == -1)
@@ -257,9 +257,9 @@ static void shirq_handler(unsigned irq,
 
 			tmp = readl(shirq->base + shirq->regs.clear_reg);
 			if (shirq->regs.reset_to_clear)
-				tmp &= ~(j << shirq->irq_bit_off);
+				tmp &= ~(j << shirq->offset);
 			else
-				tmp |= (j << shirq->irq_bit_off);
+				tmp |= (j << shirq->offset);
 			writel(tmp, shirq->base + shirq->regs.clear_reg);
 		}
 	}
@@ -271,24 +271,24 @@ static void __init spear_shirq_register(
 {
 	int i;
 
-	if (shirq->invalid_irq)
+	if (shirq->disabled)
 		return;
 
 	irq_set_chained_handler(parent_irq, shirq_handler);
 	irq_set_handler_data(parent_irq, shirq);
 
-	for (i = 0; i < shirq->irq_nr; i++) {
-		irq_set_chip_and_handler(shirq->irq_base + i,
+	for (i = 0; i < shirq->nr_irqs; i++) {
+		irq_set_chip_and_handler(shirq->virq_base + i,
 					 &shirq_chip, handle_simple_irq);
-		set_irq_flags(shirq->irq_base + i, IRQF_VALID);
-		irq_set_chip_data(shirq->irq_base + i, shirq);
+		set_irq_flags(shirq->virq_base + i, IRQF_VALID);
+		irq_set_chip_data(shirq->virq_base + i, shirq);
 	}
 }
 
 static int __init shirq_init(struct spear_shirq **shirq_blocks, int block_nr,
 		struct device_node *np)
 {
-	int i, parent_irq, irq_base, hwirq = 0, irq_nr = 0;
+	int i, parent_irq, virq_base, hwirq = 0, nr_irqs = 0;
 	struct irq_domain *shirq_domain;
 	void __iomem *base;
 
@@ -299,15 +299,15 @@ static int __init shirq_init(struct spea
 	}
 
 	for (i = 0; i < block_nr; i++)
-		irq_nr += shirq_blocks[i]->irq_nr;
+		nr_irqs += shirq_blocks[i]->nr_irqs;
 
-	irq_base = irq_alloc_descs(-1, 0, irq_nr, 0);
-	if (IS_ERR_VALUE(irq_base)) {
+	virq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
+	if (IS_ERR_VALUE(virq_base)) {
 		pr_err("%s: irq desc alloc failed\n", __func__);
 		goto err_unmap;
 	}
 
-	shirq_domain = irq_domain_add_legacy(np, irq_nr, irq_base, 0,
+	shirq_domain = irq_domain_add_legacy(np, nr_irqs, virq_base, 0,
 			&irq_domain_simple_ops, NULL);
 	if (WARN_ON(!shirq_domain)) {
 		pr_warn("%s: irq domain init failed\n", __func__);
@@ -316,18 +316,18 @@ static int __init shirq_init(struct spea
 
 	for (i = 0; i < block_nr; i++) {
 		shirq_blocks[i]->base = base;
-		shirq_blocks[i]->irq_base = irq_find_mapping(shirq_domain,
+		shirq_blocks[i]->virq_base = irq_find_mapping(shirq_domain,
 				hwirq);
 
 		parent_irq = irq_of_parse_and_map(np, i);
 		spear_shirq_register(shirq_blocks[i], parent_irq);
-		hwirq += shirq_blocks[i]->irq_nr;
+		hwirq += shirq_blocks[i]->nr_irqs;
 	}
 
 	return 0;
 
 err_free_desc:
-	irq_free_descs(irq_base, irq_nr);
+	irq_free_descs(virq_base, nr_irqs);
 err_unmap:
 	iounmap(base);
 	return -ENXIO;


