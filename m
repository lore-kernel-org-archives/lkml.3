Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaDKBqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 21:46:52 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45739 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaDKBqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 21:46:50 -0400
Date: Thu, 10 Apr 2014 18:46:50 -0700
From: Olof Johansson <olof@lixom.net>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
Message-ID: <20140411014650.GB14934@quad.lixom.net>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 06:37:12PM +0900, Chanwoo Choi wrote:
> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
> dual cores and has a target speed of 1.0GHz.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>  arch/arm/mach-exynos/exynos.c            |  1 +
>  arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index fc8bf18..6da8a68 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>  
>  menu "SAMSUNG EXYNOS SoCs Support"
>  
> +config ARCH_EXYNOS3
> +	bool "SAMSUNG EXYNOS3"
> +	select ARM_AMBA
> +	select CLKSRC_OF
> +	select HAVE_ARM_SCU if SMP
> +	select HAVE_SMP
> +	select PINCTRL
> +	select PM_GENERIC_DOMAINS if PM_RUNTIME
> +	help
> +	  Samsung EXYNOS3 SoCs based systems
> +
>  config ARCH_EXYNOS4
>  	bool "SAMSUNG EXYNOS4"
>  	default y
> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>  
>  comment "EXYNOS SoCs"
>  
> +config SOC_EXYNOS3250
> +	bool "SAMSUNG EXYNOS3250"
> +	default y
> +	depends on ARCH_EXYNOS3
> +	select ARCH_HAS_BANDGAP
> +	select ARM_CPU_SUSPEND if PM
> +	select PINCTRL_EXYNOS
> +	select SAMSUNG_DMADEV
> +	help
> +	  Enable EXYNOS3250 CPU support
> +
>  config CPU_EXYNOS4210
>  	bool "SAMSUNG EXYNOS4210"
>  	default y
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index b32a907..b134868 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -370,6 +370,7 @@ static void __init exynos_dt_machine_init(void)
>  }
>  
>  static char const *exynos_dt_compat[] __initconst = {
> +	"samsung,exynos3250",

Please consider samsung,exynos3 instead, so you don't have to update this table
for every SoC. We've talked about this before..

>  	"samsung,exynos4",
>  	"samsung,exynos4210",
>  	"samsung,exynos4212",
> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
> index 5992b8d..3d808f6b 100644
> --- a/arch/arm/plat-samsung/include/plat/cpu.h
> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
> @@ -43,6 +43,9 @@ extern unsigned long samsung_cpu_id;
>  #define S5PV210_CPU_ID		0x43110000
>  #define S5PV210_CPU_MASK	0xFFFFF000
>  
> +#define EXYNOS3250_SOC_ID       0xE3472000
> +#define EXYNOS3_SOC_MASK        0xFFFFF000
> +
>  #define EXYNOS4210_CPU_ID	0x43210000
>  #define EXYNOS4212_CPU_ID	0x43220000
>  #define EXYNOS4412_CPU_ID	0xE4412200
> @@ -68,6 +71,7 @@ IS_SAMSUNG_CPU(s5p6440, S5P6440_CPU_ID, S5P64XX_CPU_MASK)
>  IS_SAMSUNG_CPU(s5p6450, S5P6450_CPU_ID, S5P64XX_CPU_MASK)
>  IS_SAMSUNG_CPU(s5pc100, S5PC100_CPU_ID, S5PC100_CPU_MASK)
>  IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
> +IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
>  IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>  IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>  IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
> @@ -126,6 +130,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>  # define soc_is_s5pv210()	0
>  #endif
>  
> +#if defined(CONFIG_SOC_EXYNOS3250)
> +# define soc_is_exynos3250()    is_samsung_exynos3250()
> +#else
> +# define soc_is_exynos3250()    0
> +#endif

In general, I think we have too much code littered with soc_is_<foo>() going
on, so please try to avoid adding more for this SoC. Especially in cases where
you just want to bail out of certain features where we might already have
function pointers to control if a function is called or not, such as the
firmware interfaces.


-Olof
