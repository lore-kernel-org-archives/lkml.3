Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3AXDIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:08:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:7626 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab3AXDHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277725004"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 02/18] sched: select_task_rq_fair clean up
Date: Thu, 24 Jan 2013 11:06:44 +0800
Message-Id: <1358996820-23036-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is impossible to miss a task allowed cpu in a eligible group.

And since find_idlest_group only return a different group which
excludes old cpu, it's also impossible to find a new cpu same as old
cpu.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..6d3a95d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3378,11 +3378,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		}
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
-			/* Now try balancing at a lower domain level of cpu */
-			sd = sd->child;
-			continue;
-		}
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
-- 
1.7.12

