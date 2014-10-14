Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaJNCXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:23:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:12722 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbaJNCXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:23:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,714,1406617200"; 
   d="scan'208";a="588396426"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 2/2] sched/deadline: don't need to balance during wakeup if wakee is pinned
Date: Tue, 14 Oct 2014 10:22:40 +0800
Message-Id: <1413253360-5318-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use nr_cpus_allowed to bail from select_task_rq() when only one cpu 
can be used, and saves some cycles for pinned tasks.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f46b7f1..5874bf8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -914,6 +914,9 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
+	if (p->nr_cpus_allowed == 1)
+		goto out;
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		goto out;
 
-- 
1.9.1

