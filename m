Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab3FLW41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:56:27 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60590 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3FLW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:56:26 -0400
Date: Wed, 12 Jun 2013 15:56:30 -0700
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: mach-moxart: add MOXA ART UART debug files
Message-ID: <20130612225630.GC8146@quad.lixom.net>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
 <1371040448-28742-4-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371040448-28742-4-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 12, 2013 at 02:34:08PM +0200, Jonas Jensen wrote:
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>  arch/arm/Kconfig.debug          |   10 ++++++++++
>  arch/arm/include/debug/moxart.S |   14 ++++++++++++++
>  2 files changed, 24 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/include/debug/moxart.S
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 1d41908..a0e4a32 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -422,6 +422,15 @@ choice
>  		  Say Y here if you want kernel low-level debugging support
>  		  on Allwinner A1X based platforms on the UART1.
>  
> +    config DEBUG_MOXART_UART0
> +        bool "Kernel low-level debugging messages via MOXART UART0"
> +        depends on ARCH_MOXART
> +        help
> +          Say Y here if you want kernel low-level debugging support
> +          on MOXART based platforms on the UART0.
> +          select this to make sure "putc" in arch/arm/boot/compressed/debug.S
> +          uses arch/arm/include/debug/moxart.S:s "addruart" macro

Looks like the last two lines above are leftovers? It's not super-helpful for
someone trying to figure out if they want this option or not; the first two
lines covers that quite nicely.

> +
>  	config DEBUG_TEGRA_UART
>  		depends on ARCH_TEGRA
>  		bool "Use Tegra UART for low-level debug"
> @@ -642,6 +651,7 @@ config DEBUG_LL_INCLUDE
>  	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
>  	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
>  	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
> +	default "debug/moxart.S" if DEBUG_MOXART_UART0
>  	default "debug/tegra.S" if DEBUG_TEGRA_UART
>  	default "debug/ux500.S" if DEBUG_UX500_UART
>  	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \
> diff --git a/arch/arm/include/debug/moxart.S b/arch/arm/include/debug/moxart.S
> new file mode 100644
> index 0000000..01e2aee
> --- /dev/null
> +++ b/arch/arm/include/debug/moxart.S
> @@ -0,0 +1,14 @@
> +/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License,
> + * or (at your option) any later version. */
> +
> +#define MOXART_UART_DEBUG_PHYS_BASE		0x98200000
> +
> +.macro	addruart, rp, rv, tmp
> +	ldr	\rp, =MOXART_UART_DEBUG_PHYS_BASE	@ physical

You need to set rv here too.

-Olof
