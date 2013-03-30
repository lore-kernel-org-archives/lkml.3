Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3C3Og1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab3C3OgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568364"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 18/21] sched: add new members of sd_lb_stats
Date: Sat, 30 Mar 2013 22:35:05 +0800
Message-Id: <1364654108-16307-19-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added 4 new members in sb_lb_stats, that will be used in incomming
power aware balance.

group_min; 	//least utliszation group in domain
min_load_per_task; //load_per_task in group_min
leader_util;	// sum utilizations of group_leader
min_util;	// sum utilizations of group_min

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0a53e2a..8605c28 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3333,6 +3333,10 @@ struct sd_lb_stats {
 	/* Varibles of power awaring scheduling */
 	unsigned int  sd_util;	/* sum utilization of this domain */
 	struct sched_group *group_leader; /* Group which relieves group_min */
+	struct sched_group *group_min;	/* Least loaded group in sd */
+	unsigned long min_load_per_task; /* load_per_task in group_min */
+	unsigned int  leader_util;	/* sum utilizations of group_leader */
+	unsigned int  min_util;		/* sum utilizations of group_min */
 };
 
 /*
-- 
1.7.12

