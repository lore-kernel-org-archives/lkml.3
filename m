Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3KSMug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:50:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56249 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3KSMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:50:33 -0500
Date: Tue, 19 Nov 2013 13:50:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] Input: twl4030-keypad - add device tree support
Message-ID: <20131119125031.GA14587@amd.pavel.ucw.cz>
References: <1383948866-32672-1-git-send-email-sre@debian.org>
 <1383948866-32672-2-git-send-email-sre@debian.org>
 <20131111221941.GB23331@amd.pavel.ucw.cz>
 <20131112032506.GA30028@earth.universe>
 <20131117182840.GA30012@xo-6d-61-c0.localdomain>
 <20131118035815.GA3311@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118035815.GA3311@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > DRIVER              CODE                        DOCUMENTATION
> > > twl4030-keypad      linux,input-no-autorepeat   linux,keypad-no-autorepeat
> > > omap4-keypad        linux,input-no-autorepeat   linux,keypad-no-autorepeat
> > > samsung-keypad      linux,input-no-autorepeat   linux,keypad-no-autorepeat
> > > stmpe-keypad        st,no-autorepeat            st,no-autorepeat
> > > spear-keyboard      autorepeat                  autorepeat
> > > tca8418-keypad      keypad,autorepeat           --- not documented ---
> > > gpio-matrix-keypad  linux,no-autorepeat         linux,no-autorepeat
> > > gpio-keys-polled    autorepeat                  autorepeat
> > > gpio-keys           autorepeat                  --- no documentation ---
> > > 
> > > Any suggestions how to continue fixing this mess? I guess first of
> > > all the documentation of omap4-keypad, samsung-keypad and of course
> > > the new twl4030-keypad driver should be fixed.
> > > 
> > > Next it would be nice to choose one standard property name for this
> > > and use it for twl4030-keypad. I suggest to use "linux,input-no-autorepeat".
> > 
> > I'd suggest just simple "autorepeat", so that we get rid of ugly double-negation.
> The idea was that majority of setups want autorepeat so in the absence
> of the property autorepeat is turned on.

I see... but autorepeat on by default makes sense on devices that are
usually querty keybaords, but does not make sense on devices that are
usually phone keypads or power buttons.

So my proposal is:

1) driver decides if it makes sense to autorepeat by default or not.

2) dts says autorepeat=0 or autorepeat=1

That way, we get dts that get chance to work on other OSes, get rid of
double negations, and get right defaults when autorepeat is not
specified.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
