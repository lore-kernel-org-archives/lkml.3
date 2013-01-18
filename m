Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3ARTWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:22:19 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:60567 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751815Ab3ARTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:22:17 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Hrr5PMecuIae5K8pmTO76
Date: Fri, 18 Jan 2013 11:22:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, balbi@ti.com,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130118192211.GT14149@atomide.com>
References: <20130117100510.GI10814@arwen.pp.htv.fi>
 <20130117100919.GJ10814@arwen.pp.htv.fi>
 <1358418917.6252.31.camel@cumari.coelho.fi>
 <50F7D535.6030205@ti.com>
 <20130117173131.GL14149@atomide.com>
 <1358445456.6252.64.camel@cumari.coelho.fi>
 <20130117231608.GP14149@atomide.com>
 <1358499533.6252.80.camel@cumari.coelho.fi>
 <20130118173635.GE15361@atomide.com>
 <1358536096.6252.121.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358536096.6252.121.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho <coelho@ti.com> [130118 11:12]:
> On Fri, 2013-01-18 at 09:36 -0800, Tony Lindgren wrote:
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
> Okay, you're right.  We need at least to pass the GPIO number from the
> board file to the driver so that it knows what to switch.  This is also
> something that it will need from DT in the future.

Yes I agree, the GPIO number needs to be passed in the fix. 
 
> > > > If we add this, then it implies we're somehow supporting it, which is not
> > > > the way to go IMHO as we need to get rid of these platform callbacks instead.
> > > 
> > > It's a regression fix, not a new feature.  I also think these callbacks
> > > are silly, but it's the quickest solution I found for 3.7 and 3.8.
> > 
> > Right, so how about let's fix the regression in the driver, and add the
> > muxing to platform init code? 
> 
> Agreed.  I'll cook up a patch to revert the changes in eccf2979 (it
> doesn't revert cleanly) and change the panda board file to do the muxing
> and set the gpio number in the pdata for the driver to use.

OK thanks. 
  
> > > > What's your estimate of having minimal wl12xx WLAN DT binding available?
> > > 
> > > To tell you the truth, I haven't even started looking into DT for wl12xx
> > > myself.  So I have no idea when it will be ready.  Benoit has been
> > > looking into it, but I don't know how far he is.
> > 
> > If it's going to take long we should just init the platform data for
> > it temporarily even in the DT boot case until the binding is available.
> 
> I'll start looking into this now.  It's not going to be that simple, I'm
> sure, but I need to look more into DT in general to be able to say
> something more accurate.  I'll let you know as soon as I know more. :)

OK thanks!

Tony
