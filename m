Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaCKMlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:41:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbaCKMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:41:13 -0400
Date: Tue, 11 Mar 2014 05:40:25 -0700
From: tip-bot for Bjorn Helgaas <tipbot@zytor.com>
Message-ID: <tip-36fc5500bb1907bea7e9b4785dd00abf714d556f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, davem@davemloft.net, bhelgaas@google.com,
        benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, davem@davemloft.net, bhelgaas@google.com,
        benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <20140304210737.16893.54289.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140304210737.16893.54289.stgit@bhelgaas-glaptop.roam.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused mc_capable()
  and smt_capable()
Git-Commit-ID: 36fc5500bb1907bea7e9b4785dd00abf714d556f
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

Commit-ID:  36fc5500bb1907bea7e9b4785dd00abf714d556f
Gitweb:     http://git.kernel.org/tip/36fc5500bb1907bea7e9b4785dd00abf714d556f
Author:     Bjorn Helgaas <bhelgaas@google.com>
AuthorDate: Tue, 4 Mar 2014 14:07:37 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:05:45 +0100

sched: Remove unused mc_capable() and smt_capable()

Remove mc_capable() and smt_capable().  Neither is used.

Both were added by 5c45bf279d37 ("sched: mc/smt power savings sched
policy").  Uses of both were removed by 8e7fbcbc22c1 ("sched: Remove stale
power aware scheduling remnants and dysfunctional knobs").

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20140304210737.16893.54289.stgit@bhelgaas-glaptop.roam.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/include/asm/topology.h      | 3 ---
 arch/ia64/include/asm/topology.h     | 1 -
 arch/mips/include/asm/topology.h     | 4 ----
 arch/powerpc/include/asm/topology.h  | 1 -
 arch/sparc/include/asm/topology_64.h | 2 --
 arch/x86/include/asm/topology.h      | 6 ------
 6 files changed, 17 deletions(-)

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
