Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaILNlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:41:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:35656 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaILNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:41:44 -0400
Message-ID: <1410529300.3569.25.camel@tkhai>
Subject: [PATCH 3/5] sched/core: Use put_prev_task() accessor where possible.
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Fri, 12 Sep 2014 17:41:40 +0400
In-Reply-To: <20140912132709.26840.4893.stgit@tkhai>
References: <20140912132709.26840.4893.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 07d67dd..d4399b4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2998,7 +2998,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	/*
 	 * Boosting condition are:
@@ -3551,7 +3551,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, attr);
@@ -4757,7 +4757,7 @@ void sched_setnuma(struct task_struct *p, int nid)
 	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	p->numa_preferred_nid = nid;
 
@@ -7339,7 +7339,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (queued)
 		dequeue_task(rq, tsk, 0);
 	if (unlikely(running))
-		tsk->sched_class->put_prev_task(rq, tsk);
+		put_prev_task(rq, tsk);
 
 	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
 				lockdep_is_held(&tsk->sighand->siglock)),



