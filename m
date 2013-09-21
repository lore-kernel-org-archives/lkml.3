Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3IUM02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 08:26:28 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:33470 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab3IUM01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 08:26:27 -0400
Date: Sat, 21 Sep 2013 14:22:26 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/26] ARM: dove: remove custom .init_time hook
Message-ID: <20130921122226.GB31180@lunn.ch>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1379526839-14798-12-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379526839-14798-12-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 07:53:44PM +0200, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks. While at it, also remove some obsolete
> includes.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-dove/board-dt.c |   11 -----------
>  1 file changed, 11 deletions(-)

Hi Sebastian

Boot tested on cubox.

Tested-by: Andrew Lunn <andrew@lunn.ch>

	   Andrew

> 
> diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
> index 49f72a8..ddb8663 100644
> --- a/arch/arm/mach-dove/board-dt.c
> +++ b/arch/arm/mach-dove/board-dt.c
> @@ -10,17 +10,13 @@
>  
>  #include <linux/init.h>
>  #include <linux/clk-provider.h>
> -#include <linux/clocksource.h>
> -#include <linux/irqchip.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> -#include <linux/platform_data/usb-ehci-orion.h>
>  #include <asm/hardware/cache-tauros2.h>
>  #include <asm/mach/arch.h>
>  #include <mach/dove.h>
>  #include <mach/pm.h>
>  #include <plat/common.h>
> -#include <plat/irq.h>
>  #include "common.h"
>  
>  /*
> @@ -45,12 +41,6 @@ static void __init dove_legacy_clk_init(void)
>  			 of_clk_get_from_provider(&clkspec));
>  }
>  
> -static void __init dove_dt_time_init(void)
> -{
> -	of_clk_init(NULL);
> -	clocksource_of_init();
> -}
> -
>  static void __init dove_dt_init_early(void)
>  {
>  	mvebu_mbus_init("marvell,dove-mbus",
> @@ -84,7 +74,6 @@ static const char * const dove_dt_board_compat[] = {
>  DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
>  	.map_io		= dove_map_io,
>  	.init_early	= dove_dt_init_early,
> -	.init_time	= dove_dt_time_init,
>  	.init_machine	= dove_dt_init,
>  	.restart	= dove_restart,
>  	.dt_compat	= dove_dt_board_compat,
> -- 
> 1.7.10.4
> 
