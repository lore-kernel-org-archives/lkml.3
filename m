Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935728Ab3FTCV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:21:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:16182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935716Ab3FTCV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:21:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="319759611"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [Resend patch v8 13/13] sched: get_rq_runnable_load() can be static and inline
Date: Thu, 20 Jun 2013 10:18:57 +0800
Message-Id: <1371694737-29336-14-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based-on-patch-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index ce5cd48..16f5a30 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -502,12 +502,12 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 }
 
 #ifdef CONFIG_SMP
-unsigned long get_rq_runnable_load(struct rq *rq)
+static inline unsigned long get_rq_runnable_load(struct rq *rq)
 {
 	return rq->cfs.runnable_load_avg;
 }
 #else
-unsigned long get_rq_runnable_load(struct rq *rq)
+static inline unsigned long get_rq_runnable_load(struct rq *rq)
 {
 	return rq->load.weight;
 }
-- 
1.7.12

