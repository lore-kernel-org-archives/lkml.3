Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaCMLMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:12:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:49557 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaCMLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:12:45 -0400
Date: Thu, 13 Mar 2014 12:12:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: Hans de Goede <hdegoede@redhat.com>, linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 4/4] irqchip: sun4i: Use handle_fasteoi_late_irq for
 the ENMI (irq 0)
In-Reply-To: <20140313093457.GF2815@lukather>
Message-ID: <alpine.DEB.2.02.1403131212090.18573@ionos.tec.linutronix.de>
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com> <1394644627-12315-5-git-send-email-hdegoede@redhat.com> <20140313093457.GF2815@lukather>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Maxime Ripard wrote:

> On Wed, Mar 12, 2014 at 06:17:07PM +0100, Hans de Goede wrote:
> > The ENMI needs to have the ack done *after* clearing the interrupt source,
> > otherwise we will get a spurious interrupt for each real interrupt. Switch
> > to the new handle_fasteoi_late_irq handler which gives us the desired behavior.
> > 
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > ---
> >  drivers/irqchip/irq-sun4i.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
> > index 8a2fbee..4b1c874 100644
> > --- a/drivers/irqchip/irq-sun4i.c
> > +++ b/drivers/irqchip/irq-sun4i.c
> > @@ -77,15 +77,22 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
> >  static struct irq_chip sun4i_irq_chip = {
> >  	.name		= "sun4i_irq",
> >  	.irq_ack	= sun4i_irq_ack,
> > +	.irq_eoi	= sun4i_irq_ack, /* For the ENMI */
> 
> Hmmm, I wonder if that actually does something.
> 
> There's been a patch floating around that I was sure was merged, but
> apparently wasn't that remove sun4i_irq_ack, because the register we
> were writing to are in read only, and it wasn't doing anything.

Well, it looks like it does something otherwise Hans would not see any
improvement of the situation.

