Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3LPVFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:05:19 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19987 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039Ab3LPVFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:05:17 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 64.17.244.34
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+QIcqRTVJ0pR0vvFxWO9uN
Date: Mon, 16 Dec 2013 13:05:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] regulator: Start using standard gpios property and
 deprecate some custom properties
Message-ID: <20131216210512.GF26293@atomide.com>
References: <1386965234-26461-1-git-send-email-tony@atomide.com>
 <20131216183615.GK3185@sirena.org.uk>
 <20131216194023.GE26293@atomide.com>
 <20131216201102.GP3185@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216201102.GP3185@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@kernel.org> [131216 12:12]:
> On Mon, Dec 16, 2013 at 11:40:23AM -0800, Tony Lindgren wrote:
> > * Mark Brown <broonie@kernel.org> [131216 10:37]:
> 
> > > If the issue is typos then I'm not convinced that for singular GPIOs
> > > it's going to be helpful, either way is prone to typos.  If the problem
> > > is error reporting then that seems like a more important thing to fix.
> 
> > Are you serious? A typo here in the binding leads to silent errors where
> > nothing happens with the GPIO. That's just totally messed up considering
> > we use "gpios" instead of "gpio" everywhere else. So both "gpio" and
> > "gpios" should be parsed for sure.
> 
> This is the first time anyone's mentioned this so it probably isn't that
> serious an issue and bear in mind that the patch was also handling all
> the named GPIO specifiers too.

I've certainly debugged this same exact issue twice already and that
probably means that same issue has been debugged tens or hundreds
of times by other people.

For the other random named GPIO properties, I don't frankly care, that's
really not my problem.

Personally I don't see any value for a regulator describing the names of
the GPIOs in the binding, it's really up to the driver to make sense of
them. Especially if there are one or more similar GPIOs. We're not
naming interrupts either.

> In any case, the thing is that there's a difference between parsing both
> and deprecation - deprecation implies an intention to remove the old one
> which would just reintroduce the problem the other way around since
> people are likely to drop or forget the plural, use old DTs and so on.
> Adding a gpios property in parallel with plain gpio is fine and what I
> was mostly suggesting.

Deprecation _may_ imply that it will get removed, but not always.
Naturally we're going to have to keep the old bindings in place since
they were merged. I can changed that to obsoleted if that's any better.
 
> > > To be honest I'm also struggling to summon up the enthusiasm for the
> > > churn in the bindings, especially without going through and updating all
> > > the boards (and all the other GPIO properties in various DTs).  It seems
> > > like there's stuff missing in the helpers here, if we really wanted to
> > > force the properties to have -gpios on the end of their names then we
> > > should've had that being added by the helpers.
> 
> > Sounds like exposing an infinite number of random *-gpio and *-gpios
> > bindings is a topic for another discussion. Anyways it's already totally
> > out of control so what do I care.
> 
> Exactly, I think it's way more trouble than it's worth to try to change
> for named single element lists.  The standard property makes more sense.

I don't think there should be any named GPIOs. If we want names, then
the GPIO usage should be possible to group quite easily rather than create
a new property for everything. Something like "enable-gpio" comes to mind.
 
> The root of the issue is that the GPIO binding originally said that
> everything should use a single gpios property for everything but that's
> got usability issues.  The attempt to require a -gpios suffix was a
> later addition but it was just put into the binding with no real effort
> to propagate it through integration with the helpers or whatever.

There may still be a case for naming of some of the GPIOs, but usually
the order of GPIOs should be enough for the driver to know the meaning
of the GPIO.

Regards,

Tony
