Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbbAHPcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:32:16 -0500
Received: from mail-yk0-f181.google.com ([209.85.160.181]:43649 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbbAHPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:32:11 -0500
MIME-Version: 1.0
In-Reply-To: <54AE9CC8.2080302@apollo.lv>
References: <54ACB0D4.3000008@apollo.lv>
	<54AD21E2.2020100@ladisch.de>
	<54AD3D0B.6060501@apollo.lv>
	<54AE410B.40101@ladisch.de>
	<54AE9CC8.2080302@apollo.lv>
Date: Thu, 8 Jan 2015 21:02:10 +0530
Message-ID: <CAHFNz9Kj=+Gip-n=4tGaXfUXqc0QHoZgjZJ9s-0sTTFzTv4hxA@mail.gmail.com>
Subject: Re: Questions about IOMMU & PCIe switch
From: Manu Abraham <abraham.manu@gmail.com>
To: Raimonds Cicans <ray@apollo.lv>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
