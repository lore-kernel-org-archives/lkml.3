Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaJNCWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:22:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:58091 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbaJNCWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,714,1406617200"; 
   d="scan'208";a="588396395"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 1/2] sched/deadline: don't need to check SD_BALANCE_FORK
Date: Tue, 14 Oct 2014 10:22:39 +0800
Message-Id: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to do balance during fork since SCHED_DEADLINE 
tasks can't fork. This patch avoid the SD_BALANCE_FORK check.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index abfaf3d..f46b7f1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -914,7 +914,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
-	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
+	if (sd_flag != SD_BALANCE_WAKE)
 		goto out;
 
 	rq = cpu_rq(cpu);
-- 
1.9.1

