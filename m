Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaB0Lwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:52:36 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37063 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaB0Lwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:52:34 -0500
Date: Thu, 27 Feb 2014 17:20:19 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 18/46] kernel: Mark functions as static in sched/fair.c
Message-ID: <8addb2b0ca590ad5b3492ce1c6cb86b67905acd5.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in kernel/sched/fair.c because they are not
used outside this file.

This eliminates the following warning in kernel/sched/fair.c:
kernel/sched/fair.c:1658:6: warning: no previous prototype for ‘task_numa_work’ [-Wmissing-prototypes]
kernel/sched/fair.c:1780:6: warning: no previous prototype for ‘task_tick_numa’ [-Wmissing-prototypes]
kernel/sched/fair.c:5269:22: warning: no previous prototype for ‘arch_scale_smt_power’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/fair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 966cc2b..fc8aff0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1655,7 +1655,7 @@ static void reset_ptenuma_scan(struct task_struct *p)
  * The expensive part of numa migration is done from task_work context.
  * Triggered from task_tick_numa().
  */
-void task_numa_work(struct callback_head *work)
+static void task_numa_work(struct callback_head *work)
 {
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
@@ -1777,7 +1777,7 @@ out:
 /*
  * Drive the periodic memory faults..
  */
-void task_tick_numa(struct rq *rq, struct task_struct *curr)
+static void task_tick_numa(struct rq *rq, struct task_struct *curr)
 {
 	struct callback_head *work = &curr->numa_work;
 	u64 period, now;
@@ -5266,7 +5266,7 @@ static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 	return smt_gain;
 }
 
-unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+static unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	return default_scale_smt_power(sd, cpu);
 }
-- 
1.7.9.5

