Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaFBNRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:17:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47332 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaFBNRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:17:06 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-c1-538c7950e26d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 4/7] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_*
 macros by static inlines
Date: Mon, 02 Jun 2014 15:16:40 +0200
Message-id: <2528436.0tFl7PZNSv@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <538C76A4.8050508@gmail.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
 <1401712543-14281-5-git-send-email-b.zolnierkie@samsung.com>
 <538C76A4.8050508@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgG5AZU+wwY2TYhbzPsta9C64ymZx
	tukNu8X7Q8+YLTY9vsZqcXnXHDaLz71HGC1mnN/HZHHm9CVWi5N/ehkt1s94zWKxatcfRouN
	Xz0ceD12zrrL7nHn2h42j81L6j1u/3vM7LHlajuLR9+WVYwenzfJBbBHcdmkpOZklqUW6dsl
	cGXsnvqQpeCwQMXOxX+ZGhh383YxcnJICJhIzHr8gRnCFpO4cG89WxcjF4eQwCJGicZvU5hA
	EkICLUwSG0/ygdhsAlYSE9tXMYLYIgLqEt+m9LODNDALHGeWeN67kA0kISyQIvHu3iMwm0VA
	VeJfx3UWEJtXQFPi8KdfYM2iAp4SO7avBKvhBIqf+9DLCrF5GaPEuzOtTBANghI/Jt8Da2YW
	kJfYt38qK4StI7G/dRrbBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4Jh5Jr2DcVWDxSFGAQ5GJR7eH+o9wUKsiWXFlbmHGCU4mJVEeJdaAIV4UxIrq1KL8uOL
	SnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwzv869eiq2gklSauWmucs9SpM
	nFJzzrz73oTTpX1BsybduDt/u5tXot2OvuTz+SmTRcyyw9yvuG5ullm6QzdLzf5YcO03t0f+
	O7JetTKelPibf3edxq0vOzZ6LJ3l9rw58eOSMOv9O8U0n6hvu/RAJfBX1dYfjG/9rE2mfg+s
	OrL5Uc0mYbU6VSWW4oxEQy3mouJEAPzys1eVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, June 02, 2014 03:05:40 PM Tomasz Figa wrote:
> Hi,
> 
> On 02.06.2014 14:35, Bartlomiej Zolnierkiewicz wrote:
> > Replace EXYNOS_BOOT_VECTOR_ADDR and EXYNOS_BOOT_VECTOR_FLAG macros
> > by exynos_boot_vector_addr() and exynos_boot_vector_flag() static
> > inlines.
> > 
> > This patch shouldn't cause any functionality changes.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/arm/mach-exynos/pm.c | 28 ++++++++++++++++++++--------
> >  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> > diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> > index 87c0d34..cf09383 100644
> > --- a/arch/arm/mach-exynos/pm.c
> > +++ b/arch/arm/mach-exynos/pm.c
> > @@ -166,12 +166,23 @@ int exynos_cluster_power_state(int cluster)
> >  			S5P_CORE_LOCAL_PWR_EN);
> >  }
> >  
> > -#define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
> > -			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
> > -			(sysram_base_addr + 0x24) : S5P_INFORM0))
> > -#define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
> > -			S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
> > -			(sysram_base_addr + 0x20) : S5P_INFORM1))
> > +static inline void __iomem *exynos_boot_vector_addr(void)
> > +{
> > +	if (samsung_rev() == EXYNOS4210_REV_1_1)
> > +		return S5P_INFORM7;
> > +	else if (samsung_rev() == EXYNOS4210_REV_1_0)
> > +		return sysram_base_addr + 0x24;
> > +	return S5P_INFORM0;
> 
> I know this is not strictly related to this patch, but isn't a check
> whether the SoC is Exynos4210 also needed, before comparing the revision
> with Exynos4210-specific values?

Yes, it is needed but other SoCs need to be verified that they do not
rely on a buggy code (to not introduce regressions).  This is of course
outside a scope of the current patchset.

> Otherwise looks good.
> 
> Best regards,
> Tomasz

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

