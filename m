Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaLCMIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:08:16 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51383 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaLCMIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:08:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141203101109.GB11285@n2100.arm.linux.org.uk>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<54761BFC.4020705@ti.com>
	<CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
	<3212776.kDbe7yX4eX@wuerfel>
	<20141203101109.GB11285@n2100.arm.linux.org.uk>
Date: Wed, 3 Dec 2014 20:08:11 +0800
Message-ID: <CAAfSe-tHbBGgi-uaGM6WEGNO1kuf9V+C1pV7P8miQSsj6Pc5dg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Hayato Suzuki <hytszk@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Mark Brown <broonie@kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-03 18:11 GMT+08:00 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Wed, Dec 03, 2014 at 10:50:17AM +0100, Arnd Bergmann wrote:
>> On Wednesday 03 December 2014 17:17:13 Lyra Zhang wrote:
>>
>> > 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
>> > > How about sorting this includes? asm/irq.h go first followed linux/ in alphabatical order?
>> >
>> > There are a few compile warnings if I moved asm/irq.h to the top of
>> > all included files.
>>
>> The order that Murali meant is
>>
>> - first all linux/*.h headers, sorted alphabetically
>> - then all asm/*.h headers, again sorted alphabetically
>>
>> This is the recommended style in general.
>>
>> > Warning details are below:
>> >
>> > In file included from drivers/tty/serial/sprd_serial.c:14:0:
>> > ./arch/arm64/include/asm/irq.h:6:39: warning: ‘struct pt_regs’
>> > declared inside parameter list [enabled by default]
>> >  extern void (*handle_arch_irq)(struct pt_regs *);
>> >                                        ^
>> > ./arch/arm64/include/asm/irq.h:6:39: warning: its scope is only this
>> > definition or declaration, which is probably not what you want
>> > [enabled by default]
>> > ./arch/arm64/include/asm/irq.h:8:54: warning: ‘struct pt_regs’
>> > declared inside parameter list [enabled by default]
>> >  extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
>> >
>>
>> I would consider this a (minor) bug in asm/irq.h. If you don't mind,
>> please submit a patch to add a line with 'struct pt_regs;' to
>> asm/irq.h.
>
> A better question is: why is a modern driver using asm/irq.h in the
> first place.
>
> We used to include that file when platforms defined IRQ numbers
> statically, but modern platforms don't do that, so it shouldn't be
> required anymore.
>

OK, I see. I'll remove it in v4.

I'm very sorry that I didn't check it carefully enough and troubled
many people for this problem.
This file included the asm/irq.h before I revised it for upstreaming,
I also could not find this file was no longer needed to include.
Thank you for your reminder, I'll avoid making the same mistake, and
I'll also share my experience with my colleagues to keep them from
having this mistake in the future.

Best regards,
Chunyan
