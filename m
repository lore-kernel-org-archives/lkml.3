Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3KMGTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:19:39 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43519 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3KMGTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:19:31 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZC+hvChpDMasj0avRTTbprVn8ro7NxywNUPw+SOr10bw@mail.gmail.com>
References: <20131106234737.8971.37405.sendpatchset@w520>
	<CACRpkdZC+hvChpDMasj0avRTTbprVn8ro7NxywNUPw+SOr10bw@mail.gmail.com>
Date: Wed, 13 Nov 2013 15:19:29 +0900
Message-ID: <CANqRtoQA0dXPs8+sNS-8WBPLpzvbSuwj0J3967He0rm=QwNCMQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas RZ GPIO driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Nov 13, 2013 at 4:59 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Nov 7, 2013 at 12:47 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch adds a GPIO driver for the RZ series of SoCs from
>> Renesas. The driver can be used as platform device with dynamic
>> or static GPIO assignment or via DT using dynamic GPIOs.
>
> So given that this is for a new system which should only ever
> be booted using device tree, why are we bothering with supporting
> platform data passing at all?

Mainly to support the same interfaces as our other GPIO drivers. But I
can easily remove the platform data init method if that is the
preferred way, no problem.

> Is it so that arch/sh is more soft on this for example...?
> Can some arch maintainer like SH/Paul ACK this approach?
>
> Read: SH is not moving to device tree...?

>From what I can tell this GPIO block is not used with SH, so I don't
think SH is related, but regarding DT on SH, do you know when it was
decided that other architectures also were supposed to move DT?

> (...)
>> Tested with yet-to-be-posted platform device and DT devices on
>> r7s72100 and Genmai using LEDs, DIP switches and I2C bitbang.
>
> Do you think the maintainers will merge the platform
> device approach?

I would not assume so. But the goal with these patches is  not
upstream, instead they basically serve as a stop-gap solution between
now and when I get OK that the DT bits in this GPIO driver looks fine.
If they are going to be merged or not is a different question IMO.

>> --- /dev/null
>> +++ work/include/linux/platform_data/gpio-rz.h  2013-11-06 14:18:46.000000000 +0900
>> @@ -0,0 +1,13 @@
>> +#ifndef __GPIO_RZ_H__
>> +#define __GPIO_RZ_H__
>> +
>> +struct gpio_rz_config {
>> +       int gpio_base;
>
> Passing these static base offsets around is not good for the
> kernel and we're trying to get rid of it :-(

Sure.

>> +       const char *pctl_name;
>
> Ho hum... This needs some kerneldoc describing that this is
> used to map the GPIO range to the right pin controller.

Ok, but it will just go away when the platform data init method is removed

>> +#define RZ_GPIOS_PER_PORT 16
>
> This is only used in the driver so move it into the driver.

It is also used by the macro below. =)

>> +#define RZ_PORT_PIN(bank, pin) (((bank) * RZ_GPIOS_PER_PORT) + (pin))
>
> This is not used anywhere so delete it.
>
> If it is to be kept I'd like "pin" replaced with "line" to avoid
> confusion with the pin control business.

The idea with that macro is to allow board code to select which pin
from which bank, but I realize it may clash with pinctrl terminology.
Also, since the only reason for this header file is to provide a
platform data init interface for the driver all these things will go
away if we go DT-only.

I'll ditch the platform data interface and post a V2.

Thanks for your feedback!

Cheers,

/ magnus
