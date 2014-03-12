Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaCLMDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:03:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaCLMDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:03:49 -0400
Date: Wed, 12 Mar 2014 05:03:27 -0700
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-8783dd3a37a5853689e1a8fa728827a50905b912@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sboyd@codeaurora.org, joshc@codeaurora.org, linux@arm.linux.org.uk,
        ak@linux.intel.com, tglx@linutronix.de, build@lixom.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org, joshc@codeaurora.org, linux@arm.linux.org.uk,
        ak@linux.intel.com, build@lixom.net, tglx@linutronix.de
In-Reply-To: <1393980030-17770-1-git-send-email-sboyd@codeaurora.org>
References: <1393980030-17770-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: Remove asmlinkage from static functions
Git-Commit-ID: 8783dd3a37a5853689e1a8fa728827a50905b912
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

Commit-ID:  8783dd3a37a5853689e1a8fa728827a50905b912
Gitweb:     http://git.kernel.org/tip/8783dd3a37a5853689e1a8fa728827a50905b912
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Tue, 4 Mar 2014 16:40:30 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Mar 2014 13:00:41 +0100

irqchip: Remove asmlinkage from static functions

LTO patches add __visible to the asmlinkage define, causing
compilation warnings like:

  drivers/irqchip/irq-gic.c:283:1: warning: 'externally_visible'
  attribute have effect only on public objects [-Wattributes]

Drop asmlinkage here to avoid such warnings.

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: khilman@linaro.org
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1393980030-17770-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
index cd79503..41be897 100644
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
index 1693b8e..5916d6c 100644
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
index abeb5a9..531769b 100644
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
index 2cb7cd0..3c8827f 100644
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
index 5552fc2..00b3cc9 100644
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
index e51d400..c3f0f41 100644
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
index 3a070c5..581eefe 100644
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
index a5438d8..9fbff03 100644
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
index 8e21ae0..473f09a 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -228,7 +228,7 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
  * Keep iterating over all registered VIC's until there are no pending
  * interrupts.
  */
-static asmlinkage void __exception_irq_entry vic_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry vic_handle_irq(struct pt_regs *regs)
 {
 	int i, handled;
 
diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index 1846e7d..eb6e91e 100644
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
index 8ed04c4..ceb3a43 100644
--- a/drivers/irqchip/irq-zevio.c
+++ b/drivers/irqchip/irq-zevio.c
@@ -50,7 +50,7 @@ static void zevio_irq_ack(struct irq_data *irqd)
 	readl(gc->reg_base + regs->ack);
 }
 
-static asmlinkage void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
+static void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
 {
 	int irqnr;
 
