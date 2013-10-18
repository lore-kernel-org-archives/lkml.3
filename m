Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3JRLyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63722 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3JRLx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:58 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 10/14] sched: init this_load to max in find_idlest_group
Date: Fri, 18 Oct 2013 13:52:23 +0200
Message-Id: <1382097147-30088-10-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Init this_load to max value instead of 0 in find_idlest_group.
If the local group is skipped because it doesn't have allowed CPUs, this_load
stays to 0,  no idlest group will be returned and the selected CPU will be a
not allowed one (which will be replaced in select_fallback_rq by a random
one). With a default value set to max, we will use the idlest group even if we
skip the local_group.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f9b03c1..2d9f782 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3532,7 +3532,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int sd_flag)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
-	unsigned long min_load = ULONG_MAX, this_load = 0;
+	unsigned long min_load = ULONG_MAX, this_load = ULONG_MAX;
 	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
-- 
1.7.9.5

