Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3AXDIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:08:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:6332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab3AXDHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277725008"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 04/18] sched: don't need go to smaller sched domain
Date: Thu, 24 Jan 2013 11:06:46 +0800
Message-Id: <1358996820-23036-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If parent sched domain has no task allowed cpu. neither in
it's child. So, go out to save useless checking.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3c7b09a..ecfbf8e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3378,10 +3378,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			load_idx = sd->wake_idx;
 
 		group = find_idlest_group(sd, p, cpu, load_idx);
-		if (!group) {
-			sd = sd->child;
-			continue;
-		}
+		if (!group)
+			goto unlock;
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
 
-- 
1.7.12

