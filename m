Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaBKEXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 23:23:07 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:41161 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaBKEXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 23:23:06 -0500
MIME-Version: 1.0
In-Reply-To: <1392044614-6837-1-git-send-email-jjhiblot@traphandler.com>
References: <1392044614-6837-1-git-send-email-jjhiblot@traphandler.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 11 Feb 2014 13:22:44 +0900
Message-ID: <CAAVeFuJ6BP4JnVb6qD1DYXqPQ3zBKw8hb+xLqcmUjktOxAjdGA@mail.gmail.com>
Subject: Re: [PATCH] gpio: take in account the active low flag when
 configuring the gpio as an ouput
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        richard.genoud@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:03 AM, Jean-Jacques Hiblot
<jjhiblot@traphandler.com> wrote:
> The initial value of the gpio is passed to gpiod_direction_output. Currently
> this value is the raw value of the GPIO line, but it should be the logical
> value.

I think we have a patch that already does this:

http://www.kernelhub.org/?msg=390263&p=2

Linus said it would be merged for 3.15, but I am not seeing it in -next. Linus?

>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  drivers/gpio/gpiolib.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 4e10b10..111a1f1 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1751,6 +1751,9 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
>                 return -EINVAL;
>         }
>
> +       if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
> +               value = !value;
> +
>         /* GPIOs used for IRQs shall not be set as output */
>         if (test_bit(FLAG_USED_AS_IRQ, &desc->flags)) {
>                 gpiod_err(desc,
> --
> 1.8.5.3
>
