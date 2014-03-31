Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaCaK4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:56:05 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53895 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaCaKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:55:59 -0400
Date: Mon, 31 Mar 2014 12:55:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.15
Message-ID: <20140331105553.GA7767@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   # HEAD: 6037dd1a49f95092824fa8ba75c717ff7805e317 sched: Clean up the task_hot() function

Bigger changes:

  * sched/idle restructuring: they are WIP preparation for deeper 
    integration between the scheduler and idle state selection, by 
    Nicolas Pitre.

  * add NUMA scheduling pseudo-interleaving, by Rik van Riel.

  * optimize cgroup context switches, by Peter Zijlstra.

  * RT scheduling enhancements, by Thomas Gleixner.

The rest is smaller changes, non-urgnt fixes and cleanups.

 Thanks,

	Ingo

------------------>
Alex Shi (2):
      sched: Add statistic for newidle load balance cost
      sched: Clean up the task_hot() function

Bjorn Helgaas (2):
      sched: Remove unused mc_capable() and smt_capable()
      sparc64, sched: Remove unused sparc64_multi_core

Daniel Lezcano (3):
      sched: Remove 'cpu' parameter from idle_balance()
      sched: Fix race in idle_balance()
      sched: Move rq->idle_stamp up to the core

Dietmar Eggemann (2):
      sched: Delete is_same_group() outside CONFIG_FAIR_GROUP_SCHED
      sched: Put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED

Dongsheng Yang (10):
      sched: Move the priority specific bits into a new header file
      sched: Expose some macros related to priority
      sched: Implement task_nice() as static inline function
      sched/prio: Use DEFAULT_PRIO to define NICE_TO_PRIO() and PRIO_TO_NICE()
      sched/prio: Add 3 macros of MAX_NICE, MIN_NICE and NICE_WIDTH in prio.h
      rcu: Use MAX_NICE to replace hardcoding of 19
      sched: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE
      sys: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE
      workqueue: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE
      trace: Replace hardcoding of 19 with MAX_NICE

Jeremy Kerr (1):
      powerpc/spufs: Remove MAX_USER_PRIO define

Kirill Tkhai (5):
      sched/deadline: Skip in switched_to_dl() if task is current
      sched/rt: Fix picking RT and DL tasks from empty queue
      sched/fair: Push down check for high priority class task into idle_balance()
      sched/core: Fix endless loop in pick_next_task()
      sched/fair: Fix endless loop in idle_balance()

Li Zefan (2):
      sched/rt: Remove 'leaf_rt_rq_list' from 'struct rq'
      sched/rt: Make init_sched_rt_calss() __init

Michael wang (1):
      sched/fair: Reset se-depth when task switched to FAIR

Mike Galbraith (2):
      sched, nohz: Exclude isolated cores from load balancing
      sched/numa: Move task_numa_free() to __put_task_struct()

Morten Rasmussen (1):
      sched: Fix select_task_rq_fair() description comments

Nicolas Pitre (8):
      sched/idle: Move the cpuidle entry point to the generic idle loop
      sched/idle, ARM: Remove redundant cpuidle_idle_call()
      sched/idle, PPC: Remove redundant cpuidle_idle_call()
      sched/idle, SH: Remove redundant cpuidle_idle_call()
      sched/idle, x86: Remove redundant cpuidle_idle_call()
      sched/idle: Move cpu/idle.c to sched/idle.c
      cpuidle/powernv: Remove redundant cpuidle_idle_call()
      cpuidle/arm64: Remove redundant cpuidle_idle_call()

Peter Zijlstra (11):
      sched/fair: Track cgroup depth
      sched: Push put_prev_task() into pick_next_task()
      sched/fair: Clean up the __clear_buddies_*() functions
      sched/fair: Optimize cgroup pick_next_task_fair()
      sched: Clean up idle task SMP logic
      sched: Push down pre_schedule() and idle_balance()
      sched/fair: Remove idle_balance() declaration in sched.h
      sched: Fix hotplug task migration
      sched: Remove some #ifdeffery
      sched/idle: Remove stale old file
      sched: Guarantee task priority in pick_next_task()

Preeti U Murthy (1):
      cpuidle/pseries: Fix fallout caused due to cleanup in pseries cpuidle backend driver

Rik van Riel (9):
      sched/numa, mm: Remove p->numa_migrate_deferred
      sched/numa: Rename p->numa_faults to numa_faults_memory
      sched/numa: Track from which nodes NUMA faults are triggered
      sched/numa: Build per numa_group active node mask from numa_faults_cpu statistics
      sched/numa, mm: Use active_nodes nodemask to limit numa migrations
      sched/numa: Normalize faults_cpu stats and weigh by CPU use
      sched/numa: Do statistics calculation using local variables only
      sched/numa: Rename variables in task_numa_fault()
      sched/numa: Turn some magic numbers into #defines

Steven Rostedt (1):
      sched: Fix broken setscheduler()

Thomas Gleixner (6):
      sched: Init idle->on_rq in init_idle()
      sched: Check for idle task in might_sleep()
      sched: Add better debug output for might_sleep()
      sched: Adjust p->sched_reset_on_fork when nothing else changes
      sched: Queue RT tasks to head when prio drops
      sched: Consider pi boosting in setscheduler()

Vincent Guittot (1):
      sched: Remove double calculation in fix_small_imbalance()


 Documentation/sysctl/kernel.txt           |  10 +-
 arch/arm/include/asm/topology.h           |   3 -
 arch/arm/kernel/process.c                 |  16 +-
 arch/arm64/kernel/process.c               |   7 +-
 arch/ia64/include/asm/topology.h          |   1 -
 arch/mips/include/asm/topology.h          |   4 -
 arch/powerpc/include/asm/topology.h       |   1 -
 arch/powerpc/platforms/cell/spufs/sched.c |   1 -
 arch/powerpc/platforms/powernv/setup.c    |  13 +-
 arch/powerpc/platforms/pseries/setup.c    |  34 +-
 arch/sh/kernel/idle.c                     |   4 +-
 arch/sparc/include/asm/smp_64.h           |   1 -
 arch/sparc/include/asm/topology_64.h      |   2 -
 arch/sparc/kernel/mdesc.c                 |   4 -
 arch/sparc/kernel/prom_64.c               |   3 -
 arch/sparc/kernel/smp_64.c                |   2 -
 arch/x86/include/asm/topology.h           |   6 -
 arch/x86/kernel/process.c                 |   5 +-
 drivers/cpuidle/cpuidle-powernv.c         |   5 +
 drivers/cpuidle/cpuidle-pseries.c         |   6 +
 include/linux/sched.h                     |  44 ++-
 include/linux/sched/prio.h                |  44 +++
 include/linux/sched/rt.h                  |  26 +-
 kernel/Makefile                           |   1 -
 kernel/cpu/Makefile                       |   1 -
 kernel/fork.c                             |   1 +
 kernel/locking/rtmutex.c                  |  12 +
 kernel/rcu/torture.c                      |   8 +-
 kernel/sched/Makefile                     |   2 +-
 kernel/sched/auto_group.c                 |   2 +-
 kernel/sched/core.c                       | 207 +++++++----
 kernel/sched/cputime.c                    |   4 +-
 kernel/sched/deadline.c                   |  56 ++-
 kernel/sched/debug.c                      |   7 +-
 kernel/sched/fair.c                       | 600 +++++++++++++++++++++++-------
 kernel/{cpu => sched}/idle.c              |   7 +-
 kernel/sched/idle_task.c                  |  25 +-
 kernel/sched/rt.c                         | 102 +++--
 kernel/sched/sched.h                      |  65 ++--
 kernel/sched/stop_task.c                  |  15 +-
 kernel/sys.c                              |   8 +-
 kernel/sysctl.c                           |   7 -
 kernel/trace/ring_buffer_benchmark.c      |   6 +-
 kernel/workqueue.c                        |   2 +-
 mm/mempolicy.c                            |  74 +---
 45 files changed, 913 insertions(+), 541 deletions(-)
 create mode 100644 include/linux/sched/prio.h
 delete mode 100644 kernel/cpu/Makefile
 rename kernel/{cpu => sched}/idle.c (95%)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index e55124e..04bf16a 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -441,8 +441,7 @@ feature should be disabled. Otherwise, if the system overhead from the
 feature is too high then the rate the kernel samples for NUMA hinting
 faults may be controlled by the numa_balancing_scan_period_min_ms,
 numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms,
-numa_balancing_scan_size_mb, numa_balancing_settle_count sysctls and
-numa_balancing_migrate_deferred.
+numa_balancing_scan_size_mb, and numa_balancing_settle_count sysctls.
 
 ==============================================================
 
@@ -483,13 +482,6 @@ rate for each task.
 numa_balancing_scan_size_mb is how many megabytes worth of pages are
 scanned for a given scan.
 
-numa_balancing_migrate_deferred is how many page migrations get skipped
-unconditionally, after a page migration is skipped because a page is shared
-with other tasks. This reduces page migration overhead, and determines
-how much stronger the "move task near its memory" policy scheduler becomes,
-versus the "move memory near its task" memory management policy, for workloads
-with shared memory.
-
 ==============================================================
 
 osrelease, ostype & version:
diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
index 58b8b84..2fe85ff 100644
--- a/arch/arm/include/asm/topology.h
+++ b/arch/arm/include/asm/topology.h
@@ -20,9 +20,6 @@ extern struct cputopo_arm cpu_topology[NR_CPUS];
 #define topology_core_cpumask(cpu)	(&cpu_topology[cpu].core_sibling)
 #define topology_thread_cpumask(cpu)	(&cpu_topology[cpu].thread_sibling)
 
-#define mc_capable()	(cpu_topology[0].socket_id != -1)
-#define smt_capable()	(cpu_topology[0].thread_id != -1)
-
 void init_cpu_topology(void);
 void store_cpu_topology(unsigned int cpuid);
 const struct cpumask *cpu_coregroup_mask(int cpu);
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15..adabeab 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -30,7 +30,6 @@
 #include <linux/uaccess.h>
 #include <linux/random.h>
 #include <linux/hw_breakpoint.h>
-#include <linux/cpuidle.h>
 #include <linux/leds.h>
 #include <linux/reboot.h>
 
@@ -133,7 +132,11 @@ EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 void (*arm_pm_idle)(void);
 
