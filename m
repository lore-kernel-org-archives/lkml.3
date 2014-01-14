Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaANViC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:38:02 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:54646 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaANVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:37:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140113060102.GO23525@S2101-09.ap.freescale.net>
References: <1389321592-33220-1-git-send-email-john.tobias.ph@gmail.com>
	<20140113032043.GF23525@S2101-09.ap.freescale.net>
	<CACUGKYMx_o6TLsvMxK3Gb+cmOUCX3Toj+6MeJmo=ahfyc=vXCA@mail.gmail.com>
	<20140113060102.GO23525@S2101-09.ap.freescale.net>
Date: Tue, 14 Jan 2014 13:37:57 -0800
Message-ID: <CACUGKYMT1FHjpP+Yx7wKo5SXGGm3C3R6Z4tag0J1bczyg9Z8mQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: imx: add select on ARCH_MXC for cpufreq support
From: John Tobias <john.tobias.ph@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: rjw@rjwysocki.net, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<kernel@pengutronix.de>" <kernel@pengutronix.de>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a mistake. The HAVE_IMX_ANATOP doesn't require to move up. It
should be ARCH_HAS_OPP.



On Sun, Jan 12, 2014 at 10:01 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Sun, Jan 12, 2014 at 08:54:18PM -0800, John Tobias wrote:
>> I tested leaving the HAVE_IMX_ANATOP under SOC_IMX6Q and SOC_IMX6SL.
>> The iMX6Q cpufreq driver won't show up in menu config / gconfig and
>> that's the reason why I added it.
>
> I tested the following changes against my for-next branch, and I can see
> iMX6Q cpufreq driver in menuconfig.  Note, the
> drivers/cpufreq/Kconfig.arm change is on cpufreq tree, so I have to make
> the change locally for the testing.
>
> Shawn
>
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 1e70150..7071468 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -1,5 +1,7 @@
>  config ARCH_MXC
>         bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 ||
> ARCH_MULTI_V6_V7
> +       select ARCH_HAS_CPUFREQ
> +       select ARCH_HAS_OPP
>         select ARCH_REQUIRE_GPIOLIB
>         select ARM_CPU_SUSPEND if PM
>         select ARM_PATCH_PHYS_VIRT
> @@ -12,6 +14,7 @@ config ARCH_MXC
>         select MIGHT_HAVE_CACHE_L2X0 if ARCH_MULTI_V6_V7
>         select MULTI_IRQ_HANDLER
>         select PINCTRL
> +       select PM_OPP if PM
>         select SOC_BUS
>         select SPARSE_IRQ
>         select USE_OF
> @@ -787,8 +790,6 @@ config      SOC_IMX53
>
>  config SOC_IMX6Q
>         bool "i.MX6 Quad/DualLite support"
> -       select ARCH_HAS_CPUFREQ
> -       select ARCH_HAS_OPP
>         select ARM_ERRATA_754322
>         select ARM_ERRATA_764369 if SMP
>         select ARM_ERRATA_775420
> @@ -808,7 +809,6 @@ config SOC_IMX6Q
>         select PL310_ERRATA_588369 if CACHE_PL310
>         select PL310_ERRATA_727915 if CACHE_PL310
>         select PL310_ERRATA_769419 if CACHE_PL310
> -       select PM_OPP if PM
>
>         help
>           This enables support for Freescale i.MX6 Quad processor.
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index ce52ed9..21e069e 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -80,7 +80,7 @@ config ARM_HIGHBANK_CPUFREQ
>
>  config ARM_IMX6Q_CPUFREQ
>         tristate "Freescale i.MX6Q cpufreq support"
> -       depends on SOC_IMX6Q
> +       depends on ARCH_MXC
>         depends on REGULATOR_ANATOP
>         help
>           This adds cpufreq driver support for Freescale i.MX6Q SOC.
>
>
