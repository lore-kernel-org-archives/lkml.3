Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaHKLl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:41:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60994 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaHKLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:41:55 -0400
Subject: [RFC PATCH V2 16/19] sched: add new members of sd_lb_stats
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
Date: Mon, 11 Aug 2014 17:11:18 +0530
Message-ID: <20140811114105.31956.24888.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-0320-0000-0000-00000032716C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

Added 4 new members in sb_lb_stats, that will be used in incomming
power aware balance.

group_min; 	//least utliszation group in domain
min_load_per_task; //load_per_task in group_min
leader_util;	// sum utilizations of group_leader
min_util;	// sum utilizations of group_min

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fd93eaf..6d40aa3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4597,6 +4597,10 @@ struct sd_lb_stats {
         /* Varibles of power aware scheduling */
         unsigned int  sd_util;  /* sum utilization of this domain */
         struct sched_group *group_leader; /* Group which relieves group_min */
+        struct sched_group *group_min;  /* Least loaded group in sd */
+        unsigned long min_load_per_task; /* load_per_task in group_min */
+        unsigned int  leader_util;      /* sum utilizations of group_leader */
+        unsigned int  min_util;         /* sum utilizations of group_min */
 #endif
 };
 

