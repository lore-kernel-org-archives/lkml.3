Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaCDQk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:40:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaCDQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:40:57 -0500
Date: Tue, 4 Mar 2014 08:39:53 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a4e04c9f219d2c00764ffa7ba45500411815879d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de
In-Reply-To: <20140223212736.333718121@linutronix.de>
References: <20140223212736.333718121@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] powerpc: Irq: Use generic_handle_irq
Git-Commit-ID: a4e04c9f219d2c00764ffa7ba45500411815879d
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

Commit-ID:  a4e04c9f219d2c00764ffa7ba45500411815879d
Gitweb:     http://git.kernel.org/tip/a4e04c9f219d2c00764ffa7ba45500411815879d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:08 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:52 +0100

powerpc: Irq: Use generic_handle_irq

No functional change

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc <linuxppc-dev@lists.ozlabs.org>
Link: http://lkml.kernel.org/r/20140223212736.333718121@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/kernel/irq.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 1d0848b..ca1cd74 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -465,7 +465,6 @@ static inline void check_stack_overflow(void)
 
 void __do_irq(struct pt_regs *regs)
 {
-	struct irq_desc *desc;
 	unsigned int irq;
 
 	irq_enter();
@@ -487,11 +486,8 @@ void __do_irq(struct pt_regs *regs)
 	/* And finally process it */
 	if (unlikely(irq == NO_IRQ))
 		__get_cpu_var(irq_stat).spurious_irqs++;
-	else {
-		desc = irq_to_desc(irq);
-		if (likely(desc))
-			desc->handle_irq(irq, desc);
-	}
+	else
+		generic_handle_irq(irq);
 
 	trace_irq_exit(regs);
 
