Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbaBHGSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 01:18:45 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:22855 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBHGSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 01:18:44 -0500
Message-ID: <52F5CBF6.4060901@huawei.com>
Date: Sat, 8 Feb 2014 14:17:26 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] sched/rt: Remove leaf_rt_rq_list from struct rq
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a leftover from commit e23ee74777f389369431d77390c4b09332ce026a
("sched/rt: Simplify pull_rt_task() logic and remove .leaf_rt_rq_list").

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/core.c  | 1 -
 kernel/sched/sched.h | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..1f7d88a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6277,7 +6277,6 @@ void __init sched_init(void)
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
-		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b2..1c83665 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -438,10 +438,6 @@ struct rq {
 	struct list_head leaf_cfs_rq_list;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct list_head leaf_rt_rq_list;
-#endif
-
 	/*
 	 * This is part of a global counter where only the total sum
 	 * over all CPUs matters. A task can increase this counter on
-- 
1.8.0.2
