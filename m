Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaBLCVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:21:09 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53767 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaBLCVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:21:07 -0500
MIME-Version: 1.0
In-Reply-To: <1392148200-5393-2-git-send-email-ddaney.cavm@gmail.com>
References: <1392148200-5393-1-git-send-email-ddaney.cavm@gmail.com> <1392148200-5393-2-git-send-email-ddaney.cavm@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 12 Feb 2014 11:20:47 +0900
Message-ID: <CAAVeFuKxoT-fvhNAqJYdXgwXiw6LbE1ks_upkWjCYee_YtQPnw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] of/gpio: Define OF_GPIO_OPEN_DRAIN and
 OF_GPIO_OPEN_SOURCE flags.
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

On Wed, Feb 12, 2014 at 4:49 AM, David Daney <ddaney.cavm@gmail.com> wrote:
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
>         .
>         .
>         .
>
> Since the same arguments hold for open-source configurations, add a
> definition for OF_GPIO_OPEN_SOURCE as well.
>
> Signed-off-by: David Daney <david.daney@cavium.com>

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
