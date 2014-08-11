Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaHKWvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:51:22 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:53689 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaHKWvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:51:20 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org (open list:SCHEDULER)
Subject: [PATCH] sched: Remove ACCESS_ONCE() for jiffies
Date: Mon, 11 Aug 2014 18:51:41 -0400
Message-Id: <1407797503-24727-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jiffies is declared as a volatile variable. Therefore it is not neccessary to
use ACCESS_ONCE() while reading it.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/sched/core.c | 2 +-
 kernel/sched/proc.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec1a286..381d0d0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2552,7 +2552,7 @@ void scheduler_tick(void)
 u64 scheduler_tick_max_deferment(void)
 {
 	struct rq *rq = this_rq();
-	unsigned long next, now = ACCESS_ONCE(jiffies);
+	unsigned long next, now = jiffies;
 
 	next = rq->last_sched_tick + HZ;
 
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 8ecd552..87ab31b 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -526,7 +526,7 @@ static inline unsigned long get_rq_runnable_load(struct rq *rq)
  */
 void update_idle_cpu_load(struct rq *this_rq)
 {
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long curr_jiffies = jiffies;
 	unsigned long load = get_rq_runnable_load(this_rq);
 	unsigned long pending_updates;
 
@@ -548,7 +548,7 @@ void update_idle_cpu_load(struct rq *this_rq)
 void update_cpu_load_nohz(void)
 {
 	struct rq *this_rq = this_rq();
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long curr_jiffies = jiffies;
 	unsigned long pending_updates;
 
 	if (curr_jiffies == this_rq->last_load_update_tick)
-- 
1.9.1

