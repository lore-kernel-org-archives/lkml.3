Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbaEPNeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:34:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaEPNes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:34:48 -0400
Date: Fri, 16 May 2014 06:33:55 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-fd5d8abf8bdf9519f40058b5cd24b6ab37b214b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154336.566531793@linutronix.de>
References: <20140507154336.566531793@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ia64: Remove unused check_irq_used()
Git-Commit-ID: fd5d8abf8bdf9519f40058b5cd24b6ab37b214b4
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

Commit-ID:  fd5d8abf8bdf9519f40058b5cd24b6ab37b214b4
Gitweb:     http://git.kernel.org/tip/fd5d8abf8bdf9519f40058b5cd24b6ab37b214b4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:11 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:20 +0200

ia64: Remove unused check_irq_used()

Just stumbled over it when staring into ia64 irq handling.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/20140507154336.566531793@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/include/asm/hw_irq.h | 1 -
 arch/ia64/kernel/irq_ia64.c    | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/arch/ia64/include/asm/hw_irq.h b/arch/ia64/include/asm/hw_irq.h
index a681d02..029bab3 100644
--- a/arch/ia64/include/asm/hw_irq.h
+++ b/arch/ia64/include/asm/hw_irq.h
@@ -132,7 +132,6 @@ extern int reserve_irq_vector (int vector);
 extern void __setup_vector_irq(int cpu);
 extern void ia64_send_ipi (int cpu, int vector, int delivery_mode, int redirect);
 extern void ia64_native_register_percpu_irq (ia64_vector vec, struct irqaction *action);
-extern int check_irq_used (int irq);
 extern void destroy_and_reserve_irq (unsigned int irq);
 
 #if defined(CONFIG_SMP) && (defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_DIG))
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 0884f5e..5774c3b 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -93,14 +93,6 @@ static int irq_status[NR_IRQS] = {
 	[0 ... NR_IRQS -1] = IRQ_UNUSED
 };
 
-int check_irq_used(int irq)
-{
-	if (irq_status[irq] == IRQ_USED)
-		return 1;
-
-	return -1;
-}
-
 static inline int find_unassigned_irq(void)
 {
 	int irq;
