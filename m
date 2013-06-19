Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3FSPBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:01:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51715 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3FSPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:01:32 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-9b-51c1c7ca54cc
From: Tomasz Figa <t.figa@samsung.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: EXYNOS: Fix incorrect usage of S5P_ARM_CORE1_*
 registers
Date: Wed, 19 Jun 2013 17:01:21 +0200
Message-id: <24503071.R7UT57fHdP@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <CANuQgHEXHgYm1-fzLfrsk66q4T-==ka0dnSKNuBVAq1kLWOOvg@mail.gmail.com>
References: <1371569191-2364-1-git-send-email-t.figa@samsung.com>
 <1933024.UCR4mQ7fzS@amdc1227>
 <CANuQgHEXHgYm1-fzLfrsk66q4T-==ka0dnSKNuBVAq1kLWOOvg@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t/xq7qnjh8MNHh+hdni8ZrFTBZ/Jx1j
	t3i4/iaLxeWFl1gtljRzW/QuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uXeS3e/H7BbjH9
	2F82i1PXP7NZ/DjTzWKxYOMjRotVu/4wWrz8eILFQchjzbw1jB4tzT1sHr9/TWL0uNzXy+Sx
	c9Zddo871/aweWxeUu9x5UQTq0ffllWMHp83yQVwRXHZpKTmZJalFunbJXBlrHl0nrmgx6Xi
	y6lpjA2M7UZdjJwcEgImEge+XGCDsMUkLtxbD2RzcQgJLGWUOHVvCSOE08UkMXXbJGaQKjYB
	NYnPDY/AOkQEDCTW7WpiBLGZBaaxSbT/zepi5OAQFgiR6Og1BwmzCKhKfOnYC1bOK6Al8fzD
	YrByfgF1iXfbnjKB2KICrhLvVx9mAbE5BYIlDrdOYILYu4JRYtGNo+wQzYISPybfY4HYJS+x
	b/9UVghbS2L9zuNMExgFZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcx
	QiLz6w7GpcesDjEKcDAq8fDO5DwYKMSaWFZcmXuIUYKDWUmEd+lRoBBvSmJlVWpRfnxRaU5q
	8SFGJg5OqQbGpqAvv/3lFrYZhVktmi/vnKSbdP23n1/l7x3zy0xEheewJFj/feBzxsnwUW7J
	I9cPBftV1vqwzNx+K2dazjwOsdN3Vmu5V0x6xRyq2RUyVztgD+cbztojIe66+x7t89wrXH5x
	x7kMu6ubH+jVCvLdttBwrZO4HfdRQPPDtConMa2VfImcly8osRRnJBpqMRcVJwIASn35OKoC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 of June 2013 20:26:50 Chander Kashyap wrote:
