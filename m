Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaCFKmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:42:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaCFKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:42:49 -0500
Date: Thu, 6 Mar 2014 02:42:38 -0800
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-6859358e4b0bf2e599027dc4c6317e0bc25ff339@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1393981321-25721-1-git-send-email-sboyd@codeaurora.org>
References: <1393981321-25721-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: gic: Silence sparse warnings
Git-Commit-ID: 6859358e4b0bf2e599027dc4c6317e0bc25ff339
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

Commit-ID:  6859358e4b0bf2e599027dc4c6317e0bc25ff339
Gitweb:     http://git.kernel.org/tip/6859358e4b0bf2e599027dc4c6317e0bc25ff339
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Tue, 4 Mar 2014 17:02:01 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 6 Mar 2014 11:40:47 +0100

irqchip: gic: Silence sparse warnings

drivers/irqchip/irq-gic.c:53:23: warning: duplicate [noderef]
drivers/irqchip/irq-gic.c:651:6: warning: symbol 'gic_raise_softirq' was not declared. Should it be static?
drivers/irqchip/irq-gic.c:872:29: warning: symbol 'gic_irq_domain_ops' was not declared. Should it be static?
drivers/irqchip/irq-gic.c:977:12: warning: symbol 'gic_of_init' was not declared. Should it be static?

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1393981321-25721-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-gic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 341c601..abeb5a9 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -50,7 +50,7 @@
 
 union gic_base {
 	void __iomem *common_base;
-	void __percpu __iomem **percpu_base;
+	void __percpu * __iomem *percpu_base;
 };
 
 struct gic_chip_data {
@@ -648,7 +648,7 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 #endif
 
 #ifdef CONFIG_SMP
-void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
+static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
 	int cpu;
 	unsigned long flags, map = 0;
@@ -869,7 +869,7 @@ static struct notifier_block gic_cpu_notifier = {
 };
 #endif
 
-const struct irq_domain_ops gic_irq_domain_ops = {
+static const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
 };
@@ -974,7 +974,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_OF
 static int gic_cnt __initdata;
 
-int __init gic_of_init(struct device_node *node, struct device_node *parent)
+static int __init
+gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
