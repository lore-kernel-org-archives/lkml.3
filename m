Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3IUUbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 16:31:36 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:33544 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab3IUUbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 16:31:35 -0400
Date: Sat, 21 Sep 2013 22:27:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/26] ARM: kirkwood: remove custom .init_time hook
Message-ID: <20130921202753.GB735@lunn.ch>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1379526839-14798-16-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379526839-14798-16-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 07:53:48PM +0200, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks.
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
>  arch/arm/mach-kirkwood/board-dt.c |    8 --------
>  1 file changed, 8 deletions(-)


Hi Sebastian

Boot tested on a Kirkwood Topkick.

Tested-by: Andrew Lunn <andrew@lunn.ch>

	   Andrew

> 
> diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
> index 82d3ad8..a32a3e5 100644
> --- a/arch/arm/mach-kirkwood/board-dt.c
> +++ b/arch/arm/mach-kirkwood/board-dt.c
> @@ -15,7 +15,6 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/clk-provider.h>
> -#include <linux/clocksource.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/irqchip.h>
>  #include <linux/kexec.h>
> @@ -66,12 +65,6 @@ static void __init kirkwood_legacy_clk_init(void)
>  	clk_prepare_enable(clk);
>  }
>  
> -static void __init kirkwood_dt_time_init(void)
> -{
> -	of_clk_init(NULL);
> -	clocksource_of_init();
> -}
> -
>  static void __init kirkwood_dt_init_early(void)
>  {
>  	mvebu_mbus_init("marvell,kirkwood-mbus",
> @@ -122,7 +115,6 @@ DT_MACHINE_START(KIRKWOOD_DT, "Marvell Kirkwood (Flattened Device Tree)")
>  	/* Maintainer: Jason Cooper <jason@lakedaemon.net> */
>  	.map_io		= kirkwood_map_io,
>  	.init_early	= kirkwood_dt_init_early,
> -	.init_time	= kirkwood_dt_time_init,
>  	.init_machine	= kirkwood_dt_init,
>  	.restart	= kirkwood_restart,
>  	.dt_compat	= kirkwood_dt_board_compat,
> -- 
> 1.7.10.4
> 
