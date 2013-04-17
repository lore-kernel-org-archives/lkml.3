Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965861Ab3DQJCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:02:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3DQJCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:02:38 -0400
Date: Wed, 17 Apr 2013 02:00:20 -0700
From: "tip-bot for Luck, Tony" <tipbot@zytor.com>
Message-ID: <tip-2412aa1293a4159c610616305c17efd237c8208d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        tony.luck@intel.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tony.luck@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <516d9a0c26048eae9c@agluck-desk.sc.intel.com>
References: <516d9a0c26048eae9c@agluck-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] ia64: Make sure interrupts enabled when we "
 safe_halt()"
Git-Commit-ID: 2412aa1293a4159c610616305c17efd237c8208d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 02:00:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2412aa1293a4159c610616305c17efd237c8208d
Gitweb:     http://git.kernel.org/tip/2412aa1293a4159c610616305c17efd237c8208d
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Tue, 16 Apr 2013 11:35:56 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Apr 2013 10:39:37 +0200

ia64: Make sure interrupts enabled when we "safe_halt()"

In commit d166991234347215dc23fc9dc15a63a83a1a54e1
   idle: Implement generic idle function
Thomas Gleixner cleaned up many things but perturbed some
fragile code that was keeping ia64 alive. So we started
seeing:
   WARNING: at kernel/cpu/idle.c:94 cpu_idle_loop+0x360/0x380()
and other unpleasantness like system hangs during boot.

We really shouldn't ever halt with interrupts disabled.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: magnus.damm@gmail.com
Link: http://lkml.kernel.org/r/516d9a0c26048eae9c@agluck-desk.sc.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/ia64/include/asm/irqflags.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/irqflags.h b/arch/ia64/include/asm/irqflags.h
index 2b68d85..1bf2cf2 100644
--- a/arch/ia64/include/asm/irqflags.h
+++ b/arch/ia64/include/asm/irqflags.h
@@ -89,6 +89,7 @@ static inline bool arch_irqs_disabled(void)
 
 static inline void arch_safe_halt(void)
 {
+	arch_local_irq_enable();
 	ia64_pal_halt_light();	/* PAL_HALT_LIGHT */
 }
 
