Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab3HMS3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:29:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48501 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3HMS3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:29:24 -0400
Message-ID: <520A7B00.8060405@arm.com>
Date: Tue, 13 Aug 2013 19:29:20 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan> <520A536C.3030600@arm.com>
In-Reply-To: <520A536C.3030600@arm.com>
X-OriginalArrivalTime: 13 Aug 2013 18:29:20.0588 (UTC) FILETIME=[06E7B8C0:01CE9853]
X-MC-Unique: 113081319292100401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/13 16:40, Sudeep KarkadaNagesha wrote:
> Adding PowerPC list
> 
> On 13/08/13 14:00, Rafael J. Wysocki wrote:
>> On Monday, August 12, 2013 02:27:47 PM Sudeep KarkadaNagesha wrote:
>>> The following changes since commit
>>> d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
>>>
>>> Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
>>>
>>> are available in the git repository at:
>>>
>>> git://linux-arm.org/linux-skn.git cpu_of_node
>>>
>>> for you to fetch changes up to
>>> 9e9e26dde91f22635c87d0e45f3938b5ded96f0d:
>>>
>>> cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes 
>>> (2013-08-12 10:22:29 +0100)
>>>
>>> ---------------------------------------------------------------- 
>>> Sudeep KarkadaNagesha (16): of: add support for retrieving cpu node
>>> for a given logical cpu index ARM: DT/kernel: define ARM specific
>>> arch_match_cpu_phys_id driver/core: cpu: initialize of_node in
>>> cpu's device struture of/device: add helper to get cpu device node
>>> from logical cpu index ARM: topology: remove hwid/MPIDR dependency
>>> from cpu_capacity ARM: mvebu: remove device tree parsing for cpu
>>> nodes drivers/bus: arm-cci: avoid parsing DT for cpu device nodes 
>>> cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes 
>>> cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes 
>>> cpufreq: highbank-cpufreq: remove device tree parsing for cpu
>>> nodes cpufreq: spear-cpufreq: remove device tree parsing for cpu
>>> nodes cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu
>>> nodes cpufreq: arm_big_little: remove device tree parsing for cpu
>>> nodes cpufreq: maple-cpufreq: remove device tree parsing for cpu
>>> nodes cpufreq: pmac64-cpufreq: remove device tree parsing for cpu
>>> nodes cpufreq: pmac32-cpufreq: remove device tree parsing for cpu
>>> nodes
>>>
>>> arch/arm/kernel/devtree.c           |  5 +++++ 
>>> arch/arm/kernel/topology.c          | 61 
>>> +++++++++++++++++++------------------------------------------ 
>>> arch/arm/mach-imx/mach-imx6q.c      |  3 +-- 
>>> arch/arm/mach-mvebu/platsmp.c       | 52 
>>> ++++++++++++++++++++++++---------------------------- 
>>> drivers/base/cpu.c                  |  2 ++ drivers/bus/arm-cci.c
>>> | 28 +++++++--------------------- 
>>> drivers/cpufreq/arm_big_little_dt.c | 40 
>>> ++++++++++++++-------------------------- 
>>> drivers/cpufreq/cpufreq-cpu0.c      | 23 ++++------------------- 
>>> drivers/cpufreq/highbank-cpufreq.c  | 18 ++++++------------ 
>>> drivers/cpufreq/imx6q-cpufreq.c     |  4 +--- 
>>> drivers/cpufreq/kirkwood-cpufreq.c  |  8 +++++--- 
>>> drivers/cpufreq/maple-cpufreq.c     | 23 +++-------------------- 
>>> drivers/cpufreq/pmac32-cpufreq.c    |  5 +++-- 
>>> drivers/cpufreq/pmac64-cpufreq.c    | 47 
>>> +++++++++++------------------------------------ 
>>> drivers/cpufreq/spear-cpufreq.c     |  4 ++-- drivers/of/base.c
>>> | 73 
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>
>>>
> include/linux/cpu.h                 |  1 +
>>> include/linux/of.h                  |  6 ++++++ 
>>> include/linux/of_device.h           | 15 +++++++++++++++ 19 files
>>> changed, 202 insertions(+), 216 deletions(-)
>>>
>>>
>>> PS: This patch series is reviewed and acknowledged @
>>>
>>> v1: https://lkml.org/lkml/2013/7/15/128 v2:
>>> https://lkml.org/lkml/2013/7/17/341 v3:
>>> https://lkml.org/lkml/2013/7/22/219
>>
>> Pulled, thanks!
>>
> Hi Rob, Rafael,
> 
> On 13/08/13 15:16, kbuild test robot wrote:> tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> bleeding-edge
>> head:   0d4bcb5dc7d3040c0ce7572ea30ab9e5d9455bfa commit:
>> 7939ff8d991de2c0b15064e76ee549a6df5ae67f [151/204] of: add
>> support for retrieving cpu node for a given logical cpu index
>> config: make ARCH=powerpc allmodconfig
>>
>> All error/warnings:
>>
>> warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM)
>> selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
>> warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM)
>> selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
>> In file included from arch/powerpc/include/asm/kvm_para.h:26:0, from
>> include/uapi/linux/kvm_para.h:26, from include/linux/kvm_para.h:4, 
>> from include/linux/kvm_host.h:30, from
>> arch/powerpc/kernel/asm-offsets.c:53:
>> include/linux/of.h:269:28: error: conflicting types for
>> 'of_get_cpu_node'
>> extern struct device_node *of_get_cpu_node(int cpu); ^ In file
>> included from include/linux/of.h:139:0, from
>> arch/powerpc/include/asm/kvm_para.h:26, from
>> include/uapi/linux/kvm_para.h:26, from include/linux/kvm_para.h:4, 
>> from include/linux/kvm_host.h:30, from
>> arch/powerpc/kernel/asm-offsets.c:53: 
>> arch/powerpc/include/asm/prom.h:47:21: note: previous declaration
>> of 'of_get_cpu_node' was here
>> struct device_node *of_get_cpu_node(int cpu, unsigned int *thread); 
>> ^ make[2]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1 make[2]:
>> Target `__build' not remade because of errors. make[1]: ***
>> [prepare0] Error 2 make[1]: Target `prepare' not remade because of
>> errors. make: *** [sub-make] Error 2
>>
> 
> There seems to be conflict in the new function "of_get_cpu_node" added.
> PowerPC also defines the same function name. Further microblaze and
> openrisc declares it(can be removed) but doesn't define it.
> To fix this:
> 1. I can rename the newly added function to something different like
>    `of_get_cpunode` or
> 2. If of_* namespace should be used by only OF/FDT and not by any
>    architecture specific code, then the arch specific version can be
>    renamed to some thing like arch_of_get_cpu_node.
>    Also most of the calls to arch specific function can be moved to
>    generic code.
> 
> Let me know your thoughts.

