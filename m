Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaGULLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:11:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43389 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaGULLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:11:40 -0400
X-AuditID: cbfee61b-f79f86d00000144c-cb-53ccf569654c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2] ARM: EXYNOS: Fix build with PM_SLEEP=n
Date: Mon, 21 Jul 2014 13:11:14 +0200
Message-id: <1539661.ni665pgzAx@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5864544.mJGdtT36g8@amdc1032>
References: <1405323953-25954-1-git-send-email-k.kozlowski@samsung.com>
 <53C978AA.9090603@samsung.com> <5864544.mJGdtT36g8@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd3Mr2eCDY7PM7d4/cLQonfBVTaL
	s01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H2yF12i1PXP7NZXLl0is1i/YzXLA7cHi3NPWwe
	m5fUe1w50cTq0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBmr/p9jLpgsXfHg3l2mBsZJYl2M
	nBwSAiYSay61MELYYhIX7q1n62Lk4hASWMQo0fTkAyuE08IkcbBvKwtIFZuAlcTE9lVgHSIC
	ahI9i7cyghQxC/QzS5z81MsGkhAWsJOY3dDIDmKzCKhKXL21E6yBV0BTYlvzCiYQW1TAU2LH
	9pVg9ZwCWhL3Hq5jgdjWxijxrmMrG0SDoMSPyffANjMLyEvs2z+VFcLWkdjfOo1tAqPALCRl
	s5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDQ8k97BuKrB4hCjAAejEg+v
	B+OZYCHWxLLiytxDjBIczEoivCcygEK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeW
	pGanphakFsFkmTg4pRoY07K3H//O/K+Ze8P9f4//Ho6sdNDocBSsWPXiEQMzW6Zce+pztf73
	zlMCMjL+zzA0bEpXWcwh6/jh9YQO+QA5m8abnxcWnH93wFb/guwEnpddl5Pn355nXK/wuY1B
	cI6dRsGn6BAPltusDzJfiLsLPb9rksNauvzijPXLd0249MTp30w9u6vsSizFGYmGWsxFxYkA
	REHx04ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 21, 2014 12:38:28 PM Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Saturday, July 19, 2014 04:42:34 AM Kukjin Kim wrote:
> > On 07/16/14 20:59, Tomasz Figa wrote:
> > > Hi Krzysztof,
> > >
> > > On 14.07.2014 09:45, Krzysztof Kozlowski wrote:
> > >> Fix building of exynos defconfig with disabled PM_SLEEP:
> > >> CONFIG_PM_SLEEP=n
> > >> CONFIG_PM_SLEEP_SMP=n
> > >> CONFIG_SUSPEND=n
> > >> by moving functions for power up/down of CPU and cluster to platsmp.c
> > >>
> > >> The build error messages:
> > >> arch/arm/mach-exynos/built-in.o: In function `exynos_boot_secondary':
> > >> arch/arm/mach-exynos/platsmp.c:111: undefined reference to `exynos_cpu_power_state'
> > >> arch/arm/mach-exynos/platsmp.c:112: undefined reference to `exynos_cpu_power_up'
> > >> arch/arm/mach-exynos/platsmp.c:116: undefined reference to `exynos_cpu_power_state'
> > >> make: *** [vmlinux] Error 1
> > >>
> > >> Signed-off-by: Krzysztof Kozlowski<k.kozlowski@samsung.com>
> > >>
> > >> ---
> > >> Changes since v1:
> > >> 1. Use different solution - just move the power up/down functions to a
> > >>     common place instead of adding stubs in common.h. Suggested by Tomasz
> > >>     Figa.
> > >> ---
> > >>   arch/arm/mach-exynos/platsmp.c | 66 ++++++++++++++++++++++++++++++++++++++++++
> > >>   arch/arm/mach-exynos/pm.c      | 66 ------------------------------------------
> > >>   2 files changed, 66 insertions(+), 66 deletions(-)
> > >>
> > >
> > + Bart,
> > 
> > > Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> > >
> > Applied, thanks.
> > 
> > Bart, I think this is better at this moment to fix the build breakage 
> > with disabling PM...if you have any comments, please let me know.
> 
> To fix PM_SLEEP=n build itself (with ARM_EXYNOS_CPUIDLE=n) Krzysztof's
> patch is not enough and patch [1] is also needed (this patch is very
> simple so I think that it is okay for v3.16).

Hmmm, I now see that you've applied Krzysztof's patch for v3.17 not v3.16.

In that case how do you want to deal with PM_SLEEP=n build breakages for
v3.16 and what do you mean with "fix the build breakage with disabling PM"?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> For PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y config more changes are needed
> and they are contained in patch [2] (please note that this patch depends
> on patch [3] from Tomasz Figa which was redone recently into [4] so my
> patch also needs to be refreshed).  However if you think that this would
> result in too much changes for v3.16 kernel we can make ARM_EXYNOS_CPUIDLE
> select (or depend on) PM_SLEEP for now and fix the issue completely later
> in v3.17 kernel.
> 
> [1] "[PATCH 1/2] ARM: EXYNOS: Fix build with PM_SLEEP=n part #2"
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34080.html
> 
> [2] "[PATCH 2/2] ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y"
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34081.html
> 
> [3] "[PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies"
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html
> 
> [4] "[PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences"
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34150.html
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics

