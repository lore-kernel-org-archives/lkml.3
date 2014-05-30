Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbaE3OnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:43:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:29743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbaE3Olj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:41:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548947133"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 11/16 v3] Make wakeup bias threshold changeable via sysctl
Date: Fri, 30 May 2014 14:36:07 +0800
Message-Id: <1401431772-14320-12-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In wakeup balance, we bias wakee and waker (in this order) if it is capable
of handling the wakee task.

sysctl_sched_cc_wakeup_threshold is the threshold to see whether the CPU
is capable, and can be changed by sysctl tool

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched/sysctl.h |    1 +
 kernel/sysctl.c              |    7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index f8a3e0a..f1e90c7 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -38,6 +38,7 @@ extern unsigned int sysctl_sched_child_runs_first;
 
 #ifdef CONFIG_SMP
 extern unsigned int sysctl_sched_cc_sum_period;
+extern unsigned int sysctl_sched_cc_wakeup_threshold;
 #endif
 
 enum sched_tunable_scaling {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 13aea95..77a5aa5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1098,6 +1098,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "sched_cc_wakeup_threshold",
+		.data		= &sysctl_sched_cc_wakeup_threshold,
+		.maxlen		= sizeof(sysctl_sched_cc_wakeup_threshold),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{ }
 };
-- 
1.7.9.5