Hi Benjamin,

I don't understand completely the use of ibm,ppc-interrupt-server#s and
its implications on generic of_get_cpu_node implementation.
I see the PPC specific definition of of_get_cpu_node uses thread id only
in 2 instances. Based on that, I have tried to move all the other
instances to use generic definition.

Let me know if the idea is correct.

---->8--------

diff --git a/arch/powerpc/include/asm/prom.h
b/arch/powerpc/include/asm/prom.h
index 42ee294..b48bbfe 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -44,7 +44,7 @@ void of_parse_dma_window(struct device_node *dn, const
void *dma_window_prop,
 extern void kdump_move_device_tree(void);

 /* CPU OF node matching */
-struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
+struct device_node *arch_of_get_cpu_node_by_tid(int cpu, unsigned int
*thread);

 #ifdef CONFIG_NUMA
 extern int of_node_to_nid(struct device_node *device);
diff --git a/arch/powerpc/kernel/cacheinfo.c
b/arch/powerpc/kernel/cacheinfo.c
index 9262cf2..c60eef9 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -434,7 +434,7 @@ static struct cache
*cache_chain_instantiate(unsigned int cpu_id)

 	pr_debug("creating cache object(s) for CPU %i\n", cpu_id);

-	cpu_node = of_get_cpu_node(cpu_id, NULL);
+	cpu_node = of_get_cpu_node(cpu_id);
 	WARN_ONCE(!cpu_node, "no OF node found for CPU %i\n", cpu_id);
 	if (!cpu_node)
 		goto out;
@@ -764,7 +764,7 @@ static struct cache *cache_lookup_by_cpu(unsigned
int cpu_id)
 	struct device_node *cpu_node;
 	struct cache *cache;

-	cpu_node = of_get_cpu_node(cpu_id, NULL);
+	cpu_node = of_get_cpu_node(cpu_id);
 	WARN_ONCE(!cpu_node, "no OF node found for CPU %i\n", cpu_id);
 	if (!cpu_node)
 		return NULL;
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index af09e32..fe48a70 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/memblock.h>
 #include <linux/of.h>
+#include <linux/cpu.h>

 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -834,15 +835,23 @@ static int __init prom_reconfig_setup(void)
 __initcall(prom_reconfig_setup);
 #endif

+bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
+{
+	return phys_id == get_hard_smp_processor_id(cpu);
+}
+
 /* Find the device node for a given logical cpu number, also returns
the cpu
  * local thread number (index in ibm,interrupt-server#s) if relevant and
  * asked for (non NULL)
  */
-struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
+struct device_node *arch_of_get_cpunode_by_tid(int cpu, unsigned int
*thread)
 {
 	int hardid;
 	struct device_node *np;

+	if (thread == NULL)
+		return of_get_cpu_node(cpu);
+
 	hardid = get_hard_smp_processor_id(cpu);

 	for_each_node_by_type(np, "cpu") {
@@ -855,14 +864,9 @@ struct device_node *of_get_cpu_node(int cpu,
unsigned int *thread)
 		intserv = of_get_property(np, "ibm,ppc-interrupt-server#s",
 				&plen);
 		if (intserv == NULL) {
-			const u32 *reg = of_get_property(np, "reg", NULL);
-			if (reg == NULL)
-				continue;
-			if (*reg == hardid) {
-				if (thread)
-					*thread = 0;
-				return np;
-			}
+			np = of_get_cpu_node(cpu);
+			*thread = 0;
+			return np;
 		} else {
 			plen /= sizeof(u32);
 			for (t = 0; t < plen; t++) {
@@ -876,7 +880,6 @@ struct device_node *of_get_cpu_node(int cpu,
unsigned int *thread)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(of_get_cpu_node);

 #if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
 static struct debugfs_blob_wrapper flat_dt_blob;
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 38b0ba6..cc0e3a27 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -560,7 +560,7 @@ int cpu_to_core_id(int cpu)
 	const int *reg;
 	int id = -1;

-	np = of_get_cpu_node(cpu, NULL);
+	np = of_get_cpu_node(cpu);
 	if (!np)
 		goto out;

@@ -598,7 +598,7 @@ static struct device_node *cpu_to_l2cache(int cpu)
 	if (!cpu_present(cpu))
 		return NULL;

-	np = of_get_cpu_node(cpu, NULL);
+	np = of_get_cpu_node(cpu);
 	if (np == NULL)
 		return NULL;

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 5850798..4b06158 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -520,7 +520,7 @@ static int of_drconf_to_nid_single(struct
of_drconf_cell *drmem,
 static int numa_setup_cpu(unsigned long lcpu)
 {
 	int nid = 0;
-	struct device_node *cpu = of_get_cpu_node(lcpu, NULL);
+	struct device_node *cpu = of_get_cpu_node(lcpu);

 	if (!cpu) {
 		WARN_ON(1);
@@ -699,7 +699,7 @@ static int __init parse_numa_properties(void)
 		struct device_node *cpu;
 		int nid;

-		cpu = of_get_cpu_node(i, NULL);
+		cpu = of_get_cpu_node(i);
 		BUG_ON(!cpu);
 		nid = of_node_to_nid_single(cpu);
 		of_node_put(cpu);
diff --git a/arch/powerpc/platforms/44x/currituck.c
b/arch/powerpc/platforms/44x/currituck.c
index 7f1b71a..84eb64e 100644
--- a/arch/powerpc/platforms/44x/currituck.c
+++ b/arch/powerpc/platforms/44x/currituck.c
@@ -98,7 +98,7 @@ static void smp_ppc47x_setup_cpu(int cpu)

 static int smp_ppc47x_kick_cpu(int cpu)
 {
-	struct device_node *cpunode = of_get_cpu_node(cpu, NULL);
+	struct device_node *cpunode = of_get_cpu_node(cpu);
 	const u64 *spin_table_addr_prop;
 	u32 *spin_table;
 	extern void start_secondary_47x(void);
diff --git a/arch/powerpc/platforms/44x/iss4xx.c
b/arch/powerpc/platforms/44x/iss4xx.c
index 4241bc8..8195456 100644
--- a/arch/powerpc/platforms/44x/iss4xx.c
+++ b/arch/powerpc/platforms/44x/iss4xx.c
@@ -88,7 +88,7 @@ static void smp_iss4xx_setup_cpu(int cpu)

 static int smp_iss4xx_kick_cpu(int cpu)
 {
-	struct device_node *cpunode = of_get_cpu_node(cpu, NULL);
+	struct device_node *cpunode = of_get_cpu_node(cpu);
 	const u64 *spin_table_addr_prop;
 	u32 *spin_table;
 	extern void start_secondary_47x(void);
diff --git a/arch/powerpc/platforms/85xx/smp.c
b/arch/powerpc/platforms/85xx/smp.c
index 5ced4f5..e32c532 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -156,7 +156,7 @@ static int smp_85xx_kick_cpu(int nr)

 	pr_debug("smp_85xx_kick_cpu: kick CPU #%d\n", nr);

-	np = of_get_cpu_node(nr, NULL);
+	np = of_get_cpu_node(nr);
 	cpu_rel_addr = of_get_property(np, "cpu-release-addr", NULL);

 	if (cpu_rel_addr == NULL) {
diff --git a/arch/powerpc/platforms/cell/cbe_regs.c
b/arch/powerpc/platforms/cell/cbe_regs.c
index 1428d58..a055b74 100644
--- a/arch/powerpc/platforms/cell/cbe_regs.c
+++ b/arch/powerpc/platforms/cell/cbe_regs.c
@@ -182,7 +182,7 @@ static struct device_node *cbe_get_be_node(int cpu_id)
 			return np;

 		for (i=0; i<len; i++)
-			if (of_find_node_by_phandle(cpu_handle[i]) ==
of_get_cpu_node(cpu_id, NULL))
+			if (of_find_node_by_phandle(cpu_handle[i]) == of_get_cpu_node(cpu_id))
 				return np;
 	}

@@ -240,7 +240,8 @@ void __init cbe_regs_init(void)

 	/* Build local fast map of CPUs */
 	for_each_possible_cpu(i) {
-		cbe_thread_map[i].cpu_node = of_get_cpu_node(i, &thread_id);
+		cbe_thread_map[i].cpu_node =
+				arch_of_get_cpunode_by_tid(i, &thread_id);
 		cbe_thread_map[i].be_node = cbe_get_be_node(i);
 		cbe_thread_map[i].thread_id = thread_id;
 	}
diff --git a/arch/powerpc/platforms/wsp/ics.c
b/arch/powerpc/platforms/wsp/ics.c
index 2d3b1dd..b83bc2e 100644
--- a/arch/powerpc/platforms/wsp/ics.c
+++ b/arch/powerpc/platforms/wsp/ics.c
@@ -137,7 +137,7 @@ void cpus_on_chip(int chip_id, cpumask_t *mask,
cpumask_t *ret)

 	cpumask_clear(ret);
 	for_each_cpu(cpu, mask) {
-		cpu_dn = of_get_cpu_node(cpu, NULL);
+		cpu_dn = of_get_cpu_node(cpu);
 		if (!cpu_dn)
 			continue;

@@ -649,7 +649,7 @@ static void __init wsp_ics_set_default_server(void)
 	u32 hwid;

 	/* Find the server number for the boot cpu. */
-	np = of_get_cpu_node(boot_cpuid, NULL);
+	np = of_get_cpu_node(boot_cpuid);
 	BUG_ON(!np);

 	hwid = get_hard_smp_processor_id(boot_cpuid);
diff --git a/arch/powerpc/platforms/wsp/smp.c
b/arch/powerpc/platforms/wsp/smp.c
index 332a18b..2abe794 100644
--- a/arch/powerpc/platforms/wsp/smp.c
+++ b/arch/powerpc/platforms/wsp/smp.c
@@ -40,7 +40,7 @@ int smp_a2_kick_cpu(int nr)
 	if (nr < 0 || nr >= NR_CPUS)
 		return -ENOENT;

-	np = of_get_cpu_node(nr, &thr_idx);
+	np = arch_of_get_cpunode_by_tid(nr, &thr_idx);
 	if (!np)
 		return -ENODEV;

diff --git a/arch/powerpc/platforms/wsp/wsp.c
b/arch/powerpc/platforms/wsp/wsp.c
index d25cc96..43a17a2 100644
--- a/arch/powerpc/platforms/wsp/wsp.c
+++ b/arch/powerpc/platforms/wsp/wsp.c
@@ -90,7 +90,7 @@ void wsp_halt(void)
 	struct device_node *mine;
 	struct device_node *me;

-	me = of_get_cpu_node(smp_processor_id(), NULL);
+	me = of_get_cpu_node(smp_processor_id());
 	mine = scom_find_parent(me);

 	/* This will halt all the A2s but not power off the chip */
diff --git a/arch/powerpc/sysdev/xics/xics-common.c
b/arch/powerpc/sysdev/xics/xics-common.c
index 9049d9f..d16082f 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -53,7 +53,7 @@ void xics_update_irq_servers(void)
 	u32 hcpuid;

 	/* Find the server numbers for the boot cpu. */
-	np = of_get_cpu_node(boot_cpuid, NULL);
+	np = of_get_cpu_node(boot_cpuid);
 	BUG_ON(!np);

 	hcpuid = get_hard_smp_processor_id(boot_cpuid);
diff --git a/drivers/cpufreq/pasemi-cpufreq.c
b/drivers/cpufreq/pasemi-cpufreq.c
index b704da4..692755f 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -149,7 +149,7 @@ static int pas_cpufreq_cpu_init(struct
cpufreq_policy *policy)
 	struct device_node *cpu, *dn;
 	int err = -ENODEV;

-	cpu = of_get_cpu_node(policy->cpu, NULL);
+	cpu = of_get_cpu_node(policy->cpu);

 	if (!cpu)
 		goto out;
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c
b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 3cae452..64fb70a 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -150,7 +150,7 @@ static int corenet_cpufreq_cpu_init(struct
cpufreq_policy *policy)
 	struct cpu_data *data;
 	unsigned int cpu = policy->cpu;

-	np = of_get_cpu_node(cpu, NULL);
+	np = of_get_cpu_node(cpu);
 	if (!np)
 		return -ENODEV;

diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c
b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 5936f8d..0700445 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -75,7 +75,7 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy
*policy)
 	int i, cur_pmode;
 	struct device_node *cpu;

-	cpu = of_get_cpu_node(policy->cpu, NULL);
+	cpu = of_get_cpu_node(policy->cpu);

 	if (!cpu)
 		return -ENODEV;








