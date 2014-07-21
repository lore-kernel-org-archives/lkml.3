Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaGUNmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:42:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62163 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaGUNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:42:08 -0400
X-AuditID: cbfee61b-f79f86d00000144c-57-53cd18aef646
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
Date: Mon, 21 Jul 2014 15:41:44 +0200
Message-id: <19533549.DVV8hdLa08@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <93736288.A8L2I1nMme@amdc1032>
References: <1405323953-25954-1-git-send-email-k.kozlowski@samsung.com>
 <1539661.ni665pgzAx@amdc1032> <93736288.A8L2I1nMme@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jAd11EmeDDZ6sNrZ4/cLQonfBVTaL
	s01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H2yF12i1PXP7NZXLl0is1i/YzXLA7cHi3NPWwe
	m5fUe1w50cTq0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBnXdnWzFWxUrThw+zx7A+Mx2S5G
	Tg4JAROJyfd+MkHYYhIX7q1n62Lk4hASWMQocaV5KzuE08Iksf7vC1aQKjYBK4mJ7asYQWwR
	ATWJnsVbGUGKmAX6mSVOfuplA0kIC9hJzG5oZAexWQRUJdZcmAK2gldAS+Lv83awuKiAp8SO
	7SvB6jkFtCUuvf7BAmILCbQxSlxtFYCoF5T4MfkeWJxZQF5i3/6prBC2jsT+1mlsExgFZiEp
	m4WkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPhmfQOxlUNFocYBTgYlXh4
	PRjPBAuxJpYVV+YeYpTgYFYS4a1lPBssxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6
	YklqdmpqQWoRTJaJg1OqgTGh0KNI5MGsPOdABfvuw+tZ3v+RtmlhVkiMj2U54xrvo5045bpl
	646ePxFFUywE5nEuSHRiWvb1upxQ1nylizN26iebzpr6cYqhGJO+wFFHzROdd/cbfIg8E7s/
	wfjL1Lw9ccdeHbBa1njx/srH0meVth7+t6aqYVdLgGpj24z7xcwCPLOUFiuxFGckGmoxFxUn
	AgAL74eEgQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 21, 2014 02:55:52 PM Bartlomiej Zolnierkiewicz wrote:
> On Monday, July 21, 2014 01:11:14 PM Bartlomiej Zolnierkiewicz wrote:
> > On Monday, July 21, 2014 12:38:28 PM Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi,
> > > 
> > > On Saturday, July 19, 2014 04:42:34 AM Kukjin Kim wrote:
> > > > On 07/16/14 20:59, Tomasz Figa wrote:
> > > > > Hi Krzysztof,
> > > > >
> > > > > On 14.07.2014 09:45, Krzysztof Kozlowski wrote:
> > > > >> Fix building of exynos defconfig with disabled PM_SLEEP:
> > > > >> CONFIG_PM_SLEEP=n
> > > > >> CONFIG_PM_SLEEP_SMP=n
> > > > >> CONFIG_SUSPEND=n
> > > > >> by moving functions for power up/down of CPU and cluster to platsmp.c
> > > > >>
> > > > >> The build error messages:
> > > > >> arch/arm/mach-exynos/built-in.o: In function `exynos_boot_secondary':
> > > > >> arch/arm/mach-exynos/platsmp.c:111: undefined reference to `exynos_cpu_power_state'
> > > > >> arch/arm/mach-exynos/platsmp.c:112: undefined reference to `exynos_cpu_power_up'
> > > > >> arch/arm/mach-exynos/platsmp.c:116: undefined reference to `exynos_cpu_power_state'
> > > > >> make: *** [vmlinux] Error 1
> > > > >>
> > > > >> Signed-off-by: Krzysztof Kozlowski<k.kozlowski@samsung.com>
> > > > >>
> > > > >> ---
> > > > >> Changes since v1:
> > > > >> 1. Use different solution - just move the power up/down functions to a
> > > > >>     common place instead of adding stubs in common.h. Suggested by Tomasz
> > > > >>     Figa.
> > > > >> ---
> > > > >>   arch/arm/mach-exynos/platsmp.c | 66 ++++++++++++++++++++++++++++++++++++++++++
> > > > >>   arch/arm/mach-exynos/pm.c      | 66 ------------------------------------------
> > > > >>   2 files changed, 66 insertions(+), 66 deletions(-)
> > > > >>
> > > > >
> > > > + Bart,
> > > > 
> > > > > Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> > > > >
> > > > Applied, thanks.
> > > > 
> > > > Bart, I think this is better at this moment to fix the build breakage 
> > > > with disabling PM...if you have any comments, please let me know.
> > > 
> > > To fix PM_SLEEP=n build itself (with ARM_EXYNOS_CPUIDLE=n) Krzysztof's
> > > patch is not enough and patch [1] is also needed (this patch is very
> > > simple so I think that it is okay for v3.16).
> > 
> > Hmmm, I now see that you've applied Krzysztof's patch for v3.17 not v3.16.
> > 
> > In that case how do you want to deal with PM_SLEEP=n build breakages for
> > v3.16 and what do you mean with "fix the build breakage with disabling PM"?
> 
> Just a bit of explanation:
> 
> The PM_SLEEP=n build breakages show up on automated build tests done by
> various people.  Minimal fixes for them (Krzysztof's patch + patch [1] +
> making ARM_EXYNOS_CPUIDLE depend on PM_SLEEP temporally) are really obvious
> and should be pretty safe so it would be great to have them in v3.16.
> 
> If that is not possible lets fix the issue completely early in v3.17 cycle.

Okay, so Krzysztof's patch was posted in pull request to Olof on Saturday
and merged already for v3.17.  In that case I will just refresh my patches
and resubmit later.  Sorry for all the noise.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> > 
> > > For PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y config more changes are needed
> > > and they are contained in patch [2] (please note that this patch depends
> > > on patch [3] from Tomasz Figa which was redone recently into [4] so my
> > > patch also needs to be refreshed).  However if you think that this would
> > > result in too much changes for v3.16 kernel we can make ARM_EXYNOS_CPUIDLE
> > > select (or depend on) PM_SLEEP for now and fix the issue completely later
> > > in v3.17 kernel.
> > > 
> > > [1] "[PATCH 1/2] ARM: EXYNOS: Fix build with PM_SLEEP=n part #2"
> > > http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34080.html
> > > 
> > > [2] "[PATCH 2/2] ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y"
> > > http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34081.html
> > > 
> > > [3] "[PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies"
> > > http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html
> > > 
> > > [4] "[PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences"
> > > http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34150.html
> > > 
> > > Best regards,
> > > --
> > > Bartlomiej Zolnierkiewicz
> > > Samsung R&D Institute Poland
> > > Samsung Electronics

