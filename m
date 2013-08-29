Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3H2JRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:17:11 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:42500 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3H2JRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZpHk31zPPn9OeXp3=EH=H6p3BKmikN=7TwLhsR+c1aiA@mail.gmail.com>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<CACRpkdZpHk31zPPn9OeXp3=EH=H6p3BKmikN=7TwLhsR+c1aiA@mail.gmail.com>
Date: Thu, 29 Aug 2013 17:17:08 +0800
Message-ID: <CAJxxZ0OUAoCj_dj8gkipHVeHWO3VN1GiRx4t0=FS-amwxG_eBA@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Aug 29, 2013 at 4:02 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 21, 2013 at 8:30 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
>> processors. It differs a lot from the old one on BF5xx processors. So,
>> create a pinctrl driver under the pinctrl framework.
> (...)
>
> The v3 is a huge improvement! Keep going.
>
> I will not repeat any of Stephens review comments, I just
> saw this:
>
>> +static const unsigned uart1_pins[] = {
>> +       GPIO_PH0, GPIO_PH1,
>> +#ifdef CONFIG_BFIN_UART1_CTSRTS
>> +       GPIO_PE9, GPIO_PE10,
>> +#endif
> (...)
>> +static const unsigned atapi_pins[] = {
>> +       GPIO_PH2, GPIO_PJ3, GPIO_PJ4, GPIO_PJ5, GPIO_PJ6,
>> +       GPIO_PJ7, GPIO_PJ8, GPIO_PJ9, GPIO_PJ10,
>> +       GPIO_PG5, GPIO_PG6, GPIO_PG7,
>> +#ifdef CONFIG_BF548_ATAPI_ALTERNATIVE_PORT
>> +       GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
>> +       GPIO_PF7, GPIO_PF8, GPIO_PF9, GPIO_PF10, GPIO_PF11, GPIO_PF12,
>> +       GPIO_PF13, GPIO_PF14, GPIO_PF15, GPIO_PG2, GPIO_PG3, GPIO_PG4,
>> +#endif
>
> (...)
>> +static const struct adi_pin_group adi_pin_groups[] = {
> (...)
>> +       ADI_PIN_GROUP("uart1grp", uart1_pins),
> (...)
>> +       ADI_PIN_GROUP("atapigrp", atapi_pins),
>> +};
>
> This is not how we do it. Do not use Kconfig to spefify how the SoC
> is utilized. This shall be done at runtime.
>
> What you want to do for UART0 is specify one group for the TX/RX
> pair and another group for the CTS/RTS pair like this:
>
> static const unsigned uart1_rxtx_pins[] = {
>        GPIO_PH0, GPIO_PH1,
> };
>
> static const unsigned uart1_rtscts_pins[] = {
>        GPIO_PE9, GPIO_PE10,
> };
>
> static const struct adi_pin_group adi_pin_groups[] = {
> (...)
>         ADI_PIN_GROUP("uart1txrxgrp", uart1_rxtx_pins),
>         ADI_PIN_GROUP("uart1rtsctsgrp", uart1_ctsrts_pins),
>        (...)
> };
>
> (And vice versa for the atapi pins, create two groups.)
>
> If you want to use all four pins on UART1 in a system, you
> specify this in you map (in platform data or DTS), so that
> e.g. the state "default" will be activate *both* uart1txrxgrp
> and uart1rtscts groups.
>
> This is typically done with two entries in the map.

OK. I will separate the pins into 2 groups.

Regards,

Sonic
