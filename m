Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3HZQjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:39:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40559 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3HZQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:39:00 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-89-521b84a21db7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, t.figa@samsung.com,
        tomasz.figa@gmail.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC 5/5] ARM: s5pv210: Migrate clock handling to Common
 Clock Framework
Date: Mon, 26 Aug 2013 18:38:41 +0200
Message-id: <98398598.NaRaDrXJny@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1377517114-20222-6-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377517114-20222-6-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd1FLdJBBgffSFnMP3KO1eJNbweL
	Re+Cq2wWZ5vesFtsenyN1WJh2xIWi8u75rBZzDi/j8ni9mVei4vr5C1OrznFbPG67zCLxdLr
	F5ksnk64yGYxYfpaFovDKw4wWax7OR3IetPOavHqYBuLxfoZr1ks5rW/ZLU4NmMJo8WqXX8Y
	HcQ91sxbw+jR0tzD5rHg8xV2j9eTJzB67Jx1l93j1eqZrB53ru1h89i8pN7j4Ls9TB59W1Yx
	enR/usXq8XmTnMfGuaEBvFFcNimpOZllqUX6dglcGb2Ll7EWtDhXHNlyk62BcZl5FyMnh4SA
	icT0S29YIWwxiQv31rN1MXJxCAlMZ5RY+GobM0hCSKCFSWLTXjsQm03ASmJi+ypGEFtEwFTi
	3d1rYA3MArtYJN4+WAHWICwQK7F2RQvYVBYBVYknUzezgdi8AloSL1Z9AouLCrhKnFv0gwXE
	5hTwl7g0sZMRYvNkRomde7YwQTQISvyYfA+siFlAXmLf/qmsELaOxP7WaWwTGAVmISmbhaRs
	FpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/qZ1A7GlQ0WhxgFOBiVeHg7mqSD
	hFgTy4orcw8xSnAwK4nwcqQChXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5N
	LUgtgskycXBKNTBWPlH+VdpkerLm6ZsXEitbli0Rtb+rdykve5pNyNo39a1fpPpibnpnbORN
	/3sy1EGv1K1niwQjq8OdoPamJP6dl7dec3bwsuNq3XmgV+n1HyHPSR9dny979sJ5ubao7NJn
	ZVvfyk3MyPtt2LPOfXXR2bqkpPd/umL+6M+Vl+f5krs+mvlzIoMSS3FGoqEWc1FxIgBC5aG6
	5AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, August 26, 2013 01:38:34 PM Mateusz Krawczuk wrote:
> This patch migrates the s5pv210 platform to use new clock driver
> using Common Clock Framework.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  arch/arm/mach-s5pv210/Kconfig         |  9 +++++++++
>  arch/arm/mach-s5pv210/Makefile        |  4 ++--
>  arch/arm/mach-s5pv210/common.c        | 22 ++++++++++++++++++++++
>  arch/arm/mach-s5pv210/common.h        | 13 +++++++++++++
>  arch/arm/mach-s5pv210/mach-aquila.c   |  1 +
>  arch/arm/mach-s5pv210/mach-goni.c     |  3 ++-
>  arch/arm/mach-s5pv210/mach-smdkc110.c |  1 +
>  arch/arm/mach-s5pv210/mach-smdkv210.c |  1 +
>  arch/arm/mach-s5pv210/mach-torbreck.c |  1 +
>  arch/arm/plat-samsung/Kconfig         |  2 +-
>  arch/arm/plat-samsung/init.c          |  2 --
>  11 files changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
> index caaedaf..ad4546e 100644
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
> diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
> index 1c4e419..0c67fe2 100644
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
> diff --git a/arch/arm/mach-s5pv210/common.c b/arch/arm/mach-s5pv210/common.c
> index 26027a2..3c3dd05 100644
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
> @@ -50,6 +56,19 @@
>  
>  #include "common.h"
>  
> +/* External clock frequency */
> +static unsigned long xxti_f, xusbxti_f;
> +
> +void __init s5pv210_set_xxti_freq(unsigned long freq)
> +{
> +	xxti_f = freq;
> +}

