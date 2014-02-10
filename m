Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaBJP16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:27:58 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:35555 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaBJP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <1392044614-6837-1-git-send-email-jjhiblot@traphandler.com>
References: <1392044614-6837-1-git-send-email-jjhiblot@traphandler.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 10 Feb 2014 16:27:30 +0100
Message-ID: <CACQ1gAhzcg6udqVKg0ZcNmYKghS-HWD4YxZVwXcMg70x8JNvfQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: take in account the active low flag when
 configuring the gpio as an ouput
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, gnurou@gmail.com,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-10 16:03 GMT+01:00 Jean-Jacques Hiblot <jjhiblot@traphandler.com>:
> The initial value of the gpio is passed to gpiod_direction_output. Currently
> this value is the raw value of the GPIO line, but it should be the logical
> value.
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
Tested-by: Richard Genoud <richard.genoud@gmail.com>

I was just missing that for my gpio modem lines !
Thanks !
