Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbbAXTZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:25:49 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45781 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbbAXTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501242021210.5526@nanos>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
	<1421316574-10022-3-git-send-email-dbaryshkov@gmail.com>
	<alpine.DEB.2.11.1501241846540.5526@nanos>
	<CALT56yP+PGCnbUN0BB4QTQ6phxmqL43vRoS_rtoMrgfjAtr3Rw@mail.gmail.com>
	<alpine.DEB.2.11.1501242021210.5526@nanos>
Date: Sat, 24 Jan 2015 23:25:46 +0400
Message-ID: <CALT56yMLPWK6p3H+1=QAnb19GgZN3hbieXS8P3EANGfS2Ti1RQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: sa1100: use ioremapped memory to access SC registers
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-24 22:24 GMT+03:00 Thomas Gleixner <tglx@linutronix.de>:
> On Sat, 24 Jan 2015, Dmitry Eremin-Solenikov wrote:
>
>> 2015-01-24 20:48 GMT+03:00 Thomas Gleixner <tglx@linutronix.de>:
>> > On Thu, 15 Jan 2015, Dmitry Eremin-Solenikov wrote:
>> >>  static void sa1100_mask_irq(struct irq_data *d)
>> >>  {
>> >> -     ICMR &= ~BIT(d->hwirq);
>> >> +     u32 reg;
>> >> +     unsigned long flags;
>> >> +
>> >> +     raw_spin_lock_irqsave(&lock, flags);
>> >
>> > What's the exact point of that lock? And how is it related to the
>> > $subject of the patch?
>>
>> It is needed to protect ICMR register during RMW cycle, isn't it?
>
> The original code has no protection for the RMW either.
>
> And there is a simple reason for this. These functions are guaranteed
> to be called with interrupts disabled and this is a uniprocessor
> machine and it will never grow SMP support. So interrupts disabled is
> serialization enough.

OK, thanks for pointing. I'll update the patchset in a few days.

-- 
With best wishes
Dmitry
