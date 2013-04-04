Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3DDCCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:29715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647Ab3DDCCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534542"
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
Subject: [patch v7 17/21] sched: add new members of sd_lb_stats
Date: Thu,  4 Apr 2013 10:00:58 +0800
Message-Id: <1365040862-8390-18-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
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
index 86221e7..9326c22 100644
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

