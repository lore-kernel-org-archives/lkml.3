Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbaHDFEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 01:04:35 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34273 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHDFEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 01:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuK0qe9Hi8OZv9pJjZYFZB_DexPJOD-D2=4DSG==7nHkJg@mail.gmail.com>
References: <1406299116-28492-1-git-send-email-acourbot@nvidia.com>
 <CACRpkdZLXr7mTD4H1VXQPqrwZ3gcjU7CtehOK1-1_=L1J3OnfQ@mail.gmail.com> <CAAVeFuK0qe9Hi8OZv9pJjZYFZB_DexPJOD-D2=4DSG==7nHkJg@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 4 Aug 2014 14:04:12 +0900
Message-ID: <CAAVeFuJm6EOseDow9Mr27FaqucdARaQvXTb3FxA13kqnRw3a3w@mail.gmail.com>
Subject: Re: [PATCH] gpio: add flags argument to gpiod_get*() functions
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 12:43 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Mon, Jul 28, 2014 at 7:30 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, Jul 25, 2014 at 4:38 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>
>>> The huge majority of GPIOs have their direction and initial value set
>>> right after being obtained by one of the gpiod_get() functions. The
>>> integer GPIO API had gpio_request_one() that took a convenience flags
>>> parameter allowing to specify an direction and value applied to the
>>> returned GPIO. This feature greatly simplifies client code and ensures
>>> errors are always handled properly.
>>>
>>> A similar feature has been requested for the gpiod API. Since setting
>>> the direction of a GPIO is so often the very next action done after
>>> obtaining its descriptor, we prefer to extend the existing functions
>>> instead of introducing new functions that would raise the
>>> number of gpiod getters to 16 (!).
>>>
>>> The drawback of this approach is that all gpiod clients need to be
>>> updated. To limit the pain, temporary macros are introduced that allow
>>> gpiod_get*() to be called with or without the extra flags argument. They
>>> will be removed once all consumer code has been updated.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>> ---
>>> This dude can be applied harmlessly to the GPIO tree - then I will go
>>> after every gpiod user to update the calls to gpiod_get*() before
>>> removing the macros in consumer.h.
>>
>> OK I trust you. Patch applied with Broonie's review tag.
>
> Thanks! Unfortunately it is still not in -next due to a build error...
>
>> Just so we don't forget how we should move forward: Alex what do
>> you think about adding a drivers/gpio/TODO.TXT file outlining the
>> overall plan of the gpiod refactoring and clean-up work?
>
> I have such a file locally - I'm not sure if checking it into the
> kernel tree is relevant though. Sounds more like the task of a wiki
> page.

FWIW I have posted a small list of stuff I intent to do shortly:
https://gist.github.com/Gnurou/a62915acbfe0d0d4a671
