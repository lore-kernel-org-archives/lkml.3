Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3KZJDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:03:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14700 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab3KZJCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:02:13 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-be-5294639230d9
From: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org, tomasz.figa@gmail.com
Subject: [PATCH v4 4/4] ARM: EXYNOS: add Exynos Dual Cluster Support
Date: Tue, 26 Nov 2013 12:58:08 +0400
Message-id: <1385456288-20398-5-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1385456288-20398-1-git-send-email-v.tyrtov@samsung.com>
References: <1385456288-20398-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xK7qTkqcEGXz5ImIxad0BJot5n2Ut
	mubuYbSYf+Qcq8X/R69ZLc69Wslo0bvgKpvFpsfXWC0Wti1hsbi8aw6bxYzz+5gsbl/mtVh6
	/SKTxdMJF9ksPj37x24xYfpaFovDK4CmrXs5ncViy88ORotXB9tYLNY/P8VosXnTVGaLVbv+
	MFpMnfGD3UHCY828NYweLc09bB4LPl9h9/i76gWzx85Zd9k9Vi7/wubxavVMVo871/awebw7
	d47dY/OSeo9X11g8+rasYvTYfm0es8fnTXIeG+eGBvBHcdmkpOZklqUW6dslcGXc2nuMueCi
	Z8WViQYNjN+tuxg5OSQETCT2vrnHDmGLSVy4t56ti5GLQ0hgKaPE6Y9NjBBOD5PEslddYFVs
	AnoSfa9usIDYIgIKEpt7n7GCFDELHGKTeH3/LnMXIweHsICLROtKNhCTRUBVYsVJQRCTFyj6
	fYUNxC4FiaNtb9lBwpwCrhKXdoeDhIWAKta8P842gZF3ASPDKkbR1NLkguKk9FwjveLE3OLS
	vHS95PzcTYyQmPq6g3HpMatDjAIcjEo8vBKdk4OEWBPLiitzDzFKcDArifC63gcK8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYKyI29+2PzrsorTO1v1WqYX8U/luL8gzC90oyb7yU6/OIY0QP/2r
	d498C1588ul3m+4//6szrUrVcx2Vq7edfTWRQ71LqvVdoreMscUpQ/GHmasZ/vEkP85mVp21
	YGlN6eSvl4JftV7Tn3qsp8fWqPjwL6ufWaeFt97aJFM31+l5pvkGq7uaa5RYijMSDbWYi4oT
	AU6lXciHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/mach-exynos/Makefile |   2 +
 arch/arm/mach-exynos/edcs.c   | 297 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 299 insertions(+)
 create mode 100644 arch/arm/mach-exynos/edcs.c

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 8930b66..bc1f7f9 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -34,3 +34,5 @@ AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
 
 obj-$(CONFIG_ARCH_EXYNOS4)	+= mach-exynos4-dt.o
 obj-$(CONFIG_ARCH_EXYNOS5)	+= mach-exynos5-dt.o
