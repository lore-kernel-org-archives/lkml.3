Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaKLPOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:14:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21707 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaKLPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:13:57 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-4e-5463792d0f7d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH 2/2] cpuidle: exynos: add coupled cpuidle support for
 Exynos4210
Date: Wed, 12 Nov 2014 16:13:29 +0100
Message-id: <3813280.9hNcruz8Q6@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-70-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <545F8EFF.7030704@linaro.org>
References: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com>
 <1415383252-20118-3-git-send-email-b.zolnierkie@samsung.com>
 <545F8EFF.7030704@linaro.org>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=nextPart2609936.ei6EljyavP
Content-transfer-encoding: 7Bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xgK5uZXKIwfNuXosFM9qZLeZ9lrV4
	/cLQonfBVTaLs01v2C3ePNzMaPH+0DNmi8u75rBZfO49wmgx4/w+JotVu/4wOnB77Jx1l91j
	waZSjzvX9rB53P73mNmjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4MvpPVxfsPMpYsWGOQgPj
	xlmMXYycHBICJhLX+huhbDGJC/fWs3UxcnEICSxilGhd9IUdwmlhkujZ+AKsik3ASmJi+yow
	W0RAT6LxfRsTSBGzwFcmiTf7XrGBJIQFwiQ2rl4OVMTBwSKgKvHtlwFImFdAU+Lkjx9gvaIC
	nhI7px8AszkFtCT2XmtigVi2nFHi+q19jBANghI/Jt9jAZnDLOAksWBFGkiYWUBeYt/+qawT
	GAVmIamahVA1C0kVjN1xuRHK1pRo3f6bHcJ2knh0+QUzpho3ibUvn7BA2CYSRx9uY8RUYy+x
	qmMjlG0hceX7DCzm2Et0793IvICRbxWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcGJ4Jr2D
	cVWDxSFGAQ5GJR7ejM1JIUKsiWXFlbmHGFWA5jzasPoCoxRLXn5eqpII77SS5BAh3pTEyqrU
	ovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjLo8SWuPnZ/dwf7Swv5l
	rdnevr+f96m7H7k6nSPNovD0/aN6ByotF58LVZvHsPHG4Rk7Lweczp46cX2nV+LDqfPSz/tf
	aS6KfnWvviQ1jG8bg0LBpVfqeeZfTp3pDFmx8+zDvH8LPR80mLR/djKzXP9c8BDfO5MbHptW
	nTz3cOaMOL/y6AfFS3cqsRRnJBpqMRcVJwIAjLSQchQDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2609936.ei6EljyavP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"


Hi,

