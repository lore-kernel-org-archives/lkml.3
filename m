Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbaJ3PZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:25:31 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:50551 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508AbaJ3PZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:25:27 -0400
MIME-Version: 1.0
In-Reply-To: <1879572.mbc2eHiUuo@wuerfel>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
 <2294092.AHz8W66sEP@wuerfel> <alpine.DEB.2.11.1410301142010.5308@nanos> <1879572.mbc2eHiUuo@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Thu, 30 Oct 2014 08:25:03 -0700
Message-ID: <CAJiQ=7BZpDM8fxzJj_bSfHMuWTQ2eFerWkXz0inxJy9O6p4d=A@mail.gmail.com>
Subject: Re: [PATCH V2 02/15] sh: Eliminate unused irq_reg_{readl,writel} accessors
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 3:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 30 October 2014 11:43:00 Thomas Gleixner wrote:
>> On Thu, 30 Oct 2014, Arnd Bergmann wrote:
>>
>> > On Wednesday 29 October 2014 19:17:55 Kevin Cernekee wrote:
>> > > Defining these macros way down in arch/sh/.../irq.c doesn't cause
>> > > kernel/irq/generic-chip.c to use them.  As far as I can tell this code
>> > > has no effect.
>> > >
>> > > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
>> >
>> > Actually it overrides the 32-bit accessors with 16-bit accessors,
>> > which does seem intentional and certainly has an effect.
>>
>> Not really. Neither arch/sh/boards/mach-se/7343/irq.c nor
>> arch/sh/boards/mach-se/7722/irq.c actually use
>> irq_reg_readl/writel. They simply define it.
>
> Ah, that makes things easier. I looked at the commits that introduced
> them, and even then they were unused. Probably an artifact from an
> earlier version of the patch which did not get merged.

I suspect that the intention was to put them into the machine's
<irq.h> so that generic-chip.c would pick them up.  The sh irq.c files
do call ioread16/iowrite16 themselves, and like bcm7120-l2, they
utilize irq_gc_mask_{set,clr}_bit from generic-chip.c.

This may be something for the maintainers (Paul?) to double-check, but
if the submission worked as-is, maybe overriding the I/O accessors
wasn't actually needed.  Or maybe there are subtle and unfortunate
side effects on adjacent registers.
