Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036Ab3LJAGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:06:09 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32951 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743Ab3LJAGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:06:06 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.236.217
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19pwq86ECaGzB0bdvWBiWCx
Date: Mon, 9 Dec 2013 16:06:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation: dt: Document TSC2005 DT binding
Message-ID: <20131210000600.GC13171@atomide.com>
References: <1386284979-9680-1-git-send-email-sre@debian.org>
 <1386284979-9680-3-git-send-email-sre@debian.org>
 <20131209174638.GC12527@atomide.com>
 <20131209182409.GA7626@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209182409.GA7626@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131209 10:25]:
> On Mon, Dec 09, 2013 at 09:46:38AM -0800, Tony Lindgren wrote:
> > > +Optional properties:
> > > + - ti,fuzz-x		      : integer, X noise value of the touchscreen
> > > +				(defaults to 4)
> > > + - ti,fuzz-y		      : integer, Y noise value of the touchscreen
> > > +				(defaults to 8)
> > > + - ti,fuzz-pressure	      : integer, pressure noise value of the touchscreen
> > > +				(defaults to 2)
> > > + - ti,max-x		      : integer, maximum reported x value
> > > +				(defaults to 4096)
> > > + - ti,max-y		      : integer, maximum reported y value
> > > +				(defaults to 4096)
> > > + - ti,max-pressure	      : integer, maximum reported pressure
> > > +				(defaults to 4096)
> > > + - ti,x-plate-resistance      : integer, resistance of the touchscreen's X plates
> > > +				in ohm (defaults to 280)
> > > + - ti,esd-recovery-timeout-ms : integer, if the touchscreen does not respond after
> > > +				the configured time (in milli seconds), the driver
> > > +				will reset it. This is disabled by default.
> > 
> > Instead of adding these optional ti,* properties you can set them in the
> > driver directly in the of_match table based on the compatible flag. Then
> > you can pass compatible flag like ti,tsc2005-nokia-n900, or the name of
> > the LCD panel. Most likely these depend on the LCD panel selected.
> 
> I could certainly do this, but it would move the board specific data
> from the boardcode into the driver. That looks contra-productive to
> me. Is there a good reason to do it this way?

You can leave out the custom properties that way for something that probably
should be grouped by the touchpanel type connected as the values are the
same.

So for example just a few compatible flags like ti,tsc2005-panel-abc and
ti,tsc2005-panel-xyz we could potentially cover all the configurations
we're aware of without any need for custom properties. And this is way
easier to support in the long run assuming we don't end up with tons of
compatible flags. Of course if we end up with a new compatible flag for
each configuration, then it makes sense to set up the custom properties,
but I doubt that's the case here.

Regards,

Tony
