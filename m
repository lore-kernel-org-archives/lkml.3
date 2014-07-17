Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaGQGJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:09:53 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:57297 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaGQGJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <1405552260-30511-1-git-send-email-linux@roeck-us.net>
References: <1405552260-30511-1-git-send-email-linux@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 17 Jul 2014 15:09:28 +0900
Message-ID: <CAAVeFuLtUpKKVWAvJ-bw_b36jYFhrzaWeswnJKyehbwn=6y+4Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add support for GPIOF_ACTIVE_LOW to gpio_request_one
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 8:11 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> The gpio include file and the gpio documentation declare and document
> GPIOF_ACTIVE_LOW as one of the flags to be passed to gpio_request_one
> and related functions. However, the flag is not evaluated or used.
>
> Check the flag in gpio_request_one and set the gpio internal flag
> FLAG_ACTIVE_LOW if it is set.

What is the point since the integer GPIO API has no clue of the
active-low status of a GPIO? It is only used by the gpiod and sysfs
interfaces.

>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/gpio/gpiolib.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 2ebc907..43d9e34 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1842,6 +1842,9 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
>         if (flags & GPIOF_OPEN_SOURCE)
>                 set_bit(FLAG_OPEN_SOURCE, &desc->flags);
>
> +       if (flags & GPIOF_ACTIVE_LOW)
> +               set_bit(FLAG_ACTIVE_LOW, &desc->flags);
> +
>         if (flags & GPIOF_DIR_IN)
>                 err = gpiod_direction_input(desc);
>         else
> --
> 1.9.1
>
