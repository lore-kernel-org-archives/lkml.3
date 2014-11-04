Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaKDQMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:12:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaKDQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:12:42 -0500
Date: Tue, 4 Nov 2014 08:11:40 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-6b0a563f3a534827c1b56e53c3fd0fccec3c7895@git.kernel.org>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, ktkhai@parallels.com,
        wanpeng.li@linux.intel.com, tglx@linutronix.de, peterz@infradead.org,
        juri.lelli@arm.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Reply-To: hpa@zytor.com, ktkhai@parallels.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, juri.lelli@arm.com,
        peterz@infradead.org, tglx@linutronix.de, wanpeng.li@linux.intel.com
In-Reply-To: <1414708776-124078-4-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-4-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Push task away if the deadline is equal to curr during wakeup
Git-Commit-ID: 6b0a563f3a534827c1b56e53c3fd0fccec3c7895
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

Commit-ID:  6b0a563f3a534827c1b56e53c3fd0fccec3c7895
Gitweb:     http://git.kernel.org/tip/6b0a563f3a534827c1b56e53c3fd0fccec3c7895
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Fri, 31 Oct 2014 06:39:34 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:55 +0100

sched/deadline: Push task away if the deadline is equal to curr during wakeup

This patch pushes task away if the dealine of the task is equal
to current during wake up. The same behavior as rt class.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414708776-124078-4-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8867a67..e7779b3 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1506,7 +1506,7 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
 	    p->nr_cpus_allowed > 1 &&
 	    dl_task(rq->curr) &&
 	    (rq->curr->nr_cpus_allowed < 2 ||
-	     dl_entity_preempt(&rq->curr->dl, &p->dl))) {
+	     !dl_entity_preempt(&p->dl, &rq->curr->dl))) {
 		push_dl_tasks(rq);
 	}
 }
