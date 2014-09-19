Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaISLq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:46:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaISLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:46:57 -0400
Date: Fri, 19 Sep 2014 04:46:00 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-1ba93d42727c44001aa8ccffd39c8ab5705379e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1410529340.3569.27.camel@tkhai>
References: <1410529340.3569.27.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/dl: Simplify pick_dl_task()
Git-Commit-ID: 1ba93d42727c44001aa8ccffd39c8ab5705379e2
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

Commit-ID:  1ba93d42727c44001aa8ccffd39c8ab5705379e2
Gitweb:     http://git.kernel.org/tip/1ba93d42727c44001aa8ccffd39c8ab5705379e2
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Fri, 12 Sep 2014 17:42:20 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:20 +0200

sched/dl: Simplify pick_dl_task()

1) Nobody calls pick_dl_task() with negative cpu, it's old RT leftover.

2) If p->nr_cpus_allowed is 1, than the affinity has just been changed
  in set_cpus_allowed_ptr(); we'll pick it just earlier than migration
  thread.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1410529340.3569.27.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cc4eb89..aaa5abb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1121,10 +1121,8 @@ static void set_curr_task_dl(struct rq *rq)
 static int pick_dl_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
-	    (p->nr_cpus_allowed > 1))
+	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return 1;
-
 	return 0;
 }
 
