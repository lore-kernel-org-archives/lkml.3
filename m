Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaBKMTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:19:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaBKMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:19:38 -0500
Date: Tue, 11 Feb 2014 04:17:56 -0800
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-y2nbw5j3ma5siy5584919z5i@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, lethal@linux-sh.org,
        benh@kernel.crashing.org, linux@arm.linux.org.uk,
        preeti@linux.vnet.ibm.com, nico@linaro.org, rjw@rjwysocki.net,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, lethal@linux-sh.org,
        benh@kernel.crashing.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle, ARM:
  Remove redundant cpuidle_idle_call()
Git-Commit-ID: ad68cc7a777948b77f15a3dc3510918ff87ed0c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:18:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad68cc7a777948b77f15a3dc3510918ff87ed0c0
Gitweb:     http://git.kernel.org/tip/ad68cc7a777948b77f15a3dc3510918ff87ed0c0
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Wed, 29 Jan 2014 12:45:09 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:22 +0100

sched/idle, ARM: Remove redundant cpuidle_idle_call()

The core idle loop now takes care of it.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-sh@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linaro-kernel@lists.linaro.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-y2nbw5j3ma5siy5584919z5i@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/kernel/process.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15..adabeab 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -30,7 +30,6 @@
 #include <linux/uaccess.h>
 #include <linux/random.h>
 #include <linux/hw_breakpoint.h>
-#include <linux/cpuidle.h>
 #include <linux/leds.h>
 #include <linux/reboot.h>
 
@@ -133,7 +132,11 @@ EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 void (*arm_pm_idle)(void);
 
-static void default_idle(void)
+/*
+ * Called from the core idle loop.
+ */
+
+void arch_cpu_idle(void)
 {
 	if (arm_pm_idle)
 		arm_pm_idle();
@@ -168,15 +171,6 @@ void arch_cpu_idle_dead(void)
 #endif
 
 /*
- * Called from the core idle loop.
- */
-void arch_cpu_idle(void)
-{
-	if (cpuidle_idle_call())
-		default_idle();
-}
-
-/*
  * Called by kexec, immediately prior to machine_kexec().
  *
  * This must completely disable all secondary CPUs; simply causing those CPUs
