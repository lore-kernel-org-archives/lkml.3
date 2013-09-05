Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3IEDp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:45:28 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:61843 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3IEDpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <522790D6.6080803@wwwdotorg.org>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
 <1378294169-22661-3-git-send-email-acourbot@nvidia.com> <522790D6.6080803@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 5 Sep 2013 12:45:04 +0900
Message-ID: <CAAVeFuKJcD4zjiqxvzEr+HeGjs1Tz0oG6rwrNZPGKo-c438=ZQ@mail.gmail.com>
Subject: Re: [RFC 2/5] gpiolib: export descriptor-based GPIO interface
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 4:58 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/04/2013 05:29 AM, Alexandre Courbot wrote:
>> This patch exports the gpiod_* family of API functions, a safer
>> alternative to the legacy gpio interface. Differences between the gpiod
>> and gpio APIs are:
>>
>> - gpio works with integers, whereas gpiod operates on opaque handlers
>>   which cannot be forged or used before proper acquisition
>> - gpiod get/set functions are aware of the active low state of a GPIO
>> - gpio consumers should now include <linux/gpio/consumer.h> to access
>>   the new interface, whereas chips drivers will use
>>   <linux/gpio/driver.h>
>>
>> The legacy gpio API is now built as inline functions on top of gpiod.
>>
>
>> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
>
>> +struct gpio_chip {
>
>> +     int                     (*get_direction)(struct gpio_chip *chip,
>> +                                             unsigned offset);
>> +     int                     (*direction_input)(struct gpio_chip *chip,
>> +                                             unsigned offset);
>> +     int                     (*get)(struct gpio_chip *chip,
>> +                                             unsigned offset);
>> +     int                     (*direction_output)(struct gpio_chip *chip,
>> +                                             unsigned offset, int value);
>> +     int                     (*set_debounce)(struct gpio_chip *chip,
>> +                                             unsigned offset,
>> +                                             unsigned debounce);
>> +
>> +     void                    (*set)(struct gpio_chip *chip,
>> +                                             unsigned offset, int value);
>> +
>
> Minor nit: It might be nice to sort/group these entries more cohesively,
> i.e. get_direction, direction_input, direction_output, get, set,
> set_debounce?

Sure, since we are moving this around anyway... :)

Alex.
