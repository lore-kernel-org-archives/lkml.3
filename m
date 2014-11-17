Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaKQTrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:47:36 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:39826 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaKQTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:47:34 -0500
MIME-Version: 1.0
In-Reply-To: <14461008.6cZzGdpat2@wuerfel>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
 <2018325.yOrLZndTTm@wuerfel> <CAJiQ=7An5eZ3j2+Zkx1crV9pBSVodkEQ+6ESGcFk5z0tDV7cHA@mail.gmail.com>
 <14461008.6cZzGdpat2@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 17 Nov 2014 11:47:12 -0800
Message-ID: <CAJiQ=7CmFNhufdeoeH_6SuYOhf3Luwc2zwy_+8au1V8RW78rOw@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Gorski <jogo@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 10:55 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> And unless there is one, having a
>> >> multiplatform kernel does not make much sense, as there is no sane way
>> >> to tell apart different platforms on boot.
>> >
>> > How do you normally tell boards apart on MIPS when you don't use DT?
>>
>> On BCM7xxx (STB) kernels, we could assume the chip ID was in a known
>> register, and also we could call back into the bootloader to get a
>> somewhat-accurate board name.
>>
>> On BCM63xx there is logic in arch/mips/bcm63xx/cpu.c to try to guess
>> the chip identity from the CPU type/revision (because the latter can
>> be read directly from CP0).
>>
>> These systems were never really designed to support multiplatform
>> kernels.  The ARM BCM7xxx variants, by contrast, were.
>
> Guessing the chip doesn't really help you all that much of course
> as long as you don't know the board, and once you know that,
> the chip is implied.

This mostly depends on the desired feature set, and the delta from one
board to the next.  Many of the reference board sections are largely
copied from a working design, but sometimes there are changes that
affect us.  Other times there are tweaks that can be autodetected,
like a different flash chip.

The analog interfaces like SATA/USB/Ethernet don't tend to vary all
that much (although some may be missing ports on the board, or
disabled on the chip).

The pin muxing situation leaves a lot of room for board differences,
and on these platforms it isn't really handled in a central place.
This gets even more challenging when combined with some of the power
management requirements.

The peripherals that I added in my patch submission are among the
easiest / safest of the bunch.
