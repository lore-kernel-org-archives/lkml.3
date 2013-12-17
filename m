Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3LQWwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:52:45 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:65392 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3LQWvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:51 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 12/13] nohz: Allow all CPUs outside nohz_full range to do timekeeping
Date: Tue, 17 Dec 2013 23:51:31 +0100
Message-Id: <1387320692-28460-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have all the infrastructure in place and ready to support
timekeeping duty balanced across every non full dynticks CPUs, we can
hereby extend the timekeeping duty affinity.

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
 include/linux/tick.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index bd3c32e..07c02e8 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -203,15 +203,7 @@ static inline int tick_timekeeping_default_cpu(void)
  */
 static inline bool tick_timekeeping_cpu(int cpu)
 {
-	/*
-	 * If there are full dynticks CPUs around,
-	 * CPU 0 must stay periodic to update timekeeping.
-	 */
-	if (tick_nohz_full_enabled())
-		return cpu == 0;
-
-	/* Otherwise any CPU is elligible for timekeeping duty */
-	return true;
+	return !tick_nohz_full_cpu(cpu);
 }
 
 extern void tick_nohz_init(void);
-- 
1.8.3.1

