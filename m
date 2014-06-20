Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967108AbaFTKxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:53:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44946 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966558AbaFTKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:53:06 -0400
Date: Fri, 20 Jun 2014 11:52:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH 1/2] clocksource: arm_arch_timer: remove static from
 arch_timer_init
Message-ID: <20140620105217.GI30188@leverpostej>
References: <70167479.zcs3JF0luJ@diego>
 <3602534.r5eJA8RqrN@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3602534.r5eJA8RqrN@diego>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:44:11AM +0100, Heiko Stübner wrote:
> There exist SoCs that need some special setup procedure for their architected-timer
> to work. Therefore allow arch_timer_init to be called from such specialized
> clocksources.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/clocksource/arm_arch_timer.c | 2 +-
>  drivers/clocksource/arm_arch_timer.h | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clocksource/arm_arch_timer.h
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 5163ec1..55116d6 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -635,7 +635,7 @@ static void __init arch_timer_common_init(void)
>  	arch_timer_arch_init();
>  }
>  
> -static void __init arch_timer_init(struct device_node *np)
> +void __init arch_timer_init(struct device_node *np)
>  {
>  	int i;
>  
> diff --git a/drivers/clocksource/arm_arch_timer.h b/drivers/clocksource/arm_arch_timer.h
> new file mode 100644
> index 0000000..af3974d
> --- /dev/null
> +++ b/drivers/clocksource/arm_arch_timer.h
> @@ -0,0 +1,7 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +void __init arch_timer_init(struct device_node *np);

If we _really_ need this (which I hope we don't), we already have
include/clocksource/arm_arch_timer.h.

Mark.
