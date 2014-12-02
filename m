Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbaLBA2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:28:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45957 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaLBA2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:28:06 -0500
Date: Mon, 1 Dec 2014 18:27:59 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141202002758.GC24551@ti.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com>
 <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141201163639.GI25249@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141201163639.GI25249@lukather>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Mon [2014-Dec-01 17:36:39 +0100]:
> Hi,
> 
> On Fri, Nov 28, 2014 at 04:30:01PM +0900, Alexandre Courbot wrote:
> > > +/**
> > > + * do_gpio_hog - Given node is a GPIO hog configuration, handle it
> > > + * @np:                device node to get GPIO from
> > > + *
> > > + * This is only used by of_gpiochip_add to request/set GPIO initial
> > > + * configuration.
> > > + */
> > > +static int do_gpio_hog(struct device_node *np)
> > > +{
> > > +       struct gpio_desc *desc = NULL;
> > > +       int err;
> > > +       const char *name;
> > > +       enum gpio_lookup_flags lflags;
> > > +       enum gpiod_flags dflags;
> > > +
> > > +       desc = of_get_gpio_hog(np, &name, &lflags, &dflags);
> > > +       if (!desc)
> > > +               return -ENOTSUPP;
> > > +       else if (IS_ERR(desc))
> > > +               return PTR_ERR(desc);
> > > +
> > > +       err = gpiod_request(desc, name);
> > 
> > Using this function means that a GPIO chip module cannot be unloaded
> > if it uses GPIO hogs. Is it the intended behavior? If not, please use
> > gpiochip_request_own_desc() instead, and make sure to call
> > gpiochip_free_own_desc() for each hog when the driver is unloaded.
> 
> The only thing I'd like to have would be that the request here would
> be non-exclusive, so that a later driver would still be allowed later
> on to request that GPIO later on and manage it itself (ideally using
> the usual gpiod_request function).

I'll let Linus chime in on this.
But the premise for the hogging mechanism is to have a mechanism to set GPIOs
which do not need to be requested by any other entity.
If a driver needs access to a specific GPIO then it should use the existing
gpiolib API to request it and set it up.

> 
> Maxime
> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

Regards,
Benoit
