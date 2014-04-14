Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaDNI5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:57:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57022 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753338AbaDNI5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:57:39 -0400
Date: Mon, 14 Apr 2014 10:57:13 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: at91: prepare common clk transition for sam9n12
 SoC
Message-ID: <20140414085713.GL2967@piout.net>
References: <1397463399-11771-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397463399-11771-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397463399-11771-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2014 at 10:16:36 +0200, Boris Brezillon wrote :
> This patch encloses sam9n12 old clk registration in
> "#if defined(CONFIG_OLD_CLK_AT91) #endif" sections.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-at91/at91sam9n12.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
> index f2ea7b0..c8988fe 100644
> --- a/arch/arm/mach-at91/at91sam9n12.c
> +++ b/arch/arm/mach-at91/at91sam9n12.c
> @@ -19,9 +19,10 @@
>  #include "board.h"
>  #include "soc.h"
>  #include "generic.h"
> -#include "clock.h"
>  #include "sam9_smc.h"
>  
> +#if defined(CONFIG_OLD_CLK_AT91)
> +#include "clock.h"
>  /* --------------------------------------------------------------------
>   *  Clocks
>   * -------------------------------------------------------------------- */
> @@ -215,6 +216,9 @@ static void __init at91sam9n12_register_clocks(void)
>  			 ARRAY_SIZE(periph_clocks_lookups));
>  
>  }
> +#else
> +#define at91sam9n12_register_clocks NULL
> +#endif
>  
>  /* --------------------------------------------------------------------
>   *  AT91SAM9N12 processor initialization
> -- 
> 1.8.3.2
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
