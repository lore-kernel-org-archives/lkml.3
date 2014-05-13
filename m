Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbaEMIjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:39:16 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:46126 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbaEMIjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <1399175125-6430-1-git-send-email-acourbot@nvidia.com>
References: <1399175125-6430-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 13 May 2014 10:39:08 +0200
Message-ID: <CACRpkdbuKAAnXg_tTeivSaTV=3LQwKsj+XCA2Dazjd5eqTtRZw@mail.gmail.com>
Subject: Re: [PATCH] gpio: make of_get_named_gpiod_flags() private
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2014 at 5:45 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

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

Nice. Patch applied!

Yours,
Linus Walleij
