Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaGQH1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:27:06 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41948 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaGQH1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:27:01 -0400
MIME-Version: 1.0
In-Reply-To: <53C76F3C.6090104@roeck-us.net>
References: <1405552260-30511-1-git-send-email-linux@roeck-us.net>
 <CAAVeFuLtUpKKVWAvJ-bw_b36jYFhrzaWeswnJKyehbwn=6y+4Q@mail.gmail.com> <53C76F3C.6090104@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 17 Jul 2014 16:26:40 +0900
Message-ID: <CAAVeFuKC19AK8BjM7OBm=FWm0ua5YJXoGRkpOvM1TWkz9yOZ5Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add support for GPIOF_ACTIVE_LOW to gpio_request_one
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 3:37 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 07/16/2014 11:09 PM, Alexandre Courbot wrote:
>>
>> On Thu, Jul 17, 2014 at 8:11 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> The gpio include file and the gpio documentation declare and document
>>> GPIOF_ACTIVE_LOW as one of the flags to be passed to gpio_request_one
>>> and related functions. However, the flag is not evaluated or used.
>>>
>>> Check the flag in gpio_request_one and set the gpio internal flag
>>> FLAG_ACTIVE_LOW if it is set.
>>
>>
>> What is the point since the integer GPIO API has no clue of the
>> active-low status of a GPIO? It is only used by the gpiod and sysfs
>> interfaces.
>>
>
> One can use gpio_request_one() to export a gpio pin to user space from
> the kernel. That code path does use the flag, as you point out yourself
> above.

Ok, in that case I suppose it makes sense.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

> One could also argue that the integer gpio API _should_ support this as
> well,
> but that is a different question.

Probably not going to happen. The integer GPIO interface is deprecated
and users who need new features should seriously consider switching to
gpiod.