-static void default_idle(void)
+/*
+ * Called from the core idle loop.
+ */
+
+void arch_cpu_idle(void)
 {
 	if (arm_pm_idle)
 		arm_pm_idle();
@@ -168,15 +171,6 @@ void arch_cpu_idle_dead(void)
 #endif
 
 /*
- * Called from the core idle loop.
- */
-void arch_cpu_idle(void)
-{
-	if (cpuidle_idle_call())
-		default_idle();
-}
-
-/*
  * Called by kexec, immediately prior to machine_kexec().
  *
  * This must completely disable all secondary CPUs; simply causing those CPUs
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1c0a9be..9cce009 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -33,7 +33,6 @@
 #include <linux/kallsyms.h>
 #include <linux/init.h>
 #include <linux/cpu.h>
-#include <linux/cpuidle.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
 #include <linux/tick.h>
@@ -94,10 +93,8 @@ void arch_cpu_idle(void)
 	 * This should do all the clock switching and wait for interrupt
 	 * tricks
 	 */
-	if (cpuidle_idle_call()) {
-		cpu_do_idle();
-		local_irq_enable();
-	}
+	cpu_do_idle();
+	local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e4..5cb55a1 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -77,7 +77,6 @@ void build_cpu_to_node_map(void);
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
 #define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
-#define smt_capable() 				(smp_num_siblings > 1)
 #endif
 
 extern void arch_fix_phys_package_id(int num, u32 slot);
diff --git a/arch/mips/include/asm/topology.h b/arch/mips/include/asm/topology.h
index 12609a1..20ea485 100644
--- a/arch/mips/include/asm/topology.h
+++ b/arch/mips/include/asm/topology.h
@@ -10,8 +10,4 @@
 
 #include <topology.h>
 
-#ifdef CONFIG_SMP
-#define smt_capable()	(smp_num_siblings > 1)
-#endif
-
 #endif /* __ASM_TOPOLOGY_H */
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index d0b5fca..c920215 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -99,7 +99,6 @@ static inline int prrn_is_enabled(void)
 
 #ifdef CONFIG_SMP
 #include <asm/cputable.h>
-#define smt_capable()		(cpu_has_feature(CPU_FTR_SMT))
 
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 4931838..4a0a64f 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -83,7 +83,6 @@ static struct timer_list spuloadavg_timer;
 #define MIN_SPU_TIMESLICE	max(5 * HZ / (1000 * SPUSCHED_TICK), 1)
 #define DEF_SPU_TIMESLICE	(100 * HZ / (1000 * SPUSCHED_TICK))
 
-#define MAX_USER_PRIO		(MAX_PRIO - MAX_RT_PRIO)
 #define SCALE_PRIO(x, prio) \
 	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_SPU_TIMESLICE)
 
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 110f4fb..81a7a0a 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -26,7 +26,6 @@
 #include <linux/of_fdt.h>
 #include <linux/interrupt.h>
 #include <linux/bug.h>
-#include <linux/cpuidle.h>
 #include <linux/pci.h>
 
 #include <asm/machdep.h>
@@ -225,16 +224,6 @@ static int __init pnv_probe(void)
 	return 1;
 }
 
