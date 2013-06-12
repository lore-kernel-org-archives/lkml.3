Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3FLWmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:42:32 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33322 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3FLWma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:42:30 -0400
Date: Wed, 12 Jun 2013 15:42:35 -0700
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: mach-moxart: add MOXA ART SoC files
Message-ID: <20130612224235.GA8146@quad.lixom.net>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
 <1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This looks pretty good. I have mostly a bunch of nits below.

Please feel free to cc arm@kernel.org (which goes to us arm-soc maintainers) on
future postings.

On Wed, Jun 12, 2013 at 02:34:06PM +0200, Jonas Jensen wrote:
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

You should provide a commit message, ideally with a short introduction of the
platform.

> ---
>  arch/arm/Kconfig                           |    2 +
>  arch/arm/Makefile                          |    1 +
>  arch/arm/configs/moxart_uc7112lx_defconfig |  112 ++++++++++++++++++++++++++++
>  arch/arm/mach-moxart/Kconfig               |   28 +++++++
>  arch/arm/mach-moxart/Makefile              |   10 +++
>  arch/arm/mach-moxart/idle.c                |   21 +++++
>  arch/arm/mach-moxart/moxart.c              |   23 ++++++
>  7 files changed, 197 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/configs/moxart_uc7112lx_defconfig
>  create mode 100644 arch/arm/mach-moxart/Kconfig
>  create mode 100644 arch/arm/mach-moxart/Makefile
>  create mode 100644 arch/arm/mach-moxart/idle.c
>  create mode 100644 arch/arm/mach-moxart/moxart.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 0435a6a..b004ae0 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -937,6 +937,8 @@ source "arch/arm/mach-footbridge/Kconfig"
>  
>  source "arch/arm/mach-gemini/Kconfig"
>  
> +source "arch/arm/mach-moxart/Kconfig"
> +
>  source "arch/arm/mach-highbank/Kconfig"
>  
>  source "arch/arm/mach-integrator/Kconfig"
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 3380c4f..eb8f48e 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -148,6 +148,7 @@ machine-$(CONFIG_ARCH_DOVE)		+= dove
>  machine-$(CONFIG_ARCH_EBSA110)		+= ebsa110
>  machine-$(CONFIG_ARCH_EP93XX)		+= ep93xx
>  machine-$(CONFIG_ARCH_GEMINI)		+= gemini
> +machine-$(CONFIG_ARCH_MOXART)		+= moxart
>  machine-$(CONFIG_ARCH_HIGHBANK)		+= highbank
>  machine-$(CONFIG_ARCH_INTEGRATOR)	+= integrator
>  machine-$(CONFIG_ARCH_IOP13XX)		+= iop13xx
> diff --git a/arch/arm/configs/moxart_uc7112lx_defconfig b/arch/arm/configs/moxart_uc7112lx_defconfig
> new file mode 100644
> index 0000000..8d8f3a4
> --- /dev/null
> +++ b/arch/arm/configs/moxart_uc7112lx_defconfig

It'd be nice to keep the defconfig generic, and make sure to enable all boards
in it -- we're generally OK with adding one defconfig per platform upstream but
not more.

> diff --git a/arch/arm/mach-moxart/Kconfig b/arch/arm/mach-moxart/Kconfig
> new file mode 100644
> index 0000000..633ce74
> --- /dev/null
> +++ b/arch/arm/mach-moxart/Kconfig
> @@ -0,0 +1,28 @@
> +config ARCH_MOXART
> +	bool "MOXA ART SoC" if (ARCH_MULTI_V4)

No parens needed

> +	select CPU_FA526
> +	select ARM_DMA_MEM_BUFFERABLE
> +	select USE_OF
> +	select CLKSRC_OF
> +	select HAVE_CLK
> +	select COMMON_CLK
> +	select GENERIC_IRQ_CHIP
> +	select ARCH_REQUIRE_GPIOLIB
> +	help
> +	  Say Y here if you want to run your kernel on hardware with a MOXA ART SoC.
> +	  This is a Faraday FA526 ARMv4 32-bit 192 MHz processor with MMU and 16KB/8KB D/I-cache (UC-7112-LX)
> +	  This perticular SoC is used on models UC-7101, UC-7112/UC-7110, IA240/IA241, IA3341.

This should probably be line-wrapped so it doesn't get too wide when looking at
the help text.

> +
> +if ARCH_MOXART
> +
> +menu "MOXA ART SoC Implementation"
> +
> +config MACH_UC7112LX
> +	bool "MOXA UC-7112-LX"
> +	depends on ARCH_MOXART

Since the menu is already wrapped with if ARCH_MOXART, you don't need
it here.

> +	help
> +	  Say Y here if you intend to run this kernel on a MOXA UC-7112-LX embedded computer.

Same here w.r.t wrapping

> +
> +endmenu
> +
> +endif
> diff --git a/arch/arm/mach-moxart/Makefile b/arch/arm/mach-moxart/Makefile
> new file mode 100644
> index 0000000..56d8984
> --- /dev/null
> +++ b/arch/arm/mach-moxart/Makefile
> @@ -0,0 +1,10 @@
> +#
> +# Makefile for the linux kernel.
> +#

Stale comment, can just remove it.

> +
> +# Object file lists.
> +
> +obj-y          := idle.o
> +
> +obj-$(CONFIG_MACH_UC7112LX)	+= moxart.o
> +
> diff --git a/arch/arm/mach-moxart/idle.c b/arch/arm/mach-moxart/idle.c
> new file mode 100644
> index 0000000..73ed844
> --- /dev/null
> +++ b/arch/arm/mach-moxart/idle.c
> @@ -0,0 +1,21 @@
> +/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License,
> + * or (at your option) any later version. */

These are sort of non-standard format. While I can't tell you what copyright
text to use (within reason), please format it similarly to how others do,
please.

> +#include <linux/init.h>
> +#include <asm/system.h>
> +#include <asm/proc-fns.h>

arm_pm_idle is defined in <asm/system_misc.h>, so it's a good idea to include
that directly.

> +
> +static void moxart_idle(void)
> +{
> +}
> +
> +static int __init moxart_idle_init(void)
> +{
> +	arm_pm_idle = moxart_idle;
> +	return 0;
> +}
> +
> +arch_initcall(moxart_idle_init);

If you multiplatform enable this, then you need to have a check in
moxart_idle_init() to make sure you're running on a moxart soc. Otherwise this
will still be called and override the arm_pm_idle setting on other platforms as
well.

> diff --git a/arch/arm/mach-moxart/moxart.c b/arch/arm/mach-moxart/moxart.c
> new file mode 100644
> index 0000000..ab70386
> --- /dev/null
> +++ b/arch/arm/mach-moxart/moxart.c
> @@ -0,0 +1,23 @@
> +/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License,
> + * or (at your option) any later version. */

Same here w.r.t. copyright formatting.

> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of_platform.h>
> +#include <linux/clk-provider.h>

I'm guessing some of these will be needed later when you add more code, so it
might not make sense to remove them just for that, but they sure aren't all
needed now. :)

> +
> +#include <asm/mach/arch.h>
> +
> +static const char * const moxart_dt_compat[] = {
> +	"moxa,moxart-uc-7112-lx",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(MOXART, "MOXA UC-7112-LX")
> +	.dt_compat		= moxart_dt_compat,
> +MACHINE_END
> +
> -- 
> 1.7.2.5
> 
