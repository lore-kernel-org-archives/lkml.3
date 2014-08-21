Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaHUOxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:14 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:63664 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaHUOxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 5/9] x86: Tell irq work about self IPI support
Date: Thu, 21 Aug 2014 16:52:53 +0200
Message-Id: <1408632777-3348-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 supports irq work when local apic is available. This is partly known
on runtime so lets implement arch_irq_work_has_own_interrupt()
accordingly.

This should be safely called after setup_arch().

Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/irq_work.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 54f60a2..b5f8fff 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -38,6 +38,11 @@ __visible void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
+int __init arch_irq_work_has_own_interrupt(void)
+{
+	return cpu_has_apic;
+}
+
 void arch_irq_work_raise(void)
 {
 	if (!cpu_has_apic)
-- 
1.8.3.1