-void powernv_idle(void)
-{
-	/* Hook to cpuidle framework if available, else
-	 * call on default platform idle code
-	 */
-	if (cpuidle_idle_call()) {
-		power7_idle();
-	}
-}
-
 define_machine(powernv) {
 	.name			= "PowerNV",
 	.probe			= pnv_probe,
@@ -244,7 +233,7 @@ define_machine(powernv) {
 	.show_cpuinfo		= pnv_show_cpuinfo,
 	.progress		= pnv_progress,
 	.machine_shutdown	= pnv_shutdown,
-	.power_save             = powernv_idle,
+	.power_save             = power7_idle,
 	.calibrate_decr		= generic_calibrate_decr,
 	.dma_set_mask		= pnv_dma_set_mask,
 #ifdef CONFIG_KEXEC
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 972df0f..2db8cc6 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -39,7 +39,6 @@
 #include <linux/irq.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/cpuidle.h>
 #include <linux/of.h>
 #include <linux/kexec.h>
 
@@ -356,29 +355,24 @@ early_initcall(alloc_dispatch_log_kmem_cache);
 
 static void pseries_lpar_idle(void)
 {
-	/* This would call on the cpuidle framework, and the back-end pseries
-	 * driver to  go to idle states
+	/*
+	 * Default handler to go into low thread priority and possibly
+	 * low power mode by cedeing processor to hypervisor
 	 */
-	if (cpuidle_idle_call()) {
-		/* On error, execute default handler
-		 * to go into low thread priority and possibly
-		 * low power mode by cedeing processor to hypervisor
-		 */
 
-		/* Indicate to hypervisor that we are idle. */
-		get_lppaca()->idle = 1;
+	/* Indicate to hypervisor that we are idle. */
+	get_lppaca()->idle = 1;
 
-		/*
-		 * Yield the processor to the hypervisor.  We return if
-		 * an external interrupt occurs (which are driven prior
-		 * to returning here) or if a prod occurs from another
-		 * processor. When returning here, external interrupts
-		 * are enabled.
-		 */
-		cede_processor();
+	/*
+	 * Yield the processor to the hypervisor.  We return if
+	 * an external interrupt occurs (which are driven prior
+	 * to returning here) or if a prod occurs from another
+	 * processor. When returning here, external interrupts
+	 * are enabled.
+	 */
+	cede_processor();
 
-		get_lppaca()->idle = 0;
-	}
+	get_lppaca()->idle = 0;
 }
 
 /*
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 2ea4483..be616ee 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -16,7 +16,6 @@
 #include <linux/thread_info.h>
 #include <linux/irqflags.h>
 #include <linux/smp.h>
-#include <linux/cpuidle.h>
 #include <linux/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/smp.h>
@@ -40,8 +39,7 @@ void arch_cpu_idle_dead(void)
 
 void arch_cpu_idle(void)
 {
-	if (cpuidle_idle_call())
-		sh_idle();
+	sh_idle();
 }
 
 void __init select_idle_routine(void)
diff --git a/arch/sparc/include/asm/smp_64.h b/arch/sparc/include/asm/smp_64.h
index dd3bef4..0571039 100644
--- a/arch/sparc/include/asm/smp_64.h
+++ b/arch/sparc/include/asm/smp_64.h
@@ -32,7 +32,6 @@
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern cpumask_t cpu_core_map[NR_CPUS];
-extern int sparc64_multi_core;
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 1754390..a2d10fc 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -42,8 +42,6 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
 #define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
-#define mc_capable()				(sparc64_multi_core)
-#define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
 
 extern cpumask_t cpu_core_map[NR_CPUS];
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index b90bf23..a1a4400 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -896,10 +896,6 @@ void mdesc_fill_in_cpu_data(cpumask_t *mask)
 
 	mdesc_iterate_over_cpus(fill_in_one_cpu, NULL, mask);
 
-#ifdef CONFIG_SMP
-	sparc64_multi_core = 1;
-#endif
-
 	hp = mdesc_grab();
 
 	set_core_ids(hp);
diff --git a/arch/sparc/kernel/prom_64.c b/arch/sparc/kernel/prom_64.c
index 6b39125..9a690d3 100644
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@ -555,9 +555,6 @@ static void *fill_in_one_cpu(struct device_node *dp, int cpuid, int arg)
 
 		cpu_data(cpuid).core_id = portid + 1;
 		cpu_data(cpuid).proc_id = portid;
-#ifdef CONFIG_SMP
-		sparc64_multi_core = 1;
-#endif
 	} else {
 		cpu_data(cpuid).dcache_size =
 			of_getintprop_default(dp, "dcache-size", 16 * 1024);
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index b085311..9781048 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -53,8 +53,6 @@
 
 #include "cpumap.h"
 
-int sparc64_multi_core __read_mostly;
-
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 cpumask_t cpu_core_map[NR_CPUS] __read_mostly =
 	{ [0 ... NR_CPUS-1] = CPU_MASK_NONE };
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d35f24e..9bcc724 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -133,12 +133,6 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
 struct pci_bus;
 void x86_pci_root_bus_resources(int bus, struct list_head *resources);
 
-#ifdef CONFIG_SMP
-#define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
-			(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids))
-#define smt_capable()			(smp_num_siblings > 1)
-#endif
-
 #ifdef CONFIG_NUMA
 extern int get_mp_bus_to_node(int busnum);
 extern void set_mp_bus_to_node(int busnum, int node);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95..4505e2a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -298,10 +298,7 @@ void arch_cpu_idle_dead(void)
  */
 void arch_cpu_idle(void)
 {
-	if (cpuidle_idle_call())
-		x86_idle();
-	else
-		local_irq_enable();
+	x86_idle();
 }
 
 /*
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 78fd174..f48607c 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -14,6 +14,7 @@
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
+#include <asm/runlatch.h>
 
 struct cpuidle_driver powernv_idle_driver = {
 	.name             = "powernv_idle",
@@ -30,12 +31,14 @@ static int snooze_loop(struct cpuidle_device *dev,
 	local_irq_enable();
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
+	ppc64_runlatch_off();
 	while (!need_resched()) {
 		HMT_low();
 		HMT_very_low();
 	}
 
 	HMT_medium();
+	ppc64_runlatch_on();
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 	smp_mb();
 	return index;
@@ -45,7 +48,9 @@ static int nap_loop(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index)
 {
+	ppc64_runlatch_off();
 	power7_idle();
+	ppc64_runlatch_on();
 	return index;
 }
 
diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index 7ab564a..6f7b019 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -17,6 +17,7 @@
 #include <asm/reg.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
+#include <asm/runlatch.h>
 #include <asm/plpar_wrappers.h>
 
 struct cpuidle_driver pseries_idle_driver = {
@@ -29,6 +30,7 @@ static struct cpuidle_state *cpuidle_state_table;
 
 static inline void idle_loop_prolog(unsigned long *in_purr)
 {
+	ppc64_runlatch_off();
 	*in_purr = mfspr(SPRN_PURR);
 	/*
 	 * Indicate to the HV that we are idle. Now would be
@@ -45,6 +47,10 @@ static inline void idle_loop_epilog(unsigned long in_purr)
 	wait_cycles += mfspr(SPRN_PURR) - in_purr;
 	get_lppaca()->wait_state_cycles = cpu_to_be64(wait_cycles);
 	get_lppaca()->idle = 0;
+
+	if (irqs_disabled())
+		local_irq_enable();
+	ppc64_runlatch_on();
 }
 
 static int snooze_loop(struct cpuidle_device *dev,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..825ed83 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -3,6 +3,8 @@
 
 #include <uapi/linux/sched.h>
 
+#include <linux/sched/prio.h>
+
 
 struct sched_param {
 	int sched_priority;
@@ -1077,6 +1079,7 @@ struct sched_entity {
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	int			depth;
 	struct sched_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct cfs_rq		*cfs_rq;
@@ -1460,6 +1463,9 @@ struct task_struct {
 	struct mutex perf_event_mutex;
 	struct list_head perf_event_list;
 #endif
+#ifdef CONFIG_DEBUG_PREEMPT
+	unsigned long preempt_disable_ip;
+#endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
 	short il_next;
@@ -1470,9 +1476,10 @@ struct task_struct {
 	unsigned int numa_scan_period;
 	unsigned int numa_scan_period_max;
 	int numa_preferred_nid;
-	int numa_migrate_deferred;
 	unsigned long numa_migrate_retry;
 	u64 node_stamp;			/* migration stamp  */
+	u64 last_task_numa_placement;
+	u64 last_sum_exec_runtime;
 	struct callback_head numa_work;
 
 	struct list_head numa_entry;
@@ -1483,15 +1490,22 @@ struct task_struct {
 	 * Scheduling placement decisions are made based on the these counts.
 	 * The values remain static for the duration of a PTE scan
 	 */
-	unsigned long *numa_faults;
+	unsigned long *numa_faults_memory;
 	unsigned long total_numa_faults;
 
 	/*
 	 * numa_faults_buffer records faults per node during the current
-	 * scan window. When the scan completes, the counts in numa_faults
-	 * decay and these values are copied.
+	 * scan window. When the scan completes, the counts in
+	 * numa_faults_memory decay and these values are copied.
+	 */
+	unsigned long *numa_faults_buffer_memory;
+
+	/*
+	 * Track the nodes the process was running on when a NUMA hinting
+	 * fault was incurred.
 	 */
-	unsigned long *numa_faults_buffer;
+	unsigned long *numa_faults_cpu;
+	unsigned long *numa_faults_buffer_cpu;
 
 	/*
 	 * numa_faults_locality tracks if faults recorded during the last
@@ -1596,8 +1610,8 @@ extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p);
-
-extern unsigned int sysctl_numa_balancing_migrate_deferred;
+extern bool should_numa_migrate_memory(struct task_struct *p, struct page *page,
+					int src_nid, int dst_cpu);
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -1613,6 +1627,11 @@ static inline void set_numabalancing_state(bool enabled)
 static inline void task_numa_free(struct task_struct *p)
 {
 }
+static inline bool should_numa_migrate_memory(struct task_struct *p,
+				struct page *page, int src_nid, int dst_cpu)
+{
+	return true;
+}
 #endif
 
 static inline struct pid *task_pid(struct task_struct *task)
@@ -2080,7 +2099,16 @@ static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
-extern int task_nice(const struct task_struct *p);
+/**
+ * task_nice - return the nice value of a given task.
+ * @p: the task in question.
+ *
+ * Return: The nice value [ -20 ... 0 ... 19 ].
+ */
+static inline int task_nice(const struct task_struct *p)
+{
+	return PRIO_TO_NICE((p)->static_prio);
+}
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
new file mode 100644
index 0000000..ac32258
--- /dev/null
+++ b/include/linux/sched/prio.h
@@ -0,0 +1,44 @@
+#ifndef _SCHED_PRIO_H
+#define _SCHED_PRIO_H
+
+#define MAX_NICE	19
+#define MIN_NICE	-20
+#define NICE_WIDTH	(MAX_NICE - MIN_NICE + 1)
+
+/*
+ * Priority of a process goes from 0..MAX_PRIO-1, valid RT
+ * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
+ * values are inverted: lower p->prio value means higher priority.
+ *
+ * The MAX_USER_RT_PRIO value allows the actual maximum
+ * RT priority to be separate from the value exported to
+ * user-space.  This allows kernel threads to set their
+ * priority to a value higher than any user task. Note:
+ * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ */
+
+#define MAX_USER_RT_PRIO	100
+#define MAX_RT_PRIO		MAX_USER_RT_PRIO
+
+#define MAX_PRIO		(MAX_RT_PRIO + NICE_WIDTH)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + NICE_WIDTH / 2)
+
+/*
+ * Convert user-nice values [ -20 ... 0 ... 19 ]
+ * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
+ * and back.
+ */
+#define NICE_TO_PRIO(nice)	((nice) + DEFAULT_PRIO)
+#define PRIO_TO_NICE(prio)	((prio) - DEFAULT_PRIO)
+
+/*
+ * 'User priority' is the nice value converted to something we
+ * can work with better when scaling various scheduler parameters,
+ * it's a [ 0 ... 39 ] range.
+ */
+#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
+#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
+#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
+
+#endif /* _SCHED_PRIO_H */
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 34e4ebe..6341f5b 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -1,24 +1,7 @@
 #ifndef _SCHED_RT_H
 #define _SCHED_RT_H
 
-/*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
- * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
- * values are inverted: lower p->prio value means higher priority.
- *
- * The MAX_USER_RT_PRIO value allows the actual maximum
- * RT priority to be separate from the value exported to
- * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
- * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
- */
-
-#define MAX_USER_RT_PRIO	100
-#define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+#include <linux/sched/prio.h>
 
 static inline int rt_prio(int prio)
 {
@@ -35,6 +18,7 @@ static inline int rt_task(struct task_struct *p)
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern int rt_mutex_check_prio(struct task_struct *task, int newprio);
 extern struct task_struct *rt_mutex_get_top_task(struct task_struct *task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
@@ -46,6 +30,12 @@ static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
+
+static inline int rt_mutex_check_prio(struct task_struct *task, int newprio)
+{
+	return 0;
+}
+
 static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
 {
 	return NULL;
diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..6f1c7e5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -22,7 +22,6 @@ obj-y += sched/
 obj-y += locking/
 obj-y += power/
 obj-y += printk/
-obj-y += cpu/
 obj-y += irq/
 obj-y += rcu/
 
diff --git a/kernel/cpu/Makefile b/kernel/cpu/Makefile
deleted file mode 100644
index 59ab052..0000000
--- a/kernel/cpu/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-y	= idle.o
diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..332688e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -237,6 +237,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	task_numa_free(tsk);
 	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 2e960a2..aa4dff0 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -213,6 +213,18 @@ struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
 }
 
 /*
+ * Called by sched_setscheduler() to check whether the priority change
+ * is overruled by a possible priority boosting.
+ */
+int rt_mutex_check_prio(struct task_struct *task, int newprio)
+{
+	if (!task_has_pi_waiters(task))
+		return 0;
+
+	return task_top_pi_waiter(task)->task->prio <= newprio;
+}
+
+/*
  * Adjust the priority of a task, after its pi_waiters got modified.
  *
  * This can be both boosting and unboosting. task->pi_lock must be held.
diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index 732f8ae..219761d 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -805,7 +805,7 @@ rcu_torture_writer(void *arg)
 	static DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -871,7 +871,7 @@ rcu_torture_fakewriter(void *arg)
 	DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
@@ -987,7 +987,7 @@ rcu_torture_reader(void *arg)
 	unsigned long long ts;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	if (irqreader && cur_ops->irq_capable)
 		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 
@@ -1584,7 +1584,7 @@ static int rcu_torture_barrier_cbs(void *arg)
 
 	init_rcu_head_on_stack(&rcu);
 	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	do {
 		wait_event(barrier_cbs_wq[myid],
 			   (newphase =
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 9a95c8c..ab32b7b 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -13,7 +13,7 @@ endif
 
 obj-y += core.o proc.o clock.o cputime.o
 obj-y += idle_task.o fair.o rt.o deadline.o stop_task.o
-obj-y += wait.o completion.o
+obj-y += wait.o completion.o idle.o
 obj-$(CONFIG_SMP) += cpupri.o cpudeadline.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 4a07353..e73efba 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -203,7 +203,7 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int nice)
 	struct autogroup *ag;
 	int err;
 
-	if (nice < -20 || nice > 19)
+	if (nice < MIN_NICE || nice > MAX_NICE)
 		return -EINVAL;
 
 	err = security_task_setnice(current, nice);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5c6635..ae365aa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1745,8 +1745,10 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
-	p->numa_faults = NULL;
-	p->numa_faults_buffer = NULL;
+	p->numa_faults_memory = NULL;
+	p->numa_faults_buffer_memory = NULL;
+	p->last_task_numa_placement = 0;
+	p->last_sum_exec_runtime = 0;
 
 	INIT_LIST_HEAD(&p->numa_entry);
 	p->numa_group = NULL;
@@ -2149,8 +2151,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
-		task_numa_free(prev);
-
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
 
@@ -2167,13 +2167,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 
 #ifdef CONFIG_SMP
 
-/* assumes rq->lock is held */
-static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
-{
-	if (prev->sched_class->pre_schedule)
-		prev->sched_class->pre_schedule(rq, prev);
-}
-
 /* rq->lock is NOT held, but preemption is disabled */
 static inline void post_schedule(struct rq *rq)
 {
@@ -2191,10 +2184,6 @@ static inline void post_schedule(struct rq *rq)
 
 #else
 
-static inline void pre_schedule(struct rq *rq, struct task_struct *p)
-{
-}
-
 static inline void post_schedule(struct rq *rq)
 {
 }
@@ -2510,8 +2499,13 @@ void __kprobes preempt_count_add(int val)
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
 #endif
-	if (preempt_count() == val)
-		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+	if (preempt_count() == val) {
+		unsigned long ip = get_parent_ip(CALLER_ADDR1);
+#ifdef CONFIG_DEBUG_PREEMPT
+		current->preempt_disable_ip = ip;
+#endif
+		trace_preempt_off(CALLER_ADDR0, ip);
+	}
 }
 EXPORT_SYMBOL(preempt_count_add);
 
@@ -2554,6 +2548,13 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
+#ifdef CONFIG_DEBUG_PREEMPT
+	if (in_atomic_preempt_off()) {
+		pr_err("Preemption disabled at:");
+		print_ip_sym(current->preempt_disable_ip);
+		pr_cont("\n");
+	}
+#endif
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
 }
@@ -2577,36 +2578,34 @@ static inline void schedule_debug(struct task_struct *prev)
 	schedstat_inc(this_rq(), sched_count);
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *prev)
-{
-	if (prev->on_rq || rq->skip_clock_update < 0)
-		update_rq_clock(rq);
-	prev->sched_class->put_prev_task(rq, prev);
-}
-
 /*
  * Pick up the highest-prio task:
  */
 static inline struct task_struct *
-pick_next_task(struct rq *rq)
+pick_next_task(struct rq *rq, struct task_struct *prev)
 {
-	const struct sched_class *class;
+	const struct sched_class *class = &fair_sched_class;
 	struct task_struct *p;
 
 	/*
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
-		p = fair_sched_class.pick_next_task(rq);
-		if (likely(p))
+	if (likely(prev->sched_class == class &&
+		   rq->nr_running == rq->cfs.h_nr_running)) {
+		p = fair_sched_class.pick_next_task(rq, prev);
+		if (likely(p && p != RETRY_TASK))
 			return p;
 	}
 
+again:
 	for_each_class(class) {
-		p = class->pick_next_task(rq);
-		if (p)
+		p = class->pick_next_task(rq, prev);
+		if (p) {
+			if (unlikely(p == RETRY_TASK))
+				goto again;
 			return p;
+		}
 	}
 
 	BUG(); /* the idle class will always have a runnable task */
@@ -2700,13 +2699,10 @@ need_resched:
 		switch_count = &prev->nvcsw;
 	}
 
-	pre_schedule(rq, prev);
-
-	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
+	if (prev->on_rq || rq->skip_clock_update < 0)
+		update_rq_clock(rq);
 
-	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	clear_preempt_need_resched();
 	rq->skip_clock_update = 0;
@@ -2908,7 +2904,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  * This function changes the 'effective' priority of a task. It does
  * not touch ->normal_prio like __setscheduler().
  *
- * Used by the rt_mutex code to implement priority inheritance logic.
+ * Used by the rt_mutex code to implement priority inheritance
+ * logic. Call site only calls if the priority of the task changed.
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
@@ -2998,7 +2995,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	unsigned long flags;
 	struct rq *rq;
 
-	if (TASK_NICE(p) == nice || nice < -20 || nice > 19)
+	if (task_nice(p) == nice || nice < MIN_NICE || nice > MAX_NICE)
 		return;
 	/*
 	 * We have to be careful, if called from sys_setpriority(),
@@ -3076,11 +3073,11 @@ SYSCALL_DEFINE1(nice, int, increment)
 	if (increment > 40)
 		increment = 40;
 
-	nice = TASK_NICE(current) + increment;
-	if (nice < -20)
-		nice = -20;
-	if (nice > 19)
-		nice = 19;
+	nice = task_nice(current) + increment;
+	if (nice < MIN_NICE)
+		nice = MIN_NICE;
+	if (nice > MAX_NICE)
+		nice = MAX_NICE;
 
 	if (increment < 0 && !can_nice(current, nice))
 		return -EPERM;
@@ -3109,18 +3106,6 @@ int task_prio(const struct task_struct *p)
 }
 
 /**
- * task_nice - return the nice value of a given task.
- * @p: the task in question.
- *
- * Return: The nice value [ -20 ... 0 ... 19 ].
- */
-int task_nice(const struct task_struct *p)
-{
-	return TASK_NICE(p);
-}
-EXPORT_SYMBOL(task_nice);
-
-/**
  * idle_cpu - is a given cpu idle currently?
  * @cpu: the processor in question.
  *
@@ -3189,9 +3174,8 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_new = 1;
 }
 
-/* Actually do priority change: must hold pi & rq lock. */
-static void __setscheduler(struct rq *rq, struct task_struct *p,
-			   const struct sched_attr *attr)
+static void __setscheduler_params(struct task_struct *p,
+		const struct sched_attr *attr)
 {
 	int policy = attr->sched_policy;
 
@@ -3211,9 +3195,21 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 	 * getparam()/getattr() don't report silly values for !rt tasks.
 	 */
 	p->rt_priority = attr->sched_priority;
-
 	p->normal_prio = normal_prio(p);
-	p->prio = rt_mutex_getprio(p);
+	set_load_weight(p);
+}
+
+/* Actually do priority change: must hold pi & rq lock. */
+static void __setscheduler(struct rq *rq, struct task_struct *p,
+			   const struct sched_attr *attr)
+{
+	__setscheduler_params(p, attr);
+
+	/*
+	 * If we get here, there was no pi waiters boosting the
+	 * task. It is safe to use the normal prio.
+	 */
+	p->prio = normal_prio(p);
 
 	if (dl_prio(p->prio))
 		p->sched_class = &dl_sched_class;
@@ -3221,8 +3217,6 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 		p->sched_class = &rt_sched_class;
 	else
 		p->sched_class = &fair_sched_class;
-
-	set_load_weight(p);
 }
 
 static void
@@ -3275,6 +3269,8 @@ static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
 {
+	int newprio = dl_policy(attr->sched_policy) ? MAX_DL_PRIO - 1 :
+		      MAX_RT_PRIO - 1 - attr->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;
@@ -3319,7 +3315,7 @@ recheck:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (fair_policy(policy)) {
-			if (attr->sched_nice < TASK_NICE(p) &&
+			if (attr->sched_nice < task_nice(p) &&
 			    !can_nice(p, attr->sched_nice))
 				return -EPERM;
 		}
@@ -3352,7 +3348,7 @@ recheck:
 		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
 		 */
 		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
-			if (!can_nice(p, TASK_NICE(p)))
+			if (!can_nice(p, task_nice(p)))
 				return -EPERM;
 		}
 
@@ -3389,16 +3385,18 @@ recheck:
 	}
 
 	/*
-	 * If not changing anything there's no need to proceed further:
+	 * If not changing anything there's no need to proceed further,
+	 * but store a possible modification of reset_on_fork.
 	 */
 	if (unlikely(policy == p->policy)) {
-		if (fair_policy(policy) && attr->sched_nice != TASK_NICE(p))
+		if (fair_policy(policy) && attr->sched_nice != task_nice(p))
 			goto change;
 		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
 			goto change;
 		if (dl_policy(policy))
 			goto change;
 
+		p->sched_reset_on_fork = reset_on_fork;
 		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
@@ -3452,6 +3450,24 @@ change:
 		return -EBUSY;
 	}
 
+	p->sched_reset_on_fork = reset_on_fork;
+	oldprio = p->prio;
+
+	/*
+	 * Special case for priority boosted tasks.
+	 *
+	 * If the new priority is lower or equal (user space view)
+	 * than the current (boosted) priority, we just store the new
+	 * normal parameters and do not touch the scheduler class and
+	 * the runqueue. This will be done when the task deboost
+	 * itself.
+	 */
+	if (rt_mutex_check_prio(p, newprio)) {
+		__setscheduler_params(p, attr);
+		task_rq_unlock(rq, p, &flags);
+		return 0;
+	}
+
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -3459,16 +3475,18 @@ change:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->sched_reset_on_fork = reset_on_fork;
-
-	oldprio = p->prio;
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, attr);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
-		enqueue_task(rq, p, 0);
+	if (on_rq) {
+		/*
+		 * We enqueue to tail when the priority of a task is
+		 * increased (user space view).
+		 */
+		enqueue_task(rq, p, oldprio <= p->prio ? ENQUEUE_HEAD : 0);
+	}
 
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
@@ -3624,7 +3642,7 @@ static int sched_copy_attr(struct sched_attr __user *uattr,
 	 * XXX: do we want to be lenient like existing syscalls; or do we want
 	 * to be strict and return an error on out-of-bounds values?
 	 */
-	attr->sched_nice = clamp(attr->sched_nice, -20, 19);
+	attr->sched_nice = clamp(attr->sched_nice, MIN_NICE, MAX_NICE);
 
 out:
 	return ret;
@@ -3845,7 +3863,7 @@ SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 	else if (task_has_rt_policy(p))
 		attr.sched_priority = p->rt_priority;
 	else
-		attr.sched_nice = TASK_NICE(p);
+		attr.sched_nice = task_nice(p);
 
 	rcu_read_unlock();
 
@@ -4483,6 +4501,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
+	idle->on_rq = 1;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
@@ -4721,6 +4740,22 @@ static void calc_load_migrate(struct rq *rq)
 		atomic_long_add(delta, &calc_load_tasks);
 }
 
+static void put_prev_task_fake(struct rq *rq, struct task_struct *prev)
+{
+}
+
+static const struct sched_class fake_sched_class = {
+	.put_prev_task = put_prev_task_fake,
+};
+
+static struct task_struct fake_task = {
+	/*
+	 * Avoid pull_{rt,dl}_task()
+	 */
+	.prio = MAX_PRIO + 1,
+	.sched_class = &fake_sched_class,
+};
+
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
  * try_to_wake_up()->select_task_rq().
@@ -4761,7 +4796,7 @@ static void migrate_tasks(unsigned int dead_cpu)
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq);
+		next = pick_next_task(rq, &fake_task);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
@@ -4851,7 +4886,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(13);
+	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
 	if (table == NULL)
 		return NULL;
@@ -4879,9 +4914,12 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[11], "name", sd->name,
+	set_table_entry(&table[11], "max_newidle_lb_cost",
+		&sd->max_newidle_lb_cost,
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
+	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[12] is terminator */
+	/* &table[13] is terminator */
 
 	return table;
 }
@@ -6858,7 +6896,6 @@ void __init sched_init(void)
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
-		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
@@ -6947,7 +6984,8 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
+	     !is_idle_task(current)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
@@ -6965,6 +7003,13 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);
+#ifdef CONFIG_DEBUG_PREEMPT
+	if (!preempt_count_equals(preempt_offset)) {
+		pr_err("Preemption disabled at:");
+		print_ip_sym(current->preempt_disable_ip);
+		pr_cont("\n");
+	}
+#endif
 	dump_stack();
 }
 EXPORT_SYMBOL(__might_sleep);
