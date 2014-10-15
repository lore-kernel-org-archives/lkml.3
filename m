Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaJOGzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:55:40 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38065 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140926091805.GV1786@lahna.fi.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1410943745-9354-4-git-send-email-rebecca.swee.fun.chang@intel.com>
	<20140918113122.GO10854@lahna.fi.intel.com>
	<50B33AC5ED75F74F991980326F1C438D0FBE89AD@PGSMSX108.gar.corp.intel.com>
	<20140926091805.GV1786@lahna.fi.intel.com>
Date: Wed, 15 Oct 2014 08:55:37 +0200
Message-ID: <CACRpkdaP_kRPLCyVATPN9LjnwNqBEf2-fDqHUqjxdS2aBt1Ljw@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: sch: Enable IRQ support for Quark X1000
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:18 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Fri, Sep 26, 2014 at 09:14:48AM +0000, Chang, Rebecca Swee Fun wrote:

>> > > +
>> > > +         /* disable interrupts */
>> > > +         sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
>> > > +
>> > > +         err = request_irq(sch->irq_num, sch_gpio_irq_handler,
>> > > +                           IRQF_SHARED, KBUILD_MODNAME, sch);
>> >
>> > This seems weird, typically irqchip drivers don't call request_irq() directly but
>> > instead irq_set_chained_handler() or similar. With
>> > gpiochip_irqchip_* stuff you don't need even that.
>> >
>> Regarding this, gpio-sch is actually using shared interrupts and the
>> IRQ resources are from ACPI SCI. As per my understanding, resources
>> from ACPI SCI might be shared for power management purposes. In this
>> case, irq_set_chained_handler() might not be able to use here. What do
>> you think?
>
> I think you are right. And then you can't use gpiochip_irqchip_* helpers
> either :-(

No since that implies that the gpiochip lives in its own irqdomain,
and this driver uses a linear range of irqs provided from another
domain, just allocates descriptors for them.

I'll take a look at this and see if it's merge material now.

Yours,
Linus Walleij
