Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaCLGwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:52:08 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60063 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbaCLGwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:52:06 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Alex Shi <alex.shi@linaro.org>
Subject: [PATCH] sched: clean up task_hot function
Date: Wed, 12 Mar 2014 14:51:51 +0800
Message-Id: <1394607111-1904-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_hot doesn't need the 'sched_domain' parameter, so remove it.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7947c86..00153ad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4980,7 +4980,7 @@ static void move_task(struct task_struct *p, struct lb_env *env)
  * Is this task likely cache-hot:
  */
 static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+task_hot(struct task_struct *p, u64 now)
 {
 	s64 delta;
 
@@ -5141,7 +5141,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) task is cache cold, or
 	 * 3) too many balance attempts have failed.
 	 */
-	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq));
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
-- 
1.8.1.2

