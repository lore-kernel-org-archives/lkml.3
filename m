Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab3CNEHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:07:14 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:37921 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3CNEHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:07:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbTXoB_zf1axVaM89Uoxa-vXWwgEHv9nWU-jbo_P1pioA@mail.gmail.com>
References: <20130305003219.14792.13300.sendpatchset@w520>
	<CACRpkdbTXoB_zf1axVaM89Uoxa-vXWwgEHv9nWU-jbo_P1pioA@mail.gmail.com>
Date: Thu, 14 Mar 2013 13:07:10 +0900
Message-ID: <CANqRtoTFP+CycXJ-CNiFxN5iL14GTwpirs0p5HLFmeShAxvDJQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Mar 14, 2013 at 2:20 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Mar 5, 2013 at 1:32 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> +static int gpio_rcar_irq_set_type(struct irq_data *d, unsigned int type)
>> +{
>> +       struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
>> +       unsigned int hwirq = irqd_to_hwirq(d);
>> +
>> +       pr_debug("gpio: sense irq = %d, type = %d\n", hwirq, type);
>> +
>> +       switch (type & IRQ_TYPE_SENSE_MASK) {
>> +       case IRQ_TYPE_LEVEL_HIGH:
>> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, true, true);
>> +               break;
>> +       case IRQ_TYPE_LEVEL_LOW:
>> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, false, true);
>> +               break;
>> +       case IRQ_TYPE_EDGE_RISING:
>> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, true, false);
>> +               break;
>> +       case IRQ_TYPE_EDGE_FALLING:
>> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, false, false);
>> +               break;
>
> It is quite common to request IRQ on *both* rising and falling edges,
> what happens then?
>
> See <linux/irqs.h>
>         IRQ_TYPE_EDGE_RISING    = 0x00000001,
>         IRQ_TYPE_EDGE_FALLING   = 0x00000002,
>         IRQ_TYPE_EDGE_BOTH      = (IRQ_TYPE_EDGE_FALLING |
> IRQ_TYPE_EDGE_RISING),
>
> I guess then you get just rising edge...

I may be wrong, but the switch above does AND with IRQ_TYPE_SENSE_MASK
which makes me believe that the BOTH case will result in -EINVAL.

The -EINVAL is IMO correct here since the most basic version of this
GPIO block (used in r8a7779) does not suport BOTH edges. I've noticed
that newer versions of that GPIO hardware block has additional
registers where this can be selected. My plan is to submit an
incremental patch for such feature in the not so distant future.

> The rest I think is already covered by Laurent's comments.

Ok, thanks for your help!

/ magnus
