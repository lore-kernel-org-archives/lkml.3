Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaAMKVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:21:01 -0500
Received: from smtp-69.nebula.fi ([83.145.220.69]:40128 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214AbaAMKVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:21:00 -0500
Date: Mon, 13 Jan 2014 12:20:07 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH v5] video: add OpenCores VGA/LCD framebuffer driver
Message-ID: <20140113102006.GA30877@chokladfabriken.org>
References: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <52D3A1FC.4090706@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D3A1FC.4090706@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:21:16AM +0200, Tomi Valkeinen wrote:
> On 2014-01-10 22:13, Stefan Kristiansson wrote:
> > This adds support for the VGA/LCD core available from OpenCores:
> > http://opencores.org/project,vga_lcd
> > 
> > The driver have been tested together with both OpenRISC and
> > ARM (socfpga) processors.
> > 
> > Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> 
> > +/*
> > + * Init and exit routines
> > + */
> > +static int __init ocfb_init(void)
> > +{
> > +#ifndef MODULE
> > +	char *option = NULL;
> > +
> > +	if (fb_get_options("ocfb", &option))
> > +		return -ENODEV;
> > +	ocfb_setup(option);
> > +#endif
> > +	return platform_driver_register(&ocfb_driver);
> > +}
> 
> I see this is how fb_get_options is used elsewhere also, but shouldn't
> fb_get_options be called with a name that's somehow device specific? I
> haven't used it in omapfb, so maybe I'm missing how it is supposed to
> work, but if I'm not mistaken, if you have two ocfb devices on your
> board, there's no way to specify individual modes for them. Even the
> Documentation/fb/modedb.txt gives an example of a "VGA-1" which sounds
> to me that it has been designed to be used with some kind of device id.
> 
> Although even if the above code handled the different devices, when
> loading this as a module would still not work right as that code is not
> called at all in the module case. Ah, well. I guess this is legacy
> stuff, and it's just the way it works.
> 

Yes, I can't really figure out how that would be handled neither.

> The subject says this is a VGA/LCD driver. Usually with LCD, the LCD
> video timings are passed via device tree or platform data, as there's
> just one possible set of timings for a board. Is that something that
> you've thought about, or is the user always supposed to give the timings
> explicitly via kernel cmdline?
> 

The VGA/LCD in the subject comes from the name of the core,
the core itself presents a "vga-type" interface, but it can basically
be hooked up to any type of display (with a bit of glue-logic in some cases).

That said - the reason why I went for the mode_options solution in the
first place, is that when I initially wrote this driver
(>2 years ago, time flies...) the display-timing device-tree bindings weren't
invented yet, so it seemed like the most viable option without coming up
with custom device-tree bindings.

It's completely possible that this design choice should be revised now,
and I wouldn't mind converting this driver to make use of the display-timing
dt properties if you think that's a good idea?

Stefan
