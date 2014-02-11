Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBKEcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 23:32:11 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:33706 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaBKEcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 23:32:05 -0500
MIME-Version: 1.0
In-Reply-To: <1392069908-22017-1-git-send-email-ddaney.cavm@gmail.com>
References: <1392069908-22017-1-git-send-email-ddaney.cavm@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 11 Feb 2014 13:31:44 +0900
Message-ID: <CAAVeFu+_WKzLdhWcB_km3iDj419OhtMXEKzz_yWoL3WUm+7kQQ@mail.gmail.com>
Subject: Re: [PATCH] of/gpio: Define OF_GPIO_OPEN_DRAIN flag for Open Drain outputs.
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

On Tue, Feb 11, 2014 at 7:05 AM, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> When we have a GPIO pin connected to an open-drain network, we want a
> standard way of specifying this in the device tree.  So we choose bit
> 1 of the flag field to indicate open drain.
>
> A typical use case would be something like:
>
>         enum of_gpio_flags f;
>         .
>         .
>         .
>         reset_gpio = of_get_named_gpio_flags(node, "reset", 0, &f);
>         .
>         .
>         .
>         ret = gpio_request_one(reset_gpio,
>                 (f & OF_GPIO_OPEN_DRAIN) ? GPIOF_OPEN_DRAIN : 0,
>                  "reset");
>         .
>         .
>         .
>         gpio_direction_output(reset_gpio, 1);
>         gpio_set_value(reset_gpio, 0);
>         msleep(20);
>         gpio_set_value(reset_gpio, 1);

This is also useful for gpiod_get(). However, while you are at it,
could you also add a flag for the OF_GPIO_OPEN_SOURCE property? My joy
would be complete if you could also take the time to update
of_find_gpio() to pass these new flags back to the caller as it
already does for OF_GPIO_ACTIVE_LOW.

Then you could even switch your use-case to the gpiod interface and
not bother with passing these flags by yourself anymore. Just sayin'.
;)

Thanks,
Alex.
