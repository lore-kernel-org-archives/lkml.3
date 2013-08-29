Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3H2Op4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:45:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47363 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3H2Opy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:45:54 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-d2-521f5ea00a68
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com, m.chehab@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 6/6] ARM: s5pv210: Migrate clock handling to Common
 Clock Framework
Date: Thu, 29 Aug 2013 16:45:47 +0200
Message-id: <114819207.AEsYHM8mib@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377706384-3697-7-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377706384-3697-7-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t/xK7oL4uSDDDa8Y7KYtO4Ak8X8I+dY
	Ld70drBY9C64ymZxtukNu8Wmx9dYLRa2LWGxuLxrDptFz4atrBYzzu9jsrh9mdfi4jp5i9Nr
	TjFbLL1+kcni6YSLbBYTpq9lsTi8AmjaupfTgaw37awWrw62sVjMa3/JanFsxhJGi1W7/jA6
	iHusmbeG0aOluYfNY8HnK+werydPYPT4u+oFs8fOWXfZPV6tnsnqcefaHjaPzUvqPQ6+28Pk
	0bdlFaPH501yHhvnhgbwRnHZpKTmZJalFunbJXBlbL0bXvDRueLYlWesDYz/zbsYOTkkBEwk
	Vt9oYYKwxSQu3FvPBmILCSxllOiaz9PFyAVkdzFJPPx8FKyITUBN4nPDI7AiEQFTiXd3r7GB
	FDEL7GeReLp2EiNIQlggRuLZhadgNouAqkT7nl/sIDavgLZEa8MnFhCbX0Bd4t22p0BDOThE
	BVwk+v5mgoQ5BfwkPs99ywxxxERGidsv5CFaBSV+TL4H1sosIC+xb/9UVghbS2L9zuNMExgF
	ZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQmL8yw7GxcesDjEKcDAq
	8fA+CJYPEmJNLCuuzD3EKMHBrCTC+5YTKMSbklhZlVqUH19UmpNafIiRiYNTqoExJ/HX9yuP
	lJs3sPy7Oa/kW6co522fu+rx9xLZJjMHaAp3mLzVZN904oCNTMH8HAk1NbvJez+khl65tVbj
	6ZGni3aWFzw56NCddSpwbUr/srv93k8PmHqfNnu4urRm/iSxKzXdJy2qFAQXBe3X+LrGb2eI
	qGZK+2IWI07PIntOwznCac13nqQqsRRnJBpqMRcVJwIAm6GcXc8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Wednesday 28 of August 2013 18:13:04 Mateusz Krawczuk wrote:
> This patch migrates the s5pv210 platform to use new clock driver
> using Common Clock Framework.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  arch/arm/mach-s5pv210/Kconfig         |  9 +++++++++
>  arch/arm/mach-s5pv210/Makefile        |  4 ++--
>  arch/arm/mach-s5pv210/common.c        | 17 +++++++++++++++++
>  arch/arm/mach-s5pv210/common.h        | 13 +++++++++++++
>  arch/arm/mach-s5pv210/mach-aquila.c   |  1 +
>  arch/arm/mach-s5pv210/mach-goni.c     |  3 ++-
>  arch/arm/mach-s5pv210/mach-smdkc110.c |  1 +
>  arch/arm/mach-s5pv210/mach-smdkv210.c |  1 +
>  arch/arm/mach-s5pv210/mach-torbreck.c |  1 +
>  arch/arm/plat-samsung/Kconfig         |  2 +-
>  arch/arm/plat-samsung/init.c          |  2 --
>  11 files changed, 48 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-s5pv210/Kconfig
> b/arch/arm/mach-s5pv210/Kconfig index caaedaf..ad4546e 100644
> --- a/arch/arm/mach-s5pv210/Kconfig
> +++ b/arch/arm/mach-s5pv210/Kconfig
> @@ -15,6 +15,7 @@ config CPU_S5PV210
>  	select S5P_PM if PM
>  	select S5P_SLEEP if PM
>  	select SAMSUNG_DMADEV
> +	select S5P_CLOCK if !COMMON_CLK
>  	help
>  	  Enable S5PV210 CPU support
> 
> @@ -69,6 +70,14 @@ config S5PV210_SETUP_USB_PHY
>  	help
>  	  Common setup code for USB PHY controller
> 
> +config COMMON_CLK_S5PV210
> +	bool "Common Clock Framework support"
> +	default y
> +	select COMMON_CLK
> +	help
> +	  Enable this option to use new clock driver
> +	  based on Common Clock Framework.
> +
>  menu "S5PC110 Machines"
> 
>  config MACH_AQUILA
> diff --git a/arch/arm/mach-s5pv210/Makefile
> b/arch/arm/mach-s5pv210/Makefile index 1c4e419..0c67fe2 100644
> --- a/arch/arm/mach-s5pv210/Makefile
> +++ b/arch/arm/mach-s5pv210/Makefile
> @@ -12,8 +12,8 @@ obj-				:=
> 
>  # Core
> 
> -obj-y				+= common.o clock.o
> -
> +obj-y					+= common.o
> +obj-$(CONFIG_S5P_CLOCK)			+= clock.o
>  obj-$(CONFIG_PM)		+= pm.o
> 
>  obj-y				+= dma.o
> diff --git a/arch/arm/mach-s5pv210/common.c
> b/arch/arm/mach-s5pv210/common.c index 26027a2..a1d86a1 100644
> --- a/arch/arm/mach-s5pv210/common.c
> +++ b/arch/arm/mach-s5pv210/common.c
> @@ -34,7 +34,13 @@
>  #include <mach/regs-clock.h>
> 
>  #include <plat/cpu.h>
> +
> +#ifdef CONFIG_S5P_CLOCK
>  #include <plat/clock.h>
> +#else
> +#include <linux/clk-provider.h>
> +#endif
> +
>  #include <plat/devs.h>
>  #include <plat/sdhci.h>
>  #include <plat/adc-core.h>
> @@ -50,6 +56,14 @@
> 
>  #include "common.h"
> 
> +/* External clock frequency */
> +static unsigned long xusbxti_f, xxti_f;

