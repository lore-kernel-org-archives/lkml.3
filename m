Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834AbaGYTqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:46:08 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:33171 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868AbaGYTqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:46:06 -0400
Date: Fri, 25 Jul 2014 22:45:54 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH CFT v2] arm: omap1: Migrate debug_ll macros to use 8250.S
Message-ID: <20140725194554.GB5336@drone.musicnaut.iki.fi>
References: <20140717171250.GC16324@ambient.musicnaut.iki.fi>
 <1405694642-25024-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405694642-25024-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 18, 2014 at 03:44:02PM +0100, Daniel Thompson wrote:
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

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

I tested this on OMAP1510. The generic code works, though there will be
some more work for the user. Maybe that's acceptable if we want to get
rid of the asm file, since the use case is rare.

The patch still has couple typos, see comments below.

> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: linux-omap@vger.kernel.org
> ---
> 
> Notes:
>     Changes since v1:
>     
>     * Removed !ARCH_OMAP7XX from the DEBUG_OMAP1UART1/2/3 options
>       (thanks to Aaro Koskinen)
> 
>  arch/arm/Kconfig.debug                         |  57 +++++++++++++-
>  arch/arm/mach-omap1/include/mach/debug-macro.S | 101 -------------------------
>  2 files changed, 56 insertions(+), 102 deletions(-)
>  delete mode 100644 arch/arm/mach-omap1/include/mach/debug-macro.S
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 6f9664a..762b3ed 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -463,6 +463,30 @@ choice
>  		  Say Y here if you want kernel low-level debugging support
>  		  on TI-NSPIRE CX models.
>  
> +	config DEBUG_OMAP1UART1
> +		bool "Kernel low-level debugging via OMAP1 UART1"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (expect OMAP730) on the UART1.
                                            ^^^^^^

                       This should be "except", also repeated below for
                       ports 2-3.

> +	config DEBUG_OMAP1UART2
> +		bool "Kernel low-level debugging via OMAP1 UART2"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (expect OMAP730) on the UART2.
> +
> +	config DEBUG_OMAP1UART3
> +		bool "Kernel low-level debugging via OMAP1 UART3"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (expect OMAP730) on the UART3.

A.
