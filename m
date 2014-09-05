Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaIEP0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:26:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:6786 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaIEP0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:26:02 -0400
Message-ID: <5409D608.9040708@atmel.com>
Date: Fri, 5 Sep 2014 17:26:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: rm9200: fix clock registration
References: <1409926533-7853-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1409926533-7853-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 16:15, Alexandre Belloni :
> Actually register clocks from device tree when using the common clock
> framework.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Indeed, thanks: I'll queue it in at91-3.18-fixes.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> ---
>  arch/arm/mach-at91/board-dt-rm9200.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
> index 61ea21445664..a598481a3570 100644
> --- a/arch/arm/mach-at91/board-dt-rm9200.c
> +++ b/arch/arm/mach-at91/board-dt-rm9200.c
> @@ -14,6 +14,7 @@
>  #include <linux/gpio.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
> +#include <linux/clk-provider.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
> @@ -24,13 +25,21 @@
>  #include "at91_aic.h"
>  #include "generic.h"
>  
> +static void __init rm9200_dt_timer_init(void)
> +{
> +#if defined(CONFIG_COMMON_CLK)
> +	of_clk_init(NULL);
> +#endif
> +	at91rm9200_timer_init();
> +}
> +
>  static const char *at91rm9200_dt_board_compat[] __initdata = {
>  	"atmel,at91rm9200",
>  	NULL
>  };
>  
>  DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
> -	.init_time      = at91rm9200_timer_init,
> +	.init_time      = rm9200_dt_timer_init,
>  	.map_io		= at91_map_io,
>  	.init_early	= at91rm9200_dt_initialize,
>  	.dt_compat	= at91rm9200_dt_board_compat,
> 


-- 
Nicolas Ferre
