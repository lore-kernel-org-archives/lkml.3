Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab3LJUUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:20:25 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:63711 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3LJUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:20:23 -0500
Message-ID: <1386706817.7152.254.camel@host5.omatika.ru>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>, Daniel Mack <zonque@gmail.com>
Date: Wed, 11 Dec 2013 00:20:17 +0400
In-Reply-To: <CACRpkdYF-O6Qgjue6x+R6fVuSXSyO4YHw1meusuyQhtSA9PnvQ@mail.gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <201312060140.10376.arnd@arndb.de>
	 <1386347911.7152.70.camel@host5.omatika.ru>
	 <201312061814.15730.arnd@arndb.de>
	 <CACRpkdYF-O6Qgjue6x+R6fVuSXSyO4YHw1meusuyQhtSA9PnvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 13:33 +0100, Linus Walleij wrote:
> On Fri, Dec 6, 2013 at 6:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 06 December 2013, Sergei Ianovich wrote:
> >> On Fri, 2013-12-06 at 01:40 +0100, Arnd Bergmann wrote:
> >>
> >> > > +
> >> > > +static struct irq_chip lp8x4x_irq_chip = {
> >> > > +     .name                   = "FPGA",
> >> > > +     .irq_ack                = lp8x4x_ack_irq,
> >> > > +     .irq_mask               = lp8x4x_mask_irq,
> >> > > +     .irq_unmask             = lp8x4x_unmask_irq,
> >> > > +};
> >> >
> >> > Please try to move the irqchip code to drivers/irqchip/.
> >>
> >> CONFIG_IRQCHIP depends on CONFIG_OF_IRQ which in turn depends on Open
> >> Firmware.
> >
> > Hmm, I wonder if we should try to change Kconfig then. Let's leave it
> > alone for now, maybe Linus Walleij has some comments since he has
> > been looking into moving drivers out in the past.
> 
> I don't get this, if the subarch has deps in place for IRQCHIP and
> OF_IRQ just move the implementation to drivers/irqchip/foo.c
> edit drivers/irqchip/Makefile to compile the file for ARCH_FOO.
> What would the problem be? It's not like having the irqchip in the
> object is optional...

This chip is used only of one machine and only required for
machine-special devices. If those devices are not selected, the chip
will just waist memory.

> I would prefer if you augment the code to use
> IRQCHIP_DECLARE() so you can get rid of all the criss-cross
> calls, but this init contains a comment saying that GPIO
> has to be up before you initialize the irq_chip, can you please
> explain why it's like that?

This is a tertiary irq chip (primary is on CPU, secondary is GPIO). It
triggers a GPIO interrupt if it detects one of its own.

> Another way is to create a separate Kconfig entry for it in
> drivers/irqchip/Kconfig if you want the set-up to be more
> distributed, but that is usually just done when the irqchip is
> used on more than one platform.

Please consult, how to approach this driver using device tree. If I
assign an "interrupts" property in the node, and the property will point
to pxa-gpio interrupt controller using a phandle, is there a guaranty
that my device will be probed later than pxa-gpio interrupt controller?

Or how could that be achieved?

