Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbbASVmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:42:23 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28402 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293AbbASVmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:42:21 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187qwZ2fMphbQwvhiUYP8Rs
Date: Mon, 19 Jan 2015 13:38:46 -0800
From: Tony Lindgren <tony@atomide.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-omap@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.19-rc2 v15 5/8] arm: omap1: Migrate debug_ll macros to
 use 8250.S
Message-ID: <20150119213845.GL18552@atomide.com>
References: <1420461624-4410-1-git-send-email-daniel.thompson@linaro.org>
 <1420461624-4410-6-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420461624-4410-6-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Thompson <daniel.thompson@linaro.org> [150105 04:49]:
> The omap1's debug-macro.S is similar to the generic 8250 code. Compared to
> the 8520 code the omap1 macro automatically determines what UART to use
> based on breadcrumbs left by the bootloader and automatically copes with
> the eccentric register layout on OMAP7XX.
> 
> This patch drops both these features and relies instead on the generic
> 8250 macros:
> 
> 1. Dropping support for the bootloader breadcrumbs is identical to the
>    way the migration was handled for OMAP2 (see 808b7e07464d...).
> 
> 2. Support for OMAP7XX still exists but it must be configured by hand
>    (DEBUG_OMAP7XXUART1/2/3) rather than handled at runtime.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: linux-omap@vger.kernel.org
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Acked-by: Tony Lindgren <tony@atomide.com>

Daniel, I suggest you upload this patch into Russell's patch tracking
system to get it merged. That at least shrinks down your patch series
if the other patches need more work.

Regards,

Tony

