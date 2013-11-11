Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3KKINp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:13:45 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57851 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3KKINa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:13:30 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-c8-528091a7a921
Message-id: <528091A5.6030205@samsung.com>
Date: Mon, 11 Nov 2013 12:13:25 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Dave Martin <Dave.Martin@arm.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3 3/4] ARM: EXYNOS: add Exynos Dual Cluster Support
References: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
 <1383811969-32712-4-git-send-email-v.tyrtov@samsung.com>
 <20131107130141.GA3129@localhost.localdomain>
In-reply-to: <20131107130141.GA3129@localhost.localdomain>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t/xq7rLJzYEGXxuV7CYtO4Ak8W8z7IW
	TXP3MFrMP3KO1eL/o9esFuderWS06F1wlc1i0+NrrBYL25awWFzeNYfNYsb5fUwWty/zWiy9
	fpHJ4umEi2wWn579Y7eYMH0ti8XhFUDT1r2czmKx5WcHo8Wrg20sFps3TWW2WLXrD6PF1Bk/
	2B3EPdbMW8Po0dLcw+ax4PMVdo+/q14we+ycdZfdY+XyL2wer1bPZPW4c20Pm8e7c+fYPTYv
	qfd4dY3Fo2/LKkaP7dfmMXt83iTnsXFuaAB/FJdNSmpOZllqkb5dAlfG1yWTmAq2RVcsf9nE
	1MD41aOLkZNDQsBEou3fHEYIW0ziwr31bF2MXBxCAksZJd5dbIdy3jNK3Pv9hBmkildAS2LN
	k7dgNouAqsTErWeAbA4ONgFtiS07vEDCogIREkdXP2OFKBeU+DH5HguILSLgL9H88h8TyExm
	gS/sEos6foDNERbwkDg56zIrxLL1jBK3LzSBdXMKWEm8eNnNBmIzC1hLrJy0jRHClpfYvOYt
	8wRGgVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEx/mUH4+JjVocY
	BTgYlXh4IxQagoRYE8uKK3MPMUpwMCuJ8GZ5AIV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwNl77
	ps9/OrE0JKOov/jDchuW2sxUxfTzC9e9kUtgjHmS+7iIofLC98YtgjGdHr26n00mR5177Dlp
	3QeV80dWJZt6asy1nm+6q0ZZK/Tj2Y7uv//tHxh4SQRt0Zmvo3n1RE/yi60PthqsbdwtqfDx
	1TT150IytyP+tNu0ykazvZ/qt/Ct8tNVSizFGYmGWsxFxYkA1/r7+s8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.2013 17:01, Dave Martin wrote:
