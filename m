Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3AXDJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:09:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:37140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab3AXDH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277725086"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 16/18] sched: don't care if the local group has capacity
Date: Thu, 24 Jan 2013 11:06:58 +0800
Message-Id: <1358996820-23036-17-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In power aware scheduling, we don't care load weight and
want not to pull tasks just because local group has capacity.
Because the local group maybe no tasks at the time, that is the power
balance hope so.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a1ccb40..94bd40b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4767,8 +4767,12 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * extra check prevents the case where you always pull from the
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
+		 *
+		 * In power aware scheduling, we don't care load weight and
+		 * want not to pull tasks just because local group has capacity.
 		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
+		if (prefer_sibling && !local_group && sds->this_has_capacity
+				&& env->perf_lb)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
-- 
1.7.12

