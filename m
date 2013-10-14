Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3JNRa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:30:58 -0400
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:41733 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756839Ab3JNRa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:30:57 -0400
Date: Mon, 14 Oct 2013 19:24:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: remove init_machine() as default is suitable
Message-ID: <20131014172445.GL11420@ns203013.ovh.net>
References: <1381480147-14190-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381480147-14190-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 2979694103912229740
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:29 Fri 11 Oct     , Nicolas Ferre wrote:
> Since 883a106b0866ca8d75b5520bdb3ca1cf8e3730ba (ARM: default
> machine descriptor for multiplatform) we can remove the SoC-specific
> callback init_machine() to use the default code.
> This cleans up the code and reduces the number of lines.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> ---
>  arch/arm/mach-at91/board-dt-rm9200.c | 7 -------
>  arch/arm/mach-at91/board-dt-sam9.c   | 7 -------
>  2 files changed, 14 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
> index 3fcb662..3a185fa 100644
> --- a/arch/arm/mach-at91/board-dt-rm9200.c
> +++ b/arch/arm/mach-at91/board-dt-rm9200.c
> @@ -14,7 +14,6 @@
>  #include <linux/gpio.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
> -#include <linux/of_platform.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
> @@ -36,11 +35,6 @@ static void __init at91rm9200_dt_init_irq(void)
>  	of_irq_init(irq_of_match);
>  }
>  
> -static void __init at91rm9200_dt_device_init(void)
> -{
> -	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> -}
> -
>  static const char *at91rm9200_dt_board_compat[] __initdata = {
>  	"atmel,at91rm9200",
>  	NULL
> @@ -52,6 +46,5 @@ DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
>  	.handle_irq	= at91_aic_handle_irq,
>  	.init_early	= at91rm9200_dt_initialize,
>  	.init_irq	= at91rm9200_dt_init_irq,
> -	.init_machine	= at91rm9200_dt_device_init,
>  	.dt_compat	= at91rm9200_dt_board_compat,
>  MACHINE_END
> diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
> index 8db3013..3dab868 100644
> --- a/arch/arm/mach-at91/board-dt-sam9.c
> +++ b/arch/arm/mach-at91/board-dt-sam9.c
> @@ -13,7 +13,6 @@
>  #include <linux/gpio.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
> -#include <linux/of_platform.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
> @@ -37,11 +36,6 @@ static void __init at91_dt_init_irq(void)
>  	of_irq_init(irq_of_match);
>  }
>  
> -static void __init at91_dt_device_init(void)
> -{
> -	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> -}
> -
>  static const char *at91_dt_board_compat[] __initdata = {
>  	"atmel,at91sam9",
>  	NULL
> @@ -54,6 +48,5 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
>  	.handle_irq	= at91_aic_handle_irq,
>  	.init_early	= at91_dt_initialize,
>  	.init_irq	= at91_dt_init_irq,
> -	.init_machine	= at91_dt_device_init,
>  	.dt_compat	= at91_dt_board_compat,
>  MACHINE_END
> -- 
> 1.8.2.2
> 
