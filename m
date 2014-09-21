Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaIUHHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 03:07:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaIUHG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 03:06:59 -0400
Date: Sun, 21 Sep 2014 00:06:35 -0700
From: tip-bot for Zhihui Zhang <tipbot@zytor.com>
Message-ID: <tip-9c58c79a8a76c510cd3a5012c536d4fe3c81ec3b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zzhsuny@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zzhsuny@gmail.com, tglx@linutronix.de
In-Reply-To: <1411262676-19928-1-git-send-email-zzhsuny@gmail.com>
References: <1411262676-19928-1-git-send-email-zzhsuny@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Clean up some typos and grammatical errors in code/comments
Git-Commit-ID: 9c58c79a8a76c510cd3a5012c536d4fe3c81ec3b
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

Commit-ID:  9c58c79a8a76c510cd3a5012c536d4fe3c81ec3b
Gitweb:     http://git.kernel.org/tip/9c58c79a8a76c510cd3a5012c536d4fe3c81ec3b
Author:     Zhihui Zhang <zzhsuny@gmail.com>
AuthorDate: Sat, 20 Sep 2014 21:24:36 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Sep 2014 09:00:02 +0200

sched: Clean up some typos and grammatical errors in code/comments

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1411262676-19928-1-git-send-email-zzhsuny@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 4 ++--
 kernel/sched/fair.c  | 6 +++---
 kernel/sched/sched.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 61ee2b3..a284190 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8069,7 +8069,7 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 		struct cfs_bandwidth *parent_b = &tg->parent->cfs_bandwidth;
 
 		quota = normalize_cfs_quota(tg, d);
-		parent_quota = parent_b->hierarchal_quota;
+		parent_quota = parent_b->hierarchical_quota;
 
 		/*
 		 * ensure max(child_quota) <= parent_quota, inherit when no
@@ -8080,7 +8080,7 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 		else if (parent_quota != RUNTIME_INF && quota > parent_quota)
 			return -EINVAL;
 	}
-	cfs_b->hierarchal_quota = quota;
+	cfs_b->hierarchical_quota = quota;
 
 	return 0;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 74fa2c2..2a1e6ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2224,8 +2224,8 @@ static __always_inline u64 decay_load(u64 val, u64 n)
 
 	/*
 	 * As y^PERIOD = 1/2, we can combine
-	 *    y^n = 1/2^(n/PERIOD) * k^(n%PERIOD)
-	 * With a look-up table which covers k^n (n<PERIOD)
+	 *    y^n = 1/2^(n/PERIOD) * y^(n%PERIOD)
+	 * With a look-up table which covers y^n (n<PERIOD)
 	 *
 	 * To achieve constant time decay_load.
 	 */
@@ -6410,7 +6410,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/*
-	 * If the local group is more busy than the selected busiest group
+	 * If the local group is busier than the selected busiest group
 	 * don't try and pull any tasks.
 	 */
 	if (local->avg_load >= busiest->avg_load)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index aa0f73b..1bc6aad 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -188,7 +188,7 @@ struct cfs_bandwidth {
 	raw_spinlock_t lock;
 	ktime_t period;
 	u64 quota, runtime;
-	s64 hierarchal_quota;
+	s64 hierarchical_quota;
 	u64 runtime_expires;
 
 	int idle, timer_active;
