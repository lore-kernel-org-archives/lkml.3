Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3LCMf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:35:56 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47518 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3LCMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:35:52 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] nohz_full: fix code sytle issue of tick_nohz_full_stop_tick
Date: Tue,  3 Dec 2013 20:35:10 +0800
Message-Id: <1386074112-30754-2-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386074112-30754-1-git-send-email-alex.shi@linaro.org>
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code usually starts with 'tab' instead of 7 'space'es in kernel

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/time/tick-sched.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..b55d1c0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -681,18 +681,18 @@ out:
 static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 {
 #ifdef CONFIG_NO_HZ_FULL
-       int cpu = smp_processor_id();
+	int cpu = smp_processor_id();
 
-       if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
-               return;
+	if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+		return;
 
-       if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
-	       return;
+	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+		return;
 
-       if (!can_stop_full_tick())
-               return;
+	if (!can_stop_full_tick())
+		return;
 
-       tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
 #endif
 }
 
-- 
1.8.1.2

