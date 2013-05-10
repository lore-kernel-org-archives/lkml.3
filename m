Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab3EJPSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:18:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:13258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662Ab3EJPSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334911303"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [patch v6 8/8] sched: remove blocked_load_avg in tg
Date: Fri, 10 May 2013 23:17:29 +0800
Message-Id: <1368199049-2798-9-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blocked_load_avg sometime is too heavy and far bigger than runnable load
avg. that make balance make wrong decision. So better don't consider it.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 91e60ac..75c200c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1339,7 +1339,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	struct task_group *tg = cfs_rq->tg;
 	s64 tg_contrib;
 
-	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
+	tg_contrib = cfs_rq->runnable_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
 	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
-- 
1.7.5.4

