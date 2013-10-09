Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3JINFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:05:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:12188 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3JINFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:05:35 -0400
Message-ID: <5255549C.4050009@atmel.com>
Date: Wed, 9 Oct 2013 15:05:32 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/6] ARM: at91: prepare common clk transition for sama5d3
 SoC
References: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com> <1375953690-11207-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375953690-11207-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 11:21, Boris BREZILLON :
> This patch enclose sama5d3 old clk registration in
> "#if defined(CONFIG_OLD_CLK_AT91) #endif" sections.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And... do not forget to remove completely the code when transition is 
done (ie: in "[PATCH 6/6] ARM: at91/dt: remove old main clk definition 
from sama5d3xcm.dtsi").


> ---
>   arch/arm/mach-at91/sama5d3.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
> index 0003949..3426098 100644
> --- a/arch/arm/mach-at91/sama5d3.c
> +++ b/arch/arm/mach-at91/sama5d3.c
> @@ -19,9 +19,10 @@
>
>   #include "soc.h"
>   #include "generic.h"
> -#include "clock.h"
>   #include "sam9_smc.h"
>
> +#if defined(CONFIG_OLD_CLK_AT91)
> +#include "clock.h"
>   /* --------------------------------------------------------------------
>    *  Clocks
>    * -------------------------------------------------------------------- */
> @@ -361,6 +362,7 @@ static void __init sama5d3_register_clocks(void)
>   	clk_register(&pck1);
>   	clk_register(&pck2);
>   }
> +#endif
>
>   /* --------------------------------------------------------------------
>    *  AT91SAM9x5 processor initialization
> @@ -373,5 +375,7 @@ static void __init sama5d3_map_io(void)
>
>   AT91_SOC_START(sama5d3)
>   	.map_io = sama5d3_map_io,
> +#if defined(CONFIG_OLD_CLK_AT91)
>   	.register_clocks = sama5d3_register_clocks,
> +#endif
>   AT91_SOC_END
>


-- 
Nicolas Ferre
