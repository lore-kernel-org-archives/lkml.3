Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab3DIVew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:34:52 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53522 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762666Ab3DIVev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:34:51 -0400
Message-ID: <5164896E.2070002@free-electrons.com>
Date: Tue, 09 Apr 2013 23:34:38 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: pca953x: fix irq_domain_add_simple usage
References: <1365010814-3263-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1365010814-3263-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Grant,

I take the liberty to ping you on that one as it is a regression and it
may be worth to include it in 3.9 if it is still time to do so.

Best regards,

On 03/04/2013 19:40, Alexandre Belloni wrote:
> We actually have to pass chip as the host_data parameter of
> irq_domain_add_simple() as later on, it is used to initialize chip_data
> in pca953x_gpio_irq_map(). Failing to do so is leading to a NULL pointer
> dereference after calling irq_data_get_irq_chip_data() in
> pca953x_irq_mask(), pca953x_irq_unmask(), pca953x_irq_bus_lock(),
> pca953x_irq_bus_sync_unlock() and pca953x_irq_set_type().
>
> Fixes regression introduced by commit
> 0e8f2fdacf1d44651aa7e57063c76142d1f4988b (gpio: pca953x: use simple
> irqdomain)
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>
> This would probably be good to introduce that patch in the next 3.9 rc as the
> regression leads to a lot of breakage (and cursing).
>
>  drivers/gpio/gpio-pca953x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index e2dcac5..ea26e59 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -575,7 +575,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>  						chip->gpio_chip.ngpio,
>  						irq_base,
>  						&pca953x_irq_simple_ops,
> -						NULL);
> +						chip);
>  		if (!chip->domain)
>  			return -ENODEV;
>  


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

