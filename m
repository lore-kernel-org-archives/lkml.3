Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaILKU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:20:57 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:49492 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaILKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:20:53 -0400
MIME-Version: 1.0
In-Reply-To: <1410511111.31130.4.camel@x220>
References: <1406551632.5397.17.camel@x220>
	<1410511111.31130.4.camel@x220>
Date: Fri, 12 Sep 2014 05:20:52 -0500
X-Google-Sender-Auth: acXBLEaBqzQ4-llzrAeBdvYtfXU
Message-ID: <CAGo_u6r3jXX2FS-PO5_-+zhHM3i3pVzGYumSYLh7YPNXGV98eg@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: Remove ARCH_HAS_OPP completely
From: Nishanth Menon <nm@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawn.guo@freescale.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 3:38 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
> 049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
> removed the only dependency that used it. Setting it had no effect
> anymore.
>
> So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
> some reason that commit did not remove all select statements for that
> symbol. These statements are useless. Remove them too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Done on top of next-20140912. Tested with git grep only!
>
>  arch/arm/mach-omap2/Kconfig    | 5 -----

there can be conflict here:
https://patchwork.kernel.org/patch/4857231/

http://marc.info/?l=linux-omap&m=141047815520894&w=2


>  arch/arm/mach-shmobile/Kconfig | 1 -
>  drivers/devfreq/Kconfig        | 1 -
>  3 files changed, 7 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 5b103099626d..f138bd33a463 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -22,7 +22,6 @@ config ARCH_OMAP4
>         bool "TI OMAP4"
>         depends on ARCH_MULTI_V7
>         select ARCH_OMAP2PLUS
> -       select ARCH_HAS_OPP
>         select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
>         select ARM_CPU_SUSPEND if PM
>         select ARM_ERRATA_720789
> @@ -41,7 +40,6 @@ config SOC_OMAP5
>         bool "TI OMAP5"
>         depends on ARCH_MULTI_V7
>         select ARCH_OMAP2PLUS
> -       select ARCH_HAS_OPP
>         select ARM_CPU_SUSPEND if PM
>         select ARM_GIC
>         select HAVE_ARM_SCU if SMP
> @@ -53,14 +51,12 @@ config SOC_AM33XX
>         bool "TI AM33XX"
>         depends on ARCH_MULTI_V7
>         select ARCH_OMAP2PLUS
> -       select ARCH_HAS_OPP
>         select ARM_CPU_SUSPEND if PM
>
>  config SOC_AM43XX
>         bool "TI AM43x"
>         depends on ARCH_MULTI_V7
>         select ARCH_OMAP2PLUS
> -       select ARCH_HAS_OPP
>         select ARM_GIC
>         select MACH_OMAP_GENERIC
>         select MIGHT_HAVE_CACHE_L2X0
> @@ -69,7 +65,6 @@ config SOC_DRA7XX
>         bool "TI DRA7XX"
>         depends on ARCH_MULTI_V7
>         select ARCH_OMAP2PLUS
> -       select ARCH_HAS_OPP
>         select ARM_CPU_SUSPEND if PM
>         select ARM_GIC
>         select HAVE_ARM_ARCH_TIMER
> diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
> index 21f457b56c01..f59019dd986e 100644
> --- a/arch/arm/mach-shmobile/Kconfig
> +++ b/arch/arm/mach-shmobile/Kconfig
> @@ -36,7 +36,6 @@ menuconfig ARCH_SHMOBILE_MULTI
>         select NO_IOPORT_MAP
>         select PINCTRL
>         select ARCH_REQUIRE_GPIOLIB
> -       select ARCH_HAS_OPP
>
>  if ARCH_SHMOBILE_MULTI
>
> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> index 3dced0a9eae3..2227e9bf3884 100644
> --- a/drivers/devfreq/Kconfig
> +++ b/drivers/devfreq/Kconfig
> @@ -80,7 +80,6 @@ config ARM_EXYNOS4_BUS_DEVFREQ
>  config ARM_EXYNOS5_BUS_DEVFREQ
>         bool "ARM Exynos5250 Bus DEVFREQ Driver"
>         depends on SOC_EXYNOS5250
> -       select ARCH_HAS_OPP
>         select DEVFREQ_GOV_SIMPLE_ONDEMAND
>         select PM_OPP
>         help
> --
> 1.9.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Regards,
Nishanth Menon
