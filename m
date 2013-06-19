Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3FSMvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:51:11 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47655 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3FSMvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:51:08 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-b8-51c1a939e9fe
From: Tomasz Figa <t.figa@samsung.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: EXYNOS: Fix incorrect usage of S5P_ARM_CORE1_*
 registers
Date: Wed, 19 Jun 2013 14:50:57 +0200
Message-id: <8974257.1Thh8U4Een@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <CANuQgHEd3L=F20Nrp3zWh2+uXvRU9P_KVN=1xr3RXnoGBsaHLw@mail.gmail.com>
References: <1371569191-2364-1-git-send-email-t.figa@samsung.com>
 <51C0A01E.5020206@samsung.com>
 <CANuQgHEd3L=F20Nrp3zWh2+uXvRU9P_KVN=1xr3RXnoGBsaHLw@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t/xK7qWKw8GGjS9NLZ4vGYxk8XfScfY
	LR6uv8licXnhJVaLJc3cFr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXos3v1+wW0w/
	9pfN4tT1z2wWP850s1gs2PiI0WLVrj+MFi8/nmBxEPJYM28No0dLcw+bx+9fkxg9Lvf1Mnns
	nHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx+dNcgFcUVw2Kak5mWWpRfp2CVwZP/+uZSyYbV/x
	auItxgbGFt0uRk4OCQETiZNrb7BB2GISF+6tB7K5OIQEljJKrFi6nB3C6WKSuHGpmR2kik1A
	TeJzwyOwDhEBA4l1u5oYQYqYBW6wSkzb+J2pi5GDQ1ggRKKj1xykhkVAVeLCmsVgvbwCmhLT
	b74Gs/kF1CXebXvKBGKLCrhKvF99mAXE5hQIlrg95RojxOKVjBI3nqxlg2gWlPgx+R5YEbOA
	vMS+/VNZIWwtifU7jzNNYBSchaRsFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P
	3cQIic2vOxiXHrM6xCjAwajEwzuT82CgEGtiWXFl7iFGCQ5mJRHeiplAId6UxMqq1KL8+KLS
	nNTiQ4xMHJxSDYwJf10Z41Secp8Q3CHVcLVk7Rp+1aUzHQvE7KTX3F9pPFvfbqHnx8A7UbeL
	Py/4XZd96VyXR8kOHm6NyjC1qvnrSyPN5xg7y1Xv3en2jOGQ2umJZy1cdl6boX3wqcrVqwGn
	pPe6XZ74XERx2V691e9zKxg3RMlJKBqn9TLFXPK2UvOrCrz69pkSS3FGoqEWc1FxIgCM/Mch
	qwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 of June 2013 17:39:21 Chander Kashyap wrote:
