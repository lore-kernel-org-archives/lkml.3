Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937020Ab3DJKyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:54:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3DJKyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:54:17 -0400
Date: Wed, 10 Apr 2013 03:53:49 -0700
From: tip-bot for Zhang Hang <tipbot@zytor.com>
Message-ID: <tip-4e2dcb73aecbde9fe4e3137c9ea35cb6aa6cb286@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, bob.zhanghang@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, bob.zhanghang@huawei.com
In-Reply-To: <51650107.9040606@huawei.com>
References: <51650107.9040606@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify can_migrate_task()
Git-Commit-ID: 4e2dcb73aecbde9fe4e3137c9ea35cb6aa6cb286
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 03:53:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e2dcb73aecbde9fe4e3137c9ea35cb6aa6cb286
Gitweb:     http://git.kernel.org/tip/4e2dcb73aecbde9fe4e3137c9ea35cb6aa6cb286
Author:     Zhang Hang <bob.zhanghang@huawei.com>
AuthorDate: Wed, 10 Apr 2013 14:04:55 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 11:15:45 +0200

sched: Simplify can_migrate_task()

At this point tsk_cache_hot is always true, so no need to check it.

Signed-off-by: Zhang Hang <bob.zhanghang@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51650107.9040606@huawei.com
[ Also remove unnecessary schedstat #ifdefs. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 539760e..bf8ab4f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3921,20 +3921,17 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
-#ifdef CONFIG_SCHEDSTATS
+
 		if (tsk_cache_hot) {
 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
-#endif
+
 		return 1;
 	}
 
-	if (tsk_cache_hot) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
-		return 0;
-	}
-	return 1;
+	schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
+	return 0;
 }
 
 /*
