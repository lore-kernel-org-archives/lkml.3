Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965318Ab3E2JRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:17:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201Ab3E2JRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:17:06 -0400
Date: Wed, 29 May 2013 02:16:00 -0700
From: tip-bot for Gerlando Falauto <tipbot@zytor.com>
Message-ID: <tip-899f0e66fff36ebb6dd6a83af9aa631f6cb7e0dc@git.kernel.org>
Cc: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, Holger.Brunck@keymile.com,
        thomas.petazzoni@free-electrons.com, linux@arm.linux.org.uk,
        kernel@wantstofly.org, simon@sequanux.org,
        ezequiel.garcia@free-electrons.com, tglx@linutronix.de,
        joravec@drewtech.com, maxime.ripard@free-electrons.com,
        rob@landley.net, nico@fluxnic.net, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, hpa@zytor.com, grant.likely@linaro.org,
        jason@lakedaemon.net, holger.brunck@keymile.com, sguinot@lacie.com,
        gerlando.falauto@keymile.com, gregory.clement@free-electrons.com,
        rob.herring@calxeda.com, sebastian.hesselbarth@gmail.com,
        andrew@lunn.ch
Reply-To: mingo@kernel.org, moinejf@free.fr, jgunthorpe@obsidianresearch.com,
        arnd@arndb.de, Holger.Brunck@keymile.com,
        thomas.petazzoni@free-electrons.com, linux@arm.linux.org.uk,
        kernel@wantstofly.org, joravec@drewtech.com, tglx@linutronix.de,
        ezequiel.garcia@free-electrons.com, simon@sequanux.org,
        maxime.ripard@free-electrons.com, nico@fluxnic.net, rob@landley.net,
        jason@lakedaemon.net, grant.likely@linaro.org, hpa@zytor.com,
        ben-linux@fluff.org, linux-kernel@vger.kernel.org,
        holger.brunck@keymile.com, sguinot@lacie.com,
        gerlando.falauto@keymile.com, sebastian.hesselbarth@gmail.com,
        rob.herring@calxeda.com, gregory.clement@free-electrons.com,
        andrew@lunn.ch
In-Reply-To: <20130506142539.082226607@linutronix.de>
References: <20130506142539.082226607@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Generic chip:
  Add support for per chip type mask cache
Git-Commit-ID: 899f0e66fff36ebb6dd6a83af9aa631f6cb7e0dc
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

Commit-ID:  899f0e66fff36ebb6dd6a83af9aa631f6cb7e0dc
Gitweb:     http://git.kernel.org/tip/899f0e66fff36ebb6dd6a83af9aa631f6cb7e0dc
Author:     Gerlando Falauto <gerlando.falauto@keymile.com>
AuthorDate: Mon, 6 May 2013 14:30:19 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 May 2013 10:57:10 +0200

genirq: Generic chip: Add support for per chip type mask cache

Today the same interrupt mask cache (stored within struct irq_chip_generic)
is shared between all the irq_chip_type instances. As there are instances
where each irq_chip_type uses a distinct mask register (as it is the case
for Orion SoCs), sharing a single mask cache may be incorrect.
So add a distinct pointer for each irq_chip_type, which for now
points to the original mask register within irq_chip_generic.
So no functional changes here.

[ tglx: Minor cosmetic tweaks ]

Reported-by: Joey Oravec <joravec@drewtech.com>
Signed-off-by: Simon Guinot <sguinot@lacie.com>
Signed-off-by: Holger Brunck <holger.brunck@keymile.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Andrew Lunn <andrew@lunn.ch>
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
Link: http://lkml.kernel.org/r/20130506142539.082226607@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |  6 +++++-
 kernel/irq/generic-chip.c | 16 ++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bc4e066..38709a3 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -644,6 +644,8 @@ struct irq_chip_regs {
  * @regs:		Register offsets for this chip
  * @handler:		Flow handler associated with this chip
  * @type:		Chip can handle these flow types
+ * @mask_cache_priv:	Cached mask register private to the chip type
+ * @mask_cache:		Pointer to cached mask register
  *
  * A irq_generic_chip can have several instances of irq_chip_type when
  * it requires different functions and register offsets for different
@@ -654,6 +656,8 @@ struct irq_chip_type {
 	struct irq_chip_regs	regs;
 	irq_flow_handler_t	handler;
 	u32			type;
+	u32			mask_cache_priv;
+	u32			*mask_cache;
 };
 
 /**
@@ -662,7 +666,7 @@ struct irq_chip_type {
  * @reg_base:		Register base address (virtual)
  * @irq_base:		Interrupt base nr for this chip
  * @irq_cnt:		Number of interrupts handled by this chip
- * @mask_cache:		Cached mask register
+ * @mask_cache:		Cached mask register shared between all chip types
  * @type_cache:		Cached type register
  * @polarity_cache:	Cached polarity register
  * @wake_enabled:	Interrupt can wakeup from suspend
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 0e6ba78..113d9eb 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -39,7 +39,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.disable);
-	gc->mask_cache &= ~mask;
+	*ct->mask_cache &= ~mask;
 	irq_gc_unlock(gc);
 }
 
@@ -57,8 +57,8 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
-	gc->mask_cache |= mask;
-	irq_reg_writel(gc->mask_cache, gc->reg_base + ct->regs.mask);
+	*ct->mask_cache |= mask;
+	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
@@ -76,8 +76,8 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 	u32 mask = 1 << (d->irq - gc->irq_base);
 
 	irq_gc_lock(gc);
-	gc->mask_cache &= ~mask;
-	irq_reg_writel(gc->mask_cache, gc->reg_base + ct->regs.mask);
+	*ct->mask_cache &= ~mask;
+	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
@@ -96,7 +96,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + ct->regs.enable);
-	gc->mask_cache |= mask;
+	*ct->mask_cache |= mask;
 	irq_gc_unlock(gc);
 }
 
@@ -250,6 +250,10 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	if (flags & IRQ_GC_INIT_MASK_CACHE)
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
+	/* Initialize mask cache pointer */
+	for (i = 0; i < gc->num_ct; i++)
+		ct[i].mask_cache = &gc->mask_cache;
+
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
 		if (!(msk & 0x01))
 			continue;