@@ -7018,7 +7063,7 @@ void normalize_rt_tasks(void)
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
 			 */
-			if (TASK_NICE(p) < 0 && p->mm)
+			if (task_nice(p) < 0 && p->mm)
 				set_user_nice(p, 0);
 			continue;
 		}
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9994791..58624a6 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -142,7 +142,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
 
-	index = (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
+	index = (task_nice(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
 
 	/* Add user time to cpustat. */
 	task_group_account_field(p, index, (__force u64) cputime);
@@ -169,7 +169,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	p->gtime += cputime;
 
 	/* Add guest time to cpustat. */
-	if (TASK_NICE(p) > 0) {
+	if (task_nice(p) > 0) {
 		cpustat[CPUTIME_NICE] += (__force u64) cputime;
 		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
 	} else {
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6e79b3f..27ef409 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -210,6 +210,16 @@ static inline int has_pushable_dl_tasks(struct rq *rq)
 
 static int push_dl_task(struct rq *rq);
 
+static inline bool need_pull_dl_task(struct rq *rq, struct task_struct *prev)
+{
+	return dl_task(prev);
+}
+
+static inline void set_post_schedule(struct rq *rq)
+{
+	rq->post_schedule = has_pushable_dl_tasks(rq);
+}
+
 #else
 
 static inline
@@ -232,6 +242,19 @@ void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
 }
 
+static inline bool need_pull_dl_task(struct rq *rq, struct task_struct *prev)
+{
+	return false;
+}
+
+static inline int pull_dl_task(struct rq *rq)
+{
+	return 0;
+}
+
+static inline void set_post_schedule(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
@@ -586,8 +609,8 @@ static void update_curr_dl(struct rq *rq)
 	 * approach need further study.
 	 */
 	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
-	if (unlikely((s64)delta_exec < 0))
-		delta_exec = 0;
+	if (unlikely((s64)delta_exec <= 0))
+		return;
 
 	schedstat_set(curr->se.statistics.exec_max,
 		      max(curr->se.statistics.exec_max, delta_exec));
@@ -942,6 +965,8 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	resched_task(rq->curr);
 }
 
+static int pull_dl_task(struct rq *this_rq);
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -988,7 +1013,7 @@ static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 	return rb_entry(left, struct sched_dl_entity, rb_node);
 }
 
-struct task_struct *pick_next_task_dl(struct rq *rq)
+struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 {
 	struct sched_dl_entity *dl_se;
 	struct task_struct *p;
@@ -996,9 +1021,20 @@ struct task_struct *pick_next_task_dl(struct rq *rq)
 
 	dl_rq = &rq->dl;
 
+	if (need_pull_dl_task(rq, prev))
+		pull_dl_task(rq);
+	/*
+	 * When prev is DL, we may throttle it in put_prev_task().
+	 * So, we update time before we check for dl_nr_running.
+	 */
+	if (prev->sched_class == &dl_sched_class)
+		update_curr_dl(rq);
+
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
+	put_prev_task(rq, prev);
+
 	dl_se = pick_next_dl_entity(rq, dl_rq);
 	BUG_ON(!dl_se);
 
@@ -1013,9 +1049,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq)
 		start_hrtick_dl(rq, p);
 #endif
 
-#ifdef CONFIG_SMP
-	rq->post_schedule = has_pushable_dl_tasks(rq);
-#endif /* CONFIG_SMP */
+	set_post_schedule(rq);
 
 	return p;
 }
@@ -1424,13 +1458,6 @@ skip:
 	return ret;
 }
 
-static void pre_schedule_dl(struct rq *rq, struct task_struct *prev)
-{
-	/* Try to pull other tasks here */
-	if (dl_task(prev))
-		pull_dl_task(rq);
-}
-
 static void post_schedule_dl(struct rq *rq)
 {
 	push_dl_tasks(rq);
@@ -1558,7 +1585,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (unlikely(p->dl.dl_throttled))
 		return;
 
-	if (p->on_rq || rq->curr != p) {
+	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
@@ -1623,7 +1650,6 @@ const struct sched_class dl_sched_class = {
 	.set_cpus_allowed       = set_cpus_allowed_dl,
 	.rq_online              = rq_online_dl,
 	.rq_offline             = rq_offline_dl,
-	.pre_schedule		= pre_schedule_dl,
 	.post_schedule		= post_schedule_dl,
 	.task_woken		= task_woken_dl,
 #endif
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index dd52e7f..f3344c3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -321,6 +321,7 @@ do {									\
 	P(sched_goidle);
 #ifdef CONFIG_SMP
 	P64(avg_idle);
+	P64(max_idle_balance_cost);
 #endif
 
 	P(ttwu_count);
@@ -533,15 +534,15 @@ static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 			unsigned long nr_faults = -1;
 			int cpu_current, home_node;
 
-			if (p->numa_faults)
-				nr_faults = p->numa_faults[2*node + i];
+			if (p->numa_faults_memory)
+				nr_faults = p->numa_faults_memory[2*node + i];
 
 			cpu_current = !i ? (task_node(p) == node) :
 				(pol && node_isset(node, pol->v.nodes));
 
 			home_node = (p->numa_preferred_nid == node);
 
-			SEQ_printf(m, "numa_faults, %d, %d, %d, %d, %ld\n",
+			SEQ_printf(m, "numa_faults_memory, %d, %d, %d, %d, %ld\n",
 				i, node, cpu_current, home_node, nr_faults);
 		}
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b4c4f3..7e9bd0b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -322,13 +322,13 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
 
 /* Do the two (enqueued) entities belong to the same group ? */
-static inline int
+static inline struct cfs_rq *
 is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
 	if (se->cfs_rq == pse->cfs_rq)
-		return 1;
+		return se->cfs_rq;
 
-	return 0;
+	return NULL;
 }
 
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
@@ -336,17 +336,6 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
 	return se->parent;
 }
 
-/* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
-{
-	int depth = 0;
-
-	for_each_sched_entity(se)
-		depth++;
-
-	return depth;
-}
-
 static void
 find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 {
@@ -360,8 +349,8 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 	 */
 
 	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(*se);
-	pse_depth = depth_se(*pse);
+	se_depth = (*se)->depth;
+	pse_depth = (*pse)->depth;
 
 	while (se_depth > pse_depth) {
 		se_depth--;
@@ -426,12 +415,6 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
-static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
-{
-	return 1;
-}
-
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
 {
 	return NULL;
@@ -819,14 +802,6 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-/*
- * After skipping a page migration on a shared page, skip N more numa page
- * migrations unconditionally. This reduces the number of NUMA migrations
- * in shared memory workloads, and has the effect of pulling tasks towards
- * where their memory lives, over pulling the memory towards the task.
- */
-unsigned int sysctl_numa_balancing_migrate_deferred = 16;
-
 static unsigned int task_nr_scan_windows(struct task_struct *p)
 {
 	unsigned long rss = 0;
@@ -893,10 +868,26 @@ struct numa_group {
 	struct list_head task_list;
 
 	struct rcu_head rcu;
+	nodemask_t active_nodes;
 	unsigned long total_faults;
+	/*
+	 * Faults_cpu is used to decide whether memory should move
+	 * towards the CPU. As a consequence, these stats are weighted
+	 * more by CPU use than by memory faults.
+	 */
+	unsigned long *faults_cpu;
 	unsigned long faults[0];
 };
 
+/* Shared or private faults. */
+#define NR_NUMA_HINT_FAULT_TYPES 2
+
+/* Memory and CPU locality */
+#define NR_NUMA_HINT_FAULT_STATS (NR_NUMA_HINT_FAULT_TYPES * 2)
+
+/* Averaged statistics, and temporary buffers. */
+#define NR_NUMA_HINT_FAULT_BUCKETS (NR_NUMA_HINT_FAULT_STATS * 2)
+
 pid_t task_numa_group_id(struct task_struct *p)
 {
 	return p->numa_group ? p->numa_group->gid : 0;
@@ -904,16 +895,16 @@ pid_t task_numa_group_id(struct task_struct *p)
 
 static inline int task_faults_idx(int nid, int priv)
 {
-	return 2 * nid + priv;
+	return NR_NUMA_HINT_FAULT_TYPES * nid + priv;
 }
 
 static inline unsigned long task_faults(struct task_struct *p, int nid)
 {
-	if (!p->numa_faults)
+	if (!p->numa_faults_memory)
 		return 0;
 
-	return p->numa_faults[task_faults_idx(nid, 0)] +
-		p->numa_faults[task_faults_idx(nid, 1)];
+	return p->numa_faults_memory[task_faults_idx(nid, 0)] +
+		p->numa_faults_memory[task_faults_idx(nid, 1)];
 }
 
 static inline unsigned long group_faults(struct task_struct *p, int nid)
@@ -925,6 +916,12 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 		p->numa_group->faults[task_faults_idx(nid, 1)];
 }
 
+static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
+{
+	return group->faults_cpu[task_faults_idx(nid, 0)] +
+		group->faults_cpu[task_faults_idx(nid, 1)];
+}
+
 /*
  * These return the fraction of accesses done by a particular task, or
  * task group, on a particular numa node.  The group weight is given a
@@ -935,7 +932,7 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 {
 	unsigned long total_faults;
 
-	if (!p->numa_faults)
+	if (!p->numa_faults_memory)
 		return 0;
 
 	total_faults = p->total_numa_faults;
@@ -954,6 +951,69 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
 }
 
+bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
+				int src_nid, int dst_cpu)
+{
+	struct numa_group *ng = p->numa_group;
+	int dst_nid = cpu_to_node(dst_cpu);
+	int last_cpupid, this_cpupid;
+
+	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
+
+	/*
+	 * Multi-stage node selection is used in conjunction with a periodic
+	 * migration fault to build a temporal task<->page relation. By using
+	 * a two-stage filter we remove short/unlikely relations.
+	 *
+	 * Using P(p) ~ n_p / n_t as per frequentist probability, we can equate
+	 * a task's usage of a particular page (n_p) per total usage of this
+	 * page (n_t) (in a given time-span) to a probability.
+	 *
+	 * Our periodic faults will sample this probability and getting the
+	 * same result twice in a row, given these samples are fully
+	 * independent, is then given by P(n)^2, provided our sample period
+	 * is sufficiently short compared to the usage pattern.
+	 *
+	 * This quadric squishes small probabilities, making it less likely we
+	 * act on an unlikely task<->page relation.
+	 */
+	last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
+	if (!cpupid_pid_unset(last_cpupid) &&
+				cpupid_to_nid(last_cpupid) != dst_nid)
+		return false;
+
+	/* Always allow migrate on private faults */
+	if (cpupid_match_pid(p, last_cpupid))
+		return true;
+
+	/* A shared fault, but p->numa_group has not been set up yet. */
+	if (!ng)
+		return true;
+
+	/*
+	 * Do not migrate if the destination is not a node that
+	 * is actively used by this numa group.
+	 */
+	if (!node_isset(dst_nid, ng->active_nodes))
+		return false;
+
+	/*
+	 * Source is a node that is not actively used by this
+	 * numa group, while the destination is. Migrate.
+	 */
+	if (!node_isset(src_nid, ng->active_nodes))
+		return true;
+
+	/*
+	 * Both source and destination are nodes in active
+	 * use by this numa group. Maximize memory bandwidth
+	 * by migrating from more heavily used groups, to less
+	 * heavily used ones, spreading the load around.
+	 * Use a 1/4 hysteresis to avoid spurious page movement.
+	 */
+	return group_faults(p, dst_nid) < (group_faults(p, src_nid) * 3 / 4);
+}
+
 static unsigned long weighted_cpuload(const int cpu);
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
@@ -1267,7 +1327,7 @@ static int task_numa_migrate(struct task_struct *p)
 static void numa_migrate_preferred(struct task_struct *p)
 {
 	/* This task has no NUMA fault statistics yet */
-	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults))
+	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
 		return;
 
 	/* Periodically retry migrating the task to the preferred node */
@@ -1282,6 +1342,38 @@ static void numa_migrate_preferred(struct task_struct *p)
 }
 
 /*
+ * Find the nodes on which the workload is actively running. We do this by
+ * tracking the nodes from which NUMA hinting faults are triggered. This can
+ * be different from the set of nodes where the workload's memory is currently
+ * located.
+ *
+ * The bitmask is used to make smarter decisions on when to do NUMA page
+ * migrations, To prevent flip-flopping, and excessive page migrations, nodes
+ * are added when they cause over 6/16 of the maximum number of faults, but
+ * only removed when they drop below 3/16.
+ */
+static void update_numa_active_node_mask(struct numa_group *numa_group)
+{
+	unsigned long faults, max_faults = 0;
+	int nid;
+
+	for_each_online_node(nid) {
+		faults = group_faults_cpu(numa_group, nid);
+		if (faults > max_faults)
+			max_faults = faults;
+	}
+
+	for_each_online_node(nid) {
+		faults = group_faults_cpu(numa_group, nid);
+		if (!node_isset(nid, numa_group->active_nodes)) {
+			if (faults > max_faults * 6 / 16)
+				node_set(nid, numa_group->active_nodes);
+		} else if (faults < max_faults * 3 / 16)
+			node_clear(nid, numa_group->active_nodes);
+	}
+}
+
+/*
  * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
  * increments. The more local the fault statistics are, the higher the scan
  * period will be for the next scan window. If local/remote ratio is below
@@ -1355,11 +1447,41 @@ static void update_task_scan_period(struct task_struct *p,
 	memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
 }
 
+/*
+ * Get the fraction of time the task has been running since the last
+ * NUMA placement cycle. The scheduler keeps similar statistics, but
+ * decays those on a 32ms period, which is orders of magnitude off
+ * from the dozens-of-seconds NUMA balancing period. Use the scheduler
+ * stats only if the task is so new there are no NUMA statistics yet.
+ */
+static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
+{
+	u64 runtime, delta, now;
+	/* Use the start of this time slice to avoid calculations. */
+	now = p->se.exec_start;
+	runtime = p->se.sum_exec_runtime;
+
+	if (p->last_task_numa_placement) {
+		delta = runtime - p->last_sum_exec_runtime;
+		*period = now - p->last_task_numa_placement;
+	} else {
+		delta = p->se.avg.runnable_avg_sum;
+		*period = p->se.avg.runnable_avg_period;
+	}
+
+	p->last_sum_exec_runtime = runtime;
+	p->last_task_numa_placement = now;
+
+	return delta;
+}
+
 static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
 	unsigned long max_faults = 0, max_group_faults = 0;
 	unsigned long fault_types[2] = { 0, 0 };
+	unsigned long total_faults;
+	u64 runtime, period;
 	spinlock_t *group_lock = NULL;
 
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
@@ -1368,6 +1490,10 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_scan_seq = seq;
 	p->numa_scan_period_max = task_scan_max(p);
 
+	total_faults = p->numa_faults_locality[0] +
+		       p->numa_faults_locality[1];
+	runtime = numa_get_avg_runtime(p, &period);
+
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
@@ -1379,24 +1505,37 @@ static void task_numa_placement(struct task_struct *p)
 		unsigned long faults = 0, group_faults = 0;
 		int priv, i;
 
-		for (priv = 0; priv < 2; priv++) {
-			long diff;
+		for (priv = 0; priv < NR_NUMA_HINT_FAULT_TYPES; priv++) {
+			long diff, f_diff, f_weight;
 
 			i = task_faults_idx(nid, priv);
-			diff = -p->numa_faults[i];
 
 			/* Decay existing window, copy faults since last scan */
-			p->numa_faults[i] >>= 1;
-			p->numa_faults[i] += p->numa_faults_buffer[i];
-			fault_types[priv] += p->numa_faults_buffer[i];
-			p->numa_faults_buffer[i] = 0;
+			diff = p->numa_faults_buffer_memory[i] - p->numa_faults_memory[i] / 2;
+			fault_types[priv] += p->numa_faults_buffer_memory[i];
+			p->numa_faults_buffer_memory[i] = 0;
 
-			faults += p->numa_faults[i];
-			diff += p->numa_faults[i];
+			/*
+			 * Normalize the faults_from, so all tasks in a group
+			 * count according to CPU use, instead of by the raw
+			 * number of faults. Tasks with little runtime have
+			 * little over-all impact on throughput, and thus their
+			 * faults are less important.
+			 */
+			f_weight = div64_u64(runtime << 16, period + 1);
+			f_weight = (f_weight * p->numa_faults_buffer_cpu[i]) /
+				   (total_faults + 1);
+			f_diff = f_weight - p->numa_faults_cpu[i] / 2;
+			p->numa_faults_buffer_cpu[i] = 0;
+
+			p->numa_faults_memory[i] += diff;
+			p->numa_faults_cpu[i] += f_diff;
+			faults += p->numa_faults_memory[i];
 			p->total_numa_faults += diff;
 			if (p->numa_group) {
 				/* safe because we can only change our own group */
 				p->numa_group->faults[i] += diff;
+				p->numa_group->faults_cpu[i] += f_diff;
 				p->numa_group->total_faults += diff;
 				group_faults += p->numa_group->faults[i];
 			}
@@ -1416,6 +1555,7 @@ static void task_numa_placement(struct task_struct *p)
 	update_task_scan_period(p, fault_types[0], fault_types[1]);
 
 	if (p->numa_group) {
+		update_numa_active_node_mask(p->numa_group);
 		/*
 		 * If the preferred task and group nids are different,
 		 * iterate over the nodes again to find the best place.
@@ -1465,7 +1605,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 	if (unlikely(!p->numa_group)) {
 		unsigned int size = sizeof(struct numa_group) +
-				    2*nr_node_ids*sizeof(unsigned long);
+				    4*nr_node_ids*sizeof(unsigned long);
 
 		grp = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
 		if (!grp)
@@ -1475,9 +1615,14 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		spin_lock_init(&grp->lock);
 		INIT_LIST_HEAD(&grp->task_list);
 		grp->gid = p->pid;
+		/* Second half of the array tracks nids where faults happen */
+		grp->faults_cpu = grp->faults + NR_NUMA_HINT_FAULT_TYPES *
+						nr_node_ids;
+
+		node_set(task_node(current), grp->active_nodes);
 
-		for (i = 0; i < 2*nr_node_ids; i++)
-			grp->faults[i] = p->numa_faults[i];
+		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
+			grp->faults[i] = p->numa_faults_memory[i];
 
 		grp->total_faults = p->total_numa_faults;
 
@@ -1534,9 +1679,9 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 	double_lock(&my_grp->lock, &grp->lock);
 
-	for (i = 0; i < 2*nr_node_ids; i++) {
-		my_grp->faults[i] -= p->numa_faults[i];
-		grp->faults[i] += p->numa_faults[i];
+	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
+		my_grp->faults[i] -= p->numa_faults_memory[i];
+		grp->faults[i] += p->numa_faults_memory[i];
 	}
 	my_grp->total_faults -= p->total_numa_faults;
 	grp->total_faults += p->total_numa_faults;
@@ -1562,12 +1707,12 @@ void task_numa_free(struct task_struct *p)
 {
 	struct numa_group *grp = p->numa_group;
 	int i;
-	void *numa_faults = p->numa_faults;
+	void *numa_faults = p->numa_faults_memory;
 
 	if (grp) {
 		spin_lock(&grp->lock);
-		for (i = 0; i < 2*nr_node_ids; i++)
-			grp->faults[i] -= p->numa_faults[i];
+		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
+			grp->faults[i] -= p->numa_faults_memory[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
@@ -1577,18 +1722,21 @@ void task_numa_free(struct task_struct *p)
 		put_numa_group(grp);
 	}
 
-	p->numa_faults = NULL;
-	p->numa_faults_buffer = NULL;
+	p->numa_faults_memory = NULL;
+	p->numa_faults_buffer_memory = NULL;
+	p->numa_faults_cpu= NULL;
+	p->numa_faults_buffer_cpu = NULL;
 	kfree(numa_faults);
 }
 
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
-void task_numa_fault(int last_cpupid, int node, int pages, int flags)
+void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 {
 	struct task_struct *p = current;
 	bool migrated = flags & TNF_MIGRATED;
+	int cpu_node = task_node(current);
 	int priv;
 
 	if (!numabalancing_enabled)
@@ -1603,16 +1751,24 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
-	if (unlikely(!p->numa_faults)) {
-		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
+	if (unlikely(!p->numa_faults_memory)) {
+		int size = sizeof(*p->numa_faults_memory) *
+			   NR_NUMA_HINT_FAULT_BUCKETS * nr_node_ids;
 
-		/* numa_faults and numa_faults_buffer share the allocation */
-		p->numa_faults = kzalloc(size * 2, GFP_KERNEL|__GFP_NOWARN);
-		if (!p->numa_faults)
+		p->numa_faults_memory = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		if (!p->numa_faults_memory)
 			return;
 
-		BUG_ON(p->numa_faults_buffer);
-		p->numa_faults_buffer = p->numa_faults + (2 * nr_node_ids);
+		BUG_ON(p->numa_faults_buffer_memory);
+		/*
+		 * The averaged statistics, shared & private, memory & cpu,
+		 * occupy the first half of the array. The second half of the
+		 * array is for current counters, which are averaged into the
+		 * first set by task_numa_placement.
+		 */
+		p->numa_faults_cpu = p->numa_faults_memory + (2 * nr_node_ids);
+		p->numa_faults_buffer_memory = p->numa_faults_memory + (4 * nr_node_ids);
+		p->numa_faults_buffer_cpu = p->numa_faults_memory + (6 * nr_node_ids);
 		p->total_numa_faults = 0;
 		memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
 	}
@@ -1641,7 +1797,8 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 	if (migrated)
 		p->numa_pages_migrated += pages;
 
-	p->numa_faults_buffer[task_faults_idx(node, priv)] += pages;
+	p->numa_faults_buffer_memory[task_faults_idx(mem_node, priv)] += pages;
+	p->numa_faults_buffer_cpu[task_faults_idx(cpu_node, priv)] += pages;
 	p->numa_faults_locality[!!(flags & TNF_FAULT_LOCAL)] += pages;
 }
 
@@ -2219,13 +2376,20 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
 	}
 }
-#else
+
+static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
+{
+	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
+	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
+}
+#else /* CONFIG_FAIR_GROUP_SCHED */
 static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update) {}
 static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 						  struct cfs_rq *cfs_rq) {}
 static inline void __update_group_entity_contrib(struct sched_entity *se) {}
-#endif
+static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 static inline void __update_task_entity_contrib(struct sched_entity *se)
 {
@@ -2323,12 +2487,6 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
 }
 
-static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
-{
-	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
-	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
-}
-
 /* Add the load generated by se into cfs_rq's child load-average */
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  struct sched_entity *se,
@@ -2416,7 +2574,10 @@ void idle_exit_fair(struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 0);
 }
 
-#else
+static int idle_balance(struct rq *this_rq);
+
+#else /* CONFIG_SMP */
+
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
@@ -2428,7 +2589,13 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   int sleep) {}
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
-#endif
+
+static inline int idle_balance(struct rq *rq)
+{
+	return 0;
+}
+
+#endif /* CONFIG_SMP */
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -2578,10 +2745,10 @@ static void __clear_buddies_last(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->last == se)
-			cfs_rq->last = NULL;
-		else
+		if (cfs_rq->last != se)
 			break;
+
+		cfs_rq->last = NULL;
 	}
 }
 
