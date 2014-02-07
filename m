Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaBGT6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:58:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:48247 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaBGT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:58:53 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/6] sched: Check for idle task in might_sleep()
Date: Fri,  7 Feb 2014 20:58:38 +0100
Message-Id: <1391803122-4425-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Idle is not allowed to call sleeping functions ever!

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 64f75f9..fbaec2a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6938,7 +6938,8 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
+	     !is_idle_task(current)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
-- 
1.9.rc1

