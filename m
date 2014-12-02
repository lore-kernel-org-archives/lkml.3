Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaLBO6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:58:18 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:42632 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaLBO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:58:15 -0500
Message-ID: <547DD383.3030307@atmel.com>
Date: Tue, 2 Dec 2014 15:58:11 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Matthieu Crapet <mcrapet@gmail.com>
Subject: Re: [PATCH] pinctrl: at91: enhance (debugfs) at91_gpio_dbg_show
References: <1416321825-17776-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1416321825-17776-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/11/2014 15:43, Nicolas Ferre a écrit :
> From: Matthieu Crapet <mcrapet@gmail.com>
> 
> When a pin is configured as GPIO, print also direction (input or output).
> 
> Signed-off-by: Matthieu Crapet <mcrapet@gmail.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/pinctrl/pinctrl-at91.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Linus, ping?

> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 354a81d40925..a6b29ebc3cc3 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -1344,7 +1344,6 @@ static void at91_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  	for (i = 0; i < chip->ngpio; i++) {
>  		unsigned mask = pin_to_mask(i);
>  		const char *gpio_label;
> -		u32 pdsr;
>  
>  		gpio_label = gpiochip_is_requested(chip, i);
>  		if (!gpio_label)
> @@ -1353,11 +1352,13 @@ static void at91_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  		seq_printf(s, "[%s] GPIO%s%d: ",
>  			   gpio_label, chip->label, i);
>  		if (mode == AT91_MUX_GPIO) {
> -			pdsr = readl_relaxed(pio + PIO_PDSR);
> -
> -			seq_printf(s, "[gpio] %s\n",
> -				   pdsr & mask ?
> -				   "set" : "clear");
> +			seq_printf(s, "[gpio] ");
> +			seq_printf(s, "%s ",
> +				      readl_relaxed(pio + PIO_OSR) & mask ?
> +				      "output" : "input");
> +			seq_printf(s, "%s\n",
> +				      readl_relaxed(pio + PIO_PDSR) & mask ?
> +				      "set" : "clear");
>  		} else {
>  			seq_printf(s, "[periph %c]\n",
>  				   mode + 'A' - 1);
> 


-- 
Nicolas Ferre
