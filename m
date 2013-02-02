Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab3BBPLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:11:08 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41932 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab3BBPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:11:04 -0500
MIME-Version: 1.0
In-Reply-To: <1359461275-7059-1-git-send-email-agust@denx.de>
References: <1359461275-7059-1-git-send-email-agust@denx.de>
Date: Sat, 2 Feb 2013 16:11:03 +0100
Message-ID: <CACRpkdYuSpLPnTV4bNnLnA64fix7HjCU2tP6NpDn7zo+HhQ4Wg@mail.gmail.com>
Subject: Re: [PATCH] gpio: mpc8xxx: don't set IRQ_TYPE_NONE when creating irq mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Anatolij Gustschin <agust@denx.de>, Peter Korsgaard <jacmet@sunsite.dk>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 1:07 PM, Anatolij Gustschin <agust@denx.de> wrote:

> Exporting gpios throws genirq error messages like
>
> genirq: Setting trigger mode 0 for irq 44 failed
>  (mpc512x_irq_set_type+0x0/0x18c)
>
> Do not set IRQ_TYPE_NONE in mapping function. Setting this type here
> ends up in returning error code in driver's irq_set_type() function
> and this triggers the genirq error message.
>
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/gpio/gpio-mpc8xxx.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
> index 9ae29cc..a0b33a2 100644
> --- a/drivers/gpio/gpio-mpc8xxx.c
> +++ b/drivers/gpio/gpio-mpc8xxx.c
> @@ -292,7 +292,6 @@ static int mpc8xxx_gpio_irq_map(struct irq_domain *h, unsigned int virq,
>
>         irq_set_chip_data(virq, h->host_data);
>         irq_set_chip_and_handler(virq, &mpc8xxx_irq_chip, handle_level_irq);
> -       irq_set_irq_type(virq, IRQ_TYPE_NONE);

git blame says this line was put there by the IRQ subsystem maintainer
Thomas Gleixner.

I feel very nervous about removing that, and you need a better explanation
what is causing the problem and how in the commit.

Like I want to know for sure that the problem is not triggered from
somewhere else.

Please write how and where you export this to trigger the error.

Yours,
Linus Walleij
