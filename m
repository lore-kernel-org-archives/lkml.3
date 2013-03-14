Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3CNJs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:48:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60342 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab3CNJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:48:53 -0400
Message-ID: <1363254519.26965.9.camel@laptop>
Subject: [PATCH] sched,trace: Allow tracing the preemption decision on wakeup
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Mar 2013 10:48:39 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas noted that we do the wakeup preemption check after the wakeup
trace point, this means the tracepoint cannot test/report this decision;
which is rather important for latency sensitive workloads. Therefore
move the tracepoint after doing the preemption check.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b36635e..849deb9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1288,8 +1288,8 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 static void
 ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
-	trace_sched_wakeup(p, true);
 	check_preempt_curr(rq, p, wake_flags);
+	trace_sched_wakeup(p, true);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP


