Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3ARSFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:05:54 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:25962 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507Ab3ARSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:05:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Tne1HbYEJEtApZbnkkkpU
Date: Fri, 18 Jan 2013 10:05:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Luciano Coelho <coelho@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130118180548.GR14149@atomide.com>
References: <20130117100510.GI10814@arwen.pp.htv.fi>
 <20130117100919.GJ10814@arwen.pp.htv.fi>
 <1358418917.6252.31.camel@cumari.coelho.fi>
 <50F7D535.6030205@ti.com>
 <20130117173131.GL14149@atomide.com>
 <1358445456.6252.64.camel@cumari.coelho.fi>
 <20130117231608.GP14149@atomide.com>
 <1358499533.6252.80.camel@cumari.coelho.fi>
 <20130118173635.GE15361@atomide.com>
 <20130118175408.GC1035@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118175408.GC1035@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130118 09:57]:
> Hi,
> 
> On Fri, Jan 18, 2013 at 09:36:35AM -0800, Tony Lindgren wrote:
> > * Luciano Coelho <coelho@ti.com> [130118 01:03]:
> > > On Thu, 2013-01-17 at 15:16 -0800, Tony Lindgren wrote:
> > > > * Luciano Coelho <coelho@ti.com> [130117 10:04]:
> > > > > But this patch is pretty small and simple, so why not include it to at
> > > > > least fix the breakage in 3.7 and 3.8? Whether you take it or not now
> > > > > won't make any difference in the 5k LOC in these kernel versions.
> > > > 
> > > > Well we are planning to drop the non-DT support for omap4 as soon as it's
> > > > usable with DT. For omap4 we are only carrying SDP and panda support to
> > > > make this transition easier. The only bindings missing AFAIK are wl12xx and
> > > > USB.
> > > 
> > > In my view this is a regression and it should be fixed with as simple a
> > > patch as possible.  The alternative to my solution is to revert the
> > > patch that removed the enable/disable from the ti-st driver *and* fix
> > > u-boot, because if it doesn't mux the UART2 pins properly (and it
> > > doesn't) the shared transport still won't work.
> > 
> > Fixing the muxing here makes sense naturally as we cannot do that in the driver
> > until we've flipped things over to use DT.
> > 
> > But I don't think we should fix the driver regression by adding more platform
> > callbacks as we are getting rid of them anyways.
> 
> it's not adding more callbacks, solely implementing them as it should
> have been done on Pavan's original patch.

It certainly is adding new callback functions to board-*.c files looking
at the diffstat :)

IMHO the right fix is to revert eccf2979 that caused the regression and then
adding the muxing to the board-*.c file(s).

It's OK for the driver to call the standard GPIO functions, and those will
be needed in the driver for the DT case anyways.

Regards,

Tony
