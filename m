Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaKKBwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:52:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:14563 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaKKBwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:52:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,357,1413270000"; 
   d="scan'208";a="605658784"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 1/2] sched/deadline: introduce start_hrtick_dl for !CONFIG_SCHED_HRTICK
Date: Tue, 11 Nov 2014 09:52:26 +0800
Message-Id: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce start_hrtick_dl for !CONFIG_SCHED_HRTICK to align with
fair class.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 04c2cbb..56674f6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1013,6 +1013,10 @@ static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
 	hrtick_start(rq, p->dl.runtime);
 }
+#else /* !CONFIG_SCHED_HRTICK */
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+}
 #endif
 
 static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
@@ -1066,10 +1070,8 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 	/* Running task will never be pushed. */
        dequeue_pushable_dl_task(rq, p);
 
-#ifdef CONFIG_SCHED_HRTICK
 	if (hrtick_enabled(rq))
 		start_hrtick_dl(rq, p);
-#endif
 
 	set_post_schedule(rq);
 
@@ -1088,10 +1090,8 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
 {
 	update_curr_dl(rq);
 
-#ifdef CONFIG_SCHED_HRTICK
 	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
 		start_hrtick_dl(rq, p);
-#endif
 }
 
 static void task_fork_dl(struct task_struct *p)
-- 
1.9.1

