Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3LPJ5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:57:15 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:49737 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3LPJ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:57:13 -0500
Message-ID: <52AECE77.9000601@atmel.com>
Date: Mon, 16 Dec 2013 10:57:11 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pinctrl: at91: replace clk_prepare + clk_enable by
 clk_prepare_enable
References: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com> <1387132252-2584-3-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387132252-2584-3-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/12/2013 19:30, Boris BREZILLON :
> Replace the clk_prepare and clk_enable calls by a single
> clk_prepare_enable call.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/pinctrl/pinctrl-at91.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 82f6301..4deb9cb 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -1359,10 +1359,8 @@ void at91_pinctrl_gpio_resume(void)
>  
>  		pio = gpio_chips[i]->regbase;
>  
> -		if (!wakeups[i]) {
> -			if (clk_prepare(gpio_chips[i]->clock) == 0)
> -				clk_enable(gpio_chips[i]->clock);
> -		}
> +		if (!wakeups[i])
> +			clk_prepare_enable(gpio_chips[i]->clock);
>  
>  		__raw_writel(wakeups[i], pio + PIO_IDR);
>  		__raw_writel(backups[i], pio + PIO_IER);
> 


-- 
Nicolas Ferre
