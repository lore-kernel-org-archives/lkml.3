Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaIXICu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:02:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41707 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaIXICm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:02:42 -0400
MIME-Version: 1.0
In-Reply-To: <1410868367-11056-13-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
	<1410868367-11056-13-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 24 Sep 2014 10:02:41 +0200
Message-ID: <CACRpkdaQNjeL5sQNO24xPzR-PJk_emBmrUgx40x7fMP9oogqGQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 12/16] input: gpio_keys_polled - Add support for
 GPIO descriptors
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> From: Aaron Lu <aaron.lu@intel.com>
>
> GPIO descriptors are the preferred way over legacy GPIO numbers
> nowadays. Convert the driver to use GPIO descriptors internally but
> still allow passing legacy GPIO numbers from platform data to support
> existing platforms.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Great!

>  #include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>

Again <linux/gpio.h> should not be needed anymore.

> +               /*
> +                * Legacy GPIO number so request the GPIO here and
> +                * convert it to descriptor.
> +                */
> +               if (!button->gpiod && gpio_is_valid(button->gpio)) {
> +                       unsigned flags = 0;
> +
> +                       if (button->active_low)
> +                               flags |= GPIOF_ACTIVE_LOW;
> +
> +                       error = devm_gpio_request_one(&pdev->dev, button->gpio,
> +                                       flags, button->desc ? : DRV_NAME);
> +                       if (error) {
> +                               dev_err(dev, "unable to claim gpio %u, err=%d\n",
> +                                       button->gpio, error);
> +                               return error;
> +                       }
> +
> +                       button->gpiod = gpio_to_desc(button->gpio);

So the field button->gpio is still there, this is a bit disturbing, but when
I grep for it I see there is a multitude of users :-/

OK I guess these users have to be fixed one by one.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
