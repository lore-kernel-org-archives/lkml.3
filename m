Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161502AbaJ3Wkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:40:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:46204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161393AbaJ3Wj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:39:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,289,1413270000"; 
   d="scan'208";a="623777863"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3 6/6] sched/deadline: don't check CONFIG_SMP in switched_from_dl
Date: Fri, 31 Oct 2014 06:39:36 +0800
Message-Id: <1414708776-124078-6-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
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
index 2b23d50..c262eeb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1617,7 +1617,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 
 	__dl_clear_params(p);
 
-#ifdef CONFIG_SMP
 	/*
 	 * Since this might be the only -deadline task on the rq,
 	 * this is the right place to try to pull some other one
@@ -1628,7 +1627,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 
 	if (pull_dl_task(rq))
 		resched_curr(rq);
-#endif
 }
 
 /*
-- 
1.9.1

