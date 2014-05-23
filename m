Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaEWDeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 23:34:37 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:49899 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaEWDee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 23:34:34 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbfNpx6fHZyQTP1X3NSxBe_u2OXLgnNOmLuKvYq9ghprA@mail.gmail.com>
References: <1400306090-4092-1-git-send-email-acourbot@nvidia.com> <CACRpkdbfNpx6fHZyQTP1X3NSxBe_u2OXLgnNOmLuKvYq9ghprA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 23 May 2014 12:34:13 +0900
Message-ID: <CAAVeFu+8MQwBtUaz5r84zGgJZMLns1XzOkUWTtd+mTk6VF-ieQ@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: make of_get_named_gpiod_flags() private
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 6:16 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, May 17, 2014 at 7:54 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> of_get_named_gpiod_flags() is visible and directly usable by GPIO
>> consumers, but it really should not as the gpiod interface relies
>> on the simpler gpiod_get() to provide properly-configured GPIOs.
>>
>> of_get_named_gpiod_flags() is just used internally by gpiolib to
>> implement gpiod_get(), and by the old of_get_named_gpio_flags()
>> function, therefore it makes sense to make it gpiolib-private.
>>
>> As a side-effect, the unused (and unneeded) of_get_gpiod_flags()
>> inline function is also removed, and of_get_named_gpio_flags() is moved
>> from a static inline function to a regular one in gpiolib-of.c
>>
>> This results in all references to gpiod_* functions in of_gpio.h being
>> gone, which is the way it should be since this file is part of the old
>> integer GPIO interface.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>> Changes since v1:
>> - Fixed compilation error when CONFIG_OF_GPIO is not defined
>> - Fixed warning due to of_gpio_flags enum not being declared
>>   in private gpiolib.h header
>
> Applied this v2 version and pushed for testing, let's hope it flies
> properly this time :-D

Looks like the world did not break this time. However I noticed that
the commit in your tree (and -next) included the changes since v1 in
its log. Is it intended?
