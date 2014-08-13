Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaHMTWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:22:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaHMTWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:22:19 -0400
Date: Wed, 13 Aug 2014 21:19:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] sched: s/do_each_thread/for_each_process_thread/ in
	core.c
Message-ID: <20140813191953.GA19315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813191938.GA19301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kernel/sched/core.c to use for_each_process_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1211575..8a6506f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4505,7 +4505,7 @@ void show_state_filter(unsigned long state_filter)
 		"  task                        PC stack   pid father\n");
 #endif
 	rcu_read_lock();
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/*
 		 * reset the NMI-timeout, listing all files on a slow
 		 * console might take a lot of time:
@@ -4513,7 +4513,7 @@ void show_state_filter(unsigned long state_filter)
 		touch_nmi_watchdog();
 		if (!state_filter || (p->state & state_filter))
 			sched_show_task(p);
-	} while_each_thread(g, p);
+	}
 
 	touch_all_softlockup_watchdogs();
 
@@ -7138,7 +7138,7 @@ void normalize_rt_tasks(void)
 	struct rq *rq;
 
 	read_lock_irqsave(&tasklist_lock, flags);
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
 		 */
@@ -7169,8 +7169,7 @@ void normalize_rt_tasks(void)
 
 		__task_rq_unlock(rq);
 		raw_spin_unlock(&p->pi_lock);
-	} while_each_thread(g, p);
-
+	}
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
@@ -7358,10 +7357,10 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 {
 	struct task_struct *g, *p;
 
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		if (rt_task(p) && task_rq(p)->rt.tg == tg)
 			return 1;
-	} while_each_thread(g, p);
+	}
 
 	return 0;
 }
-- 
1.5.5.1

