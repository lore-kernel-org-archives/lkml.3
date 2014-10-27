Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaJ0Bmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:42:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:52739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaJ0Bmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="scan'208";a="621089550"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 6/6] sched/dl: don't check CONFIG_SMP in switched_from_dl
Date: Mon, 27 Oct 2014 09:41:07 +0800
Message-Id: <1414374067-7209-6-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are both UP and SMP version of pull_dl_task(), so don't need 
to check CONFIG_SMP in switched_from_dl();

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 21de865..35d6dd5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1577,7 +1577,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 
 	__dl_clear_params(p);
 
-#ifdef CONFIG_SMP
 	/*
 	 * Since this might be the only -deadline task on the rq,
 	 * this is the right place to try to pull some other one
@@ -1585,7 +1584,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 */
 	if (!rq->dl.dl_nr_running && pull_dl_task(rq))
 			resched_curr(rq);
-#endif
 }
 
 /*
-- 
1.9.1

