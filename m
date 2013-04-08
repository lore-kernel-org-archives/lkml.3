Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3DHUtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:49:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41128 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964790Ab3DHUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:49:15 -0400
Date: Mon, 8 Apr 2013 13:48:56 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f4e2e9a4b26789d963000f974f2dc80230bb4674@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, chris@zankel.net,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        chris@zankel.net, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215235.546600507@linutronix.de>
References: <20130321215235.546600507@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] xtensa: Use generic idle loop
Git-Commit-ID: f4e2e9a4b26789d963000f974f2dc80230bb4674
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:49:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4e2e9a4b26789d963000f974f2dc80230bb4674
Gitweb:     http://git.kernel.org/tip/f4e2e9a4b26789d963000f974f2dc80230bb4674
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:50:04 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:29 +0200

xtensa: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Chris Zankel <chris@zankel.net>
Link: http://lkml.kernel.org/r/20130321215235.546600507@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/xtensa/Kconfig          |  1 +
 arch/xtensa/kernel/process.c | 14 ++------------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index b09de49..e0144ff 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -19,6 +19,7 @@ config XTENSA
 	select CLONE_BACKWARDS
 	select IRQ_DOMAIN
 	select HAVE_OPROFILE
+	select GENERIC_IDLE_LOOP
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 5cd82e9..1c85323 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -105,19 +105,9 @@ void coprocessor_flush_all(struct thread_info *ti)
 /*
  * Powermanagement idle function, if any is provided by the platform.
  */
-
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	local_irq_enable();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			platform_idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
+	platform_idle();
 }
 
 /*
