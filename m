Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3EOA7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 20:59:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38303 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3EOA7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 20:59:31 -0400
Date: Wed, 15 May 2013 09:59:26 +0900
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
Subject: Re: [PATCH 07/20] ARM: shmobile: lager: Remove init_irq declaration
 in machine description
Message-ID: <20130515005926.GF12246@verge.net.au>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368545933-7430-8-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368545933-7430-8-git-send-email-maxime.ripard@free-electrons.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 05:38:40PM +0200, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for shmobile as well.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-shmobile/board-lager.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
> index f587187..b7488b8 100644
> --- a/arch/arm/mach-shmobile/board-lager.c
> +++ b/arch/arm/mach-shmobile/board-lager.c
> @@ -19,7 +19,6 @@
>   */
>  
>  #include <linux/interrupt.h>
> -#include <linux/irqchip.h>
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <mach/common.h>
> @@ -39,7 +38,6 @@ static const char *lager_boards_compat_dt[] __initdata = {
>  };
>  
>  DT_MACHINE_START(LAGER_DT, "lager")
> -	.init_irq	= irqchip_init,
>  	.init_time	= r8a7790_timer_init,
>  	.init_machine	= lager_add_standard_devices,
>  	.dt_compat	= lager_boards_compat_dt,

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

