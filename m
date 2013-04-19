Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3DSTL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:11:27 -0400
Received: from mail1.windriver.com ([147.11.146.13]:43915 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3DSTLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:11:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCHv2 2/2] sched: move update_load_[add/sub/set] from sched.h to fair.c
Date: Fri, 19 Apr 2013 15:10:50 -0400
Message-ID: <1366398650-31599-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366398650-31599-1-git-send-email-paul.gortmaker@windriver.com>
References: <1366398650-31599-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These inlines are only used by kernel/sched/fair.c so they do not
need to be present in the main kernel/sched/sched.h file.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched/fair.c  | 18 ++++++++++++++++++
 kernel/sched/sched.h | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 68324a9..82f160c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -113,6 +113,24 @@ unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
 #endif
 
+static inline void update_load_add(struct load_weight *lw, unsigned long inc)
+{
+	lw->weight += inc;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
+{
+	lw->weight -= dec;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_set(struct load_weight *lw, unsigned long w)
+{
+	lw->weight = w;
+	lw->inv_weight = 0;
+}
+
 /*
  * Increase the granularity value when there are more CPUs,
  * because with more CPUs the 'effective latency' as visible
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 49d4114..c9c1cdb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -888,24 +888,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #define WF_FORK		0x02		/* child wakeup after fork */
 #define WF_MIGRATED	0x4		/* internal use, task got migrated */
 
-static inline void update_load_add(struct load_weight *lw, unsigned long inc)
-{
-	lw->weight += inc;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
-{
-	lw->weight -= dec;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_set(struct load_weight *lw, unsigned long w)
-{
-	lw->weight = w;
-	lw->inv_weight = 0;
-}
-
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
-- 
1.8.1.2

