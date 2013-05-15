Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3EOBst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:48:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59248 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3EOBsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:48:47 -0400
Date: Wed, 15 May 2013 10:48:42 +0900
From: Simon Horman <horms@verge.net.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 11/20] ARM: shmobile: sh73a0: Remove init_irq declaration
 in machine description
Message-ID: <20130515014842.GQ12246@verge.net.au>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368545933-7430-12-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368545933-7430-12-git-send-email-maxime.ripard@free-electrons.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 05:38:44PM +0200, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for shmobile as well.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-shmobile/setup-sh73a0.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
> index fdf3894..73dd75b 100644
> --- a/arch/arm/mach-shmobile/setup-sh73a0.c
> +++ b/arch/arm/mach-shmobile/setup-sh73a0.c
> @@ -22,7 +22,6 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
> -#include <linux/irqchip.h>
>  #include <linux/platform_device.h>
>  #include <linux/of_platform.h>
>  #include <linux/delay.h>
> @@ -1035,7 +1034,6 @@ DT_MACHINE_START(SH73A0_DT, "Generic SH73A0 (Flattened Device Tree)")
>  	.map_io		= sh73a0_map_io,
>  	.init_early	= sh73a0_init_delay,
>  	.nr_irqs	= NR_IRQS_LEGACY,
> -	.init_irq	= irqchip_init,
>  	.init_machine	= sh73a0_add_standard_devices_dt,
>  	.dt_compat	= sh73a0_boards_compat_dt,
>  MACHINE_END

Queued up for v3.11 in the soc-sh73a0 branch of my renesas tree
on kernel.org. It is included in the renesas-next-20130515 tag of
that tree and should appear in linux-next in the not to distant future.

