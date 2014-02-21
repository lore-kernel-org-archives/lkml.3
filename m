Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaBUVhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:37:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaBUVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:37:51 -0500
Date: Fri, 21 Feb 2014 13:35:00 -0800
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-wk9vpc8dsn46s12pl602ljpo@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, catalin.marinas@arm.com, peterz@infradead.org,
        nicolas.pitre@linaro.org, paul.burton@imgtec.com,
        preeti@linux.vnet.ibm.com, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org,
        deepthi@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        peterz@infradead.org, nicolas.pitre@linaro.org, paul.burton@imgtec.com,
        preeti@linux.vnet.ibm.com, nico@linaro.org, rjw@rjwysocki.net,
        tglx@linutronix.de, daniel.lezcano@linaro.org,
        deepthi@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpuidle/arm64:
  remove redundant cpuidle_idle_call()
Git-Commit-ID: b821bb70a1af0d1063ca6c7790a3636b610c0ca2
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

Commit-ID:  b821bb70a1af0d1063ca6c7790a3636b610c0ca2
Gitweb:     http://git.kernel.org/tip/b821bb70a1af0d1063ca6c7790a3636b610c0ca2
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Mon, 17 Feb 2014 10:59:30 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:21 +0100

cpuidle/arm64: remove redundant cpuidle_idle_call()

The core idle loop now takes care of it.

Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-wk9vpc8dsn46s12pl602ljpo@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm64/kernel/process.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1c0a9be..9cce009 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -33,7 +33,6 @@
 #include <linux/kallsyms.h>
 #include <linux/init.h>
 #include <linux/cpu.h>
-#include <linux/cpuidle.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
 #include <linux/tick.h>
@@ -94,10 +93,8 @@ void arch_cpu_idle(void)
 	 * This should do all the clock switching and wait for interrupt
 	 * tricks
 	 */
-	if (cpuidle_idle_call()) {
-		cpu_do_idle();
-		local_irq_enable();
-	}
+	cpu_do_idle();
+	local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
