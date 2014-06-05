Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaFEOh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:37:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaFEOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:37:54 -0400
Date: Thu, 5 Jun 2014 07:36:53 -0700
From: tip-bot for Giedrius Rekasius <tipbot@zytor.com>
Message-ID: <tip-0b07939cbfdd05bed0c5ec01b8b25493e6ecd34c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, giedrius.rekasius@gmail.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        giedrius.rekasius@gmail.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1401027811-30066-1-git-send-email-giedrius.rekasius@gmail.com>
References: <1401027811-30066-1-git-send-email-giedrius.rekasius@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove redundant assignment to "rt_rq"
  in update_curr_rt(...)
Git-Commit-ID: 0b07939cbfdd05bed0c5ec01b8b25493e6ecd34c
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

Commit-ID:  0b07939cbfdd05bed0c5ec01b8b25493e6ecd34c
Gitweb:     http://git.kernel.org/tip/0b07939cbfdd05bed0c5ec01b8b25493e6ecd34c
Author:     Giedrius Rekasius <giedrius.rekasius@gmail.com>
AuthorDate: Sun, 25 May 2014 15:23:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:34 +0200

sched: Remove redundant assignment to "rt_rq" in update_curr_rt(...)

Variable "rt_rq" is used only in block "for_each_sched_rt_entity" so the
value assigned to it at the beginning of the update_curr_rt(...) gets
overwritten without ever being read. Remove redundant assignment and
move variable declaration to the block in which it is being used.

Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-janitors@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/1401027811-30066-1-git-send-email-giedrius.rekasius@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 0ebfd7a..43406db 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -924,7 +924,6 @@ static void update_curr_rt(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_rt_entity *rt_se = &curr->rt;
-	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	u64 delta_exec;
 
 	if (curr->sched_class != &rt_sched_class)
@@ -949,7 +948,7 @@ static void update_curr_rt(struct rq *rq)
 		return;
 
 	for_each_sched_rt_entity(rt_se) {
-		rt_rq = rt_rq_of_se(rt_se);
+		struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
