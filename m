Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3EOSv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:51:56 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:49795 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763Ab3EOSvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:51:54 -0400
Message-ID: <5193D953.5040202@prisktech.co.nz>
Date: Thu, 16 May 2013 06:52:03 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 20/20] ARM: vt8500: Remove init_irq declaration in machine
 description
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com> <1368545933-7430-21-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1368545933-7430-21-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/05/13 03:38, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for vt8500 as well.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>   arch/arm/mach-vt8500/vt8500.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
> index 1dd281e..70a5ac9 100644
> --- a/arch/arm/mach-vt8500/vt8500.c
> +++ b/arch/arm/mach-vt8500/vt8500.c
> @@ -20,7 +20,6 @@
>   
>   #include <linux/clocksource.h>
>   #include <linux/io.h>
> -#include <linux/irqchip.h>
>   #include <linux/pm.h>
>   
>   #include <asm/mach-types.h>
> @@ -178,7 +177,6 @@ static const char * const vt8500_dt_compat[] = {
>   DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
>   	.dt_compat	= vt8500_dt_compat,
>   	.map_io		= vt8500_map_io,
> -	.init_irq	= irqchip_init,
>   	.init_machine	= vt8500_init,
>   	.init_time	= clocksource_of_init,
>   	.restart	= vt8500_restart,
I don't have any plans to touch this driver, so please send direct to 
arm-soc as Arnd
requested.

Acked-by: Tony Prisk <linux@prisktech.co.nz>

Regards
Tony Prisk
