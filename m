Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab3C3OgH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab3C3Ofw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:35:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568221"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 07/21] sched: add new sg/sd_lb_stats fields for incoming fork/exec/wake balancing
Date: Sat, 30 Mar 2013 22:34:54 +0800
Message-Id: <1364654108-16307-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
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
index a165f52..dda6809 100644
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

