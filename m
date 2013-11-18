Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3KRD6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 22:58:25 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42606 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3KRD6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 22:58:18 -0500
Date: Sun, 17 Nov 2013 19:58:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-input@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] Input: twl4030-keypad - add device tree support
Message-ID: <20131118035815.GA3311@core.coreip.homeip.net>
References: <1383948866-32672-1-git-send-email-sre@debian.org>
 <1383948866-32672-2-git-send-email-sre@debian.org>
 <20131111221941.GB23331@amd.pavel.ucw.cz>
 <20131112032506.GA30028@earth.universe>
 <20131117182840.GA30012@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131117182840.GA30012@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 07:28:40PM +0100, Pavel Machek wrote:
> Hi!
> 
> > On Mon, Nov 11, 2013 at 11:19:41PM +0100, Pavel Machek wrote:
> > > > +	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
> > > > +		keypad_data->no_autorepeat = true;
> > > 
> > > From 2/2:
> > > 
> > > +Optional Properties specific to linux:
> > > +- linux,keypad-no-autorepeat: do not enable autorepeat feature.
> > > 
> > > I'm confused now.
> > 
> > good catch! That happens when one tries to mimic other drivers :/
> > 
> > I just checked all DT input drivers for autorepeat keyword:
> > 
> > DRIVER              CODE                        DOCUMENTATION
> > twl4030-keypad      linux,input-no-autorepeat   linux,keypad-no-autorepeat
> > omap4-keypad        linux,input-no-autorepeat   linux,keypad-no-autorepeat
> > samsung-keypad      linux,input-no-autorepeat   linux,keypad-no-autorepeat
> > stmpe-keypad        st,no-autorepeat            st,no-autorepeat
> > spear-keyboard      autorepeat                  autorepeat
> > tca8418-keypad      keypad,autorepeat           --- not documented ---
> > gpio-matrix-keypad  linux,no-autorepeat         linux,no-autorepeat
> > gpio-keys-polled    autorepeat                  autorepeat
> > gpio-keys           autorepeat                  --- no documentation ---
> > 
> > Any suggestions how to continue fixing this mess? I guess first of
> > all the documentation of omap4-keypad, samsung-keypad and of course
> > the new twl4030-keypad driver should be fixed.
> > 
> > Next it would be nice to choose one standard property name for this
> > and use it for twl4030-keypad. I suggest to use "linux,input-no-autorepeat".
> 
> I'd suggest just simple "autorepeat", so that we get rid of ugly double-negation.

The idea was that majority of setups want autorepeat so in the absence
of the property autorepeat is turned on.

Thanks.

-- 
Dmitry
