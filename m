Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaBQB6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:58:11 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52872 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaBQB6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:58:07 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH v2 11/11] sched: clean up task_hot function
Date: Mon, 17 Feb 2014 09:55:17 +0800
Message-Id: <1392602117-20773-12-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_hot doesn't need the 'sched_domain' parameter, so remove it.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1b008ac..e81a790 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5003,7 +5003,7 @@ static void move_task(struct task_struct *p, struct lb_env *env)
  * Is this task likely cache-hot:
  */
 static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+task_hot(struct task_struct *p, u64 now)
 {
 	s64 delta;
 
@@ -5164,7 +5164,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) task is cache cold, or
 	 * 3) too many balance attempts have failed.
 	 */
-	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq));
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
-- 
1.8.1.2

