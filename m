Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab3BKQu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:50:28 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34859 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3BKQu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:50:27 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbT2eAZR2Ud5f9h0TFsA5M0RpysE9SqMgoL-hcB8fS+Ew@mail.gmail.com>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
	<1358495866-9329-1-git-send-email-shawn.guo@linaro.org>
	<CACRpkdZA9O6N7hmtU-6R1Ff6hW5vjD_ar9RLG1dbkd+MWyoKiw@mail.gmail.com>
	<CAMo8BfJ=6WbAHoCpftRHW1iMtG8robyYUEqqCG2SecixDTgC+g@mail.gmail.com>
	<CACRpkdbT2eAZR2Ud5f9h0TFsA5M0RpysE9SqMgoL-hcB8fS+Ew@mail.gmail.com>
Date: Mon, 11 Feb 2013 19:50:25 +0300
Message-ID: <CAMo8BfKo=N_O=O0y74zy+orAn3nNb-OuS9fC92ebbN7bN_CQPg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: devm_gpio_* support should not depend on GPIOLIB
From: Max Filippov <jcmvbkbc@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 6:13 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sun, Feb 10, 2013 at 5:46 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
>> On Sat, Jan 19, 2013 at 2:33 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Fri, Jan 18, 2013 at 8:57 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
>>>
>>>> Some architectures (e.g. blackfin) provide gpio API without requiring
>>>> GPIOLIB support (ARCH_WANT_OPTIONAL_GPIOLIB).  devm_gpio_* functions
>>>> should also work for these architectures, since they do not really
>>>> depend on GPIOLIB.
>>>>
>>>> Add a new option GPIO_DEVRES (enabled by default) to control the build
>>>> of devres.c.  It also removes the empty version of devm_gpio_*
>>>> functions for !GENERIC_GPIO build from linux/gpio.h, and moves the
>>>> function declarations from asm-generic/gpio.h into linux/gpio.h.
>>>>
>>>> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>>>
>>> OK I removed the old version of the patch and pushed this instead.
>>
>> Hi,
>>
>> this patch causes the following errors for xtensa defconfig build:
>
> Max, can you point us to an xtensa cross-compiler so we can
> figure out where the problem is?

Hi Linus,

I use the following scripts to build cross-compiler for xtensa:
https://github.com/jcmvbkbc/xtensa-toolchain-build

You'd need to download binutils/gcc/gdb source tarballs with versions
specified in config and then run

$ ./prepare.sh fsf && ./fixup-gdb.sh && ./build.sh fsf


FWIW I see that the issue is caused by building drivers/gpio/devres.c
with CONFIG_GPIOLIB=n. Should I just turn GPIO_DEVRES off too?

-- 
Thanks.
-- Max
