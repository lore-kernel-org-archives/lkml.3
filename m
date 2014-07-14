Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaGNLfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:35:24 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38057 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaGNLfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:35:18 -0400
Date: Mon, 14 Jul 2014 07:35:15 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS: Fix MCPM build with SUSPEND=n
In-Reply-To: <1405337093-15377-1-git-send-email-k.kozlowski@samsung.com>
Message-ID: <alpine.LFD.2.11.1407140730080.3647@knanqh.ubzr>
References: <1405337093-15377-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Krzysztof Kozlowski wrote:

> Building of EXYNOS5420_MCPM with disabled SUSPEND fails:
> arch/arm/mach-exynos/built-in.o: In function `exynos_mcpm_init':
> arch/arm/mach-exynos/mcpm-exynos.c:361: undefined reference to `mcpm_loopback'
> 
> The exynos_mcpm_init() in mcp-exynos.c calls mcpm_loopback() which
> depends on cpu_suspend function (ARM_CPU_SUSPEND).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>

No need to CC stable here as this code has not reached a released kernel 
yet.

> Fixes: a6a4d3152e3cbb6 ("ARM: 8083/1: exynos: activate the CCI on boot CPU/cluster using the MCPM loopback")

And this is not clear yet if this commit ID is stable.

Other than that:

Acked-by: Nicolas Pitre <nico@linaro.org>

Please send to RMK's patch system.


> ---
>  arch/arm/mach-exynos/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 8f9b66c4ac78..5d4ff6571dcd 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -119,6 +119,7 @@ config EXYNOS5420_MCPM
>  	bool "Exynos5420 Multi-Cluster PM support"
>  	depends on MCPM && SOC_EXYNOS5420
>  	select ARM_CCI
> +	select ARM_CPU_SUSPEND
>  	help
>  	  This is needed to provide CPU and cluster power management
>  	  on Exynos5420 implementing big.LITTLE.
> -- 
> 1.9.1
> 
> 
