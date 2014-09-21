Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaIUBYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 21:24:49 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:49607 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaIUBYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 21:24:48 -0400
From: Zhihui Zhang <zzhsuny@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [sched] Clean up some typos and grammatical errors in code/comments
Date: Sat, 20 Sep 2014 21:24:36 -0400
Message-Id: <1411262676-19928-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, the subject line says it all.

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 kernel/sched/core.c  | 4 ++--
 kernel/sched/fair.c  | 6 +++---
 kernel/sched/sched.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec1a286..eb5505f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8005,7 +8005,7 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 		struct cfs_bandwidth *parent_b = &tg->parent->cfs_bandwidth;
 
 		quota = normalize_cfs_quota(tg, d);
-		parent_quota = parent_b->hierarchal_quota;
+		parent_quota = parent_b->hierarchical_quota;
 
 		/*
 		 * ensure max(child_quota) <= parent_quota, inherit when no
@@ -8016,7 +8016,7 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 		else if (parent_quota != RUNTIME_INF && quota > parent_quota)
 			return -EINVAL;
 	}
-	cfs_b->hierarchal_quota = quota;
+	cfs_b->hierarchical_quota = quota;
 
 	return 0;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..6d83845 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2211,8 +2211,8 @@ static __always_inline u64 decay_load(u64 val, u64 n)
 
 	/*
 	 * As y^PERIOD = 1/2, we can combine
-	 *    y^n = 1/2^(n/PERIOD) * k^(n%PERIOD)
-	 * With a look-up table which covers k^n (n<PERIOD)
+	 *    y^n = 1/2^(n/PERIOD) * y^(n%PERIOD)
+	 * With a look-up table which covers y^n (n<PERIOD)
 	 *
 	 * To achieve constant time decay_load.
 	 */
@@ -6346,7 +6346,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/*
-	 * If the local group is more busy than the selected busiest group
+	 * If the local group is busier than the selected busiest group
 	 * don't try and pull any tasks.
 	 */
 	if (local->avg_load >= busiest->avg_load)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f..80b124d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -184,7 +184,7 @@ struct cfs_bandwidth {
 	raw_spinlock_t lock;
 	ktime_t period;
 	u64 quota, runtime;
-	s64 hierarchal_quota;
+	s64 hierarchical_quota;
 	u64 runtime_expires;
 
 	int idle, timer_active;
-- 
1.8.1.2

