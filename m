Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaGBIU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:20:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41318 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbaGBIU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:20:27 -0400
Date: Wed, 2 Jul 2014 10:20:23 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/33] ARM: at91: prepare common clk transition for
 rm9200
Message-ID: <20140702102023.24f186b8@bbrezillon>
In-Reply-To: <1404223962-30471-5-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1404223962-30471-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jul 2014 16:12:13 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Enclose the rm9200 old clk registration in "#if
> defined(CONFIG_OLD_CLK_AT91) #endif"
> 

Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

> Signed-off-by: Alexandre Belloni
> <alexandre.belloni@free-electrons.com> ---
>  arch/arm/mach-at91/at91rm9200.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/at91rm9200.c
> b/arch/arm/mach-at91/at91rm9200.c index 787bb50a4dff..038702ee8bc6
> 100644 --- a/arch/arm/mach-at91/at91rm9200.c
> +++ b/arch/arm/mach-at91/at91rm9200.c
> @@ -26,10 +26,11 @@
>  #include "at91_aic.h"
>  #include "soc.h"
>  #include "generic.h"
> -#include "clock.h"
>  #include "sam9_smc.h"
>  #include "pm.h"
>  
> +#if defined(CONFIG_OLD_CLK_AT91)
> +#include "clock.h"
>  /*
> --------------------------------------------------------------------
>   *  Clocks
>   *
> --------------------------------------------------------------------
> */ @@ -277,6 +278,9 @@ static void __init
> at91rm9200_register_clocks(void) clk_register(&pck2);
> clk_register(&pck3); }
> +#else
> +#define at91rm9200_register_clocks NULL
> +#endif
>  
>  /*
> --------------------------------------------------------------------
>   *  GPIO



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
