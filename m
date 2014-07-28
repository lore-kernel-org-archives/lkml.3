Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaG1KaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:30:23 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59213 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaG1KaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <1406299116-28492-1-git-send-email-acourbot@nvidia.com>
References: <1406299116-28492-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 28 Jul 2014 12:30:20 +0200
Message-ID: <CACRpkdZLXr7mTD4H1VXQPqrwZ3gcjU7CtehOK1-1_=L1J3OnfQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: add flags argument to gpiod_get*() functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>, Thierry Reding <thierry.reding@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 4:38 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> The huge majority of GPIOs have their direction and initial value set
> right after being obtained by one of the gpiod_get() functions. The
> integer GPIO API had gpio_request_one() that took a convenience flags
> parameter allowing to specify an direction and value applied to the
> returned GPIO. This feature greatly simplifies client code and ensures
> errors are always handled properly.
>
> A similar feature has been requested for the gpiod API. Since setting
> the direction of a GPIO is so often the very next action done after
> obtaining its descriptor, we prefer to extend the existing functions
> instead of introducing new functions that would raise the
> number of gpiod getters to 16 (!).
>
> The drawback of this approach is that all gpiod clients need to be
> updated. To limit the pain, temporary macros are introduced that allow
> gpiod_get*() to be called with or without the extra flags argument. They
> will be removed once all consumer code has been updated.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> This dude can be applied harmlessly to the GPIO tree - then I will go
> after every gpiod user to update the calls to gpiod_get*() before
> removing the macros in consumer.h.

OK I trust you. Patch applied with Broonie's review tag.

Just so we don't forget how we should move forward: Alex what do
you think about adding a drivers/gpio/TODO.TXT file outlining the
overall plan of the gpiod refactoring and clean-up work?

Yours,
Linus Walleij
