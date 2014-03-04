Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbaCDUvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:51:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44600 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbaCDUvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:51:49 -0500
Date: Tue, 4 Mar 2014 12:51:33 -0800
From: tip-bot for Michael Opdenacker <tipbot@zytor.com>
Message-ID: <tip-2958a489d7d31552fd1a0a8f54a5005c278d4606@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        michael.opdenacker@free-electrons.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        michael.opdenacker@free-electrons.com, tglx@linutronix.de
In-Reply-To: <1393964953-17002-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1393964953-17002-1-git-send-email-michael.opdenacker@free-electrons.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ia64: Remove deprecated IRQF_DISABLED
Git-Commit-ID: 2958a489d7d31552fd1a0a8f54a5005c278d4606
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

Commit-ID:  2958a489d7d31552fd1a0a8f54a5005c278d4606
Gitweb:     http://git.kernel.org/tip/2958a489d7d31552fd1a0a8f54a5005c278d4606
Author:     Michael Opdenacker <michael.opdenacker@free-electrons.com>
AuthorDate: Tue, 4 Mar 2014 21:29:13 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 21:47:51 +0100

ia64: Remove deprecated IRQF_DISABLED

This patch removes the IRQF_DISABLED flag from ia64 architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: paul.gortmaker@windriver.com
Cc: viro@zeniv.linux.org.uk
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: andriy.shevchenko@linux.intel.com
Cc: fenghua.yu@intel.com
Cc: tony.luck@intel.com
Link: http://lkml.kernel.org/r/1393964953-17002-1-git-send-email-michael.opdenacker@free-electrons.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/kernel/irq_ia64.c | 4 ----
 arch/ia64/kernel/mca.c      | 6 ------
 arch/ia64/kernel/perfmon.c  | 1 -
 arch/ia64/kernel/time.c     | 2 +-
 4 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index c8a576b..0884f5e 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -364,7 +364,6 @@ static irqreturn_t smp_irq_move_cleanup_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq_move_irqaction = {
 	.handler =	smp_irq_move_cleanup_interrupt,
-	.flags =	IRQF_DISABLED,
 	.name =		"irq_move"
 };
 
@@ -600,7 +599,6 @@ static irqreturn_t dummy_handler (int irq, void *dev_id)
 
 static struct irqaction ipi_irqaction = {
 	.handler =	handle_IPI,
-	.flags =	IRQF_DISABLED,
 	.name =		"IPI"
 };
 
@@ -609,13 +607,11 @@ static struct irqaction ipi_irqaction = {
  */
 static struct irqaction resched_irqaction = {
 	.handler =	dummy_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"resched"
 };
 
 static struct irqaction tlb_irqaction = {
 	.handler =	dummy_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"tlb_flush"
 };
 
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index b8edfa7..33f1462 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1772,38 +1772,32 @@ __setup("disable_cpe_poll", ia64_mca_disable_cpe_polling);
 
 static struct irqaction cmci_irqaction = {
 	.handler =	ia64_mca_cmc_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"cmc_hndlr"
 };
 
 static struct irqaction cmcp_irqaction = {
 	.handler =	ia64_mca_cmc_int_caller,
-	.flags =	IRQF_DISABLED,
 	.name =		"cmc_poll"
 };
 
 static struct irqaction mca_rdzv_irqaction = {
 	.handler =	ia64_mca_rendez_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"mca_rdzv"
 };
 
 static struct irqaction mca_wkup_irqaction = {
 	.handler =	ia64_mca_wakeup_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"mca_wkup"
 };
 
 #ifdef CONFIG_ACPI
 static struct irqaction mca_cpe_irqaction = {
 	.handler =	ia64_mca_cpe_int_handler,
-	.flags =	IRQF_DISABLED,
 	.name =		"cpe_hndlr"
 };
 
 static struct irqaction mca_cpep_irqaction = {
 	.handler =	ia64_mca_cpe_int_caller,
-	.flags =	IRQF_DISABLED,
 	.name =		"cpe_poll"
 };
 #endif /* CONFIG_ACPI */
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index cb59277..d841c4b 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -6387,7 +6387,6 @@ pfm_flush_pmds(struct task_struct *task, pfm_context_t *ctx)
 
 static struct irqaction perfmon_irqaction = {
 	.handler = pfm_interrupt_handler,
-	.flags   = IRQF_DISABLED,
 	.name    = "perfmon"
 };
 
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index fbaac1a..71c52bc 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -380,7 +380,7 @@ static cycle_t itc_get_cycles(struct clocksource *cs)
 
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags =	IRQF_IRQPOLL,
 	.name =		"timer"
 };
 
