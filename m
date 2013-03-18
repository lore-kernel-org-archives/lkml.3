Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3CRLKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:10:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34202 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3CRLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:10:46 -0400
Date: Mon, 18 Mar 2013 04:09:05 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-a8d7ad52a7befbde896276d05c75c90fed48b5bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, pjt@google.com,
        peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, pjt@google.com,
        efault@gmx.de, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1363254519.26965.9.camel@laptop>
References: <1363254519.26965.9.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/tracing:
  Allow tracing the preemption decision on wakeup
Git-Commit-ID: a8d7ad52a7befbde896276d05c75c90fed48b5bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:09:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8d7ad52a7befbde896276d05c75c90fed48b5bf
Gitweb:     http://git.kernel.org/tip/a8d7ad52a7befbde896276d05c75c90fed48b5bf
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 14 Mar 2013 10:48:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Mar 2013 10:18:08 +0100

sched/tracing: Allow tracing the preemption decision on wakeup

Thomas noted that we do the wakeup preemption check after the
wakeup trace point, this means the tracepoint cannot test/report
this decision; which is rather important for latency sensitive
workloads. Therefore move the tracepoint after doing the
preemption check.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Link: http://lkml.kernel.org/r/1363254519.26965.9.camel@laptop
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