@@ -2589,10 +2756,10 @@ static void __clear_buddies_next(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->next == se)
-			cfs_rq->next = NULL;
-		else
+		if (cfs_rq->next != se)
 			break;
+
+		cfs_rq->next = NULL;
 	}
 }
 
@@ -2600,10 +2767,10 @@ static void __clear_buddies_skip(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->skip == se)
-			cfs_rq->skip = NULL;
-		else
+		if (cfs_rq->skip != se)
 			break;
+
+		cfs_rq->skip = NULL;
 	}
 }
 
@@ -2746,17 +2913,36 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
  * 3) pick the "last" process, for cache locality
  * 4) do not run the "skip" process, if something else is available
  */
-static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *
+pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	struct sched_entity *se = __pick_first_entity(cfs_rq);
-	struct sched_entity *left = se;
+	struct sched_entity *left = __pick_first_entity(cfs_rq);
+	struct sched_entity *se;
+
+	/*
+	 * If curr is set we have to see if its left of the leftmost entity
+	 * still in the tree, provided there was anything in the tree at all.
+	 */
+	if (!left || (curr && entity_before(curr, left)))
+		left = curr;
+
+	se = left; /* ideally we run the leftmost entity */
 
 	/*
 	 * Avoid running the skip buddy, if running something else can
 	 * be done without getting too unfair.
 	 */
 	if (cfs_rq->skip == se) {
-		struct sched_entity *second = __pick_next_entity(se);
+		struct sched_entity *second;
+
+		if (se == curr) {
+			second = __pick_first_entity(cfs_rq);
+		} else {
+			second = __pick_next_entity(se);
+			if (!second || (curr && entity_before(curr, second)))
+				second = curr;
+		}
+
 		if (second && wakeup_preempt_entity(second, left) < 1)
 			se = second;
 	}
