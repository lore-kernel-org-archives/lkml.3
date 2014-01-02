Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaABNH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 08:07:28 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62140 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaABNH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 08:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131221104920.GA3626@rashika>
References: <20131221104920.GA3626@rashika>
Date: Thu, 2 Jan 2014 14:07:25 +0100
Message-ID: <CACRpkdYyFXt1g-fL9dUTwQLnT4senUjvRpehc6yuQ9rV4ztwSA@mail.gmail.com>
Subject: Re: [PATCH] drivers: Remove unused devm_*_put functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        josh@joshtriplett.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 11:49 AM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:

> Remove unused devm_*_put functions because none of them are
> used anywhere in the kernel and devm does automatic cleanup
> of resources and requires no manual cleanup.
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/gpio/devres.c         |   25 -------------------------
>  include/linux/gpio/consumer.h |    9 ---------

Can you please split these two hunks on the patch into a separate
patch I can apply to the GPIO tree?


> -static int devm_gpiod_match(struct device *dev, void *res, void *data)
> -{
> -       struct gpio_desc **this = res, **gpio = data;
> -
> -       return *this == *gpio;
> -}
(...)
> -/**
> - * devm_gpiod_put - Resource-managed gpiod_put()
> - * @desc:      GPIO descriptor to dispose of
> - *
> - * Dispose of a GPIO descriptor obtained with devm_gpiod_get() or
> - * devm_gpiod_get_index(). Normally this function will not be called as the GPIO
> - * will be disposed of by the resource management code.
> - */
> -void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
> -{
> -       WARN_ON(devres_release(dev, devm_gpiod_release, devm_gpiod_match,
> -               &desc));
> -}
> -EXPORT_SYMBOL(devm_gpiod_put);

Alexandre what do you think about this? Can we think of a scenario
where explicit garbage collection is going to be needed or should we
remove this for now?

Yours,
Linus Walleij
