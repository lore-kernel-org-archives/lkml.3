Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbaBUVdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:33:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaBUVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:33:10 -0500
Date: Fri, 21 Feb 2014 13:32:36 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-673ca1919f2b0b83a377395454d5edd12f946bbf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <52F5CBF6.4060901@huawei.com>
References: <52F5CBF6.4060901@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Remove leaf_rt_rq_list from struct rq
Git-Commit-ID: 673ca1919f2b0b83a377395454d5edd12f946bbf
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

Commit-ID:  673ca1919f2b0b83a377395454d5edd12f946bbf
Gitweb:     http://git.kernel.org/tip/673ca1919f2b0b83a377395454d5edd12f946bbf
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Sat, 8 Feb 2014 14:17:26 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:19 +0100

sched/rt: Remove leaf_rt_rq_list from struct rq

This is a leftover from commit e23ee74777f389369431d77390c4b09332ce026a
("sched/rt: Simplify pull_rt_task() logic and remove .leaf_rt_rq_list").

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/52F5CBF6.4060901@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c  | 1 -
 kernel/sched/sched.h | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1687de..67a24fa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6884,7 +6884,6 @@ void __init sched_init(void)
 
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
