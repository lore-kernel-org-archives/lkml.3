Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965327Ab3E2JQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:16:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201Ab3E2JQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:16:13 -0400
Date: Wed, 29 May 2013 02:14:42 -0700
From: tip-bot for Gerlando Falauto <tipbot@zytor.com>
Message-ID: <tip-cfeaa93f8a13ae9117ae20933a38a406de80849e@git.kernel.org>
Cc: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, Holger.Brunck@keymile.com,
        thomas.petazzoni@free-electrons.com, kernel@wantstofly.org,
        linux@arm.linux.org.uk, simon@sequanux.org,
        ezequiel.garcia@free-electrons.com, tglx@linutronix.de,
        joravec@drewtech.com, maxime.ripard@free-electrons.com,
        rob@landley.net, nico@fluxnic.net, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, hpa@zytor.com, grant.likely@linaro.org,
        jason@lakedaemon.net, gerlando.falauto@keymile.com,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com,
        rob.herring@calxeda.com, andrew@lunn.ch
Reply-To: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, Holger.Brunck@keymile.com,
        thomas.petazzoni@free-electrons.com, kernel@wantstofly.org,
        linux@arm.linux.org.uk, joravec@drewtech.com, tglx@linutronix.de,
        ezequiel.garcia@free-electrons.com, simon@sequanux.org,
        maxime.ripard@free-electrons.com, nico@fluxnic.net, rob@landley.net,
        jason@lakedaemon.net, grant.likely@linaro.org, hpa@zytor.com,
        ben-linux@fluff.org, linux-kernel@vger.kernel.org,
        gerlando.falauto@keymile.com, rob.herring@calxeda.com,
        sebastian.hesselbarth@gmail.com, gregory.clement@free-electrons.com,
        andrew@lunn.ch
In-Reply-To: <20130506142539.010164766@linutronix.de>
References: <20130506142539.010164766@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Generic chip: Remove the local cur_regs()
  function
Git-Commit-ID: cfeaa93f8a13ae9117ae20933a38a406de80849e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfeaa93f8a13ae9117ae20933a38a406de80849e
Gitweb:     http://git.kernel.org/tip/cfeaa93f8a13ae9117ae20933a38a406de80849e
Author:     Gerlando Falauto <gerlando.falauto@keymile.com>
AuthorDate: Mon, 6 May 2013 14:30:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 May 2013 10:57:09 +0200

genirq: Generic chip: Remove the local cur_regs() function

Since we already have an irq_data_get_chip_type() function which returns
a pointer to irq_chip_type, use that instead of cur_regs().

Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Joey Oravec <joravec@drewtech.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Holger Brunck <Holger.Brunck@keymile.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Simon Guinot <simon@sequanux.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Rob Landley <rob@landley.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Link: http://lkml.kernel.org/r/20130506142539.010164766@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index c89295a..0e6ba78 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -16,11 +16,6 @@
 static LIST_HEAD(gc_list);
 static DEFINE_RAW_SPINLOCK(gc_lock);
 
-static inline struct irq_chip_regs *cur_regs(struct irq_data *d)
-{
-	return &container_of(d->chip, struct irq_chip_type, chip)->regs;
-}
-
 /**
  * irq_gc_noop - NOOP function
  * @d: irq_data
@@ -39,10 +34,11 @@ void irq_gc_noop(struct irq_data *d)
 void irq_gc_mask_disable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->disable);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.disable);
 	gc->mask_cache &= ~mask;
 	irq_gc_unlock(gc);
 }
@@ -57,11 +53,12 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 void irq_gc_mask_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
 	gc->mask_cache |= mask;
-	irq_reg_writel(gc->mask_cache, gc->reg_base + cur_regs(d)->mask);
+	irq_reg_writel(gc->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
@@ -75,11 +72,12 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 void irq_gc_mask_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
 	gc->mask_cache &= ~mask;
-	irq_reg_writel(gc->mask_cache, gc->reg_base + cur_regs(d)->mask);
+	irq_reg_writel(gc->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
@@ -93,10 +91,11 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 void irq_gc_unmask_enable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->enable);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.enable);
 	gc->mask_cache |= mask;
 	irq_gc_unlock(gc);
 }
@@ -108,10 +107,11 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 void irq_gc_ack_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -122,10 +122,11 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 void irq_gc_ack_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = ~(1 << (d->irq - gc->irq_base));
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -136,11 +137,12 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->mask);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -151,10 +153,11 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 void irq_gc_eoi(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->eoi);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.eoi);
 	irq_gc_unlock(gc);
 }
 
