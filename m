Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3LPJ47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:56:59 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42595 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3LPJ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:56:58 -0500
Message-ID: <52AECE67.6050507@atmel.com>
Date: Mon, 16 Dec 2013 10:56:55 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: at91: fix clk_unprepare and clk_disable
 order
References: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com> <1387132252-2584-2-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387132252-2584-2-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/12/2013 19:30, Boris BREZILLON :
> clk_unprepare shall be called before clk_disable.
> Fix the issue by replacing the clk_unprepare and clk_disable calls by a
> single clk_disable_unprepare call.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks.

> ---
>  drivers/pinctrl/pinctrl-at91.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index a7549c4..82f6301 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -1339,13 +1339,11 @@ void at91_pinctrl_gpio_suspend(void)
>  		__raw_writel(backups[i], pio + PIO_IDR);
>  		__raw_writel(wakeups[i], pio + PIO_IER);
>  
> -		if (!wakeups[i]) {
> -			clk_unprepare(gpio_chips[i]->clock);
> -			clk_disable(gpio_chips[i]->clock);
> -		} else {
> +		if (!wakeups[i])
> +			clk_disable_unprepare(gpio_chips[i]->clock);
> +		else
>  			printk(KERN_DEBUG "GPIO-%c may wake for %08x\n",
>  			       'A'+i, wakeups[i]);
> -		}
>  	}
>  }
>  
> 


-- 
Nicolas Ferre
