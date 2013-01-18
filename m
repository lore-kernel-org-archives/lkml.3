Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3ARTJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:09:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45751 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3ARTJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:09:18 -0500
Message-ID: <1358536096.6252.121.camel@cumari.coelho.fi>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
From: Luciano Coelho <coelho@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Fri, 18 Jan 2013 21:08:16 +0200
In-Reply-To: <20130118173635.GE15361@atomide.com>
References: <20130117093417.GH10814@arwen.pp.htv.fi>
	 <50F7CA82.4050509@ti.com> <20130117100510.GI10814@arwen.pp.htv.fi>
	 <20130117100919.GJ10814@arwen.pp.htv.fi>
	 <1358418917.6252.31.camel@cumari.coelho.fi> <50F7D535.6030205@ti.com>
	 <20130117173131.GL14149@atomide.com>
	 <1358445456.6252.64.camel@cumari.coelho.fi>
	 <20130117231608.GP14149@atomide.com>
	 <1358499533.6252.80.camel@cumari.coelho.fi>
	 <20130118173635.GE15361@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 09:36 -0800, Tony Lindgren wrote:
> * Luciano Coelho <coelho@ti.com> [130118 01:03]:
> > On Thu, 2013-01-17 at 15:16 -0800, Tony Lindgren wrote:
> > > * Luciano Coelho <coelho@ti.com> [130117 10:04]:
> > > > But this patch is pretty small and simple, so why not include it to at
> > > > least fix the breakage in 3.7 and 3.8? Whether you take it or not now
> > > > won't make any difference in the 5k LOC in these kernel versions.
> > > 
> > > Well we are planning to drop the non-DT support for omap4 as soon as it's
> > > usable with DT. For omap4 we are only carrying SDP and panda support to
> > > make this transition easier. The only bindings missing AFAIK are wl12xx and
> > > USB.
> > 
> > In my view this is a regression and it should be fixed with as simple a
> > patch as possible.  The alternative to my solution is to revert the
> > patch that removed the enable/disable from the ti-st driver *and* fix
> > u-boot, because if it doesn't mux the UART2 pins properly (and it
> > doesn't) the shared transport still won't work.
> 
> Fixing the muxing here makes sense naturally as we cannot do that in the driver
> until we've flipped things over to use DT.
> 
> But I don't think we should fix the driver regression by adding more platform
> callbacks as we are getting rid of them anyways.

Okay, you're right.  We need at least to pass the GPIO number from the
board file to the driver so that it knows what to switch.  This is also
something that it will need from DT in the future.


> > > If we add this, then it implies we're somehow supporting it, which is not
> > > the way to go IMHO as we need to get rid of these platform callbacks instead.
> > 
> > It's a regression fix, not a new feature.  I also think these callbacks
> > are silly, but it's the quickest solution I found for 3.7 and 3.8.
> 
> Right, so how about let's fix the regression in the driver, and add the
> muxing to platform init code? 

Agreed.  I'll cook up a patch to revert the changes in eccf2979 (it
doesn't revert cleanly) and change the panda board file to do the muxing
and set the gpio number in the pdata for the driver to use.

 
> > > What's your estimate of having minimal wl12xx WLAN DT binding available?
> > 
> > To tell you the truth, I haven't even started looking into DT for wl12xx
> > myself.  So I have no idea when it will be ready.  Benoit has been
> > looking into it, but I don't know how far he is.
> 
> If it's going to take long we should just init the platform data for
> it temporarily even in the DT boot case until the binding is available.

I'll start looking into this now.  It's not going to be that simple, I'm
sure, but I need to look more into DT in general to be able to say
something more accurate.  I'll let you know as soon as I know more. :)

--
Cheers,
Luca.

