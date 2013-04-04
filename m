Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3DDCC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:30857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab3DDCCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534133"
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
Subject: [patch v7 06/21] sched: add new sg/sd_lb_stats fields for incoming fork/exec/wake balancing
Date: Thu,  4 Apr 2013 10:00:47 +0800
Message-Id: <1365040862-8390-7-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power aware balancing, we care the sched domain/group's utilization.
So add: sd_lb_stats.sd_util and sg_lb_stats.group_util.

And want to know which group is busiest but still has capability to
handle more tasks, so add: sd_lb_stats.group_leader

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7124244..6b7917b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4203,6 +4203,10 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
+
+	/* Varibles of power awaring scheduling */
+	unsigned int  sd_util;	/* sum utilization of this domain */
+	struct sched_group *group_leader; /* Group which relieves group_min */
 };
 
 /*
@@ -4218,6 +4222,7 @@ struct sg_lb_stats {
 	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
+	unsigned int group_util;	/* sum utilization of group */
 };
 
 /**
-- 
1.7.12

