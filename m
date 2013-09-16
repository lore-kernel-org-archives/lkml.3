Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3IPI25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab3IPI2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:28:55 -0400
Date: Mon, 16 Sep 2013 11:30:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] sched: tweak comment for sched_info_depart
Message-ID: <20130916083036.GA1113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_info_depart seems to be only called from sched_info_switch,
so only on involuntary task switch.
Tweak comment to match.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 kernel/sched/stats.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 891ccab..2e63fc7 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -115,8 +115,9 @@ static inline void sched_info_queued(struct rq *rq, struct task_struct *t)
 }
 
 /*
- * Called when a process ceases being the active-running process, either
- * voluntarily or involuntarily.  Now we can calculate how long we ran.
+ * Called when a process ceases being the active-running process involuntarily
+ * due, typically, to expiring its time slice (this may also be called when
+ * switching to the idle task).  Now we can calculate how long we ran.
  * Also, if the process is still in the TASK_RUNNING state, call
  * sched_info_queued() to mark that it has now again started waiting on
  * the runqueue.
-- 
MST
