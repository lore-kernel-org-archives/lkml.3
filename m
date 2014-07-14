Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaGNMzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:55:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29410 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaGNMzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:55:20 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a7-53c3d336ae23
Message-id: <1405342516.13970.0.camel@AMDC1943>
Subject: Re: [PATCH] ARM: EXYNOS: Fix MCPM build with SUSPEND=n
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Date: Mon, 14 Jul 2014 14:55:16 +0200
In-reply-to: <alpine.LFD.2.11.1407140730080.3647@knanqh.ubzr>
References: <1405337093-15377-1-git-send-email-k.kozlowski@samsung.com>
 <alpine.LFD.2.11.1407140730080.3647@knanqh.ubzr>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7pmlw8HG3QcE7fYOGM9q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77Bafnv1jt1iw8RGjxfoZr1kcuD1amnvY
	PO5c28PmsXlJvUffllWMHp83yQWwRnHZpKTmZJalFunbJXBlXHjUxFawlbfi6bXljA2MV7m6
	GDk5JARMJJadfMQMYYtJXLi3nq2LkYtDSGApo8S2x89ZIZzPjBK/l65lAqniFdCXaO27xAhi
	CwvYS7xcPJEFxGYTMJbYvHwJG4gtIqAjcXTma2aQZmaBNmaJSXNb2UESLAKqEouXbgSzOQVs
	JY6svA/WICRQJXFo01qwocwC6hKT5i2COklZYt7+Y1CLBSV+TL7HAlEjL7F5zVvmCYwCs5C0
	zEJSNgtJ2QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIdHwZQfj4mNWhxgFOBiVeHgr
	xA4HC7EmlhVX5h5ilOBgVhLhPX0UKMSbklhZlVqUH19UmpNafIiRiYNTqoFx0qoLiafb/7t9
	5XiuG2l77uz1D26zdwbOe3LkrpTE3GlXBZ7l606VN+179j7m/yrxf78dZ5aoLb12zUJkqqGo
	anDA61X291v2/9g0e/LEqT8cTpWYN4aVeRxVv3ik4uk8LjPmp/sKbaQvpIp3v+x2PfRa4aGB
	x1S+K+prPvTYmr0VyJPubGn5p8RSnJFoqMVcVJwIAIcWBehkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-07-14 at 07:35 -0400, Nicolas Pitre wrote:
> On Mon, 14 Jul 2014, Krzysztof Kozlowski wrote:
> 
> > Building of EXYNOS5420_MCPM with disabled SUSPEND fails:
> > arch/arm/mach-exynos/built-in.o: In function `exynos_mcpm_init':
> > arch/arm/mach-exynos/mcpm-exynos.c:361: undefined reference to `mcpm_loopback'
> > 
> > The exynos_mcpm_init() in mcp-exynos.c calls mcpm_loopback() which
> > depends on cpu_suspend function (ARM_CPU_SUSPEND).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: <stable@vger.kernel.org>
> 
> No need to CC stable here as this code has not reached a released kernel 
> yet.
> 
> > Fixes: a6a4d3152e3cbb6 ("ARM: 8083/1: exynos: activate the CCI on boot CPU/cluster using the MCPM loopback")
> 
> And this is not clear yet if this commit ID is stable.
> 
> Other than that:
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>
> 
> Please send to RMK's patch system.

Sure, I'll remove the cc-stable tag, add your ack and send to the patch
system.

Thanks,
Krzysztof

> 
> 
> > ---
> >  arch/arm/mach-exynos/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> > index 8f9b66c4ac78..5d4ff6571dcd 100644
> > --- a/arch/arm/mach-exynos/Kconfig
> > +++ b/arch/arm/mach-exynos/Kconfig
> > @@ -119,6 +119,7 @@ config EXYNOS5420_MCPM
> >  	bool "Exynos5420 Multi-Cluster PM support"
> >  	depends on MCPM && SOC_EXYNOS5420
> >  	select ARM_CCI
> > +	select ARM_CPU_SUSPEND
> >  	help
> >  	  This is needed to provide CPU and cluster power management
> >  	  on Exynos5420 implementing big.LITTLE.
> > -- 
> > 1.9.1
> > 
> > 

