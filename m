Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3KWOgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 09:36:44 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3KWOgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 09:36:43 -0500
Date: Sat, 23 Nov 2013 06:36:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] remove CONFIG_SCHED_HRTICK
Message-ID: <20131123143639.GA2735@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's equivalent to CONFIG_HIGH_RES_TIMERS now that all architectures
use the generic helpers it relies on.
    
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a671b58..c4d0371 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1655,12 +1655,6 @@ config HZ
 	default 500 if HZ_500
 	default 1000
 
-config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS
-
-config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS
-
 config THUMB2_KERNEL
 	bool "Compile the kernel in Thumb-2 mode" if !CPU_THUMBONLY
 	depends on (CPU_V7 || CPU_V7M) && !CPU_V6 && !CPU_V6K
diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 2a202a8..af81343 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -53,6 +53,3 @@ config HZ
 	default 250 if HZ_250
 	default 300 if HZ_300
 	default 1000 if HZ_1000
-
-config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..2ebc66c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -367,7 +367,7 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
-#ifdef CONFIG_SCHED_HRTICK
+#ifdef CONFIG_HIGH_RES_TIMERS
 /*
  * Use HR-timers to deliver accurate preemption points.
  */
@@ -492,7 +492,7 @@ static void init_rq_hrtick(struct rq *rq)
 	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rq->hrtick_timer.function = hrtick;
 }
-#else	/* CONFIG_SCHED_HRTICK */
+#else	/* CONFIG_HIGH_RES_TIMERS */
 static inline void hrtick_clear(struct rq *rq)
 {
 }
@@ -504,7 +504,7 @@ static inline void init_rq_hrtick(struct rq *rq)
 static inline void init_hrtick(void)
 {
 }
-#endif	/* CONFIG_SCHED_HRTICK */
+#endif	/* CONFIG_HIGH_RES_TIMERS */
 
 /*
  * resched_task - mark a task 'to be rescheduled now'.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c70201..feffcd4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2034,7 +2034,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	update_cfs_rq_blocked_load(cfs_rq, 1);
 	update_cfs_shares(cfs_rq);
 
-#ifdef CONFIG_SCHED_HRTICK
+#ifdef CONFIG_HIGH_RES_TIMERS
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
 	 * validating it and just reschedule.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b3c5653..21b50c8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -492,7 +492,7 @@ struct rq {
 	unsigned long calc_load_update;
 	long calc_load_active;
 
-#ifdef CONFIG_SCHED_HRTICK
+#ifdef CONFIG_HIGH_RES_TIMERS
 #ifdef CONFIG_SMP
 	int hrtick_csd_pending;
 	struct call_single_data hrtick_csd;
@@ -1103,7 +1103,7 @@ static inline u64 sched_avg_period(void)
 	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
 }
 
-#ifdef CONFIG_SCHED_HRTICK
+#ifdef CONFIG_HIGH_RES_TIMERS
 
 /*
  * Use hrtick when:
@@ -1128,7 +1128,7 @@ static inline int hrtick_enabled(struct rq *rq)
 	return 0;
 }
 
-#endif /* CONFIG_SCHED_HRTICK */
+#endif /* CONFIG_HIGH_RES_TIMERS */
 
 #ifdef CONFIG_SMP
 extern void sched_avg_update(struct rq *rq);
