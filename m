Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaLEGb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:31:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:59487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLEGb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:31:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,521,1413270000"; 
   d="scan'208";a="648710892"
From: jun.zhang@intel.com
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, zhang jun <jun.zhang@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Changcheng Liu <changcheng.liu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched/fair: tiny clearup of -1
Date: Fri,  5 Dec 2014 14:02:45 +0800
Message-Id: <1417759365-28787-1-git-send-email-jun.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhang jun <jun.zhang@intel.com>

find_idlest_cpu don't return -1, so clearup it.

Signed-off-by: zhang jun <jun.zhang@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ef2b104..bbf965f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4596,7 +4596,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 		}
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
+		if (new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
 			continue;
-- 
1.7.9.5

