Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3KQJzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:55:48 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:58700 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753398Ab3KQJzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:55:22 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1606:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2895:2904:3138:3139:3140:3141:3142:3355:3867:3868:3870:4321:4605:5007:6119:6261:8603:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:13255:13868,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ear67_118663c725523
X-Filterd-Recvd-Size: 5792
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] softirq: Use const char * const for softirq_to_name, whitespace neatening
Date: Sun, 17 Nov 2013 01:55:12 -0800
Message-Id: <ec5c256bd326246f4b12dde34455c1df9b71004d.1384656563.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1384656563.git.joe@perches.com>
References: <cover.1384656563.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce data size a little.
Reduce checkpatch noise.

$ size kernel/softirq.o*
   text	   data	    bss	    dec	    hex	filename
  11554	   6013	   4008	  21575	   5447	kernel/softirq.o.new
  11474	   6093	   4008	  21575	   5447	kernel/softirq.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/interrupt.h |  2 +-
 kernel/softirq.c          | 28 +++++++++-------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index db43b58..0053add 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -360,7 +360,7 @@ enum
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.
  */
-extern char *softirq_to_name[NR_SOFTIRQS];
+extern const char * const softirq_to_name[NR_SOFTIRQS];
 
 /* softirq mask and active fields moved to irq_cpustat_t in
  * asm/hardirq.h to get better cache usage.  KAO
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 49a44cb..c828df5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -56,7 +56,7 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 
 DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
-char *softirq_to_name[NR_SOFTIRQS] = {
+const char * const softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
@@ -128,7 +128,6 @@ void local_bh_disable(void)
 {
 	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
 }
-
 EXPORT_SYMBOL(local_bh_disable);
 
 static void __local_bh_enable(unsigned int cnt)
@@ -150,7 +149,6 @@ void _local_bh_enable(void)
 	WARN_ON_ONCE(in_irq());
 	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
 }
-
 EXPORT_SYMBOL(_local_bh_enable);
 
 static inline void _local_bh_enable_ip(unsigned long ip)
@@ -167,7 +165,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
- 	 */
+	 */
 	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending())) {
@@ -289,8 +287,6 @@ restart:
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-
-
 asmlinkage void do_softirq(void)
 {
 	__u32 pending;
@@ -430,8 +426,7 @@ void open_softirq(int nr, void (*action)(struct softirq_action *))
 /*
  * Tasklets
  */
-struct tasklet_head
-{
+struct tasklet_head {
 	struct tasklet_struct *head;
 	struct tasklet_struct **tail;
 };
@@ -450,7 +445,6 @@ void __tasklet_schedule(struct tasklet_struct *t)
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__tasklet_schedule);
 
 void __tasklet_hi_schedule(struct tasklet_struct *t)
@@ -464,7 +458,6 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 	raise_softirq_irqoff(HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
 void __tasklet_hi_schedule_first(struct tasklet_struct *t)
@@ -475,7 +468,6 @@ void __tasklet_hi_schedule_first(struct tasklet_struct *t)
 	__this_cpu_write(tasklet_hi_vec.head, t);
 	__raise_softirq_irqoff(HI_SOFTIRQ);
 }
-
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
 
 static void tasklet_action(struct softirq_action *a)
@@ -495,7 +487,8 @@ static void tasklet_action(struct softirq_action *a)
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
+							&t->state))
 					BUG();
 				t->func(t->data);
 				tasklet_unlock(t);
@@ -530,7 +523,8 @@ static void tasklet_hi_action(struct softirq_action *a)
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
+							&t->state))
 					BUG();
 				t->func(t->data);
 				tasklet_unlock(t);
@@ -548,7 +542,6 @@ static void tasklet_hi_action(struct softirq_action *a)
 	}
 }
 
-
 void tasklet_init(struct tasklet_struct *t,
 		  void (*func)(unsigned long), unsigned long data)
 {
@@ -558,7 +551,6 @@ void tasklet_init(struct tasklet_struct *t,
 	t->func = func;
 	t->data = data;
 }
-
 EXPORT_SYMBOL(tasklet_init);
 
 void tasklet_kill(struct tasklet_struct *t)
@@ -574,7 +566,6 @@ void tasklet_kill(struct tasklet_struct *t)
 	tasklet_unlock_wait(t);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);
 }
-
 EXPORT_SYMBOL(tasklet_kill);
 
 /*
@@ -724,9 +715,8 @@ static void takeover_tasklets(unsigned int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int cpu_callback(struct notifier_block *nfb,
-				  unsigned long action,
-				  void *hcpu)
+static int cpu_callback(struct notifier_block *nfb, unsigned long action,
+			void *hcpu)
 {
 	switch (action) {
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.8.1.2.459.gbcd45b4.dirty

