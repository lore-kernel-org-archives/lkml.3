Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3H2PFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:05:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48168 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3H2PFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:05:52 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-22-521f634e7746
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, mturquette@linaro.org, tomasz.figa@gmail.com,
        yadi.brar@samsung.com, dianders@chromium.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, thomas.abraham@linaro.org,
        s.nawrocki@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [RFC 3/3] ARM: s5pc100: Migrate clock handling to Common Clock
 Framework
Date: Thu, 29 Aug 2013 17:05:45 +0200
Message-id: <1406622.PIapD4Dc4U@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377707357-4902-4-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377707357-4902-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377707357-4902-4-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t/xy7p+yfJBBos3cFhMWneAyWL+kXOs
	FmeXHWSzeNPbwWLRu+Aqm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCxuX+a1OL3mFLPF0usXmSye
	TrjIZjFh+loWi3Uvp7NYHH7Tzmrx6mAbi8WxGUsYLVbt+sNoMWf6OyYHEY8189YwerQ097B5
	zG64yOLxevIERo+/q14we+ycdZfd49Xqmawed67tYfPYvKTe4+C7PUwefVtWMXp83iTnsXFu
	aABvFJdNSmpOZllqkb5dAlfGnouP2QoOy1R0Lz7L3sD4XqyLkZNDQsBE4nHvI0YIW0ziwr31
	bF2MXBxCAksZJR5uusYO4XQxSfw+/Y0dpIpNQE3ic8MjNhBbRMBU4t3da2AdzAKvmCWWLZ0P
	lhAWCJdoWHSFGcRmEVCVWP6vnwnE5hXQlNh18SrYIH4BdYl3254CxTk4RAVcJPr+ZoKEOQX8
	JOb9usoCsXgio8SZ9x+gegUlfky+xwJiMwvIS+zbP5UVwtaSWL/zONMERsFZSMpmISmbhaRs
	ASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQaP66g3HpMatDjAIcjEo8vB2B8kFCrIll
	xZW5hxglOJiVRHjfcgKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MN5673b867cqTrl/z+56NEf+
	Wj370At7KwE970Ulqq0L/u7ZZVr8jleMU2KtpYLQjeOVWoWuC279SP04Ucf23AHpras/Skxf
	uGjjU8mmJcuMAoRnnwkSPH/HNujWVtewhOxG29xd6k2+M95+u6EUZryq5PsccT/OK+EHqtq0
	7SeL/fW6+3JR+0olluKMREMt5qLiRAAJn1tKxAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 of August 2013 18:29:17 Mateusz Krawczuk wrote:
> This patch migrates the s5pc100 platform to use new clock driver
> using Common Clock Framework.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  arch/arm/mach-s5pc100/Kconfig         |  8 ++++++++
>  arch/arm/mach-s5pc100/Makefile        |  4 ++--
>  arch/arm/mach-s5pc100/common.c        | 23 ++++++++++++++++++++++-
>  arch/arm/mach-s5pc100/common.h        | 13 +++++++++++++
>  arch/arm/mach-s5pc100/mach-smdkc100.c |  3 ++-
>  arch/arm/plat-samsung/Kconfig         |  2 +-
>  6 files changed, 48 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-s5pc100/Kconfig
> b/arch/arm/mach-s5pc100/Kconfig index 15170be..ed50897 100644
> --- a/arch/arm/mach-s5pc100/Kconfig
> +++ b/arch/arm/mach-s5pc100/Kconfig
> @@ -11,6 +11,7 @@ config CPU_S5PC100
>  	bool
>  	select S5P_EXT_INT
>  	select SAMSUNG_DMADEV
> +	select S5P_CLOCK if !COMMON_CLK_S5PC100
>  	help
>  	  Enable S5PC100 CPU support
> 
> @@ -50,6 +51,13 @@ config S5PC100_SETUP_SPI
>  	help
>  	  Common setup code for SPI GPIO configurations.
> 
> +config COMMON_CLK_S5PC100
> +	bool "Common Clock Framework support"
> +	default y
> +	select COMMON_CLK
> +	help
> +	  Common setup code for common clock framework.
> +
>  config MACH_SMDKC100
>  	bool "SMDKC100"
>  	select CPU_S5PC100
> diff --git a/arch/arm/mach-s5pc100/Makefile
> b/arch/arm/mach-s5pc100/Makefile index 118c711..74b90ec 100644
> --- a/arch/arm/mach-s5pc100/Makefile
> +++ b/arch/arm/mach-s5pc100/Makefile
> @@ -11,8 +11,8 @@ obj-				:=
> 
>  # Core
> 
> -obj-y				+= common.o clock.o
> -
> +obj-y				+= common.o
> +obj-$(CONFIG_S5P_CLOCK)	+= clock.o
>  obj-y				+= dma.o
> 
>  # machine support
> diff --git a/arch/arm/mach-s5pc100/common.c
> b/arch/arm/mach-s5pc100/common.c index c5a8eea..d8db7b2 100644
> --- a/arch/arm/mach-s5pc100/common.c
> +++ b/arch/arm/mach-s5pc100/common.c
> @@ -40,7 +40,13 @@
> 
>  #include <plat/cpu.h>
>  #include <plat/devs.h>
> +
> +#ifdef CONFIG_S5P_CLOCK
>  #include <plat/clock.h>
> +#else
> +#include <linux/clk-provider.h>
> +#endif
> +
>  #include <plat/sdhci.h>
>  #include <plat/adc-core.h>
>  #include <plat/ata-core.h>
> @@ -54,6 +60,18 @@
> 
>  #include "common.h"
> 
> +static unsigned long xxti_f, xusbxti_f;
> +
> +void __init s5pc100_set_xxti_freq(unsigned long freq)
> +{
> +	xxti_f = freq;
> +}
> +
> +void __init s5pc100_set_xusbxti_freq(unsigned long freq)
> +{
> +	xusbxti_f = freq;
> +}
> +

You might consolidate the two functions above into one - 
s5pc100_init_external_clocks() taking two arguments.

>  static const char name_s5pc100[] = "S5PC100";
> 
>  static struct cpu_table cpu_ids[] __initdata = {
> @@ -201,13 +219,14 @@ void __init s5pc100_map_io(void)
> 
>  void __init s5pc100_init_clocks(int xtal)
>  {
> +#ifdef CONFIG_S5P_CLOCK
>  	printk(KERN_DEBUG "%s: initializing clocks\n", __func__);
> 
>  	s3c24xx_register_baseclocks(xtal);
>  	s5p_register_clocks(xtal);
>  	s5pc100_register_clocks();
>  	s5pc100_setup_clocks();
> -	samsung_wdt_reset_init(S3C_VA_WATCHDOG);
> +#endif
>  }
> 
>  void __init s5pc100_init_irq(void)
> @@ -216,6 +235,8 @@ void __init s5pc100_init_irq(void)
> 
>  	/* VIC0, VIC1, and VIC2 are fully populated. */
>  	s5p_init_irq(vic, ARRAY_SIZE(vic));
> +	s5pc100_clk_init(NULL, xxti_f, xusbxti_f, S3C_VA_SYS);
> +	samsung_wdt_reset_init(S3C_VA_WATCHDOG);

This change (moving WDT reset initialization) should be noted in patch 
description, along with the reason to do so.

Best regards,
Tomasz

