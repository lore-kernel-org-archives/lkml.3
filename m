Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab3I0En3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 00:43:29 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60024 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3I0En2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 00:43:28 -0400
Date: Fri, 27 Sep 2013 13:43:25 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>, Olof Johansson <olof@lixom.net>
Cc: linux-sh@vger.kernel.org, khilman@linaro.org, arnd@arndb.de,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH/RFC] clocksource: Consolidate SH and ARM mach-shmobile
 Kconfig bits
Message-ID: <20130927044323.GC16541@verge.net.au>
References: <20130925233709.16540.66903.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925233709.16540.66903.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 08:37:09AM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Based on request from Olof Johansson, move ARM mach-shmobile
> clocksource entries to drivers/clocksource/Kconfig, and at
> the same time make the SH architecture use these entries.
> 
> Kconfig entries for CMT, MTU2, TMU and STI are with this patch
> now kept in one place. The SH SYS_SUPPORTS_nnn bits are dropped
> to simplye let the user select the appropriate ones using Kconfig
> instead of trying to filter available timers based on SoC.
> 
> Known issues:
>  1) Not yet wrappend in menu/endmenu, populates the root driver menu
>  -> proposal: Create separate patch to wrap all the clocksource entries?

That seems reasonable to me.

>  2) Should the entries be sorted?
>  -> proposal: Ignore cosmetic bits

I propose that you sort the entries are adding
but leave the rest of the entries as is.

>  3) What is correct dependency for multiplatform and single platform?
>  -> proposal: Perhaps we should simply default to no?

I'm not sure that I understand the issue here.

>  4) Is single patch across 2 architectures and drivers/clocksource OK?
>  -> proposal: Keep it like this if possible

Olof, I would like your opinion on this but from my pov this seems
reasonable. Especially as one of the architectures (sh) is seeing very little
change at this time.

