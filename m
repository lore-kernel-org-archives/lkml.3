Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3KLGTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:19:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56494 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab3KLGTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:19:13 -0500
Message-ID: <5281C82B.9090402@ti.com>
Date: Tue, 12 Nov 2013 11:48:19 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: davinci: Fix a check for unbanked gpio
References: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com> <1383893156-28010-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1383893156-28010-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 November 2013 12:15 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch fixes a check for offset in gpio_to_irq_unbanked()
> and also assigns gpio_irq, gpio_unbanked of chips[0] to
> appropriate values which is used in gpio_to_irq_unbanked()
> function.
> 
> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

You should note explicitly that this patch fixes broken unbanked IRQ
support. You mostly just described what you are doing.

I will fixup while committing.

Thanks,
Sekhar

> ---
>  drivers/gpio/gpio-davinci.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 8847adf..84be701 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -327,7 +327,7 @@ static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
>  	 * NOTE:  we assume for now that only irqs in the first gpio_chip
>  	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
>  	 */
> -	if (offset < d->irq_base)
> +	if (offset < d->gpio_unbanked)
>  		return d->gpio_irq + offset;
>  	else
>  		return -ENODEV;
> @@ -419,6 +419,8 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>  
>  		/* pass "bank 0" GPIO IRQs to AINTC */
>  		chips[0].chip.to_irq = gpio_to_irq_unbanked;
> +		chips[0].gpio_irq = bank_irq;
> +		chips[0].gpio_unbanked = pdata->gpio_unbanked;
>  		binten = BIT(0);
>  
>  		/* AINTC handles mask/unmask; GPIO handles triggering */
> 

