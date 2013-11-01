Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3KAVwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:52:53 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61946 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab3KAVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:52:50 -0400
Message-ID: <527422AC.1050105@gmail.com>
Date: Fri, 01 Nov 2013 16:52:44 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH v2 1/4] ARM: EXYNOS: Add support for EXYNOS5410 SoC
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com> <1381763305-7085-2-git-send-email-v.tyrtov@samsung.com>
In-Reply-To: <1381763305-7085-2-git-send-email-v.tyrtov@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 10:08 AM, Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
> Add initial support for this SoC.

I think this entire patch is mostly unnecessary and this information
should all be coming from DT. I'll leave it to arm-soc maintainers
whether they want to accept this addition rather than see some clean-up
here.

"samsung,exynos5410" does need to be documented though.

Rob

> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig             | 12 ++++++++++++
>  arch/arm/mach-exynos/common.c            | 18 ++++++++++++++++++
>  arch/arm/mach-exynos/include/mach/map.h  |  1 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c   |  1 +
>  arch/arm/plat-samsung/include/plat/cpu.h |  8 ++++++++
>  5 files changed, 40 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 56fe819..9ea1799 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -84,6 +84,18 @@ config SOC_EXYNOS5250
>  	help
>  	  Enable EXYNOS5250 SoC support
>  
> +config SOC_EXYNOS5410
> +	bool "SAMSUNG EXYNOS5410"
> +	default y
> +	depends on ARCH_EXYNOS5
> +	select MCPM
> +	select ARM_CCI
> +	select PM_GENERIC_DOMAINS if PM
> +	select S5P_PM if PM
> +	select S5P_SLEEP if PM
> +	help
> +	  Enable EXYNOS5410 SoC support
> +
>  config SOC_EXYNOS5420
>  	bool "SAMSUNG EXYNOS5420"
>  	default y
> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
> index ba95e5d..187c0a4 100644
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -53,6 +53,7 @@ static const char name_exynos4210[] = "EXYNOS4210";
>  static const char name_exynos4212[] = "EXYNOS4212";
>  static const char name_exynos4412[] = "EXYNOS4412";
>  static const char name_exynos5250[] = "EXYNOS5250";
> +static const char name_exynos5410[] = "EXYNOS5410";
>  static const char name_exynos5420[] = "EXYNOS5420";
>  static const char name_exynos5440[] = "EXYNOS5440";
>  
> @@ -86,6 +87,12 @@ static struct cpu_table cpu_ids[] __initdata = {
>  		.init		= exynos_init,
>  		.name		= name_exynos5250,
>  	}, {
> +		.idcode		= EXYNOS5410_SOC_ID,
> +		.idmask		= EXYNOS5_SOC_MASK,
> +		.map_io		= exynos5_map_io,
> +		.init		= exynos_init,
> +		.name		= name_exynos5410,
> +	}, {
>  		.idcode		= EXYNOS5420_SOC_ID,
>  		.idmask		= EXYNOS5_SOC_MASK,
>  		.map_io		= exynos5_map_io,
> @@ -216,6 +223,15 @@ static struct map_desc exynos4x12_iodesc[] __initdata = {
>  	},
>  };
>  
> +static struct map_desc exynos5410_iodesc[] __initdata = {
> +	{
> +		.virtual	= (unsigned long)S5P_VA_SYSRAM_NS,
> +		.pfn		= __phys_to_pfn(EXYNOS5410_PA_SYSRAM_NS),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	},
> +};
> +
>  static struct map_desc exynos5250_iodesc[] __initdata = {
>  	{
>  		.virtual	= (unsigned long)S5P_VA_SYSRAM_NS,
> @@ -365,6 +381,8 @@ static void __init exynos5_map_io(void)
>  
>  	if (soc_is_exynos5250())
>  		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
> +	if (soc_is_exynos5410())
> +		iotable_init(exynos5410_iodesc, ARRAY_SIZE(exynos5410_iodesc));
>  }
>  
>  void __init exynos_init_time(void)
> diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
> index 7b046b5..894f431 100644
> --- a/arch/arm/mach-exynos/include/mach/map.h
> +++ b/arch/arm/mach-exynos/include/mach/map.h
> @@ -29,6 +29,7 @@
>  #define EXYNOS4210_PA_SYSRAM_NS		0x0203F000
>  #define EXYNOS4x12_PA_SYSRAM_NS		0x0204F000
>  #define EXYNOS5250_PA_SYSRAM_NS		0x0204F000
> +#define EXYNOS5410_PA_SYSRAM_NS		0x02073000
>  
>  #define EXYNOS_PA_CHIPID		0x10000000
>  
> diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
> index f874b77..9515186 100644
> --- a/arch/arm/mach-exynos/mach-exynos5-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
> @@ -52,6 +52,7 @@ static void __init exynos5_dt_machine_init(void)
>  
>  static char const *exynos5_dt_compat[] __initdata = {
>  	"samsung,exynos5250",
> +	"samsung,exynos5410",
>  	"samsung,exynos5420",
>  	"samsung,exynos5440",
>  	NULL
> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
> index 4fb1f03..aad7c40 100644
> --- a/arch/arm/plat-samsung/include/plat/cpu.h
> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
> @@ -46,6 +46,7 @@ extern unsigned long samsung_cpu_id;
>  #define EXYNOS4_CPU_MASK	0xFFFE0000
>  
>  #define EXYNOS5250_SOC_ID	0x43520000
> +#define EXYNOS5410_SOC_ID	0xE5410023
>  #define EXYNOS5420_SOC_ID	0xE5420000
>  #define EXYNOS5440_SOC_ID	0xE5440000
>  #define EXYNOS5_SOC_MASK	0xFFFFF000
> @@ -68,6 +69,7 @@ IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>  IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>  IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>  IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
> +IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
>  IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
>  IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>  
> @@ -144,6 +146,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>  # define soc_is_exynos5250()	0
>  #endif
>  
> +#if defined(CONFIG_SOC_EXYNOS5410)
> +# define soc_is_exynos5410()	is_samsung_exynos5410()
> +#else
> +# define soc_is_exynos5410()	0
> +#endif
> +
>  #if defined(CONFIG_SOC_EXYNOS5420)
>  # define soc_is_exynos5420()	is_samsung_exynos5420()
>  #else
> 