@@ -2778,7 +2964,7 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	return se;
 }
 
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
@@ -3433,22 +3619,23 @@ static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 }
 
 /* conditionally throttle active cfs_rq's from put_prev_entity() */
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_bandwidth_used())
-		return;
+		return false;
 
 	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
-		return;
+		return false;
 
 	/*
 	 * it's possible for a throttled entity to be forced into a running
 	 * state (e.g. set_curr_task), in this case we're finished.
 	 */
 	if (cfs_rq_throttled(cfs_rq))
-		return;
+		return true;
 
 	throttle_cfs_rq(cfs_rq);
+	return true;
 }
 
 static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
@@ -3558,7 +3745,7 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq) { return false; }
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
@@ -4213,13 +4400,14 @@ done:
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
+ * select_task_rq_fair: Select target runqueue for the waking task in domains
+ * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
+ * SD_BALANCE_FORK, or SD_BALANCE_EXEC.
  *
- * Balance, ie. select the least loaded group.
+ * Balances load by selecting the idlest cpu in the idlest group, or under
+ * certain conditions an idle sibling cpu if the domain has SD_WAKE_AFFINE set.
  *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
+ * Returns the target cpu number.
  *
  * preempt must be disabled.
  */
@@ -4494,26 +4682,124 @@ preempt:
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
+	struct task_struct *p;
+	int new_tasks;
 