> On 19 June 2013 19:58, Tomasz Figa <t.figa@samsung.com> wrote:
> > On Wednesday 19 of June 2013 19:25:27 Chander Kashyap wrote:
> >> On 19 June 2013 19:19, Tomasz Figa <t.figa@samsung.com> wrote:
> >> > On Wednesday 19 of June 2013 14:24:17 Lorenzo Pieralisi wrote:
> >> >> On Wed, Jun 19, 2013 at 01:50:57PM +0100, Tomasz Figa wrote:
> >> >> > On Wednesday 19 of June 2013 17:39:21 Chander Kashyap wrote:
> >> >> > > On 18 June 2013 23:29, Kukjin Kim <kgene.kim@samsung.com> 
wrote:
> >> >> > > > On 06/19/13 02:45, Tomasz Figa wrote:
> >> >> > > >> Ccing Arnd and Olof, because I forgot to add them to git
> >> >> > > >> send-email...
> >> >> > > >> 
> >> >> > > >> Sorry for the noise.
> >> >> > > >> 
> >> >> > > >> On Tuesday 18 of June 2013 17:26:31 Tomasz Figa wrote:
> >> >> > > >>> S5P_ARM_CORE1_* registers affect only core 1. To control
> >> >> > > >>> further
> >> >> > > >>> cores
> >> >> > > >>> properly another registers must be used.
> >> >> > > >>> 
> >> >> > > >>> This patch replaces S5P_ARM_CORE1_* register definitions
> >> >> > > >>> with
> >> >> > > >>> S5P_ARM_CORE_*(x) macro which return addresses of registers
> >> >> > > >>> for
> >> >> > > >>> specified core.
> >> >> > > >>> 
> >> >> > > >>> This fixes CPU hotplug on quad core Exynos SoCs on which
> >> >> > > >>> currently
> >> >> > > >>> offlining CPUs 2 or 3 caused CPU 1 to be turned off.
> >> >> > > >> 
> >> >> > > >> Obviously this doesn't happen currently because of the if
> >> >> > > >> (cpu
> >> >> > > >> ==
> >> >> > > >> 1),
> >> >> > > >> but>
> >> >> > > > 
> >> >> > > > Yes, not happened...and just note exynos5440 doesn't support
> >> >> > > > hotplug :)
> >> >> > > > so this is available on exynos4412 and added 5420.
> >> >> > > > 
> >> >> > > >> if logical cpu1 turned out not to be physical cpu1, then it
> >> >> > > >> would
> >> >> > > >> crash.
> >> >> > > >> 
> >> >> > > >> Best regards,
> >> >> > > >> Tomasz
> >> >> > > >> 
> >> >> > > >>> In addition,
> >> >> > > >>> bring-up of CPU 2 and 3 is fixed on boards where bootloader
> >> >> > > >>> powers
> >> >> > > >>> off
> >> >> > > >>> secondary cores by default.
> >> >> > > > 
> >> >> > > > I need to test on board about above...
> >> >> > > > 
> >> >> > > >>> Cc: stable@vger.kernel.org
> >> >> > > >>> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
> >> >> > > >>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> >> > > >>> ---
> >> >> > > >>> 
> >> >> > > >>>   arch/arm/mach-exynos/hotplug.c               |  9
> >> >> > > >>>   +++++----
> >> >> > > >>>   arch/arm/mach-exynos/include/mach/regs-pmu.h | 10
> >> >> > > >>>   +++++++---
> >> >> > > >>>   arch/arm/mach-exynos/platsmp.c               |  9
> >> >> > > >>>   +++++----
> >> >> > > >>>   3 files changed, 17 insertions(+), 11 deletions(-)
> >> >> > > >>> 
> >> >> > > >>> diff --git a/arch/arm/mach-exynos/hotplug.c
> >> >> > > >>> b/arch/arm/mach-exynos/hotplug.c index af90cfa..c089943
> >> >> > > >>> 100644
> >> >> > > >>> --- a/arch/arm/mach-exynos/hotplug.c
> >> >> > > >>> +++ b/arch/arm/mach-exynos/hotplug.c
> >> >> > > >>> @@ -93,10 +93,11 @@ static inline void
> >> >> > > >>> cpu_leave_lowpower(void)
> >> >> > > >>> 
> >> >> > > >>>   static inline void platform_do_lowpower(unsigned int cpu,
> >> >> > > >>>   int
> >> >> > > >>> 
> >> >> > > >>> *spurious) {
> >> >> > > >>> 
> >> >> > > >>>         for (;;) {
> >> >> > > >>> 
> >> >> > > >>> +               void __iomem *reg_base;
> >> >> > > >>> +               unsigned int phys_cpu =
> >> >> > > >>> cpu_logical_map(cpu);
> >> >> > > >>> 
> >> >> > > >>> -               /* make cpu1 to be turned off at next WFI
> >> >> > > >>> command
> >> >> > > >>> */
> >> >> > > >>> -               if (cpu == 1)
> >> >> > > >>> -                       __raw_writel(0,
> >> >> > > >>> S5P_ARM_CORE1_CONFIGURATION);
> >> >> > > >>> +               reg_base =
> >> >> > > >>> S5P_ARM_CORE_CONFIGURATION(phys_cpu);
> >> >> > > 
> >> >> > > Tomasz,
> >> >> > > This will break for non-zero, MPIDR value.  Say if MPIDR is 1
> >> >> > > then
> >> >> > > for
> >> >> > > cpu0 phys_cpu value will be 0x100,
> >> >> > > and address calculation will be   (S5P_ARM_CORE0_CONFIGURATION
> >> >> > > +
> >> >> > > ((0x101) * 0x80)), which is wrong.
> >> >> 
> >> >> Honestly, I did not understand the reasoning above, please clarify.
> >> >> 
> >> >> > Hmm, according to the code initializing __cpu_logical_map[] array
> >> >> > this
> >> >> > is not true.
> >> >> > 
> >> >> > Here's the code:
> >> >> > 
> >> >> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
> >> >> > tre
> >> >> > e/a
> >> >> > rch/arm/kernel/setup.c?id=refs/tags/next-20130619#n468
> >> >> > 
> >> >> > and for used macros and bitmasks:
> >> >> > 
> >> >> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
> >> >> > tre
> >> >> > e/a
> >> >> > rch/arm/include/asm/cputype.h?id=refs/tags/next-20130619#n45
> >> >> > 
> >> >> > Now the structure of the MPIDR register:
> >> >> > 
> >> >> > http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi03
> >> >> > 88e
> >> >> > /CI
> >> >> > HEBGFG.html
> >> >> > 
> >> >> > As you can see, the value read from the register in
> >> >> > smp_setup_processor_id() is only the physical CPU ID, so I don't
> >> >> > see
> >> >> > any
> >> >> > problem here.
> >> >> 
> >> >> Define "physical CPU ID" :-)
> >> >> 
> >> >> There is a problem here: the MPIDR is not an index, and the
> >> >> cpu_logical_map is populated in arm_dt_init_cpu_maps in:
> >> >> 
> >> >> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tre
> >> >> e/a
> >> >> rch /arm/kernel/devtree.c?id=refs/tags/v3.10-rc6
> >> >> 
> >> >> with all affinity levels.
> >> > 
> >> > OK. This is what I was missing. Thanks.
> >> > 
> >> >> You need to perform a mapping between logical cpus and registers
> >> >> offset,
> >> >> you can't use the cpu_logical_map directly for that.
> >> > 
> >> > Hmm, can't I just extract cluster ID and CPU ID from the MPIDR value
> >> > and
> >> > use them appropriately to calculate register offsets?
> >> 
> >> That will create problem for multi-cluster systems. Say we have two
> >> clusters then with clusterID 0 and 1. So phys-cpu will be 0x0/0x100,
> >> 0x1/0x101 ans so on.
> > 
> > I mean, calculate register offset based on two parameters - cluster ID
> > and> 
> > CPU ID, like:
> >         ...
> >         
> >         u32 mpidr = cpu_logical_map(cpu);
> >         u32 phys_cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> >         
> >         if (soc_is_exynosXXXX()) {
> >         
> >                 u32 cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> >                 
> >                 phys_cpu += EXYNOSXXXX_CPUS_PER_CLUSTER * cluster;
> >         
> >         }
> >         
> >         reg_base = S5P_ARM_CORE_CONFIGURATION(phys_cpu);
> >         __raw_writel(0, reg_base);
> 
> This does not seems to viable solution, as eg. clusterID for
> exynos4210 is 0x9 and exynos 4412 is 0xa.

We don't need to consider cluster ID for any SoC that has just one cluster. 
That's why there is the if (soc_is_exynosXXXX()) clause, where exynosXXXX 
is the SoC that we support and has more clusters.

> But if we wass the cpu nodes
> thru DT, the we can comfortably rely on the logical cpu number. Also
> EXYNOSXXXX_CPUS_PER_CLUSTER can vary from cluster to cluster.

There is nothing that prevents you from specifying the CPUs in DT in 
different order. Moreover, even if you specify them in correct order, there 
is nothing that prevents you from using any of the listed CPUs as boot CPU, 
which will get the logical ID of 0.

Best regards,
Tomasz

> >         ...
> > 
> > Best regards,
> > Tomasz
> > 
> >> > Best regards,
> >> > Tomasz
> >> > 
> >> >> Next accident waiting to happen is GIC code
> >> >> (CONFIG_GIC_NON_BANKED),
> >> >> where cpu_logical_map is used erroneously as an index.
> >> >> 
> >> >> Lorenzo
> >> 
> >> --
> >> with warm regards,
> >> Chander Kashyap
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-samsung-soc" in the body of a message to
> >> majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> with warm regards,
> Chander Kashyap
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-samsung-soc" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