On Sunday, November 09, 2014 04:57:51 PM Daniel Lezcano wrote:
> On 11/07/2014 07:00 PM, Bartlomiej Zolnierkiewicz wrote:
> > The following patch adds coupled cpuidle support for Exynos4210 to
> > an existing cpuidle-exynos driver.  As a result it enables AFTR mode
> > to be used by default on Exynos4210 without the need to hot unplug
> > CPU1 first.
> >
> > The patch is heavily based on earlier cpuidle-exynos4210 driver from
> > Daniel Lezcano:
> >
> > http://www.spinics.net/lists/linux-samsung-soc/msg28134.html
> >
> > Changes from Daniel's code include:
> > - porting code to current kernels
> > - fixing it to work on my setup (by using S5P_INFORM register
> >    instead of S5P_VA_SYSRAM one on Revison 1.1 and retrying poking
> >    CPU1 out of the BOOT ROM if necessary)
> > - fixing rare lockup caused by waiting for CPU1 to get stuck in
> >    the BOOT ROM (CPU hotplug code in arch/arm/mach-exynos/platsmp.c
> >    doesn't require this and works fine)
> > - moving Exynos specific code to arch/arm/mach-exynos/pm.c
> > - using cpu_boot_reg_base() helper instead of BOOT_VECTOR macro
> > - using exynos_cpu_*() helpers instead of accessing registers
> >    directly
> > - using arch_send_wakeup_ipi_mask() instead of dsb_sev()
> >    (this matches CPU hotplug code in arch/arm/mach-exynos/platsmp.c)
> 
> I am curious. You experienced very rare hangs after running the tests a 
> few hours, right ? Is the SEV replaced by the IPI solving the issue ? If 
> yes, how did you catch it ?

Rare hangs showed up after about 30-40 minutes of testing with the attached
app and script (running of "./cpuidle_state1_test.sh script 2 500" has never
completed on the umodified driver).

The problem turned out to be in the following loop waiting for CPU1 to get
stuck in the BOOT ROM:

		/*
		 * Wait for cpu1 to get stuck in the boot rom
		 */
		while ((__raw_readl(BOOT_VECTOR) != 0) &&
		       !atomic_read(&cpu1_wakeup))
			cpu_relax();

[ Removal of the loop fixed the problem. ]

Using the SEV instead of the IPI was not a issue but it was changed to
match the existing Exynos platform code (exynos_boot_secondary() in
arch/arm/mach-exynos/platsmp.c) and as preparation for Exynos4412 (quad
core) support.

> >- integrating separate exynos4210-cpuidle driver into existing
> >    exynos-cpuidle one
> >
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Colin Cross <ccross@google.com>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Tomasz Figa <tomasz.figa@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Thanks!

> A few comments below:
> 
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >   arch/arm/mach-exynos/common.h                |   4 +
> >   arch/arm/mach-exynos/exynos.c                |   4 +
> >   arch/arm/mach-exynos/platsmp.c               |   2 +-
> >   arch/arm/mach-exynos/pm.c                    | 122 +++++++++++++++++++++++++++
> >   drivers/cpuidle/Kconfig.arm                  |   1 +
> >   drivers/cpuidle/cpuidle-exynos.c             |  62 ++++++++++++--
> >   include/linux/platform_data/cpuidle-exynos.h |  20 +++++
> >   7 files changed, 209 insertions(+), 6 deletions(-)
> >   create mode 100644 include/linux/platform_data/cpuidle-exynos.h
> >
> > diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> > index d4d09bc..f208a60 100644
> > --- a/arch/arm/mach-exynos/common.h
> > +++ b/arch/arm/mach-exynos/common.h
> > @@ -14,6 +14,7 @@
> >
> >   #include <linux/reboot.h>
> >   #include <linux/of.h>
> > +#include <linux/platform_data/cpuidle-exynos.h>
> >
> >   #define EXYNOS3250_SOC_ID	0xE3472000
> >   #define EXYNOS3_SOC_MASK	0xFFFFF000
> > @@ -168,8 +169,11 @@ extern void exynos_pm_central_suspend(void);
> >   extern int exynos_pm_central_resume(void);
> >   extern void exynos_enter_aftr(void);
> >
> > +extern struct cpuidle_exynos_data cpuidle_coupled_exynos_data;
> > +
> >   extern void s5p_init_cpu(void __iomem *cpuid_addr);
> >   extern unsigned int samsung_rev(void);
> > +extern void __iomem *cpu_boot_reg_base(void);
> >
> >   static inline void pmu_raw_writel(u32 val, u32 offset)
> >   {
> > diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> > index a487e59..4f4eb9e 100644
> > --- a/arch/arm/mach-exynos/exynos.c
> > +++ b/arch/arm/mach-exynos/exynos.c
> > @@ -317,6 +317,10 @@ static void __init exynos_dt_machine_init(void)
> >   	if (!IS_ENABLED(CONFIG_SMP))
> >   		exynos_sysram_init();
> >
> > +#ifdef CONFIG_ARM_EXYNOS_CPUIDLE
> > +	if (of_machine_is_compatible("samsung,exynos4210"))
> > +		exynos_cpuidle.dev.platform_data = &cpuidle_coupled_exynos_data;
> > +#endif
> 
> You should not add those #ifdef.

Without those #ifdef I get:

  LD      init/built-in.o
arch/arm/mach-exynos/built-in.o: In function `exynos_dt_machine_init':
/home/bzolnier/sam/linux-sprc/arch/arm/mach-exynos/exynos.c:334: undefined reference to `cpuidle_coupled_exynos_data'
make: *** [vmlinux] Error 1

when CONFIG_EXYNOS_CPU_SUSPEND is disabled.

> >   	if (of_machine_is_compatible("samsung,exynos4210") ||
> >   	    of_machine_is_compatible("samsung,exynos4212") ||
> >   	    (of_machine_is_compatible("samsung,exynos4412") &&
> > diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> > index adb36a8..0e3ffc9 100644
> > --- a/arch/arm/mach-exynos/platsmp.c
> > +++ b/arch/arm/mach-exynos/platsmp.c
> > @@ -182,7 +182,7 @@ int exynos_cluster_power_state(int cluster)
> >   		S5P_CORE_LOCAL_PWR_EN);
> >   }
> >
> > -static inline void __iomem *cpu_boot_reg_base(void)
> > +void __iomem *cpu_boot_reg_base(void)
> >   {
> >   	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
> >   		return pmu_base_addr + S5P_INFORM5;
> > diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> > index 4b36ab5..44cc08a 100644
> > --- a/arch/arm/mach-exynos/pm.c
> > +++ b/arch/arm/mach-exynos/pm.c
> > @@ -178,3 +178,125 @@ void exynos_enter_aftr(void)
> >
> >   	cpu_pm_exit();
> >   }
> > +
> > +static atomic_t cpu1_wakeup = ATOMIC_INIT(0);
> > +
> > +static int exynos_cpu0_enter_aftr(void)
> > +{
> > +	int ret = -1;
> > +
> > +	/*
> > +	 * If the other cpu is powered on, we have to power it off, because
> > +	 * the AFTR state won't work otherwise
> > +	 */
> > +	if (cpu_online(1)) {
> > +		/*
> > +		 * We reach a sync point with the coupled idle state, we know
> > +		 * the other cpu will power down itself or will abort the
> > +		 * sequence, let's wait for one of these to happen
> > +		 */
> > +		while (exynos_cpu_power_state(1)) {
> > +			/*
> > +			 * The other cpu may skip idle and boot back
> > +			 * up again
> > +			 */
> > +			if (atomic_read(&cpu1_wakeup))
> > +				goto abort;
> > +
> > +			/*
> > +			 * The other cpu may bounce through idle and
> > +			 * boot back up again, getting stuck in the
> > +			 * boot rom code
> > +			 */
> > +			if (__raw_readl(cpu_boot_reg_base()) == 0)
> > +				goto abort;
> > +
> > +			cpu_relax();
> > +		}
> > +	}
> > +
> > +	exynos_enter_aftr();
> > +	ret = 0;
> > +
> > +abort:
> > +	if (cpu_online(1)) {
> > +		/*
> > +		 * Set the boot vector to something non-zero
> > +		 */
> > +		__raw_writel(virt_to_phys(exynos_cpu_resume),
> > +			     cpu_boot_reg_base());
> > +		dsb();
> > +
> > +		/*
> > +		 * Turn on cpu1 and wait for it to be on
> > +		 */
> > +		exynos_cpu_power_up(1);
> > +		while (exynos_cpu_power_state(1) != S5P_CORE_LOCAL_PWR_EN)
> > +			cpu_relax();
> > +
> > +		while (!atomic_read(&cpu1_wakeup)) {
> > +			/*
> > +			 * Poke cpu1 out of the boot rom
> > +			 */
> > +			__raw_writel(virt_to_phys(exynos_cpu_resume),
> > +				     cpu_boot_reg_base());
> > +
> > +			arch_send_wakeup_ipi_mask(cpumask_of(1));
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int exynos_wfi_finisher(unsigned long flags)
> > +{
> > +	cpu_do_idle();
> > +
> > +	return -1;
> > +}
> > +
> > +static int exynos_cpu1_powerdown(void)
> > +{
> > +	int ret = -1;
> > +
> > +	/*
> > +	 * Idle sequence for cpu1
> > +	 */
> > +	if (cpu_pm_enter())
> > +		goto cpu1_aborted;
> > +
> > +	/*
> > +	 * Turn off cpu 1
> > +	 */
> > +	exynos_cpu_power_down(1);
> > +
> > +	ret = cpu_suspend(0, exynos_wfi_finisher);
> > +
> > +	cpu_pm_exit();
> > +
> > +cpu1_aborted:
> > +	dsb();
> > +	/*
> > +	 * Notify cpu 0 that cpu 1 is awake
> > +	 */
> > +	atomic_set(&cpu1_wakeup, 1);
> > +
> > +	return ret;
> > +}
> > +
> > +static void exynos_pre_enter_aftr(void)
> > +{
> > +	__raw_writel(virt_to_phys(exynos_cpu_resume), cpu_boot_reg_base());
> > +}
> > +
> > +static void exynos_post_enter_aftr(void)
> > +{
> > +	atomic_set(&cpu1_wakeup, 0);
> > +}
> > +
> > +struct cpuidle_exynos_data cpuidle_coupled_exynos_data = {
> > +	.cpu0_enter_aftr		= exynos_cpu0_enter_aftr,
> > +	.cpu1_powerdown		= exynos_cpu1_powerdown,
> > +	.pre_enter_aftr		= exynos_pre_enter_aftr,
> > +	.post_enter_aftr		= exynos_post_enter_aftr,
> > +};
> > diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
> > index 8c16ab2..8e07c94 100644
> > --- a/drivers/cpuidle/Kconfig.arm
> > +++ b/drivers/cpuidle/Kconfig.arm
> > @@ -55,6 +55,7 @@ config ARM_AT91_CPUIDLE
> >   config ARM_EXYNOS_CPUIDLE
> >   	bool "Cpu Idle Driver for the Exynos processors"
> >   	depends on ARCH_EXYNOS
> > +	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
> >   	help
> >   	  Select this to enable cpuidle for Exynos processors
> >
> > diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
> > index ba9b34b..4700d5d 100644
> > --- a/drivers/cpuidle/cpuidle-exynos.c
> > +++ b/drivers/cpuidle/cpuidle-exynos.c
> > @@ -1,8 +1,11 @@
> > -/* linux/arch/arm/mach-exynos/cpuidle.c
> > - *
> > - * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> > +/*
> > + * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
> >    *		http://www.samsung.com
> >    *
> > + * Coupled cpuidle support based on the work of:
> > + *	Colin Cross <ccross@android.com>
> > + *	Daniel Lezcano <daniel.lezcano@linaro.org>
> > + *
> >    * This program is free software; you can redistribute it and/or modify
> >    * it under the terms of the GNU General Public License version 2 as
> >    * published by the Free Software Foundation.
> > @@ -13,13 +16,49 @@
> >   #include <linux/export.h>
> >   #include <linux/module.h>
> >   #include <linux/platform_device.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_data/cpuidle-exynos.h>
> >
> >   #include <asm/proc-fns.h>
> >   #include <asm/suspend.h>
> >   #include <asm/cpuidle.h>
> >
> > +static atomic_t exynos_idle_barrier;
> > +
> > +static struct cpuidle_exynos_data *exynos_cpuidle_pdata;
> >   static void (*exynos_enter_aftr)(void);
> >
> > +static int exynos_enter_coupled_lowpower(struct cpuidle_device *dev,
> > +					 struct cpuidle_driver *drv,
> > +					 int index)
> > +{
> > +	int ret;
> > +
> > +	exynos_cpuidle_pdata->pre_enter_aftr();
> > +
> > +	/*
> > +	 * Waiting all cpus to reach this point at the same moment
> > +	 */
> > +	cpuidle_coupled_parallel_barrier(dev, &exynos_idle_barrier);
> > +
> > +	/*
> > +	 * Both cpus will reach this point at the same time
> > +	 */
> > +	ret = dev->cpu ? exynos_cpuidle_pdata->cpu1_powerdown()
> > +		       : exynos_cpuidle_pdata->cpu0_enter_aftr();
> > +	if (ret)
> > +		index = ret;
> > +
> > +	/*
> > +	 * Waiting all cpus to finish the power sequence before going further
> > +	 */
> > +	cpuidle_coupled_parallel_barrier(dev, &exynos_idle_barrier);
> > +
> > +	exynos_cpuidle_pdata->post_enter_aftr();
> > +
> > +	return index;
> > +}
> > +
> >   static int exynos_enter_lowpower(struct cpuidle_device *dev,
> >   				struct cpuidle_driver *drv,
> >   				int index)
> > @@ -58,11 +97,24 @@ static struct cpuidle_driver exynos_idle_driver = {
> >
> >   static int exynos_cpuidle_probe(struct platform_device *pdev)
> >   {
> > +	const struct cpumask *coupled_cpus = NULL;
> >   	int ret;
> >
> > -	exynos_enter_aftr = (void *)(pdev->dev.platform_data);
> > +	if (of_machine_is_compatible("samsung,exynos4210")) {
> > +		exynos_cpuidle_pdata = pdev->dev.platform_data;
> > +
> > +		exynos_idle_driver.states[1].enter =
> > +						exynos_enter_coupled_lowpower;
> > +		exynos_idle_driver.states[1].exit_latency = 5000;
> > +		exynos_idle_driver.states[1].target_residency = 10000;
> > +		exynos_idle_driver.states[1].flags |= CPUIDLE_FLAG_COUPLED |
> > +						      CPUIDLE_FLAG_TIMER_STOP;
> 
> I tried to remove those dynamic state allocation everywhere in the 
> different drivers. I would prefer to have another cpuidle_driver to be 
> registered with its states instead of overwriting the existing idle state.
> 
> struct cpuidle_driver exynos4210_idle_driver = {
> 	.name = "exynos4210_idle",
> 	.owner = THIS_MODULE,
> 	.states = {
> 		[0] = ARM_CPUIDLE_WFI_STATE,
>                  [1] = {
>                          .enter = exynos_enter_coupled_lowpower,
>                          .exit_latency = 5000,
>                          .target_residency = 10000,
> 			.flags = CPUIDLE_FLAG_TIME_VALID |
> 				CPUIDLE_FLAG_COUPLED |
> 				CPUIDLE_FLAG_TIMER_STOP,
>                          .name = "C1",
>                          .desc = "ARM power down",
>                  },
> 	}
> };
> 
> 
> and then:
> 
> if (of_machine_is_compatible("samsung,exynos4210")) {
> 	...
> 	ret = cpuidle_register(&exynos4210_idle_driver,
> 				cpu_online_mask);
> 	...
> }
> ...

OK, I will fix it but (if you are OK with it) I will make the code use
"exynos_coupled" naming instead of "exynos4210" one to not have to change
it later.

> If we can reuse this mechanism, which I believe it is possible to, for 
> 4420 and 5250. Then we will be able to refactor this out again.

I plan to add support for Exynos3250 next as it should be the simplest
(it is also dual core) and I need it for other reasons anyway.  Exynos4412
(quad core) support requires more work but should also be doable.

When it comes to Exynos5250 I was thinking about disabling normal AFTR
mode support for it as according to my testing (on Arndale board) it has
never worked (at least in upstream kernels, I don't know about Linaro or
internal ones).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > +
> > +		coupled_cpus = cpu_possible_mask;
> > +	} else
> > +		exynos_enter_aftr = (void *)(pdev->dev.platform_data);
> >
> > -	ret = cpuidle_register(&exynos_idle_driver, NULL);
> > +	ret = cpuidle_register(&exynos_idle_driver, coupled_cpus);
> >   	if (ret) {
> >   		dev_err(&pdev->dev, "failed to register cpuidle driver\n");
> >   		return ret;
> > diff --git a/include/linux/platform_data/cpuidle-exynos.h b/include/linux/platform_data/cpuidle-exynos.h
> > new file mode 100644
> > index 0000000..bfa40e4
> > --- /dev/null
> > +++ b/include/linux/platform_data/cpuidle-exynos.h
> > @@ -0,0 +1,20 @@
> > +/*
> > + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> > + *              http://www.samsung.com
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > +*/
> > +
> > +#ifndef __CPUIDLE_EXYNOS_H
> > +#define __CPUIDLE_EXYNOS_H
> > +
> > +struct cpuidle_exynos_data {
> > +	int (*cpu0_enter_aftr)(void);
> > +	int (*cpu1_powerdown)(void);
> > +	void (*pre_enter_aftr)(void);
> > +	void (*post_enter_aftr)(void);
> > +};
> > +
> > +#endif

--nextPart2609936.ei6EljyavP
Content-Disposition: attachment; filename="cpuidle_state1_test.sh"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-shellscript; name="cpuidle_state1_test.sh"

#!/bin/bash
#
# Simple scheduler test for deeper idle states (CPU idle).
# Test runs some tasks and let scheduler decide where they
# are executed.
# At the end it prints CPU idle statistics.
#

SCHED_TASKS=2
ROUNDS=10
if [ $# -ne 2 ]; then
	echo "Usage: $(basename $0) <# of tasks> <# executions>"
	exit 1
elif [ $# -eq 2 ]; then
	SCHED_TASKS=$1
	ROUNDS=$2
fi

CPU_IDLE_DIR="/sys/devices/system/cpu/cpu[0-9]*/cpuidle"
CPI_IDLE_STATE="state1"
SCHED_TPERIOD=50000
SCHED_WORK=100
SCHED_COUNT=100

echo "Found $(ls -d1 ${CPU_IDLE_DIR} | wc -l) CPU idle sysfs entries"
echo "Important: This will extract only $CPI_IDLE_STATE idle time"
echo "Spawning $SCHED_TASKS tasks"

before=$(cat ${CPU_IDLE_DIR}/${CPI_IDLE_STATE}/time)
#echo "Before: $before"

for i in `seq $ROUNDS` ; do
	offset=100
	pids=
	for i in `seq $SCHED_TASKS` ; do
		echo "./sched_task --tperiod $SCHED_TPERIOD --work $SCHED_WORK --offset $offset --count $SCHED_COUNT &"
		./sched_task --sched_other --tperiod $SCHED_TPERIOD --work $SCHED_WORK --offset $offset --count $SCHED_COUNT &
		pids="$pids $!"
		offset=$((offset+3300));
	done
	wait $pids
	sleep 5
done

after=$(cat ${CPU_IDLE_DIR}/${CPI_IDLE_STATE}/time)
#echo "After: $after"

echo "Diff:"
i=1
for cpu_before in $before ; do
	cpu_after=$(echo $after | cut -f $i -d ' ')
	echo $((cpu_after-cpu_before));
	i=$((i+1))
done


--nextPart2609936.ei6EljyavP
Content-Disposition: attachment; filename="Makefile"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-makefile; charset="UTF-8"; name="Makefile"

CROSS_COMPILE ?= arm-linux-gnueabi-
CC = $(CROSS_COMPILE)gcc
OBJS = sched_task
# -static needed for cross building for old EGLIBC on newer GLIBC
# Example: Building for Rinato (Eglibc-2.13) on Glibc-2.19
CFLAGS = -static-libgcc -static
# -lrt for clock_gettime when Glibc < 2.17
LDFLAGS = -lrt

all:  $(OBJS)

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@ $(LDFLAGS)

% : %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean:
	rm -f *.o
	rm -f $(OBJS)

--nextPart2609936.ei6EljyavP
Content-Disposition: attachment; filename="sched_task.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="sched_task.c"

/*
   sched_task - scheduler test task -> for power evaluation

   Copyright (C) 2013 Lukasz Majewski <l.majewski@samsung.com>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
   USA
*/

/* This is based on the pi_stress.c rt-test program by Clark Williams */

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sched.h>
#include <sys/mman.h>
#include <string.h>
#include <getopt.h>

#define NSEC_PER_SEC    1000000000
#define USEC_TO_NSEC    1000

#define TIME_MIN 100000 /* 100 us minimal time */

#define TEST_TAB_SIZE 512
/*
 * TODO: add support for chosing schedule policy (other, idle, rt)
 */
int sched_policy = SCHED_FIFO;
int priority = 10;

int task_period = 0;
int task_count = 0;
int work_time = 0;
int work_count = 0;
int work_offset = 0;

int lockall_flag = 0;
int debug_flag = 0;

#define DBG(fmt, args...) do {	  \
	if (debug_flag) \
		printf(fmt, args); \
	} while (0);


/* command line options */
struct option options[] = {
	{"tperiod", required_argument, NULL, 't'},
	{"work", required_argument, NULL, 'w'},
	{"count", required_argument, NULL, 'c'},
	{"offset", required_argument, NULL, 'o'},
	{"prio", no_argument, NULL, 'p'},
	{"debug", no_argument, &debug_flag, 'd'},
	{"mlockall", no_argument, &lockall_flag, 'm'},
	{"help", no_argument, NULL, 'h'},
	{"sched_other", no_argument, NULL, 's'},
	{NULL, 0, NULL, 0},
};

void busy_test(void)
{
	volatile static unsigned char test[TEST_TAB_SIZE];
	int i, j;

	for(i = 0xFF; i; i--)
		for(j = 0; j < sizeof(test); j++)
			test[j] = i;
}

int adjust_wakeup_time(struct timespec *t, int time)
{
	t->tv_nsec += time;

	while (t->tv_nsec >= NSEC_PER_SEC) {
		t->tv_nsec -= NSEC_PER_SEC;
		t->tv_sec++;
	}

	return 0;
}

int time_passed(struct timespec *x, struct timespec *y, struct timespec *result)
{
	result->tv_sec = x->tv_sec - y->tv_sec;
	result->tv_nsec = x->tv_nsec - y->tv_nsec;

	if (result->tv_nsec < 0) {
		--result->tv_sec;
		result->tv_nsec += NSEC_PER_SEC;
	}

	/* Return 1 if result is negative. */
	return result->tv_sec < 0;
}

void usage(void)
{
	printf("usage: sched_task <options>\n");
	printf("    options:\n");
	printf("\t--prio\t\t- specify priority [real time] of the task\n");
	printf("\t--work\t\t- specify time the task is executed [us]\n");
	printf("\t--count\t\t- specify how many times the task is executed\n");
	printf("\t\t\t- if --count is specified but --work is not then\n");
	printf("\t\t\t  the task will be executed (count/10) times before\n");
	printf("\t\t\t  each sleep time\n");
	printf("\t\t\t- if both --count and --work are specified then\n");
	printf("\t\t\t  the task will be executed for --work time before\n");
	printf("\t\t\t  going to sleep\n");
	printf("\t--offset\t- specify time after which execution starts [us]\n");
	printf("\t--tperiod\t- specify period of the task [us]\n");
	printf("\t--mlockall\t- lock current and future memory\n");
	printf("\t--sched_other\t- use standard SCHED_OTHER scheduling policy for normal\n");
	printf("\t\t\t  task; priority will be ignored\n");
	printf("\t--debug\t\t- turn on debug prints\n");
	printf("\t--help\t\t- print this message\n");
}


void process_command_line(int argc, char **argv)
{
	int opt;
	while ((opt = getopt_long(argc, argv, "+", options, NULL)) != -1) {
		switch (opt) {
		case '?':
		case 'h':
			usage();
			exit(0);
		case 'p':
			priority = strtol(optarg, NULL, 10);
			break;
		case 's':
			sched_policy = SCHED_OTHER;
			break;
		case 't':
			task_period = strtoul(optarg, NULL, 10) * USEC_TO_NSEC;
			break;
		case 'w':
			work_time = strtoul(optarg, NULL, 10) * USEC_TO_NSEC;
			break;
		case 'c':
			task_count = strtoul(optarg, NULL, 10);
			break;
		case 'o':
			work_offset = strtoul(optarg, NULL, 10) * USEC_TO_NSEC;
			break;
		}
	}
	if (!work_time)
		work_count = task_count / 10;
}

int main(int argc, char* argv[])
{
	struct timespec t, tt, ttt, result;
	struct sched_param param;
	int count = 0;

	process_command_line(argc, argv);

	if(work_time > task_period) {
		perror("Wrong value of \'work\' time");
		exit(-1);
	}

	if(task_period < TIME_MIN) {
		error(0, 0, "Task period time (%d) must be grater than %d [us]\n",
		      task_period/1000, TIME_MIN/1000);
		exit(-1);
	}

	if(work_time && (work_time < TIME_MIN)) {
		error(0, 0, "Work time (%d) must be grater than %d [us]\n",
		      work_time/1000, TIME_MIN/1000);
		exit(-1);
	}
	if (task_count < 0) {
		perror("Wrong value for --count\n");
		exit(-1);
	}
	if (!work_time && !task_count) {
		perror("At least one of (--work,--count) must be provided\n");
		exit(-1);
	}

	if ((sched_policy != SCHED_FIFO) && (sched_policy != SCHED_RR))
		priority = 0;
	param.sched_priority = priority;
	if(sched_setscheduler(0, sched_policy, &param) == -1) {
		perror("sched_setscheduler for policy %d failed\n");
	}

	if (lockall_flag)
		if(mlockall(MCL_CURRENT|MCL_FUTURE) == -1) {
			perror("mlockall failed");
			exit(-2);
		}

	clock_gettime(CLOCK_MONOTONIC ,&t);
	adjust_wakeup_time(&t, work_offset);

	while(!task_count || (count < task_count)) {
		/* wait until next shot */
		clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &t, NULL);

		clock_gettime(CLOCK_MONOTONIC ,&tt);
		clock_gettime(CLOCK_MONOTONIC ,&ttt);

		DBG("t:%d %d tt:%d %d ", t.tv_sec, t.tv_nsec,
		       tt.tv_sec, tt.tv_nsec);
		adjust_wakeup_time(&tt, work_time);

		if (work_time) {
			do {
				busy_test();
				clock_gettime(CLOCK_MONOTONIC ,&ttt);
				count++;
			} while (!time_passed(&tt, &ttt, &result));
		} else {
			int i = 0;
			do {
				busy_test();
				clock_gettime(CLOCK_MONOTONIC ,&ttt);
				count++;
			} while (++i < work_count);
		}

		DBG("tt:%d %d ttt:%d %d\n", tt.tv_sec, tt.tv_nsec,
		       ttt.tv_sec, ttt.tv_nsec);
		/* calculate next shot */
		adjust_wakeup_time(&t, task_period);
	}
	printf("Work executions: %d\n", count);
}

--nextPart2609936.ei6EljyavP--