+again:
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (!cfs_rq->nr_running)
-		return NULL;
+		goto idle;
+
+	if (prev->sched_class != &fair_sched_class)
+		goto simple;
+
+	/*
+	 * Because of the set_next_buddy() in dequeue_task_fair() it is rather
+	 * likely that a next task is from the same cgroup as the current.
+	 *
+	 * Therefore attempt to avoid putting and setting the entire cgroup
+	 * hierarchy, only change the part that actually changes.
+	 */
+
+	do {
+		struct sched_entity *curr = cfs_rq->curr;
+
+		/*
+		 * Since we got here without doing put_prev_entity() we also
+		 * have to consider cfs_rq->curr. If it is still a runnable
+		 * entity, update_curr() will update its vruntime, otherwise
+		 * forget we've ever seen it.
+		 */
+		if (curr && curr->on_rq)
+			update_curr(cfs_rq);
+		else
+			curr = NULL;
+
+		/*
+		 * This call to check_cfs_rq_runtime() will do the throttle and
+		 * dequeue its entity in the parent(s). Therefore the 'simple'
+		 * nr_running test will indeed be correct.
+		 */
+		if (unlikely(check_cfs_rq_runtime(cfs_rq)))
+			goto simple;
+
+		se = pick_next_entity(cfs_rq, curr);
+		cfs_rq = group_cfs_rq(se);
+	} while (cfs_rq);
+
+	p = task_of(se);
+
+	/*
+	 * Since we haven't yet done put_prev_entity and if the selected task
+	 * is a different task than we started out with, try and touch the
+	 * least amount of cfs_rqs.
+	 */
+	if (prev != p) {
+		struct sched_entity *pse = &prev->se;
+
+		while (!(cfs_rq = is_same_group(se, pse))) {
+			int se_depth = se->depth;
+			int pse_depth = pse->depth;
+
+			if (se_depth <= pse_depth) {
+				put_prev_entity(cfs_rq_of(pse), pse);
+				pse = parent_entity(pse);
+			}
+			if (se_depth >= pse_depth) {
+				set_next_entity(cfs_rq_of(se), se);
+				se = parent_entity(se);
+			}
+		}
+
+		put_prev_entity(cfs_rq, pse);
+		set_next_entity(cfs_rq, se);
+	}
+
+	if (hrtick_enabled(rq))
+		hrtick_start_fair(rq, p);
+
+	return p;
+simple:
+	cfs_rq = &rq->cfs;
+#endif
+
+	if (!cfs_rq->nr_running)
+		goto idle;
+
+	put_prev_task(rq, prev);
 
 	do {
-		se = pick_next_entity(cfs_rq);
+		se = pick_next_entity(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
 	p = task_of(se);
+
 	if (hrtick_enabled(rq))
 		hrtick_start_fair(rq, p);
 
 	return p;
+
+idle:
+	new_tasks = idle_balance(rq);
+	/*
+	 * Because idle_balance() releases (and re-acquires) rq->lock, it is
+	 * possible for any higher priority task to appear. In that case we
+	 * must re-start the pick_next_entity() loop.
+	 */
+	if (new_tasks < 0)
+		return RETRY_TASK;
+
+	if (new_tasks > 0)
+		goto again;
+
+	return NULL;
 }
 
 /*
@@ -4751,7 +5037,7 @@ static void move_task(struct task_struct *p, struct lb_env *env)
  * Is this task likely cache-hot:
  */
 static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+task_hot(struct task_struct *p, u64 now)
 {
 	s64 delta;
 
@@ -4785,7 +5071,7 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 {
 	int src_nid, dst_nid;
 
-	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults ||
+	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults_memory ||
 	    !(env->sd->flags & SD_NUMA)) {
 		return false;
 	}
@@ -4816,7 +5102,7 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
 		return false;
 
-	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
+	if (!p->numa_faults_memory || !(env->sd->flags & SD_NUMA))
 		return false;
 
 	src_nid = cpu_to_node(env->src_cpu);
@@ -4912,7 +5198,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) task is cache cold, or
 	 * 3) too many balance attempts have failed.
 	 */
-	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq));
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
@@ -5775,12 +6061,10 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
-		busiest->group_power;
-	if (busiest->avg_load > tmp) {
+	if (busiest->avg_load > scaled_busy_load_per_task) {
 		pwr_move += busiest->group_power *
 			    min(busiest->load_per_task,
-				busiest->avg_load - tmp);
+				busiest->avg_load - scaled_busy_load_per_task);
 	}
 
 	/* Amount of load we'd add */
@@ -6359,17 +6643,23 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(int this_cpu, struct rq *this_rq)
+static int idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 	u64 curr_cost = 0;
+	int this_cpu = this_rq->cpu;
 
+	idle_enter_fair(this_rq);
+	/*
+	 * We must set idle_stamp _before_ calling idle_balance(), such that we
+	 * measure the duration of idle_balance() as idle time.
+	 */
 	this_rq->idle_stamp = rq_clock(this_rq);
 
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
+		goto out;
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6407,15 +6697,22 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
 
+	/*
+	 * While browsing the domains, we released the rq lock.
+	 * A task could have be enqueued in the meantime
+	 */
+	if (this_rq->cfs.h_nr_running && !pulled_task) {
+		pulled_task = 1;
+		goto out;
+	}
+
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
 		 * We are going idle. next_balance may be set based on
@@ -6426,6 +6723,20 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
+
+out:
+	/* Is there a task of a high priority class? */
+	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
+	    (this_rq->dl.dl_nr_running ||
+	     (this_rq->rt.rt_nr_running && !rt_rq_throttled(&this_rq->rt))))
+		pulled_task = -1;
+
+	if (pulled_task) {
+		idle_exit_fair(this_rq);
+		this_rq->idle_stamp = 0;
+	}
+
+	return pulled_task;
 }
 
 /*
@@ -6496,6 +6807,11 @@ out_unlock:
 	return 0;
 }
 
+static inline int on_null_domain(struct rq *rq)
+{
+	return unlikely(!rcu_dereference_sched(rq->sd));
+}
+
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * idle load balancing details
@@ -6550,8 +6866,13 @@ static void nohz_balancer_kick(void)
 static inline void nohz_balance_exit_idle(int cpu)
 {
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
-		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
-		atomic_dec(&nohz.nr_cpus);
+		/*
+		 * Completely isolated CPUs don't ever set, so we must test.
+		 */
+		if (likely(cpumask_test_cpu(cpu, nohz.idle_cpus_mask))) {
+			cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+			atomic_dec(&nohz.nr_cpus);
+		}
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 	}
 }
@@ -6605,6 +6926,12 @@ void nohz_balance_enter_idle(int cpu)
 	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 		return;
 
+	/*
+	 * If we're a completely isolated CPU, we don't play.
+	 */
+	if (on_null_domain(cpu_rq(cpu)))
+		return;
+
 	cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
 	atomic_inc(&nohz.nr_cpus);
 	set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
@@ -6867,11 +7194,6 @@ static void run_rebalance_domains(struct softirq_action *h)
 	nohz_idle_balance(this_rq, idle);
 }
 
-static inline int on_null_domain(struct rq *rq)
-{
-	return !rcu_dereference_sched(rq->sd);
-}
-
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  */
@@ -7036,7 +7358,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
  */
 static void switched_to_fair(struct rq *rq, struct task_struct *p)
 {
-	if (!p->se.on_rq)
+	struct sched_entity *se = &p->se;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/*
+	 * Since the real-depth could have been changed (only FAIR
+	 * class maintain depth value), reset depth properly.
+	 */
+	se->depth = se->parent ? se->parent->depth + 1 : 0;
+#endif
+	if (!se->on_rq)
 		return;
 
 	/*
@@ -7084,7 +7414,9 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
+	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq;
+
 	/*
 	 * If the task was not on the rq at the time of this cgroup movement
 	 * it must have been asleep, sleeping tasks keep their ->vruntime
@@ -7110,23 +7442,24 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * To prevent boost or penalty in the new cfs_rq caused by delta
 	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
 	 */
-	if (!on_rq && (!p->se.sum_exec_runtime || p->state == TASK_WAKING))
+	if (!on_rq && (!se->sum_exec_runtime || p->state == TASK_WAKING))
 		on_rq = 1;
 
 	if (!on_rq)
-		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+		se->vruntime -= cfs_rq_of(se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
+	se->depth = se->parent ? se->parent->depth + 1 : 0;
 	if (!on_rq) {
-		cfs_rq = cfs_rq_of(&p->se);
-		p->se.vruntime += cfs_rq->min_vruntime;
+		cfs_rq = cfs_rq_of(se);
+		se->vruntime += cfs_rq->min_vruntime;
 #ifdef CONFIG_SMP
 		/*
 		 * migrate_task_rq_fair() will have removed our previous
 		 * contribution, but we must synchronize for ongoing future
 		 * decay.
 		 */
-		p->se.avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
-		cfs_rq->blocked_load_avg += p->se.avg.load_avg_contrib;
+		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 #endif
 	}
 }
@@ -7222,10 +7555,13 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	if (!se)
 		return;
 
-	if (!parent)
+	if (!parent) {
 		se->cfs_rq = &rq->cfs;
-	else
+		se->depth = 0;
+	} else {
 		se->cfs_rq = parent->my_q;
+		se->depth = parent->depth + 1;
+	}
 
 	se->my_q = cfs_rq;
 	/* guarantee group entities always have weight */
diff --git a/kernel/cpu/idle.c b/kernel/sched/idle.c
similarity index 95%
rename from kernel/cpu/idle.c
rename to kernel/sched/idle.c
index 277f494..b7976a1 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/sched/idle.c
@@ -3,6 +3,7 @@
  */
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/cpuidle.h>
 #include <linux/tick.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
@@ -95,8 +96,10 @@ static void cpu_idle_loop(void)
 				if (!current_clr_polling_and_test()) {
 					stop_critical_timings();
 					rcu_idle_enter();
-					arch_cpu_idle();
-					WARN_ON_ONCE(irqs_disabled());
+					if (cpuidle_idle_call())
+						arch_cpu_idle();
+					if (WARN_ON_ONCE(irqs_disabled()))
+						local_irq_enable();
 					rcu_idle_exit();
 					start_critical_timings();
 				} else {
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 516c3d9..879f2b7 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,18 +13,8 @@ select_task_rq_idle(struct task_struct *p, int cpu, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
-
-static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
-{
-	idle_exit_fair(rq);
-	rq_last_tick_reset(rq);
-}
-
-static void post_schedule_idle(struct rq *rq)
-{
-	idle_enter_fair(rq);
-}
 #endif /* CONFIG_SMP */
+
 /*
  * Idle tasks are unconditionally rescheduled:
  */
@@ -33,13 +23,12 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 	resched_task(rq->idle);
 }
 
-static struct task_struct *pick_next_task_idle(struct rq *rq)
+static struct task_struct *
+pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	put_prev_task(rq, prev);
+
 	schedstat_inc(rq, sched_goidle);
-#ifdef CONFIG_SMP
-	/* Trigger the post schedule to do an idle_enter for CFS */
-	rq->post_schedule = 1;
-#endif
 	return rq->idle;
 }
 
@@ -58,6 +47,8 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	idle_exit_fair(rq);
+	rq_last_tick_reset(rq);
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
@@ -101,8 +92,6 @@ const struct sched_class idle_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
-	.pre_schedule		= pre_schedule_idle,
-	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1999021..d8cdf16 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -229,6 +229,14 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 #ifdef CONFIG_SMP
 
+static int pull_rt_task(struct rq *this_rq);
+
+static inline bool need_pull_rt_task(struct rq *rq, struct task_struct *prev)
+{
+	/* Try to pull RT tasks here if we lower this rq's prio */
+	return rq->rt.highest_prio.curr > prev->prio;
+}
+
 static inline int rt_overloaded(struct rq *rq)
 {
 	return atomic_read(&rq->rd->rto_count);
@@ -315,6 +323,15 @@ static inline int has_pushable_tasks(struct rq *rq)
 	return !plist_head_empty(&rq->rt.pushable_tasks);
 }
 
+static inline void set_post_schedule(struct rq *rq)
+{
+	/*
+	 * We detect this state here so that we can avoid taking the RQ
+	 * lock again later if there is no need to push
+	 */
+	rq->post_schedule = has_pushable_tasks(rq);
+}
+
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
@@ -359,6 +376,19 @@ void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 }
 
