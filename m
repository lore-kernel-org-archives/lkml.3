Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3CFBkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:40:39 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38880 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3CFBkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:40:36 -0500
Date: Wed, 6 Mar 2013 09:40:28 +0800
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: musb: ux500: add otg notifier support
Message-ID: <20130306014028.GA11205@balto.lan>
References: <1362047934-22337-1-git-send-email-fabio.baltieri@linaro.org>
 <1362047934-22337-4-git-send-email-fabio.baltieri@linaro.org>
 <20130304143810.GJ3397@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304143810.GJ3397@arwen.pp.htv.fi>
X-Operating-System: Linux balto 3.8.0-09633-g2a7d2b9 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

On Mon, Mar 04, 2013 at 04:38:10PM +0200, Felipe Balbi wrote:
> On Thu, Feb 28, 2013 at 11:38:52AM +0100, Fabio Baltieri wrote:
> > Add transceiver notifier event handling to the ux500 driver to set vbus
> > on specific transceiver events.
> > 
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
> >  drivers/usb/musb/ux500.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> > 
> > diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
> > index 5b742ba..b20326bb 100644
> > --- a/drivers/usb/musb/ux500.c
> > +++ b/drivers/usb/musb/ux500.c
> > @@ -98,6 +98,36 @@ static void ux500_musb_set_vbus(struct musb *musb, int is_on)
> >  		musb_readb(musb->mregs, MUSB_DEVCTL));
> >  }
> >  
> > +static int musb_otg_notifications(struct notifier_block *nb,
> > +		unsigned long event, void *unused)
> > +{
> > +	struct musb *musb = container_of(nb, struct musb, nb);
> > +
> > +	dev_dbg(musb->controller, "musb_otg_notifications %ld %s\n",
> > +			event, otg_state_string(musb->xceiv->state));
> > +
> > +	switch (event) {
> > +	case USB_EVENT_ID:
> > +		dev_dbg(musb->controller, "ID GND\n");
> > +		ux500_musb_set_vbus(musb, 1);
> > +		break;
> > +	case USB_EVENT_VBUS:
> > +		dev_dbg(musb->controller, "VBUS Connect\n");
> 
> are you sure this is correct ? you're not doing anything in case of
> vbus event. Shouldn't you make sure your vbus is off ?

The implementation I'm taking as reference for this patches does not do
anything on VBUS event and as I can see from commmit history, it has
been based on the omap2430 one, that in turns used to just run phy_init
- and that's not implemented.  But...

> What if your user uses a non-standard cable which has id-pin grounded
> on both sides ?

A cable with two micro/mini connectors with grounded IDs?  Did you ever
encountered such a thing?  I guess a ux500_musb_set_vbus(musb, 0) would
not hurt in that case.

Fabio

-- 
Fabio Baltieri
