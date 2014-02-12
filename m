Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaBLCVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:21:40 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36125 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaBLCVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <1392148200-5393-3-git-send-email-ddaney.cavm@gmail.com>
References: <1392148200-5393-1-git-send-email-ddaney.cavm@gmail.com> <1392148200-5393-3-git-send-email-ddaney.cavm@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 12 Feb 2014 11:21:17 +0900
Message-ID: <CAAVeFu+WekUizRz6G=Rwfbd8Tc1vY6DqV=JDeM_bg4GQ50xZNQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of/gpio: Automatically decode OF_GPIO_OPEN_DRAIN
 and OF_GPIO_OPEN_SOURCE flags in gpiolib.
To: David Daney <ddaney.cavm@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 4:50 AM, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> Just as gpiod_get() automatically interprets the OF_GPIO_ACTIVE_LOW
> flag from the device tree, add handling for OF_GPIO_OPEN_DRAIN and
> OF_GPIO_OPEN_SOURCE.
>
> This keeps the details of handling open-drain GPIOs in the core GPIO
> code, and out of the individual drivers.
>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  drivers/gpio/gpiolib.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 50c4922..7f596d0 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2307,6 +2307,12 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
>         if (of_flags & OF_GPIO_ACTIVE_LOW)
>                 *flags |= GPIO_ACTIVE_LOW;
>
> +       if (of_flags & OF_GPIO_OPEN_DRAIN)
> +               *flags |= GPIO_OPEN_DRAIN;
> +
> +       if (of_flags & OF_GPIO_OPEN_SOURCE)
> +               *flags |= GPIO_OPEN_SOURCE;
> +
>         return desc;
>  }

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Thanks for taking the time to do this!
