Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3LJMdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:33:08 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34990 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3LJMdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:33:04 -0500
MIME-Version: 1.0
In-Reply-To: <201312061814.15730.arnd@arndb.de>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	<201312060140.10376.arnd@arndb.de>
	<1386347911.7152.70.camel@host5.omatika.ru>
	<201312061814.15730.arnd@arndb.de>
Date: Tue, 10 Dec 2013 13:33:03 +0100
Message-ID: <CACRpkdYF-O6Qgjue6x+R6fVuSXSyO4YHw1meusuyQhtSA9PnvQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sergei Ianovich <ynvich@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>, Daniel Mack <zonque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 6:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 06 December 2013, Sergei Ianovich wrote:
>> On Fri, 2013-12-06 at 01:40 +0100, Arnd Bergmann wrote:
>>
>> > > +
>> > > +static struct irq_chip lp8x4x_irq_chip = {
>> > > +     .name                   = "FPGA",
>> > > +     .irq_ack                = lp8x4x_ack_irq,
>> > > +     .irq_mask               = lp8x4x_mask_irq,
>> > > +     .irq_unmask             = lp8x4x_unmask_irq,
>> > > +};
>> >
>> > Please try to move the irqchip code to drivers/irqchip/.
>>
>> CONFIG_IRQCHIP depends on CONFIG_OF_IRQ which in turn depends on Open
>> Firmware.
>
> Hmm, I wonder if we should try to change Kconfig then. Let's leave it
> alone for now, maybe Linus Walleij has some comments since he has
> been looking into moving drivers out in the past.

I don't get this, if the subarch has deps in place for IRQCHIP and
OF_IRQ just move the implementation to drivers/irqchip/foo.c
edit drivers/irqchip/Makefile to compile the file for ARCH_FOO.
What would the problem be? It's not like having the irqchip in the
object is optional...

I would prefer if you augment the code to use
IRQCHIP_DECLARE() so you can get rid of all the criss-cross
calls, but this init contains a comment saying that GPIO
has to be up before you initialize the irq_chip, can you please
explain why it's like that?

Another way is to create a separate Kconfig entry for it in
drivers/irqchip/Kconfig if you want the set-up to be more
distributed, but that is usually just done when the irqchip is
used on more than one platform.

Yours,
Linus Walleij
