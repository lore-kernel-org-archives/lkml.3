Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3BRFKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:10:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:12556 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab3BRFHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:07:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258209974"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 07/15] sched: add new sg/sd_lb_stats fields for incoming fork/exec/wake balancing
Date: Mon, 18 Feb 2013 13:07:34 +0800
Message-Id: <1361164062-20111-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power aware balancing, we care the sched domain/group's
utilizations more than their load weight. So add:
sd_lb_stats.sd_utils and sg_lb_stats.group_utils.

We want to know the sd capacity, so add:
sd_lb_stats.sd_capacity.

And want to know which group is busiest but still has free time to
handle more tasks, so add:
sd_lb_stats.group_leader.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b9a34ab..32b8a7b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4214,6 +4214,11 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
+
+	/* Varibles of power awaring scheduling */
+	unsigned int  sd_utils;	/* sum utilizations of this domain */
+	unsigned long sd_capacity;	/* capacity of this domain */
+	struct sched_group *group_leader; /* Group which relieves group_min */
 };
 
 /*
@@ -4229,6 +4234,7 @@ struct sg_lb_stats {
 	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
+	unsigned int group_utils;	/* sum utilizations of group */
 };
 
 /**
-- 
1.7.12

