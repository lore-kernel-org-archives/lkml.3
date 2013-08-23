Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3HWQsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:48:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35028 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805Ab3HWQst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:48:49 -0400
Date: Fri, 23 Aug 2013 17:48:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: mcp23s08: rename the device tree property
Message-ID: <20130823164842.GC7015@e106331-lin.cambridge.arm.com>
References: <1377165378-9589-1-git-send-email-larsi@wh2.tu-dresden.de>
 <20130823142421.GK25856@e106331-lin.cambridge.arm.com>
 <201308231722.10392.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308231722.10392.poeschel@lemonage.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 04:22:10PM +0100, Lars Poeschel wrote:
> On Friday 23 August 2013 at 16:24:21, Mark Rutland wrote:
> > On Thu, Aug 22, 2013 at 10:56:17AM +0100, Lars Poeschel wrote:
> > > From: Lars Poeschel <poeschel@lemonage.de>
> > > 
> > > The device tree property should be more descriptive.
> > > microchip seems more reasonable than mcp. As there are no
> > > in tree users of this property, so the rename can still be
> > > done without pain.
> > 
> > Are there definitely no users? I see there are no dts with a
> > "mcp,mcp23***" compatible string, but are there any boards already out
> > there with this hardware that someone might be using and a currently
> > release kernel supports?
> 
> What do you mean by "release"? The device tree support for the gpio-
> mcp23s08 driver and thus the "mcp" string came in with v3.9. This is stable 
> but not longterm.

I meant a vX.Y non -rc kernel. v3.9 definitely counts.

> 
> > With the bcm/broadcom => brcm change, we marked the old vendor prefix as
> > deprecated (but left the support code).
> > 
> > If we can 100% guarantee no-one's using the compatible string, I'm happy
> > to change it. Otherwise we just have to mark the old string as
> > deprecated.
> 
> I am the developer of the device tree support for that driver and I am not 
> aware of any user, but surely I can not guarantee it.
> 
> I never imagined how hard it would be. ;-)
> I presented both variants:
> 1.) simply add mcp to vendor-prefixes.txt
> 2.) change the driver to microchip and add microchip to vendor-prefixes.txt

I think "microchip" is definitely preferable to "mcp", and would prefer
that going forward.

> 
> May one of the maintainers decide which one to take or even take none of 
> the patches.
> Or do you need a third variant with both strings in the driver and 
> microchip in vendor-prefixes?

If there are users, maintaining support for the old, deprecated string
in the driver (alongside the new one) is preferable, and simple to do.
That's how we've handled the other name changes in bindings. We should
probably do that here, documenting the "mcp,mcp23***" strings as
deprecated in the binding document.

Later, we may choose to drop unused deprecated bindings.

Thanks,
Mark.