> Not-yet-signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  arch/arm/mach-shmobile/Kconfig |   19 --------------
>  arch/sh/Kconfig                |   53 ----------------------------------------
>  drivers/clocksource/Kconfig    |   25 ++++++++++++++++++
>  3 files changed, 25 insertions(+), 72 deletions(-)
> 
> --- 0004/arch/arm/mach-shmobile/Kconfig
> +++ work/arch/arm/mach-shmobile/Kconfig	2013-09-26 07:51:06.000000000 +0900
> @@ -307,25 +307,6 @@ config SHMOBILE_TIMER_HZ
>  	  SH-Mobile systems using a 32768 Hz RCLK for clock events may want
>  	  to select a HZ value such as 128 that can evenly divide RCLK.
>  	  A HZ value that does not divide evenly may cause timer drift.
> -
> -config SH_TIMER_CMT
> -	bool "CMT timer driver"
> -	default y
> -	help
> -	  This enables build of the CMT timer driver.
> -
> -config SH_TIMER_TMU
> -	bool "TMU timer driver"
> -	default y
> -	help
> -	  This enables build of the TMU timer driver.
> -
> -config EM_TIMER_STI
> -	bool "STI timer driver"
> -	default y
> -	help
> -	  This enables build of the STI timer driver.
> -
>  endmenu
>  
>  endif
> --- 0001/arch/sh/Kconfig
> +++ work/arch/sh/Kconfig	2013-09-26 08:00:49.000000000 +0900
> @@ -121,15 +121,6 @@ config SYS_SUPPORTS_NUMA
>  config SYS_SUPPORTS_PCI
>  	bool
>  
> -config SYS_SUPPORTS_CMT
> -	bool
> -
> -config SYS_SUPPORTS_MTU2
> -	bool
> -
> -config SYS_SUPPORTS_TMU
> -	bool
> -
>  config STACKTRACE_SUPPORT
>  	def_bool y
>  
> @@ -189,14 +180,12 @@ config CPU_SH3
>  	bool
>  	select CPU_HAS_INTEVT
>  	select CPU_HAS_SR_RB
> -	select SYS_SUPPORTS_TMU
>  
>  config CPU_SH4
>  	bool
>  	select CPU_HAS_INTEVT
>  	select CPU_HAS_SR_RB
>  	select CPU_HAS_FPU if !CPU_SH4AL_DSP
> -	select SYS_SUPPORTS_TMU
>  	select SYS_SUPPORTS_HUGETLBFS if MMU
>  
>  config CPU_SH4A
> @@ -211,7 +200,6 @@ config CPU_SH4AL_DSP
>  config CPU_SH5
>  	bool
>  	select CPU_HAS_FPU
> -	select SYS_SUPPORTS_TMU
>  	select SYS_SUPPORTS_HUGETLBFS if MMU
>  
>  config CPU_SHX2
> @@ -248,7 +236,6 @@ choice
>  config CPU_SUBTYPE_SH7619
>  	bool "Support SH7619 processor"
>  	select CPU_SH2
> -	select SYS_SUPPORTS_CMT
>  
>  # SH-2A Processor Support
>  
> @@ -256,50 +243,38 @@ config CPU_SUBTYPE_SH7201
>  	bool "Support SH7201 processor"
>  	select CPU_SH2A
>  	select CPU_HAS_FPU
> -	select SYS_SUPPORTS_MTU2
>   
>  config CPU_SUBTYPE_SH7203
>  	bool "Support SH7203 processor"
>  	select CPU_SH2A
>  	select CPU_HAS_FPU
> -	select SYS_SUPPORTS_CMT
> -	select SYS_SUPPORTS_MTU2
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select PINCTRL
>  
>  config CPU_SUBTYPE_SH7206
>  	bool "Support SH7206 processor"
>  	select CPU_SH2A
> -	select SYS_SUPPORTS_CMT
> -	select SYS_SUPPORTS_MTU2
>  
>  config CPU_SUBTYPE_SH7263
>  	bool "Support SH7263 processor"
>  	select CPU_SH2A
>  	select CPU_HAS_FPU
> -	select SYS_SUPPORTS_CMT
> -	select SYS_SUPPORTS_MTU2
>  
>  config CPU_SUBTYPE_SH7264
>  	bool "Support SH7264 processor"
>  	select CPU_SH2A
>  	select CPU_HAS_FPU
> -	select SYS_SUPPORTS_CMT
> -	select SYS_SUPPORTS_MTU2
>  	select PINCTRL
>  
>  config CPU_SUBTYPE_SH7269
>  	bool "Support SH7269 processor"
>  	select CPU_SH2A
>  	select CPU_HAS_FPU
> -	select SYS_SUPPORTS_CMT
> -	select SYS_SUPPORTS_MTU2
>  	select PINCTRL
>  
>  config CPU_SUBTYPE_MXG
>  	bool "Support MX-G processor"
>  	select CPU_SH2A
> -	select SYS_SUPPORTS_MTU2
>  	help
>  	  Select MX-G if running on an R8A03022BG part.
>  
> @@ -352,7 +327,6 @@ config CPU_SUBTYPE_SH7720
>  	bool "Support SH7720 processor"
>  	select CPU_SH3
>  	select CPU_HAS_DSP
> -	select SYS_SUPPORTS_CMT
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select USB_ARCH_HAS_OHCI
>  	select USB_OHCI_SH if USB_OHCI_HCD
> @@ -364,7 +338,6 @@ config CPU_SUBTYPE_SH7721
>  	bool "Support SH7721 processor"
>  	select CPU_SH3
>  	select CPU_HAS_DSP
> -	select SYS_SUPPORTS_CMT
>  	select USB_ARCH_HAS_OHCI
>  	select USB_OHCI_SH if USB_OHCI_HCD
>  	help
> @@ -420,7 +393,6 @@ config CPU_SUBTYPE_SH7723
>  	select CPU_SHX2
>  	select ARCH_SHMOBILE
>  	select ARCH_SPARSEMEM_ENABLE
> -	select SYS_SUPPORTS_CMT
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select PINCTRL
>  	help
> @@ -432,7 +404,6 @@ config CPU_SUBTYPE_SH7724
>  	select CPU_SHX2
>  	select ARCH_SHMOBILE
>  	select ARCH_SPARSEMEM_ENABLE
> -	select SYS_SUPPORTS_CMT
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select PINCTRL
>  	help
> @@ -512,7 +483,6 @@ config CPU_SUBTYPE_SH7343
>  	bool "Support SH7343 processor"
>  	select CPU_SH4AL_DSP
>  	select ARCH_SHMOBILE
> -	select SYS_SUPPORTS_CMT
>  
>  config CPU_SUBTYPE_SH7722
>  	bool "Support SH7722 processor"
> @@ -521,7 +491,6 @@ config CPU_SUBTYPE_SH7722
>  	select ARCH_SHMOBILE
>  	select ARCH_SPARSEMEM_ENABLE
>  	select SYS_SUPPORTS_NUMA
> -	select SYS_SUPPORTS_CMT
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select PINCTRL
>  
> @@ -532,7 +501,6 @@ config CPU_SUBTYPE_SH7366
>  	select ARCH_SHMOBILE
>  	select ARCH_SPARSEMEM_ENABLE
>  	select SYS_SUPPORTS_NUMA
> -	select SYS_SUPPORTS_CMT
>  
>  endchoice
>  
> @@ -565,27 +533,6 @@ source "arch/sh/boards/Kconfig"
>  
>  menu "Timer and clock configuration"
>  
> -config SH_TIMER_TMU
> -	bool "TMU timer driver"
> -	depends on SYS_SUPPORTS_TMU
> -	default y
> -	help
> -	  This enables the build of the TMU timer driver.
> -
> -config SH_TIMER_CMT
> -	bool "CMT timer driver"
> -	depends on SYS_SUPPORTS_CMT
> -	default y
> -	help
> -	  This enables build of the CMT timer driver.
> -
> -config SH_TIMER_MTU2
> -	bool "MTU2 timer driver"
> -	depends on SYS_SUPPORTS_MTU2
> -	default y
> -	help
> -	  This enables build of the MTU2 timer driver.
> -
>  config SH_PCLK_FREQ
>  	int "Peripheral clock frequency (in Hz)"
>  	depends on SH_CLK_CPG_LEGACY
> --- 0001/drivers/clocksource/Kconfig
> +++ work/drivers/clocksource/Kconfig	2013-09-26 07:59:19.000000000 +0900
> @@ -109,3 +109,28 @@ config VF_PIT_TIMER
>  	bool
>  	help
>  	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> +
> +config SH_TIMER_CMT
> +	bool "CMT timer driver"
> +	default y
> +	help
> +	  This enables build of the CMT timer driver.
> +
> +config SH_TIMER_MTU2
> +	bool "MTU2 timer driver"
> +	default y
> +	help
> +	  This enables build of the MTU2 timer driver.
> +
> +config SH_TIMER_TMU
> +	bool "TMU timer driver"
> +	default y
> +	help
> +	  This enables build of the TMU timer driver.
> +
> +config EM_TIMER_STI
> +	bool "STI timer driver"
> +	default y
> +	help
> +	  This enables build of the STI timer driver.
> +
> 
