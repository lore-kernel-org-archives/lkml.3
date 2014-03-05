Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaCEAkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:40:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58555 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaCEAke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:40:34 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        "olof @ lixom . net" <linux-arm-kernel@lists.infradead.org>,
        khilman@linaro.org, kernel-build-reports@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Josh Cartwright <joshc@codeaurora.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] irqchip: Remove asmlinkage from static functions
Date: Tue,  4 Mar 2014 16:40:30 -0800
Message-Id: <1393980030-17770-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <20140301161258.GN12219@tassilo.jf.intel.com>
References: <20140301161258.GN12219@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTO patches add __visible to the asmlinkage define, causing
compilation warnings like:

  drivers/irqchip/irq-gic.c:283:1: warning: 'externally_visible'
  attribute have effect only on public objects [-Wattributes]

Drop asmlinkage here to avoid such warnings.

Reported-by: Olof's autobuilder <build@lixom.net>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Based on next-20140226.

 drivers/irqchip/irq-armada-370-xp.c | 2 +-
 drivers/irqchip/irq-bcm2835.c       | 4 ++--
 drivers/irqchip/irq-gic.c           | 2 +-
 drivers/irqchip/irq-mmp.c           | 6 ++----
 drivers/irqchip/irq-moxart.c        | 2 +-
 drivers/irqchip/irq-orion.c         | 2 +-
 drivers/irqchip/irq-sirfsoc.c       | 2 +-
 drivers/irqchip/irq-sun4i.c         | 4 ++--
 drivers/irqchip/irq-vic.c           | 2 +-
 drivers/irqchip/irq-vt8500.c        | 3 +--
 drivers/irqchip/irq-zevio.c         | 2 +-
 11 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index cd79503abea9..41be897df8d5 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -410,7 +410,7 @@ static void armada_370_xp_mpic_handle_cascade_irq(unsigned int irq,
 	chained_irq_exit(chip, desc);
 }
 
-static asmlinkage void __exception_irq_entry
+static void __exception_irq_entry
 armada_370_xp_handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat, irqnr;
diff --git a/drivers/irqchip/irq-bcm2835.c b/drivers/irqchip/irq-bcm2835.c
index 1693b8e7f26a..5916d6cdafa1 100644
--- a/drivers/irqchip/irq-bcm2835.c
+++ b/drivers/irqchip/irq-bcm2835.c
@@ -95,7 +95,7 @@ struct armctrl_ic {
 };
 
 static struct armctrl_ic intc __read_mostly;
-static asmlinkage void __exception_irq_entry bcm2835_handle_irq(
+static void __exception_irq_entry bcm2835_handle_irq(
 	struct pt_regs *regs);
 
 static void armctrl_mask_irq(struct irq_data *d)
@@ -196,7 +196,7 @@ static void armctrl_handle_shortcut(int bank, struct pt_regs *regs,
 	handle_IRQ(irq_linear_revmap(intc.domain, irq), regs);
 }
 
-static asmlinkage void __exception_irq_entry bcm2835_handle_irq(
+static void __exception_irq_entry bcm2835_handle_irq(
 	struct pt_regs *regs)
 {
 	u32 stat, irq;
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index a917b144895e..63922b9ba6b7 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -279,7 +279,7 @@ static int gic_set_wake(struct irq_data *d, unsigned int on)
 #define gic_set_wake	NULL
 #endif
 
-static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat, irqnr;
 	struct gic_chip_data *gic = &gic_data[0];
diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
index 2cb7cd0bc2f5..3c8827fe83f3 100644
--- a/drivers/irqchip/irq-mmp.c
+++ b/drivers/irqchip/irq-mmp.c
@@ -194,8 +194,7 @@ static struct mmp_intc_conf mmp2_conf = {
 	.conf_mask	= 0x7f,
 };
 
-static asmlinkage void __exception_irq_entry
-mmp_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry mmp_handle_irq(struct pt_regs *regs)
 {
 	int irq, hwirq;
 
@@ -207,8 +206,7 @@ mmp_handle_irq(struct pt_regs *regs)
 	handle_IRQ(irq, regs);
 }
 
-static asmlinkage void __exception_irq_entry
-mmp2_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry mmp2_handle_irq(struct pt_regs *regs)
 {
 	int irq, hwirq;
 
diff --git a/drivers/irqchip/irq-moxart.c b/drivers/irqchip/irq-moxart.c
index 5552fc2bf28a..00b3cc908f76 100644
--- a/drivers/irqchip/irq-moxart.c
+++ b/drivers/irqchip/irq-moxart.c
@@ -44,7 +44,7 @@ struct moxart_irq_data {
 
 static struct moxart_irq_data intc;
 
-static asmlinkage void __exception_irq_entry handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat;
 	int hwirq;
diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 8e41be62812e..e25f246cd2fb 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -30,7 +30,7 @@
 
 static struct irq_domain *orion_irq_domain;
 
-static asmlinkage void
+static void
 __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
 {
 	struct irq_domain_chip_generic *dgc = orion_irq_domain->gc;
diff --git a/drivers/irqchip/irq-sirfsoc.c b/drivers/irqchip/irq-sirfsoc.c
index 3a070c587ed9..581eefe331ae 100644
--- a/drivers/irqchip/irq-sirfsoc.c
+++ b/drivers/irqchip/irq-sirfsoc.c
@@ -47,7 +47,7 @@ sirfsoc_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 	ct->regs.mask = SIRFSOC_INT_RISC_MASK0;
 }
 
-static asmlinkage void __exception_irq_entry sirfsoc_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry sirfsoc_handle_irq(struct pt_regs *regs)
 {
 	void __iomem *base = sirfsoc_irqdomain->host_data;
 	u32 irqstat, irqnr;
diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index a5438d889245..9fbff030c700 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -36,7 +36,7 @@
 static void __iomem *sun4i_irq_base;
 static struct irq_domain *sun4i_irq_domain;
 
-static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
+static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
 static void sun4i_irq_ack(struct irq_data *irqd)
 {
@@ -136,7 +136,7 @@ static int __init sun4i_of_init(struct device_node *node,
 }
 IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-ic", sun4i_of_init);
 
-static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 {
 	u32 irq, hwirq;
 
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index fd2c980e4cea..37dab0b472cd 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -240,7 +240,7 @@ static void vic_handle_irq_cascaded(unsigned int irq, struct irq_desc *desc)
  * Keep iterating over all registered VIC's until there are no pending
  * interrupts.
  */
-static asmlinkage void __exception_irq_entry vic_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry vic_handle_irq(struct pt_regs *regs)
 {
 	int i, handled;
 
diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index 1846e7d66681..eb6e91efdec8 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -178,8 +178,7 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-static asmlinkage
-void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 {
 	u32 stat, i;
 	int irqnr, virq;
diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
index 8ed04c4a43ee..ceb3a4318f73 100644
--- a/drivers/irqchip/irq-zevio.c
+++ b/drivers/irqchip/irq-zevio.c
@@ -50,7 +50,7 @@ static void zevio_irq_ack(struct irq_data *irqd)
 	readl(gc->reg_base + regs->ack);
 }
 
-static asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
 {
 	int irqnr;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

