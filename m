Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3KNCRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:17:24 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:38477 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KNCRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:17:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Subject: Re: [PATCH 01/03] gpio: rcar: Use lazy disable and mask on suspend
Date: Thu, 14 Nov 2013 03:17:57 +0100
Message-ID: <4743540.rTIWauTJHg@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CANqRtoR+ngS5o77Lw1gUUzq-qcHuBZtfiiAnALvH_GsNMvNN7A@mail.gmail.com>
References: <20131113225927.21449.78044.sendpatchset@w520> <1906707.rpHAsqdqKq@avalon> <CANqRtoR+ngS5o77Lw1gUUzq-qcHuBZtfiiAnALvH_GsNMvNN7A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Thursday 14 November 2013 11:03:06 Magnus Damm wrote:
> On Thu, Nov 14, 2013 at 9:07 AM, Laurent Pinchart wrote:
> > On Thursday 14 November 2013 07:59:36 Magnus Damm wrote:
> >> From: Magnus Damm <damm@opensource.se>
> >> 
> >> Set the ->irq_enable() and ->irq_disable() methods to NULL
> >> to enable lazy disable of interrupts.
> > 
> > Is that just for optimization purpose, or is there another reason ?
> 
> It is needed for IRQCHIP_MASK_ON_SUSPEND operation, which in turn is
> needed for Suspend-to-RAM.
> 
> >> Also extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells the core
> >> that only IRQs marked as wakeups need to stay enabled during
> >> Suspend-to-RAM.
> >
> > Shouldn't this be split to a separate patch ?
> 
> I could split them up, but since there is a dependency and since I
> mainly care about making sure Suspend-to-RAM works I preferred to keep
> them together.

Fine with me. Could you then please update the commit message to mention that 
lazy disabling is required for IRQCHIP_MASK_ON_SUSPEND ? Same comment for 
patch 03/03.

> >> Tested on the Lager board with GPIO-keys and Suspend-to-RAM.
> >> 
> >> Signed-off-by: Magnus Damm <damm@opensource.se>
> >> ---
> >> 
> >>  drivers/gpio/gpio-rcar.c |    3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >> 
> >> --- 0001/drivers/gpio/gpio-rcar.c
> >> +++ work/drivers/gpio/gpio-rcar.c     2013-11-13 19:26:26.000000000 +0900
> >> @@ -368,10 +368,9 @@ static int gpio_rcar_probe(struct platfo
> >>       irq_chip->name = name;
> >>       irq_chip->irq_mask = gpio_rcar_irq_disable;
> >>       irq_chip->irq_unmask = gpio_rcar_irq_enable;
> >> -     irq_chip->irq_enable = gpio_rcar_irq_enable;
> >> -     irq_chip->irq_disable = gpio_rcar_irq_disable;
> >>       irq_chip->irq_set_type = gpio_rcar_irq_set_type;
> >>       irq_chip->flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED;
> >> +     irq_chip->flags |= IRQCHIP_MASK_ON_SUSPEND;
> > 
> > You can write it as
> > 
> >         irq_chip->flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED
> >                         | IRQCHIP_MASK_ON_SUSPEND;
> 
> I know. =) If that's the preferred way then..

-- 
Regards,

Laurent Pinchart

