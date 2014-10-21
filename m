Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaJUOSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:18:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49048 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbaJUOSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:18:41 -0400
Message-ID: <54466B3A.5030005@atmel.com>
Date: Tue, 21 Oct 2014 16:18:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] power: reset: at91-reset: fix power down register
References: <1413829629-8705-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1413829629-8705-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/10/2014 20:27, Alexandre Belloni :
> In the case of at91sam9g45_restart(), the driver is writing
> AT91_DDRSDRC_LPCB_POWER_DOWN to AT91_DDRSDRC_RTR, this should actually be
> AT91_DDRSDRC_LPR.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Absolutely:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

If you don't mind Dmitry, I'll take this patch through the at91/arm-soc
git trees in my next at91-3.18-fixes branch.

Thanks Alex, bye,

> ---
>  drivers/power/reset/at91-reset.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
> index 3611806c9cfd..3cb36693343a 100644
> --- a/drivers/power/reset/at91-reset.c
> +++ b/drivers/power/reset/at91-reset.c
> @@ -100,11 +100,11 @@ static void at91sam9g45_restart(enum reboot_mode mode, const char *cmd)
>  		/* Disable SDRAM0 accesses */
>  		"1:	str	%3, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
>  		/* Power down SDRAM0 */
> -		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> +		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
>  		/* Disable SDRAM1 accesses */
>  		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
>  		/* Power down SDRAM1 */
> -		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> +		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
>  		/* Reset CPU */
>  		"	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
>  
> 


-- 
Nicolas Ferre
