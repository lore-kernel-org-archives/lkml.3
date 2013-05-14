Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3ENSFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:05:14 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3181 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab3ENSFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:05:11 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <51927CC2.7080101@broadcom.com>
Date: Tue, 14 May 2013 11:04:50 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Maxime Ripard" <maxime.ripard@free-electrons.com>
cc: "Michal Simek" <michal.simek@xilinx.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Jamie Iles" <jamie@jamieiles.com>,
        "Simon Horman" <horms@verge.net.au>,
        "Magnus Damm" <magnus.damm@gmail.com>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "David Brown" <davidb@codeaurora.org>,
        "Jason Cooper" <jason@lakedaemon.net>, "Andrew Lunn" <andrew@lunn.ch>,
        "Gregory Clement" <gregory.clement@free-electrons.com>,
        "Shawn Guo" <shawn.guo@linaro.org>, "Barry Song" <baohua.song@csr.com>,
        "Tony Prisk" <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Arnd Bergmann" <arnd@arndb.de>, "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH 12/20] ARM: bcm281xx: Remove init_irq declaration in
 machine description
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368545933-7430-13-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1368545933-7430-13-git-send-email-maxime.ripard@free-electrons.com>
X-WSS-ID: 7D8CA40D1R014408375-19-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-05-14 08:38 AM, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for bcm281xx as well.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Christian Daudt <csd@broadcom.com>
> ---
>   arch/arm/mach-bcm/board_bcm.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm.c
> index 22e8421..2859932 100644
> --- a/arch/arm/mach-bcm/board_bcm.c
> +++ b/arch/arm/mach-bcm/board_bcm.c
> @@ -15,7 +15,6 @@
>   #include <linux/init.h>
>   #include <linux/device.h>
>   #include <linux/platform_device.h>
> -#include <linux/irqchip.h>
>   #include <linux/clocksource.h>
>   
>   #include <asm/mach/arch.h>
> @@ -54,7 +53,6 @@ static void __init board_init(void)
>   static const char * const bcm11351_dt_compat[] = { "bcm,bcm11351", NULL, };
>   
>   DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
> -	.init_irq = irqchip_init,
>   	.init_time = clocksource_of_init,
>   	.init_machine = board_init,
>   	.dt_compat = bcm11351_dt_compat,
Applied.

  Thanks,
    csd


