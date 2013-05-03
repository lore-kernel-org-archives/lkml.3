Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823Ab3ECIto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:49:44 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51048 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3ECItk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:49:40 -0400
MIME-Version: 1.0
In-Reply-To: <517A475D.8060606@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
	<1366727607-27444-7-git-send-email-james.hogan@imgtec.com>
	<CACRpkdbzYpQqe4yabAwFSAG2rPstT8jM_--LssHi=ttUYtu1ug@mail.gmail.com>
	<517A475D.8060606@imgtec.com>
Date: Fri, 3 May 2013 10:49:40 +0200
Message-ID: <CACRpkdZzfegengBJ4n1Yc1WQU9TT7+-n3VoHiBA+AG68CJEyiw@mail.gmail.com>
Subject: Re: [PATCH 6/8] gpio-tz1090: add TZ1090 gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>, "arm@kernel.org" <arm@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:22 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> On Tue, Apr 23, 2013 at 4:33 PM, James Hogan <james.hogan@imgtec.com> wrote:

>> So when someone using this device tree for Symbian or Windows
>> Mobile start to work, what does "standard Linux gpio flags" tell them?
>
> well this is what of_gpio.h says:
>> /*
>>  * This is Linux-specific flags. By default controllers' and Linux' mapping
>>  * match, but GPIO controllers are free to translate their own flags to
>>  * Linux-specific in their .xlate callback. Though, 1:1 mapping is recommended.
>>  */
>> enum of_gpio_flags {
>>       OF_GPIO_ACTIVE_LOW = 0x1,
>> };
>
> So do you mean that the bindings docs should just explicitly state those
> flag values rather than referring to Linux?

Yes, without mentioning Linux.

"setting bit 0 means active low".

> So basically a bunch of global registers (e.g. pinctrl and gpio) are
> shared between all 3 cores (up to 4 OSes). The __global_lock2 should do
> all that is required to ensure exclusive access to the register (as long
> as the other OSes do something similar when they access the same
> registers). This is one of the reasons why there are 3 gpio banks with
> separate interrupts, and each bank's interrupt is optional in this driver.

OK I get it ...

I think this platform will never ever work with single zImage
though, that seems very unlikely given these constraints.

Well you will have to fight this out with the ARM SoC maintainers
anyway. If they are OK with it I will live with it.

(CC ARM SoC for this.)

>>> +/* caller must hold LOCK2 */
>>> +static inline void _tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
>>> +                                       unsigned int reg_offs,
>>> +                                       unsigned int offset,
>>> +                                       int val)
>>
>> If val is used as it is, make it a bool.
>>
>>> +{
>>> +       u32 value;
>>> +
>>> +       value = tz1090_gpio_read(bank, reg_offs);
>>> +       value &= ~(0x1 << offset);
>>> +       value |= !!val << offset;
>>
>> You're claming val to [0,1] obviously it's a bool.
>
> It's often simply passing on things like the int output_value from the
> direction_output and set callbacks. Is it necessary to confuse things by
> making it a bool and then turning it back into an int to write into the
> register?

Nah no big deal. Keep it like this if it's convenient.
Mainly pointing it out...

Yours,
Linus Walleij
