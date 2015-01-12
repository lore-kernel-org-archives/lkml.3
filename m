Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbbALW5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:57:41 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42695 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbALW5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:57:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1421097825-396-7-git-send-email-alexandre.belloni@free-electrons.com>
Cc: "Boris Brezillon" <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421097825-396-7-git-send-email-alexandre.belloni@free-electrons.com>
Message-ID: <20150112225733.20842.93026@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 6/6] ARM: at91: move at91rm9200_idle() to clk/at91/pmc.c
Date: Mon, 12 Jan 2015 14:57:33 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexandre Belloni (2015-01-12 13:23:45)
> Move at91rm9200_idle() along with at91sam9_idle() in clk/at91/pmc.c.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>

Acked-by: Michael Turquette <mturquette@linaro.org>

> 
> Mike, Boris,
> I guess that one can go through the at91 tree unless you have any objections.
> 
>  arch/arm/mach-at91/at91rm9200.c | 9 ---------
>  arch/arm/mach-at91/generic.h    | 1 +
>  drivers/clk/at91/pmc.c          | 9 +++++++++
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
> index fc7c26138037..3be1963f5c56 100644
> --- a/arch/arm/mach-at91/at91rm9200.c
> +++ b/arch/arm/mach-at91/at91rm9200.c
> @@ -21,14 +21,6 @@
>  #include "soc.h"
>  #include "generic.h"
>  
> -static void at91rm9200_idle(void)
> -{
> -       /*
> -        * Disable the processor clock.  The processor will be automatically
> -        * re-enabled by an interrupt or by a reset.
> -        */
> -       at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> -}
>  
>  static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
>  {
> @@ -49,7 +41,6 @@ static void __init at91rm9200_initialize(void)
>         arm_pm_restart = at91rm9200_restart;
>  }
>  
> -
>  AT91_SOC_START(at91rm9200)
>         .init = at91rm9200_initialize,
>  AT91_SOC_END
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index 18d5547f11d5..c4aa21fb765f 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -25,6 +25,7 @@ extern void __init at91_dt_initialize(void);
>  extern void at91rm9200_timer_init(void);
>  
>  /* idle */
> +extern void at91rm9200_idle(void);
>  extern void at91sam9_idle(void);
>  
>  /* Matrix */
> diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
> index 386999b4f8eb..f07c8152e5cc 100644
> --- a/drivers/clk/at91/pmc.c
> +++ b/drivers/clk/at91/pmc.c
> @@ -27,6 +27,15 @@
>  void __iomem *at91_pmc_base;
>  EXPORT_SYMBOL_GPL(at91_pmc_base);
>  
> +void at91rm9200_idle(void)
> +{
> +       /*
> +        * Disable the processor clock.  The processor will be automatically
> +        * re-enabled by an interrupt or by a reset.
> +        */
> +       at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> +}
> +
>  void at91sam9_idle(void)
>  {
>         at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> -- 
> 2.1.0
> 
