Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3CCJXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:23:02 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64302 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3CCJW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:22:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: stmpe: pass DT node to irqdomain
To: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1362139302-23048-1-git-send-email-linus.walleij@stericsson.com>
References: <1362139302-23048-1-git-send-email-linus.walleij@stericsson.com>
Date: Sat, 02 Mar 2013 09:23:09 +0000
Message-Id: <20130302092309.692CD3E17F8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013 13:01:42 +0100, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> 
> The irq domain was implemented but the device tree
> node was not transmitted to irq_domain_add_simple().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

I've got a small branch of fixes that I need to send to Linus for v3.9,
and then I'll leave the rest of the bug fixes to you.

g.

> ---
>  drivers/gpio/gpio-stmpe.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
> index 770476a..73b691c 100644
> --- a/drivers/gpio/gpio-stmpe.c
> +++ b/drivers/gpio/gpio-stmpe.c
> @@ -309,9 +309,11 @@ static const struct irq_domain_ops stmpe_gpio_irq_simple_ops = {
>  
>  static int stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
>  {
> -	int base = stmpe_gpio->irq_base;
> +	int base = 0;
> +	if (!stmpe_gpio->chip.of_node)
> +		base = stmpe_gpio->irq_base;
>  
> -	stmpe_gpio->domain = irq_domain_add_simple(NULL,
> +	stmpe_gpio->domain = irq_domain_add_simple(stmpe_gpio->chip.of_node,
>  				stmpe_gpio->chip.ngpio, base,
>  				&stmpe_gpio_irq_simple_ops, stmpe_gpio);
>  	if (!stmpe_gpio->domain) {
> @@ -346,6 +348,7 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
>  	stmpe_gpio->chip = template_chip;
>  	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
>  	stmpe_gpio->chip.dev = &pdev->dev;
> +	stmpe_gpio->chip.of_node = np;
>  	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
>  
>  	if (pdata)
> -- 
> 1.7.11.3
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
