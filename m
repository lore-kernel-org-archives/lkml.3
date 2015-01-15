Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbbAOMyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:54:12 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:62333 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbAOMyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:54:10 -0500
MIME-Version: 1.0
Date: Thu, 15 Jan 2015 12:54:09 +0000
Message-ID: <CAGj5WxAsvr6s+0L0yNPMraRGr23yPeE3-suB6R+NmvKA3DYBjw@mail.gmail.com>
Subject: Re: Questions about IOMMU & PCIe switch
From: Luis Alves <ljalvs@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Manu Abraham <abraham.manu@gmail.com>, ray@apollo.lv, clemens@ladisch.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manu,

Do you know if your saa716x driver might have any issue in the dma code?
The code doesn't seem to be using chained scatterlists so it should be
ok with the "old" method of just increment the pointer instead of
using sg_next.
(It's still a little blurry to my this IOMMU+dma+scatterlist stuff)

Anyway, I've converted it to use "sg_next" as asked Raimonds to test
(but I think it shouldn't make any difference):
https://github.com/ljalves/linux_media/commit/54362743588bc8271e7988dd2823f818c00bf43d

I also know don't fully understand the whole driver but I say thank
you for it! :)
By the way, when can we get it upstream? If you need help with
anything just mail me. We are waiting for that driver for so long!


Regards,
Luis


On Thu, Jan 8, 2015 at 8:35 PM, Raimonds Cicans <ray@apollo.lv> wrote:
> On 08.01.2015 10:34, Clemens Ladisch wrote:
>>
>> Raimonds Cicans wrote:
>>>
>>> https://github.com/ljalves/linux_media/issues/66
>>
>> If the TBS driver works, why don't you use it?
>
> 1) driver is not stable in 24x7 setups
>
> 2) driver use old DVBAPI. This cause problems with some
>      user space programs.

It shouldn't. It is backward compatible.

>
> 3) TBS recommends to use card in MSI interrupt mode
>      but this mode on IOMMU systems do not work:
>      card is able to find transponders and tune to it
>      but can not receive any data

TBS didn't even have the courtesy to say thanks, but still.
They don't have any clue on the driver.

You shouldn't use MSI mode on most systems unless you
are sure that your machine works perfectly well with MSI
mode.

You should simply use standard interrupt mode, if you are
unsure.

In any sense, that card looks a bit odd:

1. It doesn't need a PCIe switch, nor that CPLD in there for
the fact that it is using a SAA7160, rather than an E version,
which thereby support 4 FGPI inputs (4 simultaneous TS's)
(Redundant components)

2. But in any sense, the PCIe switch is transparent, It doesn't
need any programming. All what you can do with the PCIe
switch is to reprogram the lines to it, nothing more. In any
case, if your card is detected, there's no point in playing with
the PCIe switch

3. The TS failure in a while can most likely be attributed to
bad CPLD programming. On the cards that I have worked
with, they've worked pretty well.


Regards,

Manu
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