If the xxti_f variable is not being changed anywhere, it might be a good 
idea to drop it completely and pass a constant zero to s5pv210_clk_init().

> +
> +void __init s5pv210_set_xusbxti_freq(unsigned long freq)
> +{
> +	xusbxti_f = freq;
> +}
> +
>  static const char name_s5pv210[] = "S5PV210/S5PC110";
> 
>  static struct cpu_table cpu_ids[] __initdata = {
> @@ -229,12 +243,14 @@ void __init s5pv210_map_io(void)
> 
>  void __init s5pv210_init_clocks(int xtal)
>  {
> +#ifdef CONFIG_S5P_CLOCK
>  	printk(KERN_DEBUG "%s: initializing clocks\n", __func__);
> 
>  	s3c24xx_register_baseclocks(xtal);
>  	s5p_register_clocks(xtal);
>  	s5pv210_register_clocks();
>  	s5pv210_setup_clocks();
> +#endif
>  }
> 
>  void __init s5pv210_init_irq(void)
> @@ -248,6 +264,7 @@ void __init s5pv210_init_irq(void)
>  	vic[3] = ~0;
> 
>  	s5p_init_irq(vic, ARRAY_SIZE(vic));
> +	s5pv210_clk_init(NULL, xxti_f, xusbxti_f, S3C_VA_SYS);
>  }
> 
>  struct bus_type s5pv210_subsys = {
> diff --git a/arch/arm/mach-s5pv210/common.h
> b/arch/arm/mach-s5pv210/common.h index fe1beb5..2db2a15 100644
> --- a/arch/arm/mach-s5pv210/common.h
> +++ b/arch/arm/mach-s5pv210/common.h
> @@ -14,6 +14,19 @@
> 
>  #include <linux/reboot.h>
> 
> +void s5pv210_set_xxti_freq(unsigned long freq);

This function is no longer present in common.c, so should be removed here 
as well.

> +void s5pv210_set_xusbxti_freq(unsigned long freq);
> +
> +#ifdef CONFIG_COMMON_CLK_S5PV210
> +void s5pv210_clk_init(struct device_node *np,
> +			    unsigned long xxti_f, unsigned long xusbxti_f,
> +			    void __iomem *reg_base);
> +#else
> +static inline void s5pv210_clk_init(struct device_node *np,
> +			    unsigned long xxti_f, unsigned long xusbxti_f,
> +			    void __iomem *reg_base) {}
> +#endif
> +
>  void s5pv210_init_io(struct map_desc *mach_desc, int size);
>  void s5pv210_init_irq(void);
> 
> diff --git a/arch/arm/mach-s5pv210/mach-aquila.c
> b/arch/arm/mach-s5pv210/mach-aquila.c index ad40ab0..e37a311 100644
> --- a/arch/arm/mach-s5pv210/mach-aquila.c
> +++ b/arch/arm/mach-s5pv210/mach-aquila.c
> @@ -646,6 +646,7 @@ static void __init aquila_map_io(void)
>  {
>  	s5pv210_init_io(NULL, 0);
>  	s3c24xx_init_clocks(24000000);
> +	s5pv210_set_xusbxti_freq(24000000);
>  	s3c24xx_init_uarts(aquila_uartcfgs, ARRAY_SIZE(aquila_uartcfgs));
>  	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
>  }
> diff --git a/arch/arm/mach-s5pv210/mach-goni.c
> b/arch/arm/mach-s5pv210/mach-goni.c index 282d714..a1955e9 100644
> --- a/arch/arm/mach-s5pv210/mach-goni.c
> +++ b/arch/arm/mach-s5pv210/mach-goni.c
> @@ -966,7 +966,8 @@ static void __init goni_sound_init(void)
>  static void __init goni_map_io(void)
>  {
>  	s5pv210_init_io(NULL, 0);
> -	s3c24xx_init_clocks(clk_xusbxti.rate);
> +	s3c24xx_init_clocks(24000000);
> +	s5pv210_set_xusbxti_freq(24000000);
>  	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
>  	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
>  }
> diff --git a/arch/arm/mach-s5pv210/mach-smdkc110.c
> b/arch/arm/mach-s5pv210/mach-smdkc110.c index 7c0ed07..89563ed 100644
> --- a/arch/arm/mach-s5pv210/mach-smdkc110.c
> +++ b/arch/arm/mach-s5pv210/mach-smdkc110.c
> @@ -119,6 +119,7 @@ static void __init smdkc110_map_io(void)
>  {
>  	s5pv210_init_io(NULL, 0);
>  	s3c24xx_init_clocks(24000000);
> +	s5pv210_set_xusbxti_freq(24000000);
>  	s3c24xx_init_uarts(smdkv210_uartcfgs, ARRAY_SIZE(smdkv210_uartcfgs));
>  	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
>  }
> diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c
> b/arch/arm/mach-s5pv210/mach-smdkv210.c index 6d72bb99..ff4a470 100644
> --- a/arch/arm/mach-s5pv210/mach-smdkv210.c
> +++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
> @@ -285,6 +285,7 @@ static void __init smdkv210_map_io(void)
>  {
>  	s5pv210_init_io(NULL, 0);
>  	s3c24xx_init_clocks(clk_xusbxti.rate);

This won't compile with common clk enabled, since it would reference a non-
existent clk_xusbxti symbol. Shouldn't this be changed in the same way as 
mach-goni?

> +	s5pv210_set_xusbxti_freq(24000000);
>  	s3c24xx_init_uarts(smdkv210_uartcfgs, ARRAY_SIZE(smdkv210_uartcfgs));
>  	samsung_set_timer_source(SAMSUNG_PWM2, SAMSUNG_PWM4);
>  }
> diff --git a/arch/arm/mach-s5pv210/mach-torbreck.c
> b/arch/arm/mach-s5pv210/mach-torbreck.c index 579afe8..c131cd2 100644
> --- a/arch/arm/mach-s5pv210/mach-torbreck.c
> +++ b/arch/arm/mach-s5pv210/mach-torbreck.c
> @@ -105,6 +105,7 @@ static void __init torbreck_map_io(void)
>  {
>  	s5pv210_init_io(NULL, 0);
>  	s3c24xx_init_clocks(24000000);
> +	s5pv210_set_xusbxti_freq(24000000);
>  	s3c24xx_init_uarts(torbreck_uartcfgs, ARRAY_SIZE(torbreck_uartcfgs));
>  	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
>  }
> diff --git a/arch/arm/plat-samsung/Kconfig
> b/arch/arm/plat-samsung/Kconfig index 7dfba93..2a98613 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -91,7 +91,7 @@ config SAMSUNG_CLKSRC
>  	  used by newer systems such as the S3C64XX.
> 
>  config S5P_CLOCK
> -	def_bool (ARCH_S5P64X0 || ARCH_S5PC100 || ARCH_S5PV210)
> +	def_bool (ARCH_S5P64X0 || ARCH_S5PC100)
>  	help
>  	  Support common clock part for ARCH_S5P and ARCH_EXYNOS SoCs
> 
> diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
> index aa9511b..f0f818e 100644
> --- a/arch/arm/plat-samsung/init.c
> +++ b/arch/arm/plat-samsung/init.c
> @@ -69,7 +69,6 @@ void __init s3c_init_cpu(unsigned long idcode,
>  	if (cpu->map_io)
>  		cpu->map_io();
>  }
> -

This change doesn't belong to this patch.

>  /* s3c24xx_init_clocks
>   *
>   * Initialise the clock subsystem and associated information from the
> @@ -92,7 +91,6 @@ void __init s3c24xx_init_clocks(int xtal)
>  	else
>  		(cpu->init_clocks)(xtal);
>  }
> -

Ditto.

Otherwise looks good.

Best regards,
Tomasz