> On Thu, Nov 07, 2013 at 08:12:48AM +0000, Vyacheslav Tyrtov wrote:
>> From: Tarek Dakhran <t.dakhran@samsung.com>
>>
>> Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
>> This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.
>>
>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>> ---
>>   arch/arm/mach-exynos/Makefile |   2 +
>>   arch/arm/mach-exynos/edcs.c   | 278 ++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 280 insertions(+)
>>   create mode 100644 arch/arm/mach-exynos/edcs.c
>>
>> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
>> index 5369615..ba6efdb 100644
>> --- a/arch/arm/mach-exynos/Makefile
>> +++ b/arch/arm/mach-exynos/Makefile
>> @@ -34,3 +34,5 @@ AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
>>   
>>   obj-$(CONFIG_MACH_EXYNOS4_DT)		+= mach-exynos4-dt.o
>>   obj-$(CONFIG_MACH_EXYNOS5_DT)		+= mach-exynos5-dt.o
>> +
>> +obj-$(CONFIG_SOC_EXYNOS5410)		+= edcs.o
>> diff --git a/arch/arm/mach-exynos/edcs.c b/arch/arm/mach-exynos/edcs.c
>> new file mode 100644
>> index 0000000..980bfdd
>> --- /dev/null
>> +++ b/arch/arm/mach-exynos/edcs.c
>> @@ -0,0 +1,278 @@
>> +/*
>> + * arch/arm/mach-exynos/edcs.c - exynos dual cluster power management support
>> + *
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
>> + * Author: Tarek Dakhran <t.dakhran@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * EDCS(exynos dual cluster support) for Exynos5410 SoC.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/io.h>
>> +#include <linux/of_address.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/errno.h>
>> +#include <linux/irqchip/arm-gic.h>
>> +
>> +#include <asm/mcpm.h>
>> +#include <asm/proc-fns.h>
>> +#include <asm/cacheflush.h>
>> +#include <asm/cputype.h>
>> +#include <asm/cp15.h>
>> +
>> +#include <linux/arm-cci.h>
>> +#include <mach/regs-pmu.h>
>> +
>> +#define EDCS_CPUS_PER_CLUSTER	4
>> +#define EDCS_CLUSTERS		2
>> +
>> +/* Exynos5410 power management registers */
>> +#define EDCS_CORE_CONFIGURATION(_nr)	(S5P_ARM_CORE0_CONFIGURATION	\
>> +						+ ((_nr) * 0x80))
>> +#define EDCS_CORE_STATUS(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x4)
>> +#define EDCS_CORE_OPTION(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x8)
>> +
>> +#define REG_CPU_STATE_ADDR0		(S5P_VA_SYSRAM_NS + 0x28)
>> +#define REG_CPU_STATE_ADDR(_nr)		(REG_CPU_STATE_ADDR0 +	\
>> +						 (_nr) * EDCS_CPUS_PER_CLUSTER)
>> +
>> +#define SECONDARY_RESET		(1 << 1)
>> +#define REG_ENTRY_ADDR		(S5P_VA_SYSRAM_NS + 0x1c)
>> +
>> +static arch_spinlock_t edcs_lock = __ARCH_SPIN_LOCK_UNLOCKED;
>> +
>> +static int edcs_use_count[EDCS_CPUS_PER_CLUSTER][EDCS_CLUSTERS];
>> +static int core_count[EDCS_CLUSTERS];
>> +
>> +static void exynos_core_power_control(unsigned int cpu, unsigned int cluster,
>> +				bool enable)
>> +{
>> +	unsigned int offset = cluster * MAX_CPUS_PER_CLUSTER + cpu;
>> +	int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
>> +
>> +	if ((readl_relaxed(EDCS_CORE_STATUS(offset)) & 0x3) != value) {
> I wonder if there is a race here.
>
> If there is a pending powerdown which has reached the __mcpm_cpu_down()
> stage, then the kernel has no way to know what is still pending.  This
> means that when calling exynos_power_up(cpu, cluster) after a successful
> call to exynos_power_down(same cpu, cluster), there is a chance that
> the CPU still gets powered down, because of the pending
> exynos_core_power_control() on the outbound side.
>
> This isn't an issue for TC2, because TC2's power controller queues
> requests and services them in order, so a new powerup request cannot
> race with a powerdown request in that way.
>
> For exynos5410, it looks like the kernel needs to do that sequencing,
> based on my guess about what the EDCS_CORE_STATUS() bits tell us.
>
>
> I think that for correct behaviour we would need to wait for the race to
> be resolved here, but only if a powerdown might be pending.
>
> This implies that something like a call to the power_down_finish()
> method (which you would need to write -- see my comments below) is
> needed in exynos_core_power_up().
>
>
> It might make sense to have a per-cpu flag that tracks whether a
> powerdown is pending.  The flag could be set after
> __mcpm_cpu_going_down() is called, and cleared in the powered_up()
> method (which you would need to add).
>
>
> Maybe we should always just poll and wait, though.  exynos_power_up()
> should never be called for a CPU that the kernel thinks is already up,
> so it should either be down already (in which case we will poll the
> status once and then continue), or a power down is pending (in which
> case we must wait, but we know the wait will terminate).  This would
> be simpler than tracking a "power down pending" flag for each CPU.
>
>> +		wmb();
>> +		writel_relaxed(value, EDCS_CORE_CONFIGURATION(offset));
>> +	}
>> +}
>> +
>> +static void exynos_core_power_up(unsigned int cpu, unsigned int cluster)
>> +{
>> +	exynos_core_power_control(cpu, cluster, true);
>> +}
>> +
>> +static void exynos_core_power_down(unsigned int cpu, unsigned int cluster)
>> +{
>> +	exynos_core_power_control(cpu, cluster, false);
>> +}
>> +
>> +void set_boot_flag(unsigned int cpu, unsigned int mode)
>> +{
>> +	writel_relaxed(mode, REG_CPU_STATE_ADDR(cpu));
>> +}
>> +
>> +static int exynos_power_up(unsigned int cpu, unsigned int cluster)
>> +{
>> +	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
>> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER || cluster >= EDCS_CLUSTERS);
>> +
>> +	local_irq_disable();
>> +	arch_spin_lock(&edcs_lock);
>> +
>> +	edcs_use_count[cpu][cluster]++;
>> +	if (edcs_use_count[cpu][cluster] == 1) {
>> +		++core_count[cluster];
>> +		set_boot_flag(cpu, SECONDARY_RESET);
>> +		exynos_core_power_up(cpu, cluster);
>> +	} else if (edcs_use_count[cpu][cluster] != 2) {
>> +		/*
>> +		 * The only possible values are:
>> +		 * 0 = CPU down
>> +		 * 1 = CPU (still) up
>> +		 * 2 = CPU requested to be up before it had a chance
>> +		 *     to actually make itself down.
>> +		 * Any other value is a bug.
>> +		 */
>> +		BUG();
>> +	}
>> +
>> +	arch_spin_unlock(&edcs_lock);
>> +	local_irq_enable();
>> +
>> +	return 0;
>> +}
>> +static void exynos_power_down(void)
>> +{
>> +	unsigned int mpidr, cpu, cluster;
>> +	bool last_man = false, skip_wfi = false;
>> +
>> +	mpidr = read_cpuid_mpidr();
>> +	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
>> +	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
>> +
>> +	pr_debug("%s: CORE%d on CLUSTER %d\n", __func__, cpu, cluster);
>> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
>> +
>> +	__mcpm_cpu_going_down(cpu, cluster);
>> +
>> +	arch_spin_lock(&edcs_lock);
>> +	BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
>> +	edcs_use_count[cpu][cluster]--;
>> +	if (edcs_use_count[cpu][cluster] == 0) {
>> +		--core_count[cluster];
>> +		if (core_count[cluster] == 0)
>> +			last_man = true;
>> +	} else if (edcs_use_count[cpu][cluster] == 1) {
>> +		/*
>> +		 * A power_up request went ahead of us.
>> +		 * Even if we do not want to shut this CPU down,
>> +		 * the caller expects a certain state as if the WFI
>> +		 * was aborted.  So let's continue with cache cleaning.
>> +		 */
>> +		skip_wfi = true;
>> +	} else
>> +		BUG();
>> +
>> +	if (!skip_wfi)
>> +		gic_cpu_if_down();
>> +
>> +	if (last_man && __mcpm_outbound_enter_critical(cpu, cluster)) {
>> +		arch_spin_unlock(&edcs_lock);
>> +
>> +		if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A15) {
>> +			/*
>> +			 * On the Cortex-A15 we need to disable
>> +			 * L2 prefetching before flushing the cache.
>> +			 */
>> +			asm volatile(
>> +			"mcr	p15, 1, %0, c15, c0, 3\n\t"
>> +			"isb\n\t"
>> +			"dsb"
>> +			: : "r" (0x400));
>> +		}
>> +
>> +		/*
>> +		 * We need to disable and flush the whole (L1 and L2) cache.
>> +		 * Let's do it in the safest possible way i.e. with
>> +		 * no memory access within the following sequence
>> +		 * including the stack.
>> +		 *
>> +		 * Note: fp is preserved to the stack explicitly prior doing
>> +		 * this since adding it to the clobber list is incompatible
>> +		 * with having CONFIG_FRAME_POINTER=y.
>> +		 */
>> +		asm volatile(
>> +		"str	fp, [sp, #-4]!\n\t"
>> +		"mrc	p15, 0, r0, c1, c0, 0	@ get CR\n\t"
>> +		"bic	r0, r0, #"__stringify(CR_C)"\n\t"
>> +		"mcr	p15, 0, r0, c1, c0, 0	@ set CR\n\t"
>> +		"isb\n\t"
>> +		"bl	v7_flush_dcache_all\n\t"
>> +		"clrex\n\t"
>> +		"mrc	p15, 0, r0, c1, c0, 1	@ get AUXCR\n\t"
>> +		"bic	r0, r0, #(1 << 6)	@ disable local coherency\n\t"
>> +		"mcr	p15, 0, r0, c1, c0, 1	@ set AUXCR\n\t"
>> +		"isb\n\t"
>> +		"dsb\n\t"
>> +		"ldr	fp, [sp], #4"
> The v7_exit_coherency_flush() macro is now in linux-next, so
> you can now use it to replace these sequences.
>
> This can be replaced by v7_exit_coherency_flush(all).
>
>> +		: : : "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
>> +			"r9", "r10", "lr", "memory");
>> +
>> +		cci_disable_port_by_cpu(mpidr);
>> +
>> +		__mcpm_outbound_leave_critical(cluster, CLUSTER_DOWN);
>> +
>> +	} else {
>> +		arch_spin_unlock(&edcs_lock);
>> +		/*
>> +			* We need to disable and flush only the L1 cache.
>> +			* Let's do it in the safest possible way as above.
>> +		*/
>> +		asm volatile(
>> +		"str	fp, [sp, #-4]!\n\t"
>> +		"mrc	p15, 0, r0, c1, c0, 0	@ get CR\n\t"
>> +		"bic	r0, r0, #"__stringify(CR_C)"\n\t"
>> +		"mcr	p15, 0, r0, c1, c0, 0	@ set CR\n\t"
>> +		"isb\n\t"
>> +		"bl	v7_flush_dcache_louis\n\t"
>> +		"clrex\n\t"
>> +		"mrc	p15, 0, r0, c1, c0, 1	@ get AUXCR\n\t"
>> +		"bic	r0, r0, #(1 << 6)	@ disable local coherency\n\t"
>> +		"mcr	p15, 0, r0, c1, c0, 1	@ set AUXCR\n\t"
>> +		"isb\n\t"
>> +		"dsb\n\t"
>> +		"ldr	fp, [sp], #4"
> v7_exit_coherency_flush(louis) should work here.
>
> arch/arm/mach-vexpress/tc2_pm.c (in linux-next) shows how to use it.
>
>> +		: : : "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
>> +		      "r9", "r10", "lr", "memory");
>> +
>> +	}
>> +	__mcpm_cpu_down(cpu, cluster);
>> +
>> +	if (!skip_wfi) {
>> +		exynos_core_power_down(cpu, cluster);
>> +		wfi();
>> +	}
>> +}
>> +
>> +static const struct mcpm_platform_ops exynos_power_ops = {
>> +	.power_up	= exynos_power_up,
>> +	.power_down	= exynos_power_down,
>> +};
> The new mcpm_power_down_finish() call is also present in linux-next now,
> so it should get merged into v3.13.
>
> One effect of this is that you should provide a power_down_finish()
> method in your mcpm_platform_ops, to provide the kernel with a way to
> check that a CPU has finished powering down.  This would usually involve
> checking some status bits in the power controller.  See the comments for
> mcpm_power_down_finish() in arch/arm/include/asm/mcpm.h for details.
>
> No platform backend for power_down_finish() is merged yet.  The most
> recent patch for TC2 was posted here -- I need to follow up on it.
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/201619.html
> [PATCH v3 3/3] ARM: vexpress/TC2: Implement MCPM power_down_finish()
>
> This may look quite different for exynos5410.
>
> Cheers
> ---Dave
>
Thanks Dave.
I'm working on this problem.

Best regards,
     Tarek Dakhran.
