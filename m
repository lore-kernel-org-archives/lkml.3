Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaFCGNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:13:24 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50329 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaFCGNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:13:23 -0400
MIME-Version: 1.0
In-Reply-To: <1401746847-3193-1-git-send-email-sboyd@codeaurora.org>
References: <1401746847-3193-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 3 Jun 2014 11:43:21 +0530
Message-ID: <CAK5sBcEbLetRcgPuDJ30RqYjLOHhCXChtKE5ep22ZvEPWc9XwA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Remove ARCH_HAS_CPUFREQ config option
From: Sachin Kamat <spk.linux@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 3:37 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> This config exists entirely to hide the cpufreq menu from the
> kernel configuration unless a platform has selected it. Nothing
> is actually built if this config is 'Y' and it just leads to
> more patches that add a select under a platform Kconfig so that
> some other CPUfreq option can be chosen. Let's remove the
> option so that we can always enable CPUfreq drivers on ARM
> platforms.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/Kconfig               | 18 ------------------
>  arch/arm/mach-davinci/Kconfig  |  1 -
>  arch/arm/mach-highbank/Kconfig |  1 -
>  arch/arm/mach-imx/Kconfig      |  3 ---
>  arch/arm/mach-mvebu/Kconfig    |  1 -
>  arch/arm/mach-omap2/Kconfig    |  1 -
>  arch/arm/mach-shmobile/Kconfig |  2 --
>  arch/arm/mach-spear/Kconfig    |  1 -
>  arch/arm/mach-tegra/Kconfig    |  1 -
>  arch/arm/mach-ux500/Kconfig    |  1 -
>  arch/arm/mach-vexpress/Kconfig |  1 -
>  arch/arm/mach-vt8500/Kconfig   |  1 -
>  arch/arm/mach-zynq/Kconfig     |  1 -
>  13 files changed, 33 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 5e91e40c1d22..3fdae40d5114 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -179,13 +179,6 @@ config ARCH_HAS_ILOG2_U32
>  config ARCH_HAS_ILOG2_U64
>         bool
>
> -config ARCH_HAS_CPUFREQ
> -       bool
> -       help
> -         Internal node to signify that the ARCH has CPUFREQ support
> -         and that the relevant menu configurations are displayed for
> -         it.
> -
>  config ARCH_HAS_BANDGAP
>         bool
>
> @@ -321,7 +314,6 @@ config ARCH_MULTIPLATFORM
>
>  config ARCH_INTEGRATOR
>         bool "ARM Ltd. Integrator family"
> -       select ARCH_HAS_CPUFREQ
>         select ARM_AMBA
>         select ARM_PATCH_PHYS_VIRT
>         select AUTO_ZRELADDR
> @@ -540,7 +532,6 @@ config ARCH_DOVE
>
>  config ARCH_KIRKWOOD
>         bool "Marvell Kirkwood"
> -       select ARCH_HAS_CPUFREQ
>         select ARCH_REQUIRE_GPIOLIB
>         select CPU_FEROCEON
>         select GENERIC_CLOCKEVENTS
> @@ -639,7 +630,6 @@ config ARCH_LPC32XX
>  config ARCH_PXA
>         bool "PXA2xx/PXA3xx-based"
>         depends on MMU
> -       select ARCH_HAS_CPUFREQ
>         select ARCH_MTD_XIP
>         select ARCH_REQUIRE_GPIOLIB
>         select ARM_CPU_SUSPEND if PM
> @@ -709,7 +699,6 @@ config ARCH_RPC
>
>  config ARCH_SA1100
>         bool "SA1100-based"
> -       select ARCH_HAS_CPUFREQ
>         select ARCH_MTD_XIP
>         select ARCH_REQUIRE_GPIOLIB
>         select ARCH_SPARSEMEM_ENABLE
> @@ -727,7 +716,6 @@ config ARCH_SA1100
>
>  config ARCH_S3C24XX
>         bool "Samsung S3C24XX SoCs"
> -       select ARCH_HAS_CPUFREQ
>         select ARCH_REQUIRE_GPIOLIB
>         select ATAGS
>         select CLKDEV_LOOKUP
> @@ -748,7 +736,6 @@ config ARCH_S3C24XX
>
>  config ARCH_S3C64XX
>         bool "Samsung S3C64XX"
> -       select ARCH_HAS_CPUFREQ
>         select ARCH_REQUIRE_GPIOLIB
>         select ARM_AMBA
>         select ARM_VIC
> @@ -811,7 +798,6 @@ config ARCH_S5PC100
>
>  config ARCH_S5PV210
>         bool "Samsung S5PV210/S5PC110"
> -       select ARCH_HAS_CPUFREQ
>         select ARCH_HAS_HOLES_MEMORYMODEL
>         select ARCH_SPARSEMEM_ENABLE
>         select ATAGS
> @@ -831,7 +817,6 @@ config ARCH_S5PV210
>
>  config ARCH_EXYNOS
>         bool "Samsung EXYNOS"
> -       select ARCH_HAS_CPUFREQ
>         select ARCH_HAS_HOLES_MEMORYMODEL
>         select ARCH_REQUIRE_GPIOLIB
>         select ARCH_SPARSEMEM_ENABLE

I think this patch is not based on the latest code base as ARCH_EXYNOS
symbol is now defined in arch/arm/mach-exynos/Kconfig file.
