Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbaISLqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:46:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaISLqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:46:05 -0400
Date: Fri, 19 Sep 2014 04:45:32 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f3cd1c4ec059c956d3346705e453aff3ace3b494@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1410529300.3569.25.camel@tkhai>
References: <1410529300.3569.25.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/core: Use put_prev_task()
  accessor where possible
Git-Commit-ID: f3cd1c4ec059c956d3346705e453aff3ace3b494
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

Commit-ID:  f3cd1c4ec059c956d3346705e453aff3ace3b494
Gitweb:     http://git.kernel.org/tip/f3cd1c4ec059c956d3346705e453aff3ace3b494
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Fri, 12 Sep 2014 17:41:40 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:19 +0200

sched/core: Use put_prev_task() accessor where possible

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1410529300.3569.25.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f7c6ed2..5536397 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3033,7 +3033,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	/*
 	 * Boosting condition are:
@@ -3586,7 +3586,7 @@ change:
 	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, attr);
@@ -4792,7 +4792,7 @@ void sched_setnuma(struct task_struct *p, int nid)
 	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	p->numa_preferred_nid = nid;
 
@@ -7374,7 +7374,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (queued)
 		dequeue_task(rq, tsk, 0);
 	if (unlikely(running))
-		tsk->sched_class->put_prev_task(rq, tsk);
+		put_prev_task(rq, tsk);
 
 	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
 				lockdep_is_held(&tsk->sighand->siglock)),
