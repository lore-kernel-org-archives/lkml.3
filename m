Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3EOA7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 20:59:24 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38289 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3EOA7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 20:59:22 -0400
Date: Wed, 15 May 2013 09:59:17 +0900
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
Subject: Re: [PATCH 06/20] ARM: shmobile: kzm9g: Remove init_irq declaration
 in machine description
Message-ID: <20130515005917.GE12246@verge.net.au>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368545933-7430-7-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368545933-7430-7-git-send-email-maxime.ripard@free-electrons.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 05:38:39PM +0200, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for shmobile as well.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-shmobile/board-kzm9g-reference.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
> index aefa50d..b7ee96e 100644
> --- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
> +++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
> @@ -24,7 +24,6 @@
>  #include <linux/gpio.h>
>  #include <linux/io.h>
>  #include <linux/irq.h>
> -#include <linux/irqchip.h>
>  #include <linux/input.h>
>  #include <linux/of_platform.h>
>  #include <linux/pinctrl/machine.h>
> @@ -100,7 +99,6 @@ DT_MACHINE_START(KZM9G_DT, "kzm9g-reference")
>  	.map_io		= sh73a0_map_io,
>  	.init_early	= sh73a0_init_delay,
>  	.nr_irqs	= NR_IRQS_LEGACY,
> -	.init_irq	= irqchip_init,
>  	.init_machine	= kzm_init,
>  	.init_time	= shmobile_timer_init,
>  	.dt_compat	= kzm9g_boards_compat_dt,

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

