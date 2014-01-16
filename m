Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaAPNkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:40:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaAPNkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:40:41 -0500
Date: Thu, 16 Jan 2014 05:40:01 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-71362650b555a5b24c732e455484cc7cac1c8588@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dan.carpenter@oracle.com,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com,
        dan.carpenter@oracle.com
In-Reply-To: <52D54E25.6060100@gmail.com>
References: <52D54E25.6060100@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  No need to check p if dl_se is valid
Git-Commit-ID: 71362650b555a5b24c732e455484cc7cac1c8588
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:40:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71362650b555a5b24c732e455484cc7cac1c8588
Gitweb:     http://git.kernel.org/tip/71362650b555a5b24c732e455484cc7cac1c8588
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Tue, 14 Jan 2014 12:03:51 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:11 +0100

sched/deadline: No need to check p if dl_se is valid

Dan Carpenter reported new 'Smatch' warnings:

  > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
  > head:   130816ce4d5f69167324f7272e70aa3d641677c6
  > commit: 1baca4ce16b8cc7d4f50be1f7914799af30a2861 [17/50] sched/deadline: Add SCHED_DEADLINE SMP-related data structures & logic
  >
  > kernel/sched/deadline.c:937 pick_next_task_dl() warn: variable dereferenced before check 'p' (see line 934)

BUG_ON() already fires if pick_next_dl_entity() doesn't return a valid
dl_se. No need to check if p is valid afterward.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Fixes: 1baca4ce16b8 ("sched/deadline: Add SCHED_DEADLINE SMP-related data structures & logic")
Link: http://lkml.kernel.org/r/52D54E25.6060100@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ee25361..0de2482 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1007,8 +1007,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq)
 	p->se.exec_start = rq_clock_task(rq);
 
 	/* Running task will never be pushed. */
-	if (p)
-		dequeue_pushable_dl_task(rq, p);
+       dequeue_pushable_dl_task(rq, p);
 
 #ifdef CONFIG_SCHED_HRTICK
 	if (hrtick_enabled(rq))
