Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaDXNXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:23:36 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:57221 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaDXNXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:23:34 -0400
Message-ID: <53591051.9030804@gmail.com>
Date: Thu, 24 Apr 2014 15:23:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?QW50b2luZSBUw6luYQ==?= =?UTF-8?B?cnQ=?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] ARM: berlin: add pinctrl support
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com> <CACRpkdbT94HqVroM_0gSJJ8Q2+YaKXLwjFGMn+4SCa_PYiF19Q@mail.gmail.com>
In-Reply-To: <CACRpkdbT94HqVroM_0gSJJ8Q2+YaKXLwjFGMn+4SCa_PYiF19Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 02:52 PM, Linus Walleij wrote:
> On Wed, Apr 23, 2014 at 5:51 PM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
>
>> This series adds support for the Marvell Berlin pin-controller, allowing
>> to configure the pin muxing from the device tree.
>>
>> The Berlin pin-controller support is divided into 3 drivers, each
>> driving one Berlin SoC. These drivers use a Berlin common part.
>>
>> This series applies on top of patches introducing the Marvell Berlin
>> BG2Q you can find on Sebastian's berlin/for-next branch[1] and the patch
>> allowing not to define the get_group_pins() function[2].
>>
>> Tested on the Berlin BG2Q.
>
> So now I need some advice from the mvebu pinctrl maintainers
> (Thomas, Sebastian etc):
>
> - Is this a totally different pin controller so that drivers/pinctrl/mvebu
>   can not be used?

Unfortunately, yes. Well actually, it _can_ be seen as a subset of
the mvebu pinctrl:

- mvebu (usually) uses 4bit per mux function with 8 functions/register
- berlin uses 1-4bit per mux function with as many functions/register
   as there fit in 32b.

This great feature saves _at least_ one additional address decoding!
It doesn't save registers, because they will never be synthesized, but
at least each SoC has a very different pinmux layout. *sigh*

> - Really?

Yep.

> - OK can you help me review this thing?

Sure thing!

> - Should the base folder really be named "berlin" or is this going to
>    be part of a bigger family of pin controllers so a more neutral name
>    should be sought?

Well, Marvell basically has two groups of SoCs, MVEBU and PXA/MMP. Don't
ask me why but sometimes they share IP, sometimes they don't.

Berlin names Marvell SoCs prefixed 88DExxxx, I *think* it may be derived 
from the PXA/MMP line of SoCs. To make it more confuse,
it also got the marketing name "Armada".

> - Why do hardware engineers seek to reinvent wheels like pin
>    controllers, GPIO and DMA engines all the time :-/

I guess it is: "Look what we found in our IP archives".

Honestly, I can think of making pinctrl/mvebu and pinctrl/berlin
compatible but I don't know if it is worth the pain :P

We have "custom" set/get_function() callbacks in pinctrl/mvebu
so that should fit. Each "group" of pins has a name and a bunch
of "functions", that fits too.

I need some time to think about it, but if you insist on it, I
can possibly make it work.

Sebastian

