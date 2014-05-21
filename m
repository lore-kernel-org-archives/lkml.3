Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaEUJQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:16:18 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51089 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaEUJQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <1400306090-4092-1-git-send-email-acourbot@nvidia.com>
References: <1400306090-4092-1-git-send-email-acourbot@nvidia.com>
Date: Wed, 21 May 2014 11:16:14 +0200
Message-ID: <CACRpkdbfNpx6fHZyQTP1X3NSxBe_u2OXLgnNOmLuKvYq9ghprA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: make of_get_named_gpiod_flags() private
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 7:54 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> of_get_named_gpiod_flags() is visible and directly usable by GPIO
> consumers, but it really should not as the gpiod interface relies
> on the simpler gpiod_get() to provide properly-configured GPIOs.
>
> of_get_named_gpiod_flags() is just used internally by gpiolib to
> implement gpiod_get(), and by the old of_get_named_gpio_flags()
> function, therefore it makes sense to make it gpiolib-private.
>
> As a side-effect, the unused (and unneeded) of_get_gpiod_flags()
> inline function is also removed, and of_get_named_gpio_flags() is moved
> from a static inline function to a regular one in gpiolib-of.c
>
> This results in all references to gpiod_* functions in of_gpio.h being
> gone, which is the way it should be since this file is part of the old
> integer GPIO interface.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Changes since v1:
> - Fixed compilation error when CONFIG_OF_GPIO is not defined
> - Fixed warning due to of_gpio_flags enum not being declared
>   in private gpiolib.h header

Applied this v2 version and pushed for testing, let's hope it flies
properly this time :-D

Yours,
Linus Walleij