This function is not used anywhere while xxti_f is used in
s5pv210_init_irq(). Please fix it.

> +void __init s5pv210_set_xusbxti_freq(unsigned long freq)
> +{
> +	xusbxti_f = freq;
> +}
> +
>  static const char name_s5pv210[] = "S5PV210/S5PC110";
>  
>  static struct cpu_table cpu_ids[] __initdata = {
> @@ -229,12 +248,14 @@ void __init s5pv210_map_io(void)
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
> @@ -248,6 +269,7 @@ void __init s5pv210_init_irq(void)
>  	vic[3] = ~0;
>  
>  	s5p_init_irq(vic, ARRAY_SIZE(vic));
> +	s5pv210_clk_init(NULL, xxti_f, xusbxti_f, S3C_VA_SYS);
>  }
>  
>  struct bus_type s5pv210_subsys = {
> diff --git a/arch/arm/mach-s5pv210/common.h b/arch/arm/mach-s5pv210/common.h
> index fe1beb5..2db2a15 100644
> --- a/arch/arm/mach-s5pv210/common.h
> +++ b/arch/arm/mach-s5pv210/common.h
> @@ -14,6 +14,19 @@
>  
>  #include <linux/reboot.h>
>  
> +void s5pv210_set_xxti_freq(unsigned long freq);
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
> diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
> index ad40ab0..e37a311 100644
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
> diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
> index 309b5ad..a306c3b 100644
> --- a/arch/arm/mach-s5pv210/mach-goni.c
> +++ b/arch/arm/mach-s5pv210/mach-goni.c
> @@ -946,7 +946,8 @@ static void __init goni_sound_init(void)
>  static void __init goni_map_io(void)
>  {
>  	s5pv210_init_io(NULL, 0);
> -	s3c24xx_init_clocks(clk_xusbxti.rate);
> +	s3c24xx_init_clocks(24000000);
> +	s5pv210_set_xusbxti_freq(24000000);
>  	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
>  	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
>  }
> diff --git a/arch/arm/mach-s5pv210/mach-smdkc110.c b/arch/arm/mach-s5pv210/mach-smdkc110.c
> index 7c0ed07..89563ed 100644
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
> diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
> index 6d72bb99..ff4a470 100644
> --- a/arch/arm/mach-s5pv210/mach-smdkv210.c
> +++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
> @@ -285,6 +285,7 @@ static void __init smdkv210_map_io(void)
>  {
>  	s5pv210_init_io(NULL, 0);
>  	s3c24xx_init_clocks(clk_xusbxti.rate);
> +	s5pv210_set_xusbxti_freq(24000000);
>  	s3c24xx_init_uarts(smdkv210_uartcfgs, ARRAY_SIZE(smdkv210_uartcfgs));
>  	samsung_set_timer_source(SAMSUNG_PWM2, SAMSUNG_PWM4);
>  }
> diff --git a/arch/arm/mach-s5pv210/mach-torbreck.c b/arch/arm/mach-s5pv210/mach-torbreck.c
> index 579afe8..c131cd2 100644
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
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 7dfba93..2a98613 100644
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
> index 50a3ea0..915e87f 100644
> --- a/arch/arm/plat-samsung/init.c
> +++ b/arch/arm/plat-samsung/init.c
> @@ -63,7 +63,6 @@ void __init s3c_init_cpu(unsigned long idcode,
>  	if (cpu->map_io)
>  		cpu->map_io();
>  }
> -
>  /* s3c24xx_init_clocks
>   *
>   * Initialise the clock subsystem and associated information from the
> @@ -86,7 +85,6 @@ void __init s3c24xx_init_clocks(int xtal)
>  	else
>  		(cpu->init_clocks)(xtal);
>  }
> -
>  /* uart management */
>  #if IS_ENABLED(CONFIG_SAMSUNG_ATAGS)
>  static int nr_uarts __initdata = 0;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

