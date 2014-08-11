Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaHKLgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:36:21 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54854 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaHKLgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:36:17 -0400
Subject: [RFC PATCH V2 07/19] sched: add new sg/sd_lb_stats fields for
 incoming fork/exec/wake balancing
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:05:57 +0530
Message-ID: <20140811113547.31956.27826.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-1542-0000-0000-000003E83842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

For power aware balancing, we care the sched domain/group's utilization.
So add: sd_lb_stats.sd_util and sg_lb_stats.group_util.

And want to know which group is busiest but still has capability to
handle more tasks, so add: sd_lb_stats.group_leader

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 681ad06..3d6d081 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5593,6 +5593,9 @@ struct sg_lb_stats {
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
 #endif
+#ifdef CONFIG_SCHED_POWER
+	unsigned int group_util;	/* sum utilization of group */
+#endif
 };
 
 /*
@@ -5608,6 +5611,12 @@ struct sd_lb_stats {
 
 	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
 	struct sg_lb_stats local_stat;	/* Statistics of the local group */
+
+#ifdef CONFIG_SCHED_POWER
+        /* Varibles of power aware scheduling */
+        unsigned int  sd_util;  /* sum utilization of this domain */
+        struct sched_group *group_leader; /* Group which relieves group_min */
+#endif
 };
 
 static inline void init_sd_lb_stats(struct sd_lb_stats *sds)

