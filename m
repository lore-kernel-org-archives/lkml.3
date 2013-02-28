Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3B1E5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:57:30 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:34543 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3B1E52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:57:28 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6tyDrOF1eNNjY0j4tctx=C+m+9xkjGUFRW33hU+k6+o-g@mail.gmail.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
 <CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com>
 <20130226175311.D17173E2EF8@localhost> <CAAVeFuLazaZEbbUVtR_Zyub3hgTesW6JcD9Kxgk7dUXuESpLOw@mail.gmail.com>
 <CACxGe6tyDrOF1eNNjY0j4tctx=C+m+9xkjGUFRW33hU+k6+o-g@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 28 Feb 2013 13:57:07 +0900
Message-ID: <CAAVeFuKGS2j_V8HG-q-=U0Rkz5Dp48xEmwg3h4ShVyh3vHXnyw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] gpiolib: some fixup patches
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 4:52 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> While you're working on that, I'd like you to keep the following in
> mind. I'm getting concerned with the level of overhead that the gpio
> access routines are incuring. They're doing a lot of checks right now
> when with GPIOs we want it to be as fast as possible for the case of
> mmio gpios. (i2c and spi gpios are always going to be slow, so I'm not
> so concerned here). gpio_get, gpio_set and gpio_direction all need to
> be fast.
>
> Basically, I think the model should be that if you've got a gpio_desc
> pointer, then you've got a valid gpio.

Yes, that's what I had in mind as well. Since the only way to obtain a
GPIO descriptor is through the gpiod_get() function(s), we can safely
issues descriptors are valid. There should be no gpiod_is_valid()
function.

> A lot of the checks that are
> currently performed in the gpiod_ versions of functions can be moved
> to the gpio_ versions where a lookup has to be performed anyway. For
> example, right now gpiod_direction_output() is 61 lines long. Madness!
>  :-)

There is certainly room to optimize things and avoid redundant tests
in the legacy GPIO API. Will be worth having a look at this once we
have a clean gpiod implementation.

> I've been playing with an idea of pulling in some basic MMIO gpio
> access directly into gpiolib so that when appropriate gpiolib itself
> can have a fast path for doing the register access and shadow register
> management.

Appealing. :)

Alex.
