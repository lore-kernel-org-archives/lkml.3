Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaGJKC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:02:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45512 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaGJKC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:02:26 -0400
X-AuditID: cbfee61b-f79f86d00000144c-eb-53be64afc063
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-pm@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/4] ARM: EXYNOS: cpuidle: add secure firmware support
 to AFTR mode code
Date: Thu, 10 Jul 2014 12:02:11 +0200
Message-id: <1535286.PRp2nN91oT@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <53BE4E5E.1080803@samsung.com>
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
 <1404926274-18411-4-git-send-email-b.zolnierkie@samsung.com>
 <53BE4E5E.1080803@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jQd31KfuCDRau0raY91nW4vULQ4ve
	BVfZLM42vWG3eH/oGbPFpsfXWC0u75rDZvG59wijxYzz+5gszpy+xGpx8k8vo8X6Ga9ZLDZ+
	9XDg9bhzbQ+bx+Yl9R63/z1m9thytZ3Fo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDJe/HvL
	XvBfvmLKjxVsDYznJbsYOTkkBEwk7t39zAxhi0lcuLeerYuRi0NIYDqjRGv3C1YIp4VJ4kXH
	ZhaQKjYBK4mJ7asYQWwRAUOJg7u3M4EUMQscZZa43HwdqIODQ1ggUeLwZT2QGhYBVYm5/2+D
	9fIKaEosbPrCDmKLCnhK7Ni+kg3E5hTQllhw9igTiC0ksIJRYs/PXIh6QYkfk++B9TILyEvs
	2z+VFcLWkdjfOo1tAqPALCRls5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cJQ8k97BuKrB4hCjAAejEg9vQ8/eYCHWxLLiytxDjBIczEoivNvs9gUL8aYkVlalFuXHF5Xm
	pBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYBRoO77RJqxpckL1Gaa6tm9vZveY
	uRuY/g2N27fe8Cb/zvbZZit8///R9vyje+ei2dbj22Z8vuOu9V/Q2nYVm5JHiXyG0oX785U7
	Dzx5zvL0Rd/3t0Z+exUagh+9bin/keDSf/T7M9sUm3bHn1pbHbIzvXSWs1+aKh2+VKjJZ5qS
	utEGvQu7vJRYijMSDbWYi4oTATVAOWSOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, July 10, 2014 10:27:10 AM Krzysztof Kozlowski wrote:
> On 09.07.2014 19:17, Bartlomiej Zolnierkiewicz wrote:
> > * Move cp15 registers saving to exynos_save_cp15() helper and add
> >    additional helper usage to do_idle firmware method.
> >
> > * Use sysram_ns_base_addr + 0x24/0x20 addresses instead of the default
> >    ones used by exynos_cpu_set_boot_vector() on boards with secure
> >    firmware enabled.
> >
> > * Use do_idle firmware method instead of cpu_do_idle() on boards with
> >    secure firmware enabled.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > v3:
> > - make exynos_enter_aftr() return a value
> > - add cp15 registers handling to do_idle firmware method
> > - set sysram_ns_base_addr + 0x24/0x20 in do_idle firmware method
> > - move calling of do_idle firmware method from cpuidle-exynos.c
> >    to pm.c
> >
> >   arch/arm/mach-exynos/common.h    |  2 +-
> >   arch/arm/mach-exynos/firmware.c  | 26 ++++++++++++++++++--------
> >   arch/arm/mach-exynos/pm.c        | 11 +++++++++--
> >   drivers/cpuidle/cpuidle-exynos.c |  6 +++---
> >   4 files changed, 31 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> > index a6a200f..0829808 100644
> > --- a/arch/arm/mach-exynos/common.h
> > +++ b/arch/arm/mach-exynos/common.h
> > @@ -170,7 +170,7 @@ extern int  exynos_cpu_power_state(int cpu);
> >   extern void exynos_cluster_power_down(int cluster);
> >   extern void exynos_cluster_power_up(int cluster);
> >   extern int  exynos_cluster_power_state(int cluster);
> > -extern void exynos_enter_aftr(void);
> > +extern int  exynos_enter_aftr(void);
> >
> >   extern void s5p_init_cpu(void __iomem *cpuid_addr);
> >   extern unsigned int samsung_rev(void);
> > diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> > index 53fbf5c..163f5b9 100644
> > --- a/arch/arm/mach-exynos/firmware.c
> > +++ b/arch/arm/mach-exynos/firmware.c
> > @@ -24,13 +24,30 @@
> >   #include "smc.h"
> >
> >   #define EXYNOS_SLEEP_MAGIC	0x00000bad
> > +#define EXYNOS_AFTR_MAGIC	0xfcba0d10
> >   #define EXYNOS_BOOT_ADDR	0x8
> >   #define EXYNOS_BOOT_FLAG	0xc
> >
> > +/* For Cortex-A9 Diagnostic and Power control register */
> > +static unsigned int cp15_power;
> > +static unsigned int cp15_diag;
> > +
> > +static void exynos_save_cp15(void)
> > +{
> > +	/* Save Power control and Diagnostic registers */
> > +	asm ("mrc p15, 0, %0, c15, c0, 0\n"
> > +	     "mrc p15, 0, %1, c15, c0, 1\n"
> > +		: "=r" (cp15_power), "=r" (cp15_diag) : : "cc");
> 
> Hi,
> 
> On Exynos3250 I encounter "Oops - undefined instruction" on this asm 
> while entering AFTR:
> [    2.277946] CPUidle CPU1: going off
> [    2.278110] CPUidle CPU0: going AFTR
> [    2.279478] Internal error: Oops - undefined instruction: 0 [#1] 
> PREEMPT SMP ARM
> 
> 
> Are you sure it should be called on each SoC?

This should not be called on Exynos3250 (Cortex A7) but this is not
an issue currently with upstream since:

- Exynos3250 cpuidle support is disabled in Tomasz's earlier patch

- Exynos3250 need other patches (i.e. PMU support) to make cpuidle
  work in upstream kernel anyway

- there is no support for any Exynos3250 board in upstream yet

Please also note that corresponding code for cp15 registers restore
needs also to be disabled for Cortex A7 and it is not present in
Tomasz's firmware patches yet.  He is going to fix his patches to
check for Cortex A9 before restoring registers.  Once it is done
I'll rebase my patches and also add Cortex A9 checking to cp15
registers saving code.

When it comes to our internal tree (that you posted log from)
please fix it with adding Cortex A9 check:

	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9) to

cp15 registers saving/restoring code.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

