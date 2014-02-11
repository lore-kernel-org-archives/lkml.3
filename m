Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaBKMUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:20:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaBKMUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:20:00 -0500
Date: Tue, 11 Feb 2014 04:18:21 -0800
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-v2c3oswyd80xk2vh7fwmu6r8@git.kernel.org>
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
Subject: [tip:sched/core] sched/idle, SH:
  Remove redundant cpuidle_idle_call()
Git-Commit-ID: f0c5cdb5cf89e56bdef9d71da89d4966dea6ef71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:18:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0c5cdb5cf89e56bdef9d71da89d4966dea6ef71
Gitweb:     http://git.kernel.org/tip/f0c5cdb5cf89e56bdef9d71da89d4966dea6ef71
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Wed, 29 Jan 2014 12:45:11 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:26 +0100

sched/idle, SH: Remove redundant cpuidle_idle_call()

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
Link: http://lkml.kernel.org/n/tip-v2c3oswyd80xk2vh7fwmu6r8@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sh/kernel/idle.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 2ea4483..be616ee 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -16,7 +16,6 @@
 #include <linux/thread_info.h>
 #include <linux/irqflags.h>
 #include <linux/smp.h>
-#include <linux/cpuidle.h>
 #include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/smp.h>
@@ -40,8 +39,7 @@ void arch_cpu_idle_dead(void)
 
 void arch_cpu_idle(void)
 {
-	if (cpuidle_idle_call())
-		sh_idle();
+	sh_idle();
 }
 
 void __init select_idle_routine(void)
