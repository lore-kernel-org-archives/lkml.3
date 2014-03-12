Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaCLKLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:11:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaCLKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:11:17 -0400
Date: Wed, 12 Mar 2014 03:10:45 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-6037dd1a49f95092824fa8ba75c717ff7805e317@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alex.shi@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alex.shi@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1394607111-1904-1-git-send-email-alex.shi@linaro.org>
References: <1394607111-1904-1-git-send-email-alex.shi@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Clean up the task_hot() function
Git-Commit-ID: 6037dd1a49f95092824fa8ba75c717ff7805e317
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6037dd1a49f95092824fa8ba75c717ff7805e317
Gitweb:     http://git.kernel.org/tip/6037dd1a49f95092824fa8ba75c717ff7805e317
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Wed, 12 Mar 2014 14:51:51 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Mar 2014 10:49:01 +0100

sched: Clean up the task_hot() function

task_hot() doesn't need the 'sched_domain' parameter, so remove it.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1394607111-1904-1-git-send-email-alex.shi@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b301918..7e9bd0b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5037,7 +5037,7 @@ static void move_task(struct task_struct *p, struct lb_env *env)
  * Is this task likely cache-hot:
  */
 static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+task_hot(struct task_struct *p, u64 now)
 {
 	s64 delta;
 
@@ -5198,7 +5198,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) task is cache cold, or
 	 * 3) too many balance attempts have failed.
 	 */
-	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq));
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
