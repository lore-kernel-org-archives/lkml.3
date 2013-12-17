Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3LQWvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:51:45 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:48939 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3LQWvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:42 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 04/13] tick: Use timekeeping_cpu() to elect the CPU handling timekeeping duty
Date: Tue, 17 Dec 2013 23:51:23 +0100
Message-Id: <1387320692-28460-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have an API to determine if a CPU is allowed to handle
timekeeping duty, use it now on timekeeper selection time for clarity.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
---
 kernel/time/tick-common.c | 2 +-
 kernel/time/tick-sched.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 64522ec..755dcd6 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -163,7 +163,7 @@ static void tick_setup_device(struct tick_device *td,
 		 * this cpu:
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
-			if (!tick_nohz_full_cpu(cpu))
+			if (tick_timekeeping_cpu(cpu))
 				tick_do_timer_cpu = cpu;
 			else
 				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index df6432d..ea0d411 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -118,7 +118,7 @@ static void tick_sched_do_timer(ktime_t now)
 	 * jiffies_lock.
 	 */
 	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
-	    && !tick_nohz_full_cpu(cpu))
+	    && tick_timekeeping_cpu(cpu))
 		tick_do_timer_cpu = cpu;
 #endif
 
-- 
1.8.3.1