> On 18 June 2013 23:29, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > On 06/19/13 02:45, Tomasz Figa wrote:
> >> Ccing Arnd and Olof, because I forgot to add them to git send-email...
> >> 
> >> Sorry for the noise.
> >> 
> >> On Tuesday 18 of June 2013 17:26:31 Tomasz Figa wrote:
> >>> S5P_ARM_CORE1_* registers affect only core 1. To control further
> >>> cores
> >>> properly another registers must be used.
> >>> 
> >>> This patch replaces S5P_ARM_CORE1_* register definitions with
> >>> S5P_ARM_CORE_*(x) macro which return addresses of registers for
> >>> specified core.
> >>> 
> >>> This fixes CPU hotplug on quad core Exynos SoCs on which currently
> >>> offlining CPUs 2 or 3 caused CPU 1 to be turned off.
> >> 
> >> Obviously this doesn't happen currently because of the if (cpu == 1),
> >> but> 
> > Yes, not happened...and just note exynos5440 doesn't support hotplug :)
> > so this is available on exynos4412 and added 5420.
> > 
> >> if logical cpu1 turned out not to be physical cpu1, then it would
> >> crash.
> >> 
> >> Best regards,
> >> Tomasz
> >> 
> >>> In addition,
> >>> bring-up of CPU 2 and 3 is fixed on boards where bootloader powers
> >>> off
> >>> secondary cores by default.
> > 
> > I need to test on board about above...
> > 
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
> >>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >>> ---
> >>> 
> >>>   arch/arm/mach-exynos/hotplug.c               |  9 +++++----
> >>>   arch/arm/mach-exynos/include/mach/regs-pmu.h | 10 +++++++---
> >>>   arch/arm/mach-exynos/platsmp.c               |  9 +++++----
> >>>   3 files changed, 17 insertions(+), 11 deletions(-)
> >>> 
> >>> diff --git a/arch/arm/mach-exynos/hotplug.c
> >>> b/arch/arm/mach-exynos/hotplug.c index af90cfa..c089943 100644
> >>> --- a/arch/arm/mach-exynos/hotplug.c
> >>> +++ b/arch/arm/mach-exynos/hotplug.c
> >>> @@ -93,10 +93,11 @@ static inline void cpu_leave_lowpower(void)
> >>> 
> >>>   static inline void platform_do_lowpower(unsigned int cpu, int
> >>> 
> >>> *spurious) {
> >>> 
> >>>         for (;;) {
> >>> 
> >>> +               void __iomem *reg_base;
> >>> +               unsigned int phys_cpu = cpu_logical_map(cpu);
> >>> 
> >>> -               /* make cpu1 to be turned off at next WFI command */
> >>> -               if (cpu == 1)
> >>> -                       __raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
> >>> +               reg_base = S5P_ARM_CORE_CONFIGURATION(phys_cpu);
> 
> Tomasz,
> This will break for non-zero, MPIDR value.  Say if MPIDR is 1 then for
> cpu0 phys_cpu value will be 0x100,
> and address calculation will be   (S5P_ARM_CORE0_CONFIGURATION +
> ((0x101) * 0x80)), which is wrong.

Hmm, according to the code initializing __cpu_logical_map[] array this is 
not true.

Here's the code:

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/kernel/setup.c?id=refs/tags/next-20130619#n468

and for used macros and bitmasks:

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/include/asm/cputype.h?id=refs/tags/next-20130619#n45

Now the structure of the MPIDR register:

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0388e/CIHEBGFG.html

As you can see, the value read from the register in 
smp_setup_processor_id() is only the physical CPU ID, so I don't see any 
problem here.

If I'm wrong, feel free to correct me.

Cc'ing people who should have more knowledge on this.

Best regards,
Tomasz

> >>> +               __raw_writel(0, reg_base);
> >>> 
> >>>                 /*
> >>>                 
> >>>                  * here's the WFI
> >>> 
> >>> @@ -106,7 +107,7 @@ static inline void platform_do_lowpower(unsigned
> >>> int
> >>> cpu, int *spurious)
> >>> 
> >>>                     : "memory", "cc");
> >>> 
> >>> -               if (pen_release == cpu_logical_map(cpu)) {
> >>> +               if (pen_release == phys_cpu) {
> >>> 
> >>>                         /*
> >>>                         
> >>>                          * OK, proper wakeup, we're done
> >>>                          */
> >>> 
> >>> diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h
> >>> b/arch/arm/mach-exynos/include/mach/regs-pmu.h index 57344b7..cf40b86
> >>> 100644
> >>> --- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
> >>> +++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
> >>> @@ -125,10 +125,14 @@
> >>> 
> >>>   #define S5P_GPS_ALIVE_LOWPWR                  S5P_PMUREG(0x13A0)
> >>>   
> >>>   #define S5P_ARM_CORE0_CONFIGURATION           S5P_PMUREG(0x2000)
> >>> 
> >>> +#define S5P_ARM_CORE0_STATUS                   S5P_PMUREG(0x2004)
> >>> 
> >>>   #define S5P_ARM_CORE0_OPTION                  S5P_PMUREG(0x2008)
> >>> 
> >>> -#define S5P_ARM_CORE1_CONFIGURATION            S5P_PMUREG(0x2080)
> >>> -#define S5P_ARM_CORE1_STATUS                   S5P_PMUREG(0x2084)
> >>> -#define S5P_ARM_CORE1_OPTION                   S5P_PMUREG(0x2088)
> >>> +#define S5P_ARM_CORE_CONFIGURATION(_nr)                \
> >>> +               (S5P_ARM_CORE0_CONFIGURATION + ((_nr) * 0x80))
> >>> +#define S5P_ARM_CORE_STATUS(_nr)               \
> >>> +               (S5P_ARM_CORE0_STATUS + ((_nr) * 0x80))
> >>> +#define S5P_ARM_CORE_OPTION(_nr)               \
> >>> +               (S5P_ARM_CORE0_OPTION + ((_nr) * 0x80))
> >>> 
> >>>   #define S5P_ARM_COMMON_OPTION                 S5P_PMUREG(0x2408)
> >>>   #define S5P_TOP_PWR_OPTION                    S5P_PMUREG(0x2C48)
> >>> 
> >>> diff --git a/arch/arm/mach-exynos/platsmp.c
> >>> b/arch/arm/mach-exynos/platsmp.c index d9c6d0a..2cbabc8 100644
> >>> --- a/arch/arm/mach-exynos/platsmp.c
> >>> +++ b/arch/arm/mach-exynos/platsmp.c
> >>> @@ -109,14 +109,15 @@ static int __cpuinit
> >>> exynos_boot_secondary(unsigned int cpu, struct task_struct */
> >>> 
> >>>         write_pen_release(phys_cpu);
> >>> 
> >>> -       if (!(__raw_readl(S5P_ARM_CORE1_STATUS)& 
> >>> S5P_CORE_LOCAL_PWR_EN))>> 
> >> {
> >> 
> >>> +       if (!(__raw_readl(S5P_ARM_CORE_STATUS(phys_cpu))
> >>> +       &  S5P_CORE_LOCAL_PWR_EN)) {
> >>> 
> >>>                 __raw_writel(S5P_CORE_LOCAL_PWR_EN,
> >>> 
> >>> -                            S5P_ARM_CORE1_CONFIGURATION);
> >>> +                            S5P_ARM_CORE_CONFIGURATION(phys_cpu));
> >>> 
> >>>                 timeout = 10;
> >>>                 
> >>>                 /* wait max 10 ms until cpu1 is on */
> >>> 
> >>> -               while ((__raw_readl(S5P_ARM_CORE1_STATUS)
> >>> +               while ((__raw_readl(S5P_ARM_CORE_STATUS(phys_cpu))
> 
> Ditto
> 
> >>>                         &  S5P_CORE_LOCAL_PWR_EN) !=
> >>> 
> >>> S5P_CORE_LOCAL_PWR_EN)
> >> 
> >> {
> >> 
> >>>                         if (timeout-- == 0)
> >>>                         
> >>>                                 break;
> >>> 
> >>> @@ -125,7 +126,7 @@ static int __cpuinit
> >>> exynos_boot_secondary(unsigned
> >>> int cpu, struct task_struct }
> >>> 
> >>>                 if (timeout == 0) {
> >>> 
> >>> -                       printk(KERN_ERR "cpu1 power enable failed");
> >>> +                       printk(KERN_ERR "cpu%u power enable failed",
> >>> cpu);
> >>> 
> >>>                         spin_unlock(&boot_lock);
> >>>                         return -ETIMEDOUT;
> >>>                 
> >>>                 }
> >> 
> >> --
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-samsung-soc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> with warm regards,
> Chander Kashyap
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-samsung-soc" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
