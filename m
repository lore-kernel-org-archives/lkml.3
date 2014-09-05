Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaIEOSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:18:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60618 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932388AbaIEOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:18:39 -0400
Date: Fri, 5 Sep 2014 16:18:37 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: rm9200: fix clock registration
Message-ID: <20140905161837.7b83929c@bbrezillon>
In-Reply-To: <1409926533-7853-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1409926533-7853-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Sep 2014 16:15:33 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Actually register clocks from device tree when using the common clock
> framework.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

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



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
