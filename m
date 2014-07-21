Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaGUKi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:38:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32141 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbaGUKi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:38:56 -0400
X-AuditID: cbfee61a-f79e46d00000134f-14-53ccedbb884d
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
Date: Mon, 21 Jul 2014 12:38:28 +0200
Message-id: <5864544.mJGdtT36g8@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <53C978AA.9090603@samsung.com>
References: <1405323953-25954-1-git-send-email-k.kozlowski@samsung.com>
 <53C66924.3010303@samsung.com> <53C978AA.9090603@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jAd3db88EG6yZY2Tx+oWhRe+Cq2wW
	Z5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12LtkbvsFqeuf2azuHLpFJvF+hmvWRy4PVqae9g8
	Ni+p97hyoonVo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDLmLznNVPBJrGLOsg2sDYztwl2M
	nBwSAiYSH5ufskDYYhIX7q1n62Lk4hASWMQoceLzbhYIp4VJYt78bawgVWwCVhIT21cxgtgi
	AmoSPYu3MoIUMQv0M0uc/NTLBpIQFrCTmN3QyA5iswioSkyaNBmomYODV0BT4vACW5CwqICn
	xI7tK8HKOQW0JX7+28kKsaydUeL8xQ6wk3gFBCV+TL4HZjMLyEvs2z+VFcLWkdjfOo1tAqPA
	LCRls5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcCw8k9rBuLLB4hCjAAej
	Eg+vB+OZYCHWxLLiytxDjBIczEoivCcygEK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJ
	pCeWpGanphakFsFkmTg4pRoYAwv2z1/pXPQ7UHl16OQXKtwhi2w89AvuakvLeK8IWHPNde3e
	WLflG3632n945/kgUeJpkEJRpeWhieLzXt+6OFf23XeG07Er2NcHrf1s1BO6pNZTsvXYA3GO
	V7etlJ9Xx5ZGLhdIERJlP/BYjJ/pbfyZqi0Hbpd19zZxf57OdM9+Y7Oioew/JZbijERDLeai
	4kQAMSXd+YECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday, July 19, 2014 04:42:34 AM Kukjin Kim wrote:
> On 07/16/14 20:59, Tomasz Figa wrote:
> > Hi Krzysztof,
> >
> > On 14.07.2014 09:45, Krzysztof Kozlowski wrote:
> >> Fix building of exynos defconfig with disabled PM_SLEEP:
> >> CONFIG_PM_SLEEP=n
> >> CONFIG_PM_SLEEP_SMP=n
> >> CONFIG_SUSPEND=n
> >> by moving functions for power up/down of CPU and cluster to platsmp.c
> >>
> >> The build error messages:
> >> arch/arm/mach-exynos/built-in.o: In function `exynos_boot_secondary':
> >> arch/arm/mach-exynos/platsmp.c:111: undefined reference to `exynos_cpu_power_state'
> >> arch/arm/mach-exynos/platsmp.c:112: undefined reference to `exynos_cpu_power_up'
> >> arch/arm/mach-exynos/platsmp.c:116: undefined reference to `exynos_cpu_power_state'
> >> make: *** [vmlinux] Error 1
> >>
> >> Signed-off-by: Krzysztof Kozlowski<k.kozlowski@samsung.com>
> >>
> >> ---
> >> Changes since v1:
> >> 1. Use different solution - just move the power up/down functions to a
> >>     common place instead of adding stubs in common.h. Suggested by Tomasz
> >>     Figa.
> >> ---
> >>   arch/arm/mach-exynos/platsmp.c | 66 ++++++++++++++++++++++++++++++++++++++++++
> >>   arch/arm/mach-exynos/pm.c      | 66 ------------------------------------------
> >>   2 files changed, 66 insertions(+), 66 deletions(-)
> >>
> >
> + Bart,
> 
> > Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> >
> Applied, thanks.
> 
> Bart, I think this is better at this moment to fix the build breakage 
> with disabling PM...if you have any comments, please let me know.

To fix PM_SLEEP=n build itself (with ARM_EXYNOS_CPUIDLE=n) Krzysztof's
patch is not enough and patch [1] is also needed (this patch is very
simple so I think that it is okay for v3.16).

For PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y config more changes are needed
and they are contained in patch [2] (please note that this patch depends
on patch [3] from Tomasz Figa which was redone recently into [4] so my
patch also needs to be refreshed).  However if you think that this would
result in too much changes for v3.16 kernel we can make ARM_EXYNOS_CPUIDLE
select (or depend on) PM_SLEEP for now and fix the issue completely later
in v3.17 kernel.

[1] "[PATCH 1/2] ARM: EXYNOS: Fix build with PM_SLEEP=n part #2"
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34080.html

[2] "[PATCH 2/2] ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y"
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34081.html

[3] "[PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies"
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html

[4] "[PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences"
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34150.html

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

