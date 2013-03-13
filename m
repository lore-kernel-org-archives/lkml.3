Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab3CMRUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:20:34 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52317 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab3CMRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:20:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130305003219.14792.13300.sendpatchset@w520>
References: <20130305003219.14792.13300.sendpatchset@w520>
Date: Wed, 13 Mar 2013 18:20:32 +0100
Message-ID: <CACRpkdbTXoB_zf1axVaM89Uoxa-vXWwgEHv9nWU-jbo_P1pioA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 1:32 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> +static int gpio_rcar_irq_set_type(struct irq_data *d, unsigned int type)
> +{
> +       struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
> +       unsigned int hwirq = irqd_to_hwirq(d);
> +
> +       pr_debug("gpio: sense irq = %d, type = %d\n", hwirq, type);
> +
> +       switch (type & IRQ_TYPE_SENSE_MASK) {
> +       case IRQ_TYPE_LEVEL_HIGH:
> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, true, true);
> +               break;
> +       case IRQ_TYPE_LEVEL_LOW:
> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, false, true);
> +               break;
> +       case IRQ_TYPE_EDGE_RISING:
> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, true, false);
> +               break;
> +       case IRQ_TYPE_EDGE_FALLING:
> +               gpio_rcar_config_interrupt_input_mode(p, hwirq, false, false);
> +               break;

It is quite common to request IRQ on *both* rising and falling edges,
what happens then?

See <linux/irqs.h>
        IRQ_TYPE_EDGE_RISING    = 0x00000001,
        IRQ_TYPE_EDGE_FALLING   = 0x00000002,
        IRQ_TYPE_EDGE_BOTH      = (IRQ_TYPE_EDGE_FALLING |
IRQ_TYPE_EDGE_RISING),

I guess then you get just rising edge...


> +       default:
> +               return -EINVAL;
> +       }
> +       return 0;
> +}

(...)

The rest I think is already covered by Laurent's comments.

Yours,
Linus Walleij