+
+obj-$(CONFIG_SOC_EXYNOS5410)	+= edcs.o
diff --git a/arch/arm/mach-exynos/edcs.c b/arch/arm/mach-exynos/edcs.c
new file mode 100644
index 0000000..29f0bdd
--- /dev/null
+++ b/arch/arm/mach-exynos/edcs.c
@@ -0,0 +1,297 @@
+/*
+ * arch/arm/mach-exynos/edcs.c - exynos dual cluster power management support
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * Author: Tarek Dakhran <t.dakhran@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * EDCS(exynos dual cluster support) for Exynos5410 SoC.
+ */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/irqchip/arm-gic.h>
+#include <linux/delay.h>
+
+#include <asm/mcpm.h>
+#include <asm/proc-fns.h>
+#include <asm/cacheflush.h>
+#include <asm/cputype.h>
+#include <asm/cp15.h>
+
+#include <linux/arm-cci.h>
+#include <mach/regs-pmu.h>
+
+#define EDCS_CPUS_PER_CLUSTER		4
+#define EDCS_CLUSTERS			2
+
+/* Exynos5410 power management registers */
+#define EDCS_CORE_CONFIGURATION(_nr)	(S5P_ARM_CORE0_CONFIGURATION	\
+						+ ((_nr) * 0x80))
+#define EDCS_CORE_STATUS(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x4)
+#define EDCS_CORE_OPTION(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x8)
+
+#define REG_CPU_STATE_ADDR0		(S5P_VA_SYSRAM_NS + 0x28)
+#define REG_CPU_STATE_ADDR(_nr)		(REG_CPU_STATE_ADDR0 +	\
+						 (_nr) * EDCS_CPUS_PER_CLUSTER)
+
+#define SECONDARY_RESET			(1 << 1)
+#define REG_ENTRY_ADDR			(S5P_VA_SYSRAM_NS + 0x1c)
+
+#define EDCS_CORE_PWR_ON		0x3
+#define EDCS_CORE_PWR_OFF		0x0
+#define CORE_PWR_STATE_MASK		0x3
+
+static arch_spinlock_t edcs_lock = __ARCH_SPIN_LOCK_UNLOCKED;
+
+static int edcs_use_count[EDCS_CPUS_PER_CLUSTER][EDCS_CLUSTERS];
+static int core_count[EDCS_CLUSTERS];
+
+/*
+ * this_core_to_pcpu reads mpidr and defines cluster and cpu.
+ */
+static void this_core_to_pcpu(unsigned int *pcpu, unsigned int *pcluster)
+{
+	unsigned int mpidr;
+
+	mpidr = read_cpuid_mpidr();
+	*pcpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+	*pcluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
+}
+
+/*
+ * core_power_state is used to get core power state.
+ * returns:
+ *        0x0 - powered off;
+ *        0x3 - powered on;
+ *        other values - in process;
+ */
+static int core_power_state(unsigned int cpu, unsigned int cluster)
+{
+	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
+	int status = readl_relaxed(EDCS_CORE_STATUS(offset));
+
+	return status & CORE_PWR_STATE_MASK;
+}
+
+static void edcs_core_power_up(unsigned int cpu, unsigned int cluster)
+{
+	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
+	if (core_power_state(cpu, cluster) == EDCS_CORE_PWR_OFF) {
+		/* boot flag should be written before powering up */
+		wmb();
+		writel_relaxed(EDCS_CORE_PWR_ON,
+				 EDCS_CORE_CONFIGURATION(offset));
+	}
+}
+
+static void edcs_core_power_down(unsigned int cpu, unsigned int cluster)
+{
+	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
+	if (core_power_state(cpu, cluster) == EDCS_CORE_PWR_ON)
+		writel_relaxed(EDCS_CORE_PWR_OFF,
+				 EDCS_CORE_CONFIGURATION(offset));
+}
+
+void set_boot_flag(unsigned int cpu, unsigned int mode)
+{
+	writel_relaxed(mode, REG_CPU_STATE_ADDR(cpu));
+}
+
+static int edcs_power_up(unsigned int cpu, unsigned int cluster)
+{
+	pr_debug("cpu %u cluster %u\n", cpu, cluster);
+	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER || cluster >= EDCS_CLUSTERS);
+
+	local_irq_disable();
+	arch_spin_lock(&edcs_lock);
+
+	edcs_use_count[cpu][cluster]++;
+	if (edcs_use_count[cpu][cluster] == 1) {
+		++core_count[cluster];
+		set_boot_flag(cpu, SECONDARY_RESET);
+		edcs_core_power_up(cpu, cluster);
+	} else if (edcs_use_count[cpu][cluster] != 2) {
+		/*
+		 * The only possible values are:
+		 * 0 = CPU down
+		 * 1 = CPU (still) up
+		 * 2 = CPU requested to be up before it had a chance
+		 *     to actually make itself down.
+		 * Any other value is a bug.
+		 */
+		BUG();
+	}
+
+	arch_spin_unlock(&edcs_lock);
+	local_irq_enable();
+
+	return 0;
+}
+static void edcs_power_down(void)
+{
+	unsigned int mpidr, cpu, cluster;
+	bool last_man = false, skip_wfi = false;
+
+	this_core_to_pcpu(&cpu, &cluster);
+	mpidr = read_cpuid_mpidr();
+
+	pr_debug("cpu %u cluster %u\n", cpu, cluster);
+	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
+
+	__mcpm_cpu_going_down(cpu, cluster);
+
+	arch_spin_lock(&edcs_lock);
+	BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
+	edcs_use_count[cpu][cluster]--;
+	if (edcs_use_count[cpu][cluster] == 0) {
+		--core_count[cluster];
+		edcs_core_power_down(cpu, cluster);
+		if (core_count[cluster] == 0)
+			last_man = true;
+	} else if (edcs_use_count[cpu][cluster] == 1) {
+		/*
+		 * A power_up request went ahead of us.
+		 * Even if we do not want to shut this CPU down,
+		 * the caller expects a certain state as if the WFI
+		 * was aborted.  So let's continue with cache cleaning.
+		 */
+		skip_wfi = true;
+	} else
+		BUG();
+
+	if (!skip_wfi)
+		gic_cpu_if_down();
+
+	if (last_man && __mcpm_outbound_enter_critical(cpu, cluster)) {
+		arch_spin_unlock(&edcs_lock);
+
+		if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A15) {
+			/*
+			 * On the Cortex-A15 we need to disable
+			 * L2 prefetching before flushing the cache.
+			 */
+			asm volatile(
+			"mcr	p15, 1, %0, c15, c0, 3\n\t"
+			"isb\n\t"
+			"dsb"
+			: : "r" (0x400));
+		}
+
+		/*
+		 * We need to disable and flush the whole (L1 and L2) cache.
+		 * Let's do it in the safest possible way i.e. with
+		 * no memory access within the following sequence
+		 * including the stack.
+		 *
+		 * Note: fp is preserved to the stack explicitly prior doing
+		 * this since adding it to the clobber list is incompatible
+		 * with having CONFIG_FRAME_POINTER=y.
+		 */
+		v7_exit_coherency_flush(all);
+
+		cci_disable_port_by_cpu(mpidr);
+
+		__mcpm_outbound_leave_critical(cluster, CLUSTER_DOWN);
+
+	} else {
+		arch_spin_unlock(&edcs_lock);
+		/*
+			* We need to disable and flush only the L1 cache.
+			* Let's do it in the safest possible way as above.
+		*/
+		v7_exit_coherency_flush(louis);
+
+	}
+	__mcpm_cpu_down(cpu, cluster);
+
+	if (!skip_wfi)
+		wfi();
+}
+
+static int edcs_power_down_finish(unsigned int cpu, unsigned int cluster)
+{
+	unsigned int timeout = 1000;
+	unsigned int sleep_time = 10;
+
+	pr_debug("cpu %u cluster %u\n", cpu, cluster);
+	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
+
+	do {
+		if (ACCESS_ONCE(edcs_use_count[cpu][cluster]) == 0) {
+			/* checking if core powered down */
+			if (core_power_state(cpu, cluster) == EDCS_CORE_PWR_OFF)
+				return 0;
+		}
+		msleep(sleep_time);
+		timeout -= sleep_time;
+	} while (timeout);
+
+	return -ETIMEDOUT; /* timeout */
+}
+
+static const struct mcpm_platform_ops edcs_power_ops = {
+	.power_up		= edcs_power_up,
+	.power_down		= edcs_power_down,
+	.power_down_finish	= edcs_power_down_finish,
+};
+
+static void __init edcs_data_init(void)
+{
+	unsigned int cpu, cluster;
+
+	this_core_to_pcpu(&cpu, &cluster);
+
+	pr_debug("cpu %u cluster %u\n", cpu, cluster);
+	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
+	edcs_use_count[cpu][cluster] = 1;
+	++core_count[cluster];
+}
+
+/*
+ * Enable cluster-level coherency, in preparation for turning on the MMU.
+ */
+static void __naked edcs_power_up_setup(unsigned int affinity_level)
+{
+	asm volatile ("\n"
+	"b	cci_enable_port_for_self");
+}
+
+static int __init edcs_init(void)
+{
+	int ret;
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "samsung,exynos5410");
+	if (!node)
+		return -ENODEV;
+
+	if (!cci_probed())
+		return -ENODEV;
+
+	/*
+	 * Future entries into the kernel can now go
+	 * through the cluster entry vectors.
+	 */
+	writel_relaxed(virt_to_phys(mcpm_entry_point), REG_ENTRY_ADDR);
+
+	edcs_data_init();
+	mcpm_smp_set_ops();
+
+	ret = mcpm_platform_register(&edcs_power_ops);
+	if (!ret) {
+		mcpm_sync_init(edcs_power_up_setup);
+		pr_info("EDCS power management initialized\n");
+	}
+	return ret;
+}
+
+early_initcall(edcs_init);
-- 
1.8.1.5

