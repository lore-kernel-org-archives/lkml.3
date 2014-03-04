Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbaCDVIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:08:04 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39453 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbaCDVHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:07:47 -0500
Subject: [PATCH 2/2] sparc64: Remove unused sparc64_multi_core
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-mips@linux-mips.org, linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 04 Mar 2014 14:07:44 -0700
Message-ID: <20140304210744.16893.75929.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove sparc64_multi_core because it's not used any more.

It was added by a2f9f6bbb30e ("Fix {mc,smt}_capable()"), and the last uses
were removed by e637d96bf462 ("sched: Remove unused mc_capable() and
smt_capable()").

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/sparc/include/asm/smp_64.h |    1 -
 arch/sparc/kernel/mdesc.c       |    4 ----
 arch/sparc/kernel/prom_64.c     |    3 ---
 arch/sparc/kernel/smp_64.c      |    2 --
 4 files changed, 10 deletions(-)

diff --git a/arch/sparc/include/asm/smp_64.h b/arch/sparc/include/asm/smp_64.h
index dd3bef4b9896..05710393959f 100644
--- a/arch/sparc/include/asm/smp_64.h
+++ b/arch/sparc/include/asm/smp_64.h
@@ -32,7 +32,6 @@
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern cpumask_t cpu_core_map[NR_CPUS];
-extern int sparc64_multi_core;
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index b90bf23e3aab..a1a4400d4025 100644
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
index 6b39125eb927..9a690d39c01b 100644
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
index b085311dcd0e..9781048161ab 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -53,8 +53,6 @@
 
 #include "cpumap.h"
 
-int sparc64_multi_core __read_mostly;
-
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 cpumask_t cpu_core_map[NR_CPUS] __read_mostly =
 	{ [0 ... NR_CPUS-1] = CPU_MASK_NONE };