> ---
>  arch/arm/Kconfig.debug                         |  57 +++++++++++++-
>  arch/arm/mach-omap1/include/mach/debug-macro.S | 101 -------------------------
>  2 files changed, 56 insertions(+), 102 deletions(-)
>  delete mode 100644 arch/arm/mach-omap1/include/mach/debug-macro.S
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index eba36e35bad2..ec25d746b4dd 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -527,6 +527,30 @@ choice
>  		  Say Y here if you want kernel low-level debugging support
>  		  on TI-NSPIRE CX models.
>  
> +	config DEBUG_OMAP1UART1
> +		bool "Kernel low-level debugging via OMAP1 UART1"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (except OMAP730) on the UART1.
> +
> +	config DEBUG_OMAP1UART2
> +		bool "Kernel low-level debugging via OMAP1 UART2"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (except OMAP730) on the UART2.
> +
> +	config DEBUG_OMAP1UART3
> +		bool "Kernel low-level debugging via OMAP1 UART3"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (except OMAP730) on the UART3.
> +
>  	config DEBUG_OMAP2UART1
>  		bool "OMAP2/3/4 UART1 (omap2/3 sdp boards and some omap3 boards)"
>  		depends on ARCH_OMAP2PLUS
> @@ -569,6 +593,30 @@ choice
>  		depends on ARCH_OMAP2PLUS
>  		select DEBUG_OMAP2PLUS_UART
>  
> +	config DEBUG_OMAP7XXUART1
> +		bool "Kernel low-level debugging via OMAP730 UART1"
> +		depends on ARCH_OMAP730
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP730 based platforms on the UART1.
> +
> +	config DEBUG_OMAP7XXUART2
> +		bool "Kernel low-level debugging via OMAP730 UART2"
> +		depends on ARCH_OMAP730
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP730 based platforms on the UART2.
> +
> +	config DEBUG_OMAP7XXUART3
> +		bool "Kernel low-level debugging via OMAP730 UART3"
> +		depends on ARCH_OMAP730
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP730 based platforms on the UART3.
> +
>  	config DEBUG_TI81XXUART1
>  		bool "Kernel low-level debugging messages via TI81XX UART1 (ti8148evm)"
>  		depends on ARCH_OMAP2PLUS
> @@ -1308,6 +1356,9 @@ config DEBUG_UART_PHYS
>  	default 0xffe40000 if DEBUG_RCAR_GEN1_SCIF0
>  	default 0xffe42000 if DEBUG_RCAR_GEN1_SCIF2
>  	default 0xfff36000 if DEBUG_HIGHBANK_UART
> +	default 0xfffb0000 if DEBUG_OMAP1UART1 || DEBUG_OMAP7XXUART1
> +	default 0xfffb0800 if DEBUG_OMAP1UART2 || DEBUG_OMAP7XXUART2
> +	default 0xfffb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
>  	default 0xfffe8600 if DEBUG_UART_BCM63XX
>  	default 0xfffff700 if ARCH_IOP33X
>  	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
> @@ -1390,6 +1441,9 @@ config DEBUG_UART_VIRT
>  	default 0xfef00000 if ARCH_IXP4XX && !CPU_BIG_ENDIAN
>  	default 0xfef00003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
>  	default 0xfef36000 if DEBUG_HIGHBANK_UART
> +	default 0xfefb0000 if DEBUG_OMAP1UART1 || DEBUG_OMAP7XXUART1
> +	default 0xfefb0800 if DEBUG_OMAP1UART2 || DEBUG_OMAP7XXUART2
> +	default 0xfefb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
>  	default 0xfefff700 if ARCH_IOP33X
>  	default 0xff003000 if DEBUG_U300_UART
>  	default DEBUG_UART_PHYS if !MMU
> @@ -1401,7 +1455,8 @@ config DEBUG_UART_VIRT
>  config DEBUG_UART_8250_SHIFT
>  	int "Register offset shift for the 8250 debug UART"
>  	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
> -	default 0 if FOOTBRIDGE || ARCH_IOP32X || DEBUG_BCM_5301X
> +	default 0 if FOOTBRIDGE || ARCH_IOP32X || DEBUG_BCM_5301X || \
> +		DEBUG_OMAP7XXUART1 || DEBUG_OMAP7XXUART2 || DEBUG_OMAP7XXUART3
>  	default 2
>  
>  config DEBUG_UART_8250_WORD
> diff --git a/arch/arm/mach-omap1/include/mach/debug-macro.S b/arch/arm/mach-omap1/include/mach/debug-macro.S
> deleted file mode 100644
> index 5c1a26c9f490..000000000000
> --- a/arch/arm/mach-omap1/include/mach/debug-macro.S
> +++ /dev/null
> @@ -1,101 +0,0 @@
> -/* arch/arm/mach-omap1/include/mach/debug-macro.S
> - *
> - * Debugging macro include header
> - *
> - *  Copyright (C) 1994-1999 Russell King
> - *  Moved from linux/arch/arm/kernel/debug.S by Ben Dooks
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
> -*/
> -
> -#include <linux/serial_reg.h>
> -
> -#include "serial.h"
> -
> -		.pushsection .data
> -omap_uart_phys:	.word	0x0
> -omap_uart_virt:	.word	0x0
> -		.popsection
> -
> -		/*
> -		 * Note that this code won't work if the bootloader passes
> -		 * a wrong machine ID number in r1. To debug, just hardcode
> -		 * the desired UART phys and virt addresses temporarily into
> -		 * the omap_uart_phys and omap_uart_virt above.
> -		 */
> -		.macro	addruart, rp, rv, tmp
> -
> -		/* Use omap_uart_phys/virt if already configured */
> -9:		adr	\rp, 99f		@ get effective addr of 99f
> -		ldr	\rv, [\rp]		@ get absolute addr of 99f
> -		sub	\rv, \rv, \rp		@ offset between the two
> -		ldr	\rp, [\rp, #4]		@ abs addr of omap_uart_phys
> -		sub	\tmp, \rp, \rv		@ make it effective
> -		ldr	\rp, [\tmp, #0]		@ omap_uart_phys
> -		ldr	\rv, [\tmp, #4]		@ omap_uart_virt
> -		cmp	\rp, #0			@ is port configured?
> -		cmpne	\rv, #0
> -		bne	100f			@ already configured
> -
> -		/* Check the debug UART configuration set in uncompress.h */
> -		and	\rp, pc, #0xff000000
> -		ldr	\rv, =OMAP_UART_INFO_OFS
> -		ldr	\rp, [\rp, \rv]
> -
> -		/* Select the UART to use based on the UART1 scratchpad value */
> -10:		cmp	\rp, #0			@ no port configured?
> -		beq	11f			@ if none, try to use UART1
> -		cmp	\rp, #OMAP1UART1
> -		beq	11f			@ configure OMAP1UART1
> -		cmp	\rp, #OMAP1UART2
> -		beq	12f			@ configure OMAP1UART2
> -		cmp	\rp, #OMAP1UART3
> -		beq	13f			@ configure OMAP2UART3
> -
> -		/* Configure the UART offset from the phys/virt base */
> -11:		mov	\rp, #0x00fb0000	@ OMAP1UART1
> -		b	98f
> -12:		mov	\rp, #0x00fb0000	@ OMAP1UART1
> -		orr	\rp, \rp, #0x00000800	@ OMAP1UART2
> -		b	98f
> -13:		mov	\rp, #0x00fb0000	@ OMAP1UART1
> -		orr	\rp, \rp, #0x00000800	@ OMAP1UART2
> -		orr	\rp, \rp, #0x00009000	@ OMAP1UART3
> -
> -		/* Store both phys and virt address for the uart */
> -98:		add	\rp, \rp, #0xff000000	@ phys base
> -		str	\rp, [\tmp, #0]		@ omap_uart_phys
> -		sub	\rp, \rp, #0xff000000	@ phys base
> -		add	\rp, \rp, #0xfe000000	@ virt base
> -		str	\rp, [\tmp, #4]		@ omap_uart_virt
> -		b	9b
> -
> -		.align
> -99:		.word	.
> -		.word	omap_uart_phys
> -		.ltorg
> -
> -100:
> -		.endm
> -
> -		.macro	senduart,rd,rx
> -		strb	\rd, [\rx]
> -		.endm
> -
> -		.macro	busyuart,rd,rx
> -1001:		ldrb	\rd, [\rx, #(UART_LSR << OMAP_PORT_SHIFT)]
> -		and	\rd, \rd, #(UART_LSR_TEMT | UART_LSR_THRE)
> -		teq	\rd, #(UART_LSR_TEMT | UART_LSR_THRE)
> -		beq	1002f
> -		ldrb	\rd, [\rx, #(UART_LSR << OMAP7XX_PORT_SHIFT)]
> -		and	\rd, \rd, #(UART_LSR_TEMT | UART_LSR_THRE)
> -		teq	\rd, #(UART_LSR_TEMT | UART_LSR_THRE)
> -		bne	1001b
> -1002:
> -		.endm
> -
> -		.macro	waituart,rd,rx
> -		.endm
> -- 
> 1.9.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
