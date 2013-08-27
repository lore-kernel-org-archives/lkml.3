Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3H0O4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:56:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:41479 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3H0O4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:56:35 -0400
Message-ID: <521CBE38.4090202@atmel.com>
Date: Tue, 27 Aug 2013 16:56:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: at91: fix get_pullup/down function return
References: <1377609561-22054-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377609561-22054-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2013 15:19, Boris BREZILLON :
> In PIO_PUSR and PIO_PPDSR register if a given bit is set 1 this means the
> pullup/down for this pin (pin is represented as a bit position) is
> disabled.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Indeed.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and even:
Cc: stable <stable@vger.kernel.org> # 3.8+

Thanks for fixing this Boris.

> ---
>   drivers/pinctrl/pinctrl-at91.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index b90a3a0..19afb9a 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -325,7 +325,7 @@ static void at91_mux_disable_interrupt(void __iomem *pio, unsigned mask)
>
>   static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
>   {
> -	return (readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1;
> +	return !((readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1);
>   }
>
>   static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
> @@ -445,7 +445,7 @@ static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
>
>   static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
>   {
> -	return (__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1;
> +	return !((__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1);
>   }
>
>   static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)
>


-- 
Nicolas Ferre
