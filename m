Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152Ab3DHUmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:42:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935919Ab3DHUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:42:08 -0400
Date: Mon, 8 Apr 2013 13:41:44 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-99444202b924e916aad95073d23f9995ae8eb558@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, lennox.wu@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        lennox.wu@gmail.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215235.147909863@linutronix.de>
References: <20130321215235.147909863@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] score: Use generic idle loop
Git-Commit-ID: 99444202b924e916aad95073d23f9995ae8eb558
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:41:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99444202b924e916aad95073d23f9995ae8eb558
Gitweb:     http://git.kernel.org/tip/99444202b924e916aad95073d23f9995ae8eb558
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:58 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:28 +0200

score: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Link: http://lkml.kernel.org/r/20130321215235.147909863@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/score/Kconfig          |  1 +
 arch/score/kernel/process.c | 18 ------------------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index c8def8b..eaac45d 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -11,6 +11,7 @@ config SCORE
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
+       select GENERIC_IDLE_LOOP
        select HAVE_MOD_ARCH_SPECIFIC
 	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index 7956846..f4c6d02 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -41,24 +41,6 @@ void machine_halt(void) {}
 /* If or when software machine-power-off is implemented, add code here. */
 void machine_power_off(void) {}
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void __noreturn cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			barrier();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void ret_from_fork(void);
 void ret_from_kernel_thread(void);
 
