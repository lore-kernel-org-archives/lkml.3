Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaATMlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:41:55 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51699 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaATMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:07 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 06/11] sched: delete redundant sd init macros
Date: Mon, 20 Jan 2014 12:39:43 +0000
Message-Id: <1390221588-20473-7-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:04.0254 (UTC) FILETIME=[BE0CEBE0:01CF15DC]
X-MC-Unique: 114012012400509901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCg4kB003810

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch deletes all occurrences of SD_SIBLING_INIT, SD_MC_INIT,
SD_BOOK_INIT and SD_CPU_INIT.

The SD_NODE_INIT in arch/metag/include/asm/topology.h seems to be
leftover, probably because the metag arch got introduced at the same
time (v3.9) the other archs moved away from SD_NODE_INIT.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/ia64/include/asm/topology.h  |   24 --------
 arch/metag/include/asm/topology.h |   27 ---------
 arch/s390/include/asm/topology.h  |    2 -
 arch/tile/include/asm/topology.h  |   33 -----------
 include/linux/topology.h          |  115 -------------------------------------
 5 files changed, 201 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e449b75..20d12fa7e0cd 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -46,30 +46,6 @@
 
 void build_cpu_to_node_map(void);
 
-#define SD_CPU_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 1,			\
-	.max_interval		= 4,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 2,			\
-	.idle_idx		= 1,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 8e9c0b3b9691..e95f874ded1b 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -3,33 +3,6 @@
 
 #ifdef CONFIG_NUMA
 
-/* sched_domains SD_NODE_INIT for Meta machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-	.max_newidle_lb_cost	= 0,			\
-	.next_decay_max_lb_cost	= jiffies,		\
-}
-
 #define cpu_to_node(cpu)	((void)(cpu), 0)
 #define parent_node(node)	((void)(node), 0)
 
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index 05425b18c0aa..07763bdb408d 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -64,8 +64,6 @@ static inline void s390_init_cpu_topology(void)
 };
 #endif
 
-#define SD_BOOK_INIT	SD_CPU_INIT
-
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_S390_TOPOLOGY_H */
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index d15c0d8d550f..938311844233 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -44,39 +44,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 /* For now, use numa node -1 for global allocation. */
 #define pcibus_to_node(bus)		((void)(bus), -1)
 
-/*
- * TILE architecture has many cores integrated in one processor, so we need
- * setup bigger balance_interval for both CPU/NODE scheduling domains to
- * reduce process scheduling costs.
- */
-
-/* sched_domains SD_CPU_INIT for TILE architecture */
-#define SD_CPU_INIT (struct sched_domain) {				\
-	.min_interval		= 4,					\
-	.max_interval		= 128,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 32,					\
-}
-
 /* By definition, we create nodes based on online memory. */
 #define node_has_online_mem(nid) 1
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 0bfcead0ace7..0a7d6142f242 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -66,121 +66,6 @@ int arch_update_cpu_topology(void);
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
 #endif
 
-/*
- * Below are the 3 major initializers used in building sched_domains:
- * SD_SIBLING_INIT, for SMT domains
- * SD_CPU_INIT, for SMP domains
- *
- * Any architecture that cares to do any tuning to these values should do so
- * by defining their own arch-specific initializer in include/asm/topology.h.
- * A definition there will automagically override these default initializers
- * and allow arch-specific performance tuning of sched_domains.
- * (Only non-zero and non-null fields need be specified.)
- */
-
-#ifdef CONFIG_SCHED_SMT
-/* MCD - Do we really need this?  It is always on if CONFIG_SCHED_SMT is,
- * so can't we drop this in favor of CONFIG_SCHED_SMT?
- */
-#define ARCH_HAS_SCHED_WAKE_IDLE
-/* Common values for SMT siblings */
-#ifndef SD_SIBLING_INIT
-#define SD_SIBLING_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 2,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 110,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_SHARE_CPUPOWER			\
-				| 1*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				| arch_sd_sibling_asym_packing()	\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-	.smt_gain		= 1178,	/* 15% */			\
-	.max_newidle_lb_cost	= 0,					\
-	.next_decay_max_lb_cost	= jiffies,				\
-}
-#endif
-#endif /* CONFIG_SCHED_SMT */
-
-#ifdef CONFIG_SCHED_MC
-/* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
-#ifndef SD_MC_INIT
-#define SD_MC_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 4,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 1*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-	.max_newidle_lb_cost	= 0,					\
-	.next_decay_max_lb_cost	= jiffies,				\
-}
-#endif
-#endif /* CONFIG_SCHED_MC */
-
-/* Common values for CPUs */
-#ifndef SD_CPU_INIT
-#define SD_CPU_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 4,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				| 1*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-	.max_newidle_lb_cost	= 0,					\
-	.next_decay_max_lb_cost	= jiffies,				\
-}
-#endif
-
-#ifdef CONFIG_SCHED_BOOK
-#ifndef SD_BOOK_INIT
-#error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
-#endif
-#endif /* CONFIG_SCHED_BOOK */
-
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DECLARE_PER_CPU(int, numa_node);
 
-- 
1.7.9.5


