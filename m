Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3GBLx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:53:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49405 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751085Ab3GBLxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:53:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187ixiKoMkUfsFJY/nu9fvSPcVX71s0MlY=
Date: Tue, 2 Jul 2013 07:53:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] ARM: kirkwood: convert to DT irqchip and
 clocksource
Message-ID: <20130702115311.GG19937@titan.lakedaemon.net>
References: <1372763023-12374-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1372763023-12374-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372763023-12374-6-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 01:03:41PM +0200, Sebastian Hesselbarth wrote:
> With recent support for true irqchip and clocksource drivers for Orion
> SoCs, now make use of it on DT enabled Kirkwood boards.
> 
> This also introduces a new Kconfig option for legacy (non-DT) Kirkwood
> where old code is moved out to and polishes DT board file a little bit.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> --- 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/Kconfig    |   22 ++++++++++++++++++++++
>  arch/arm/mach-kirkwood/Makefile   |    4 ++--
>  arch/arm/mach-kirkwood/board-dt.c |   24 +++++++++++++++++-------
>  3 files changed, 41 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
> index 493c71a..ede131e 100644
> --- a/arch/arm/mach-kirkwood/Kconfig
> +++ b/arch/arm/mach-kirkwood/Kconfig
> @@ -2,67 +2,81 @@ if ARCH_KIRKWOOD
>  
>  menu "Marvell Kirkwood Implementations"
>  
> +config KIRKWOOD_LEGACY
> +	bool
> +
>  config MACH_D2NET_V2
>  	bool "LaCie d2 Network v2 NAS Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  LaCie d2 Network v2 NAS.
>  
>  config MACH_DOCKSTAR
>  	bool "Seagate FreeAgent DockStar"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  Seagate FreeAgent DockStar.
>  
>  config MACH_ESATA_SHEEVAPLUG
>  	bool "Marvell eSATA SheevaPlug Reference Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  Marvell eSATA SheevaPlug Reference Board.
>  
>  config MACH_GURUPLUG
>  	bool "Marvell GuruPlug Reference Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  Marvell GuruPlug Reference Board.
>  
>  config MACH_INETSPACE_V2
>  	bool "LaCie Internet Space v2 NAS Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  LaCie Internet Space v2 NAS.
>  
>  config MACH_MV88F6281GTW_GE
>  	bool "Marvell 88F6281 GTW GE Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  Marvell 88F6281 GTW GE Board.
>  
>  config MACH_NET2BIG_V2
>  	bool "LaCie 2Big Network v2 NAS Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  LaCie 2Big Network v2 NAS.
>  
>  config MACH_NET5BIG_V2
>  	bool "LaCie 5Big Network v2 NAS Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  LaCie 5Big Network v2 NAS.
>  
>  config MACH_NETSPACE_MAX_V2
>  	bool "LaCie Network Space Max v2 NAS Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  LaCie Network Space Max v2 NAS.
>  
>  config MACH_NETSPACE_V2
>  	bool "LaCie Network Space v2 NAS Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  LaCie Network Space v2 NAS.
>  
>  config MACH_OPENRD
> +	select KIRKWOOD_LEGACY
>          bool
>  
>  config MACH_OPENRD_BASE
> @@ -88,30 +102,35 @@ config MACH_OPENRD_ULTIMATE
>  
>  config MACH_RD88F6192_NAS
>  	bool "Marvell RD-88F6192-NAS Reference Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  Marvell RD-88F6192-NAS Reference Board.
>  
>  config MACH_RD88F6281
>  	bool "Marvell RD-88F6281 Reference Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  Marvell RD-88F6281 Reference Board.
>  
>  config MACH_SHEEVAPLUG
>  	bool "Marvell SheevaPlug Reference Board"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  Marvell SheevaPlug Reference Board.
>  
>  config MACH_T5325
>  	bool "HP t5325 Thin Client"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  HP t5325 Thin Client.
>  
>  config MACH_TS219
>  	bool "QNAP TS-110, TS-119, TS-119P+, TS-210, TS-219, TS-219P and TS-219P+ Turbo NAS"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  QNAP TS-110, TS-119, TS-119P+, TS-210, TS-219, TS-219P and
> @@ -119,6 +138,7 @@ config MACH_TS219
>  
>  config MACH_TS41X
>  	bool "QNAP TS-410, TS-410U, TS-419P, TS-419P+ and TS-419U Turbo NAS"
> +	select KIRKWOOD_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  QNAP TS-410, TS-410U, TS-419P, TS-419P+ and TS-419U Turbo
> @@ -129,6 +149,8 @@ comment "Device tree entries"
>  config ARCH_KIRKWOOD_DT
>  	bool "Marvell Kirkwood Flattened Device Tree"
>  	select KIRKWOOD_CLK
> +	select ORION_IRQCHIP
> +	select ORION_TIMER
>  	select POWER_SUPPLY
>  	select POWER_RESET
>  	select POWER_RESET_GPIO
> diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
> index 062f8c7..f78f333 100644
> --- a/arch/arm/mach-kirkwood/Makefile
> +++ b/arch/arm/mach-kirkwood/Makefile
> @@ -1,5 +1,5 @@
> -obj-y				+= common.o irq.o pcie.o mpp.o
> -
> +obj-y				+= common.o pcie.o
> +obj-$(CONFIG_KIRKWOOD_LEGACY)	+= irq.o mpp.o
>  obj-$(CONFIG_MACH_D2NET_V2)		+= d2net_v2-setup.o lacie_v2-common.o
>  obj-$(CONFIG_MACH_DOCKSTAR)		+= dockstar-setup.o
>  obj-$(CONFIG_MACH_ESATA_SHEEVAPLUG)	+= sheevaplug-setup.o
> diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
> index 881f37e..385244c 100644
> --- a/arch/arm/mach-kirkwood/board-dt.c
> +++ b/arch/arm/mach-kirkwood/board-dt.c
> @@ -15,6 +15,9 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/clk-provider.h>
> +#include <linux/clocksource.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/irqchip.h>
>  #include <linux/kexec.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> @@ -67,10 +70,18 @@ static void __init kirkwood_legacy_clk_init(void)
>  	clk_prepare_enable(clk);
>  }
>  
> -static void __init kirkwood_of_clk_init(void)
> +static void __init kirkwood_dt_time_init(void)
>  {
>  	of_clk_init(NULL);
> -	kirkwood_legacy_clk_init();
> +	clocksource_of_init();
> +}
> +
> +static void __init kirkwood_dt_init_early(void)
> +{


> +	init_dma_coherent_pool_size(SZ_1M);

This shouldn't be needed any more.  Is there a reason you're adding it
back in?

thx,

Jason.

> +	mvebu_mbus_init("marvell,kirkwood-mbus",
> +			BRIDGE_WINS_BASE, BRIDGE_WINS_SZ,
> +			DDR_WINDOW_CPU_BASE, DDR_WINDOW_CPU_SZ);
>  }
>  
>  static void __init kirkwood_dt_init(void)
> @@ -91,8 +102,8 @@ static void __init kirkwood_dt_init(void)
>  
>  	kirkwood_cpufreq_init();
>  
> -	/* Setup root of clk tree */
> -	kirkwood_of_clk_init();
> +	/* Setup clocks for legacy devices */
> +	kirkwood_legacy_clk_init();
>  
>  	kirkwood_cpuidle_init();
>  
> @@ -114,9 +125,8 @@ static const char * const kirkwood_dt_board_compat[] = {
>  DT_MACHINE_START(KIRKWOOD_DT, "Marvell Kirkwood (Flattened Device Tree)")
>  	/* Maintainer: Jason Cooper <jason@lakedaemon.net> */
>  	.map_io		= kirkwood_map_io,
> -	.init_early	= kirkwood_init_early,
> -	.init_irq	= orion_dt_init_irq,
> -	.init_time	= kirkwood_timer_init,
> +	.init_early	= kirkwood_dt_init_early,
> +	.init_time	= kirkwood_dt_time_init,
>  	.init_machine	= kirkwood_dt_init,
>  	.restart	= kirkwood_restart,
>  	.dt_compat	= kirkwood_dt_board_compat,
> -- 
> 1.7.2.5
> 