+static inline bool need_pull_rt_task(struct rq *rq, struct task_struct *prev)
+{
+	return false;
+}
+
+static inline int pull_rt_task(struct rq *this_rq)
+{
+	return 0;
+}
+
+static inline void set_post_schedule(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 static inline int on_rt_rq(struct sched_rt_entity *rt_se)
@@ -440,11 +470,6 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 		dequeue_rt_entity(rt_se);
 }
 
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
-}
-
 static int rt_se_boosted(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
@@ -515,11 +540,6 @@ static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 }
 
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_throttled;
-}
-
 static inline const struct cpumask *sched_rt_period_mask(void)
 {
 	return cpu_online_mask;
@@ -1318,15 +1338,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
-	struct rt_rq *rt_rq;
-
-	rt_rq = &rq->rt;
-
-	if (!rt_rq->rt_nr_running)
-		return NULL;
-
-	if (rt_rq_throttled(rt_rq))
-		return NULL;
+	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
 		rt_se = pick_next_rt_entity(rq, rt_rq);
@@ -1340,21 +1352,45 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	return p;
 }
 
-static struct task_struct *pick_next_task_rt(struct rq *rq)
+static struct task_struct *
+pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p = _pick_next_task_rt(rq);
+	struct task_struct *p;
+	struct rt_rq *rt_rq = &rq->rt;
+
+	if (need_pull_rt_task(rq, prev)) {
+		pull_rt_task(rq);
+		/*
+		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
+		 * means a dl task can slip in, in which case we need to
+		 * re-start task selection.
+		 */
+		if (unlikely(rq->dl.dl_nr_running))
+			return RETRY_TASK;
+	}
+
+	/*
+	 * We may dequeue prev's rt_rq in put_prev_task().
+	 * So, we update time before rt_nr_running check.
+	 */
+	if (prev->sched_class == &rt_sched_class)
+		update_curr_rt(rq);
+
+	if (!rt_rq->rt_nr_running)
+		return NULL;
+
+	if (rt_rq_throttled(rt_rq))
+		return NULL;
+
+	put_prev_task(rq, prev);
+
+	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
 	if (p)
 		dequeue_pushable_task(rq, p);
 
-#ifdef CONFIG_SMP
-	/*
-	 * We detect this state here so that we can avoid taking the RQ
-	 * lock again later if there is no need to push
-	 */
-	rq->post_schedule = has_pushable_tasks(rq);
-#endif
+	set_post_schedule(rq);
 
 	return p;
 }
@@ -1724,13 +1760,6 @@ skip:
 	return ret;
 }
 
-static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
-{
-	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (rq->rt.highest_prio.curr > prev->prio)
-		pull_rt_task(rq);
-}
-
 static void post_schedule_rt(struct rq *rq)
 {
 	push_rt_tasks(rq);
@@ -1833,7 +1862,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 		resched_task(rq->curr);
 }
 
-void init_sched_rt_class(void)
+void __init init_sched_rt_class(void)
 {
 	unsigned int i;
 
@@ -2007,7 +2036,6 @@ const struct sched_class rt_sched_class = {
 	.set_cpus_allowed       = set_cpus_allowed_rt,
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
-	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f964add..f2de7a1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -24,24 +24,6 @@ extern long calc_load_fold_active(struct rq *this_rq);
 extern void update_cpu_load_active(struct rq *this_rq);
 
 /*
- * Convert user-nice values [ -20 ... 0 ... 19 ]
- * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
- * and back.
- */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
-#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
-
-/*
- * 'User priority' is the nice value converted to something we
- * can work with better when scaling various scheduler parameters,
- * it's a [ 0 ... 39 ] range.
- */
-#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
-#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
-#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-
-/*
  * Helpers for converting nanosecond timing to jiffy resolution
  */
 #define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
@@ -441,6 +423,18 @@ struct rt_rq {
 #endif
 };
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
+}
+#else
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled;
+}
+#endif
+
 /* Deadline class' related fields in a runqueue */
 struct dl_rq {
 	/* runqueue is an rbtree, ordered by deadline */
@@ -558,11 +552,9 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct list_head leaf_rt_rq_list;
-#endif
+	struct sched_avg avg;
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
 	 * This is part of a global counter where only the total sum
@@ -651,8 +643,6 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
-
-	struct sched_avg avg;
 };
 
 static inline int cpu_of(struct rq *rq)
@@ -1112,6 +1102,8 @@ static const u32 prio_to_wmult[40] = {
 
 #define DEQUEUE_SLEEP		1
 
+#define RETRY_TASK		((void *)-1UL)
+
 struct sched_class {
 	const struct sched_class *next;
 
@@ -1122,14 +1114,22 @@ struct sched_class {
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
-	struct task_struct * (*pick_next_task) (struct rq *rq);
+	/*
+	 * It is the responsibility of the pick_next_task() method that will
+	 * return the next task to call put_prev_task() on the @prev task or
+	 * something equivalent.
+	 *
+	 * May return RETRY_TASK when it finds a higher prio class has runnable
+	 * tasks.
+	 */
+	struct task_struct * (*pick_next_task) (struct rq *rq,
+						struct task_struct *prev);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct task_struct *p, int task_cpu, int sd_flag, int flags);
 	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
-	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
@@ -1159,6 +1159,11 @@ struct sched_class {
 #endif
 };
 
+static inline void put_prev_task(struct rq *rq, struct task_struct *prev)
+{
+	prev->sched_class->put_prev_task(rq, prev);
+}
+
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
@@ -1175,16 +1180,14 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(int this_cpu, struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
-#else	/* CONFIG_SMP */
+#else
 
-static inline void idle_balance(int cpu, struct rq *rq)
-{
-}
+static inline void idle_enter_fair(struct rq *rq) { }
+static inline void idle_exit_fair(struct rq *rq) { }
 
 #endif
 
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index fdb6bb0..d6ce65d 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,16 +23,19 @@ check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
 	/* we're never preempted */
 }
 
-static struct task_struct *pick_next_task_stop(struct rq *rq)
+static struct task_struct *
+pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq) {
-		stop->se.exec_start = rq_clock_task(rq);
-		return stop;
-	}
+	if (!stop || !stop->on_rq)
+		return NULL;
 
-	return NULL;
+	put_prev_task(rq, prev);
+
+	stop->se.exec_start = rq_clock_task(rq);
+
+	return stop;
 }
 
 static void
diff --git a/kernel/sys.c b/kernel/sys.c
index c0a58be..adaeab6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -174,10 +174,10 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 
 	/* normalize: avoid signed division (rounding problems) */
 	error = -ESRCH;
-	if (niceval < -20)
-		niceval = -20;
-	if (niceval > 19)
-		niceval = 19;
+	if (niceval < MIN_NICE)
+		niceval = MIN_NICE;
+	if (niceval > MAX_NICE)
+		niceval = MAX_NICE;
 
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1..7754ff1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -386,13 +386,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname       = "numa_balancing_migrate_deferred",
-		.data           = &sysctl_numa_balancing_migrate_deferred,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
-	{
 		.procname	= "numa_balancing",
 		.data		= NULL, /* filled in by handler */
 		.maxlen		= sizeof(unsigned int),
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index a5457d5..0434ff1 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -40,8 +40,8 @@ static int write_iteration = 50;
 module_param(write_iteration, uint, 0644);
 MODULE_PARM_DESC(write_iteration, "# of writes between timestamp readings");
 
-static int producer_nice = 19;
-static int consumer_nice = 19;
+static int producer_nice = MAX_NICE;
+static int consumer_nice = MAX_NICE;
 
 static int producer_fifo = -1;
 static int consumer_fifo = -1;
@@ -308,7 +308,7 @@ static void ring_buffer_producer(void)
 
 	/* Let the user know that the test is running at low priority */
 	if (producer_fifo < 0 && consumer_fifo < 0 &&
-	    producer_nice == 19 && consumer_nice == 19)
+	    producer_nice == MAX_NICE && consumer_nice == MAX_NICE)
 		trace_printk("WARNING!!! This test is running at lowest priority.\n");
 
 	trace_printk("Time:     %lld (usecs)\n", time);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 193e977..3fa5b8f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3225,7 +3225,7 @@ static ssize_t wq_nice_store(struct device *dev, struct device_attribute *attr,
 		return -ENOMEM;
 
 	if (sscanf(buf, "%d", &attrs->nice) == 1 &&
-	    attrs->nice >= -20 && attrs->nice <= 19)
+	    attrs->nice >= MIN_NICE && attrs->nice <= MAX_NICE)
 		ret = apply_workqueue_attrs(wq, attrs);
 	else
 		ret = -EINVAL;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ae3c8f3..f520b9d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2301,35 +2301,6 @@ static void sp_free(struct sp_node *n)
 	kmem_cache_free(sn_cache, n);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-static bool numa_migrate_deferred(struct task_struct *p, int last_cpupid)
-{
-	/* Never defer a private fault */
-	if (cpupid_match_pid(p, last_cpupid))
-		return false;
-
-	if (p->numa_migrate_deferred) {
-		p->numa_migrate_deferred--;
-		return true;
-	}
-	return false;
-}
-
-static inline void defer_numa_migrate(struct task_struct *p)
-{
-	p->numa_migrate_deferred = sysctl_numa_balancing_migrate_deferred;
-}
-#else
-static inline bool numa_migrate_deferred(struct task_struct *p, int last_cpupid)
-{
-	return false;
-}
-
-static inline void defer_numa_migrate(struct task_struct *p)
-{
-}
-#endif /* CONFIG_NUMA_BALANCING */
-
 /**
  * mpol_misplaced - check whether current page node is valid in policy
  *
@@ -2403,52 +2374,9 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 
 	/* Migrate the page towards the node whose CPU is referencing it */
 	if (pol->flags & MPOL_F_MORON) {
-		int last_cpupid;
-		int this_cpupid;
-
 		polnid = thisnid;
-		this_cpupid = cpu_pid_to_cpupid(thiscpu, current->pid);
-
-		/*
-		 * Multi-stage node selection is used in conjunction
-		 * with a periodic migration fault to build a temporal
-		 * task<->page relation. By using a two-stage filter we
-		 * remove short/unlikely relations.
-		 *
-		 * Using P(p) ~ n_p / n_t as per frequentist
-		 * probability, we can equate a task's usage of a
-		 * particular page (n_p) per total usage of this
-		 * page (n_t) (in a given time-span) to a probability.
-		 *
-		 * Our periodic faults will sample this probability and
-		 * getting the same result twice in a row, given these
-		 * samples are fully independent, is then given by
-		 * P(n)^2, provided our sample period is sufficiently
-		 * short compared to the usage pattern.
-		 *
-		 * This quadric squishes small probabilities, making
-		 * it less likely we act on an unlikely task<->page
-		 * relation.
-		 */
-		last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
-		if (!cpupid_pid_unset(last_cpupid) && cpupid_to_nid(last_cpupid) != thisnid) {
 
-			/* See sysctl_numa_balancing_migrate_deferred comment */
-			if (!cpupid_match_pid(current, last_cpupid))
-				defer_numa_migrate(current);
-
-			goto out;
-		}
-
-		/*
-		 * The quadratic filter above reduces extraneous migration
-		 * of shared pages somewhat. This code reduces it even more,
-		 * reducing the overhead of page migrations of shared pages.
-		 * This makes workloads with shared pages rely more on
-		 * "move task near its memory", and less on "move memory
-		 * towards its task", which is exactly what we want.
-		 */
-		if (numa_migrate_deferred(current, last_cpupid))
+		if (!should_numa_migrate_memory(current, page, curnid, thiscpu))
 			goto out;
 	}
 
