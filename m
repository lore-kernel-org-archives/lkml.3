Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3GHLbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:31:14 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:39728 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3GHLbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:31:12 -0400
MIME-Version: 1.0
X-Originating-IP: [193.120.41.118]
In-Reply-To: <1373041417-217728-5-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
	<1373041417-217728-5-git-send-email-arnd@arndb.de>
Date: Mon, 8 Jul 2013 04:31:12 -0700
Message-ID: <CAOesGMg2f2iRuanVkDOR6m459oQou6J8oJC3Enm_rrS2WMM3hA@mail.gmail.com>
Subject: Re: [PATCH 4/8] ARM: OMAP: build mach-omap code only if needed
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@infradead.org, "arm@kernel.org" <arm@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think this broke multi_v7_defconfig in last night's linux-next, due
to TI_PRIV_EDMA no longer being selected. Looks like you missed it
when moving the options around:

On Fri, Jul 5, 2013 at 9:23 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 1f8127a..5c14051 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -1,62 +1,10 @@
>  config ARCH_OMAP
>         bool
>
> -config ARCH_OMAP2PLUS
> -       bool "TI OMAP2/3/4/5 SoCs with device tree support" if (ARCH_MULTI_V6 || ARCH_MULTI_V7)
> -       select ARCH_HAS_CPUFREQ
> -       select ARCH_HAS_HOLES_MEMORYMODEL
> -       select ARCH_OMAP
> -       select ARCH_REQUIRE_GPIOLIB
> -       select CLKDEV_LOOKUP
> -       select CLKSRC_MMIO
> -       select GENERIC_CLOCKEVENTS
> -       select GENERIC_IRQ_CHIP
> -       select HAVE_CLK
> -       select OMAP_DM_TIMER
> -       select PINCTRL
> -       select PROC_DEVICETREE if PROC_FS
> -       select SOC_BUS
> -       select SPARSE_IRQ
> -       select TI_PRIV_EDMA
> -       select USE_OF
> -       help
> -         Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
[...]
> +config ARCH_OMAP2PLUS
> +       bool
> +       select ARCH_HAS_BANDGAP
> +       select ARCH_HAS_CPUFREQ
> +       select ARCH_HAS_HOLES_MEMORYMODEL
> +       select ARCH_OMAP
> +       select ARCH_REQUIRE_GPIOLIB
> +       select CLKDEV_LOOKUP
> +       select CLKSRC_MMIO
> +       select GENERIC_CLOCKEVENTS
> +       select GENERIC_IRQ_CHIP
> +       select HAVE_CLK
> +       select OMAP_DM_TIMER
> +       select PINCTRL
> +       select PROC_DEVICETREE if PROC_FS
> +       select SOC_BUS
> +       select SPARSE_IRQ
> +       select USE_OF
> +       help
> +         Systems based on OMAP2, OMAP3, OMAP4 or OMAP5


-Olof
