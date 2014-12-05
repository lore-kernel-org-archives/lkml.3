Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaLEGWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:22:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:63099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaLEGWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:22:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,521,1413270000"; 
   d="scan'208";a="619014181"
From: jun.zhang@intel.com
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhang jun <jun.zhang@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Changcheng Liu <changcheng.liu@intel.com>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched/fair: fix find_idlest_cpu return -1
Date: Fri,  5 Dec 2014 13:58:01 +0800
Message-Id: <1417759082-28385-1-git-send-email-jun.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhang jun <jun.zhang@intel.com>

find_idlest_cpu return -1 is not reasonable, set default value to this_cpu.

Signed-off-by: zhang jun <jun.zhang@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: <stable@vger.kernel.org> # 3.14.25
---
 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b4c4f3..9d18887 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4151,7 +4151,7 @@ static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
-	int idlest = -1;
+	int idlest = this_cpu;
 	int i;
 
 	/* Traverse only the allowed CPUs */
@@ -4284,7 +4284,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 		}
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
+		if (new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
 			continue;
-- 
1.7.9.5

