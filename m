Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbbAZHtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:49:42 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36733 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbAZHtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 02:49:40 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-43-54c5f0ffd033
Content-transfer-encoding: 8BIT
Message-id: <1422258575.4131.0.camel@AMDC1943>
Subject: Re: [PATCH v3 1/2] ARM: EXYNOS: apply S5P_CENTRAL_SEQ_OPTION fix only
 when necessary
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Colin Cross <ccross@google.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Date: Mon, 26 Jan 2015 08:49:35 +0100
In-reply-to: <1422030294-20925-2-git-send-email-b.zolnierkie@samsung.com>
References: <1422030294-20925-1-git-send-email-b.zolnierkie@samsung.com>
 <1422030294-20925-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xy7r/PxwNMfjVbGaxccZ6VosFM9qZ
	LeZ9lrXoXXCVzaL/8Wtmi7NNb9gt3h96xmxxedccNovPvUcYLWac38dksWrXH0YHbo+ds+6y
	eyzYVOqxaVUnm8eda3vYPG7/e8zs0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBlTD2UVnBKt
	OP7xKVsD42fBLkYODgkBE4l5i1m6GDmBTDGJC/fWs3UxcnEICSxllLh37SUjSIJXQFDix+R7
	LCD1zALyEkcuZYOEmQXUJSbNW8QMUf+ZUaJtyXFmiHo9iVc7DoP1CgvES/xZNxssziZgLLF5
	+RI2EFtEwEJi7Yq3LCDNzALPmSTedf4Ga2ARUJU4v3gKmM0p4Clxfc9PJogN7YwSL5YeYYW4
	Wlmisd9tAqPALCT3zUK4bxaS+xYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImMLzsY
	Fx+zOsQowMGoxMM7YeLRECHWxLLiytxDjBIczEoivOVTgEK8KYmVValF+fFFpTmpxYcYmTg4
	pRoYq1xZ7l0rkze/H6n1lnNOi4cmL4vAegO1iw0Buj/k6o4+er9le0j/5ZmRNcGdB50tFe+y
	3spI8TiSeelP57rqA1+FWY9JXBROfhemFhivoKO/OtjlVME6500XI/T2zf3Vev/L8YPFulNC
	+JecS29w+WZ2a3vR9te5USlPZ1QktnDZ+LzU7vZXYinOSDTUYi4qTgQAAz+G0moCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2015-01-23 at 17:24 +0100, Bartlomiej Zolnierkiewicz wrote:
> Commit c2dd114d2486 ("ARM: EXYNOS: fix register setup for AFTR mode
> code") added S5P_CENTRAL_SEQ_OPTION register setup fix for all
> Exynos SoCs to AFTR mode code-path.  It turned out that for coupled
> cpuidle AFTR mode on Exynos4210 (added by the next patch) applying
> this fix causes lockup so enable it in the AFTR mode code-path only
> on SoCs that require it (in the suspend code-path it can be always
> applied like it was before commit c2dd114d2486).
> 
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Colin Cross <ccross@google.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/pm.c      | 11 +++++++----
>  arch/arm/mach-exynos/suspend.c |  4 ++++
>  2 files changed, 11 insertions(+), 4 deletions(-)

Looks good.

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> 
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index dfc8594..1a7454d 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -98,10 +98,6 @@ void exynos_pm_central_suspend(void)
>  	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
>  	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
>  	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
> -
> -	/* Setting SEQ_OPTION register */
> -	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
> -		       S5P_CENTRAL_SEQ_OPTION);
>  }
>  
>  int exynos_pm_central_resume(void)
> @@ -165,6 +161,13 @@ void exynos_enter_aftr(void)
>  
>  	exynos_pm_central_suspend();
>  
> +	if (of_machine_is_compatible("samsung,exynos4212") ||
> +	    of_machine_is_compatible("samsung,exynos4412")) {
> +		/* Setting SEQ_OPTION register */
> +		pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
> +			       S5P_CENTRAL_SEQ_OPTION);
> +	}
> +
>  	cpu_suspend(0, exynos_aftr_finisher);
>  
>  	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
> diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
> index 82e6b6f..666ec3e 100644
> --- a/arch/arm/mach-exynos/suspend.c
> +++ b/arch/arm/mach-exynos/suspend.c
> @@ -319,6 +319,10 @@ static int exynos_pm_suspend(void)
>  {
>  	exynos_pm_central_suspend();
>  
> +	/* Setting SEQ_OPTION register */
> +	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
> +		       S5P_CENTRAL_SEQ_OPTION);
> +
>  	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
>  		exynos_cpu_save_register();
>  

