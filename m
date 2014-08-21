Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaHUOxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:41 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:45144 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaHUOxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:39 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Bassel <larry.bassel@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 7/9] arm64: Tell irq work about self IPI support
Date: Thu, 21 Aug 2014 16:52:55 +0200
Message-Id: <1408632777-3348-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM64 irq work support depends on __smp_cross_call to point to some
relevant IRQ controller operations. This information should be available
after the call to init_IRQ().

Lets implement arch_irq_work_has_own_interrupt() accordingly.

Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Larry Bassel <larry.bassel@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/arm64/kernel/smp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 4743397..b3e8b9e 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -534,6 +534,11 @@ void arch_irq_work_raise(void)
 	if (__smp_cross_call)
 		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
 }
+
+int __init arch_irq_work_has_own_interrupt(void)
+{
+	return !!__smp_cross_call;
+}
 #endif
 
 static DEFINE_RAW_SPINLOCK(stop_lock);
-- 
1.8.3.1

