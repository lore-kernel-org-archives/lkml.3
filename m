Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBLQOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:14:52 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43469 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBLQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
References: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
Date: Wed, 12 Feb 2014 17:14:50 +0100
Message-ID: <CACRpkdau6dE1mjBx6rew1Ad8FHu7cTMfwNN1rsrWXvPcUeAR2g@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpiolib: add gpiochip_get_desc() driver function
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 9:43 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Some drivers dealing with a gpio_chip might need to act on its
> descriptors directly; one example is pinctrl drivers that need to lock a
> GPIO for being used as IRQ using gpiod_lock_as_irq().
>
> This patch exports a gpiochip_get_desc() function that returns the
> GPIO descriptor at the requested index. It also sweeps the
> gpio_to_chip() function out of the consumer interface since any holder
> of a gpio_chip reference can manipulate its GPIOs way beyond what a
> consumer should be allowed to do.
>
> As a result, gpio_chip is not visible anymore to simple GPIO consumers.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Hm the gpio_lock_as_irq() uses a local offset number on
the GPIOchip, not the global GPIO number, so I'm not
quite following the first paragraph here.

But this is useful anyway so patch applied.

Yours,
Linus Walleij
