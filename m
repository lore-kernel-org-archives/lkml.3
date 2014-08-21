Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaHUMZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:25:31 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61361 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaHUMZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <1407541685-20021-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407541685-20021-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Thu, 21 Aug 2014 07:25:25 -0500
Message-ID: <CACRpkdYNXEqOTU6C5dDm_Tv_Kd8CRo=OZ8w5Bb01PqQ99R-ArA@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: exynos: Lock GPIOs as interrupts when used
 as EINTs
From: Linus Walleij <linus.walleij@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 6:48 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:

> From: Tomasz Figa <t.figa@samsung.com>
>
> Currently after configuring a GPIO pin as an interrupt related pinmux
> registers are changed, but there is no protection from calling
> gpio_direction_*() in a badly written driver, which would cause the same
> pinmux register to be reconfigured for regular input/output and this
> disabling interrupt capability of the pin.
>
> This patch addresses this issue by moving pinmux reconfiguration to
> .irq_{request,release}_resources() callback of irq_chip and calling
> gpio_lock_as_irq() helper to prevent reconfiguration of pin direction.
>
> Setting up a GPIO interrupt on Samsung SoCs is a two-step operation -
> in addition to trigger configuration in a dedicated register, the pinmux
> must be also reconfigured to GPIO interrupt, which is a different function
> than normal GPIO input, although I/O-wise they both behave in the same way
> and gpio_get_value() can be used on a pin configured as IRQ as well.
>
> Such design implies subtleties such as gpio_direction_input() not having
> to fail if a pin is already configured as an interrupt nor change the
> configuration to normal input. But the FLAG_USED_AS_IRQ set in gpiolib by
> gpio_lock_as_irq() is only used to check that gpio_direction_output() is
> not called, it's not used to prevent gpio_direction_input() to be called.
> So this is not a complete solution for Samsung SoCs but it's definitely a
> move in the right direction.
>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> [javier: use request resources instead of startup and expand commit message]
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

OK patch applied for fixes, sorry for missing to follow up on this.

Yours,
Linus Walleij
