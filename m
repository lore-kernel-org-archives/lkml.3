Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3H3BwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:52:02 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63731 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3H3BwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:52:00 -0400
X-Spam-Score: -100.9
Message-ID: <521FFA7E.5090106@asianux.com>
Date: Fri, 30 Aug 2013 09:50:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] include/asm-generic/gpio.h: remove the call for __gpio_get_value()
 and __gpio_set_value() when GPIOLIB disabled
References: <521B2917.6040908@asianux.com> <CACRpkdazBtZfWdGA71WV20oZn2NYXDGExDmDkrv_TrRnhOmxQg@mail.gmail.com>
In-Reply-To: <CACRpkdazBtZfWdGA71WV20oZn2NYXDGExDmDkrv_TrRnhOmxQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 08:08 PM, Linus Walleij wrote:
> On Mon, Aug 26, 2013 at 12:08 PM, Chen Gang <gang.chen@asianux.com> wrote:
> 
>> When GPIOLIB disabled, __gpio_get_value() and __gpio_set_value() will
>> not implement, so need remove them, or compiling fails.
>>
>> e.g. (allmodconfig for h8300)
>>
>>     CC      arch/h8300/kernel/h8300_ksyms.o
>>   In file included from arch/h8300/include/generated/asm/gpio.h:1:0,
>>                    from arch/h8300/kernel/h8300_ksyms.c:17:
>>   include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
>>   include/asm-generic/gpio.h:270:2: error: implicit declaration of function '__gpio_get_value' [-Werror=implicit-function-declaration]
>>     return __gpio_get_value(gpio);
>>     ^
>>
>> For __gpio_get_value(), according to its implementation, it is enough
>> to use "return 0" instead of, and for __gpio_set_value(), just remove
>> directly.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> NAK, this is not how you do it. This fallback path is for GENERIC_GPIO
> without GPIOLIB. Including it from a file indicates that you *are*
> using GENERIC_GPIO when GPIOLIB is not activated. It can not be
> used to stub out gpiolib.
> 

Hmm... what you said above sounds reasonable to me (at least, it can be
acceptable).


> This is a better alternative: let h8300 select
> ARCH_HAVE_CUSTOM_GPIO_H
> 
> This is quite common:
> $ git grep ARCH_HAVE_CUSTOM_GPIO_H
> arch/arm/Kconfig:       select ARCH_HAVE_CUSTOM_GPIO_H
> arch/avr32/Kconfig:     select ARCH_HAVE_CUSTOM_GPIO_H
> arch/blackfin/Kconfig:  select ARCH_HAVE_CUSTOM_GPIO_H
> arch/m68k/Kconfig.cpu:  select ARCH_HAVE_CUSTOM_GPIO_H
> arch/mips/Kconfig:      select ARCH_HAVE_CUSTOM_GPIO_H
> arch/sh/Kconfig:        select ARCH_HAVE_CUSTOM_GPIO_H
> arch/unicore32/Kconfig: select ARCH_HAVE_CUSTOM_GPIO_H
> 
> Then put your stubs for __gpio_get_value() etc in
> arch/h8300/include/asm/gpio.h
> 
> This way the h8300 will have a stub implementation if GPIOLIB
> is not selected.
> 
> Be sure to put a comment about this in that file.
> 

That sounds a standard way for it, thanks.

Hmm... but for h8300, it seems it may not include "gpio.h" which is just
discussing about it with Geert in another thread (it seems what he said
is correct, and now I am just proving it).

Thanks.


> Note: I'm still a bit rookie as GPIO maintainer so if Grant or
> Russell tells me I'm telling you wrong things: listen to them.
> 

Thank you for your modesty and honesty.

And welcome other members' suggestions or completions.


Thanks.

> Yours,
> Linus Walleij
> 
> 


-- 
Chen Gang
