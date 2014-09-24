Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaIXO6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:58:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaIXO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:58:43 -0400
Date: Wed, 24 Sep 2014 07:57:48 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-8aa6f0ebf41b5fdd186276394bf07e7bd6884d94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140922183642.11015.66039.stgit@localhost>
References: <20140922183642.11015.66039.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Use resched_curr() in task_tick_rt()
Git-Commit-ID: 8aa6f0ebf41b5fdd186276394bf07e7bd6884d94
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

Commit-ID:  8aa6f0ebf41b5fdd186276394bf07e7bd6884d94
Gitweb:     http://git.kernel.org/tip/8aa6f0ebf41b5fdd186276394bf07e7bd6884d94
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 22 Sep 2014 22:36:43 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:12 +0200

sched/rt: Use resched_curr() in task_tick_rt()

Some time ago PREEMPT_NEED_RESCHED was implemented,
so reschedule technics is a little more difficult now.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140922183642.11015.66039.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2e6a774..87ea5bf 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2072,7 +2072,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	for_each_sched_rt_entity(rt_se) {
 		if (rt_se->run_list.prev != rt_se->run_list.next) {
 			requeue_task_rt(rq, p, 0);
-			set_tsk_need_resched(p);
+			resched_curr(rq);
 			return;
 		}
 	}
