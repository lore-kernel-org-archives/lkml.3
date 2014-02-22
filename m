Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBVSDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:03:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaBVSDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:03:36 -0500
Date: Sat, 22 Feb 2014 10:03:01 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-d82fd25356b902703152c1800845661835541878@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <52F5CBF6.4060901@huawei.com>
References: <52F5CBF6.4060901@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Remove 'leaf_rt_rq_list' from '
 struct rq'
Git-Commit-ID: d82fd25356b902703152c1800845661835541878
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

Commit-ID:  d82fd25356b902703152c1800845661835541878
Gitweb:     http://git.kernel.org/tip/d82fd25356b902703152c1800845661835541878
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Sat, 8 Feb 2014 14:17:26 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:10:43 +0100

sched/rt: Remove 'leaf_rt_rq_list' from 'struct rq'

This is a leftover from commit e23ee74777f389369431d77390c4b09332ce026a
("sched/rt: Simplify pull_rt_task() logic and remove .leaf_rt_rq_list").

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/52F5CBF6.4060901@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 1 -
 kernel/sched/sched.h | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 003263b..cc4965e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6876,7 +6876,6 @@ void __init sched_init(void)
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
-		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index caf4abd..d608125 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -543,10 +543,6 @@ struct rq {
 	struct list_head leaf_cfs_rq_list;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct list_head leaf_rt_rq_list;
-#endif
-
 	/*
 	 * This is part of a global counter where only the total sum
 	 * over all CPUs matters. A task can increase this counter on
