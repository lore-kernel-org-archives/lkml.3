Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3FLODM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:03:12 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37577 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3FLOCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:02:54 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 6/6] nohz: Remove obsolete check for full dynticks CPUs to be RCU nocbs
Date: Wed, 12 Jun 2013 16:02:38 +0200
Message-Id: <1371045758-5296-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building full dynticks now implies that all CPUs are forced
into RCU nocb mode through CONFIG_RCU_NOCB_CPU_ALL.

The dynamic check has become useless.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
---
 kernel/time/tick-sched.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 917b871..91e2ab9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -356,16 +356,6 @@ void __init tick_nohz_init(void)
 	}
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-
-	/* Make sure full dynticks CPU are also RCU nocbs */
-	for_each_cpu(cpu, nohz_full_mask) {
-		if (!rcu_is_nocb_cpu(cpu)) {
-			pr_warning("NO_HZ: CPU %d is not RCU nocb: "
-				   "cleared from nohz_full range", cpu);
-			cpumask_clear_cpu(cpu, nohz_full_mask);
-		}
-	}
-
 	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
 }
-- 
1.7.5.4

