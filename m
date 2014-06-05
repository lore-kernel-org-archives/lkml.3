Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaFEOhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:37:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaFEOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:37:39 -0400
Date: Thu, 5 Jun 2014 07:36:39 -0700
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-e93lpnxb87owfievqatey6b5@git.kernel.org>
Cc: mingo@kernel.org, hegdevasant@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        mpe@ellerman.id.au, nicolas.pitre@linaro.org, morten.rasmussen@arm.com,
        robh+dt@kernel.org, tglx@linutronix.de, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        anton@samba.org, grant.likely@linaro.org, afleming@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, toshi.kani@hp.com,
        benh@kernel.crashing.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, nico@linaro.org, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        hegdevasant@linux.vnet.ibm.com, peterz@infradead.org,
        nicolas.pitre@linaro.org, mpe@ellerman.id.au, morten.rasmussen@arm.com,
        robh+dt@kernel.org, tglx@linutronix.de, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        anton@samba.org, grant.likely@linaro.org, afleming@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, toshi.kani@hp.com,
        benh@kernel.crashing.org, preeti@linux.vnet.ibm.com, nico@linaro.org,
        vincent.guittot@linaro.org, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rename capacity related flags
Git-Commit-ID: 5d4dfddd4f02b028d6ddaaa04d75d3b0cad1c9ae
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

Commit-ID:  5d4dfddd4f02b028d6ddaaa04d75d3b0cad1c9ae
Gitweb:     http://git.kernel.org/tip/5d4dfddd4f02b028d6ddaaa04d75d3b0cad1c9ae
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Tue, 27 May 2014 13:50:41 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:32 +0200

sched: Rename capacity related flags

It is better not to think about compute capacity as being equivalent
to "CPU power".  The upcoming "power aware" scheduler work may create
confusion with the notion of energy consumption if "power" is used too
liberally.

Let's rename the following feature flags since they do relate to capacity:

	SD_SHARE_CPUPOWER  -> SD_SHARE_CPUCAPACITY
	ARCH_POWER         -> ARCH_CAPACITY
	NONTASK_POWER      -> NONTASK_CAPACITY

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linaro-kernel@lists.linaro.org
Cc: Andy Fleming <afleming@freescale.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/n/tip-e93lpnxb87owfievqatey6b5@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/kernel/smp.c |  2 +-
 include/linux/sched.h     |  4 ++--
 kernel/sched/core.c       | 14 +++++++-------
 kernel/sched/fair.c       |  8 ++++----
 kernel/sched/features.h   |  8 ++++----
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 10ffffe..c51d163 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -770,7 +770,7 @@ int setup_profiling_timer(unsigned int multiplier)
 /* cpumask of CPUs with asymetric SMT dependancy */
 static const int powerpc_smt_flags(void)
 {
-	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+	int flags = SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
 
 	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
 		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 322110a..ce93768 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -869,7 +869,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
-#define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_SHARE_CPUCAPACITY	0x0080	/* Domain members share cpu power */
 #define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
@@ -881,7 +881,7 @@ enum cpu_idle_type {
 #ifdef CONFIG_SCHED_SMT
 static inline const int cpu_smt_flags(void)
 {
-	return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+	return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7ba4f54..5976ca5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -872,7 +872,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	rq->clock_task += delta;
 
 #if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
-	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
+	if ((irq_delta + steal) && sched_feat(NONTASK_CAPACITY))
 		sched_rt_avg_update(rq, irq_delta + steal);
 #endif
 }
@@ -5309,7 +5309,7 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_NEWIDLE |
 			 SD_BALANCE_FORK |
 			 SD_BALANCE_EXEC |
-			 SD_SHARE_CPUPOWER |
+			 SD_SHARE_CPUCAPACITY |
 			 SD_SHARE_PKG_RESOURCES |
 			 SD_SHARE_POWERDOMAIN)) {
 		if (sd->groups != sd->groups->next)
@@ -5340,7 +5340,7 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_NEWIDLE |
 				SD_BALANCE_FORK |
 				SD_BALANCE_EXEC |
-				SD_SHARE_CPUPOWER |
+				SD_SHARE_CPUCAPACITY |
 				SD_SHARE_PKG_RESOURCES |
 				SD_PREFER_SIBLING |
 				SD_SHARE_POWERDOMAIN);
@@ -5947,7 +5947,7 @@ static int sched_domains_curr_level;
 /*
  * SD_flags allowed in topology descriptions.
  *
- * SD_SHARE_CPUPOWER      - describes SMT topologies
+ * SD_SHARE_CPUCAPACITY      - describes SMT topologies
  * SD_SHARE_PKG_RESOURCES - describes shared caches
  * SD_NUMA                - describes NUMA topologies
  * SD_SHARE_POWERDOMAIN   - describes shared power domain
@@ -5956,7 +5956,7 @@ static int sched_domains_curr_level;
  * SD_ASYM_PACKING        - describes SMT quirks
  */
 #define TOPOLOGY_SD_FLAGS		\
-	(SD_SHARE_CPUPOWER |		\
+	(SD_SHARE_CPUCAPACITY |		\
 	 SD_SHARE_PKG_RESOURCES |	\
 	 SD_NUMA |			\
 	 SD_ASYM_PACKING |		\
@@ -6002,7 +6002,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 					| 1*SD_BALANCE_FORK
 					| 0*SD_BALANCE_WAKE
 					| 1*SD_WAKE_AFFINE
-					| 0*SD_SHARE_CPUPOWER
+					| 0*SD_SHARE_CPUCAPACITY
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 0*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
@@ -6024,7 +6024,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	 * Convert topological properties into behaviour.
 	 */
 
-	if (sd->flags & SD_SHARE_CPUPOWER) {
+	if (sd->flags & SD_SHARE_CPUCAPACITY) {
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dc7d652..d3c73122 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5672,8 +5672,8 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 	unsigned long capacity = SCHED_CAPACITY_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-		if (sched_feat(ARCH_POWER))
+	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
+		if (sched_feat(ARCH_CAPACITY))
 			capacity *= arch_scale_smt_capacity(sd, cpu);
 		else
 			capacity *= default_scale_smt_capacity(sd, cpu);
@@ -5683,7 +5683,7 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 
 	sdg->sgc->capacity_orig = capacity;
 
-	if (sched_feat(ARCH_POWER))
+	if (sched_feat(ARCH_CAPACITY))
 		capacity *= arch_scale_freq_capacity(sd, cpu);
 	else
 		capacity *= default_scale_capacity(sd, cpu);
@@ -5782,7 +5782,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	/*
 	 * Only siblings can have significantly less than SCHED_CAPACITY_SCALE
 	 */
-	if (!(sd->flags & SD_SHARE_CPUPOWER))
+	if (!(sd->flags & SD_SHARE_CPUCAPACITY))
 		return 0;
 
 	/*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 5716929..90284d1 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -37,18 +37,18 @@ SCHED_FEAT(CACHE_HOT_BUDDY, true)
 SCHED_FEAT(WAKEUP_PREEMPTION, true)
 
 /*
- * Use arch dependent cpu power functions
+ * Use arch dependent cpu capacity functions
  */
-SCHED_FEAT(ARCH_POWER, true)
+SCHED_FEAT(ARCH_CAPACITY, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
 SCHED_FEAT(LB_BIAS, true)
 
 /*
- * Decrement CPU power based on time not spent running tasks
+ * Decrement CPU capacity based on time not spent running tasks
  */
-SCHED_FEAT(NONTASK_POWER, true)
+SCHED_FEAT(NONTASK_CAPACITY, true)
 
 /*
  * Queue remote wakeups on the target CPU and process them
