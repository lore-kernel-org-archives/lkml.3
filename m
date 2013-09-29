Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3I2OLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 10:11:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58396 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140Ab3I2OLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 10:11:43 -0400
Date: Sun, 29 Sep 2013 15:11:37 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: devicetree@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mfd: arizona: Update device tree regulator bindings
Message-ID: <20130929141137.GW3635@opensource.wolfsonmicro.com>
References: <1380131272-16982-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20130925183201.GT3226@sirena.org.uk> <20130926152941.GQ3635@opensource.wolfsonmicro.com> <20130926175843.GS19304@sirena.org.uk> <20130928155308.GV3635@opensource.wolfsonmicro.com> <20130928225535.GQ19304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928225535.GQ19304@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 11:55:35PM +0100, Mark Brown wrote:
> No, having the supplies bound to the parent is desired (especially given
> that there isn't a child node) - it's the fact that you're bodging this
> in the framework by just randomly peering at the parent device and
> hoping it's an MFD parent when a lookup fails.  That's not a safe thing
> to do.  
> 
> Like I said in the quote above trying to handle this in the child isn't
> a good approach, it's both more idiomatic and more robust to put the
> mappings from the parent device to the child devices in when creating
> the child devices.

Apologies I didn't mean to convey I was still pushing for the
above patch. I am just trying to get a good handle on what needs
to be done here, and thought I best clarify about the gpio
functionality as it is starting to look like changes in quite a
few places and I am wondering if there is a better more central
place to handle the issue.

> > For example, the GPIO driver has a similar issue if anything else
> > wishes to use an Arizona devices GPIO, because the GPIO driver
> > is on a different device to the MFD so again it can't locate it.
> > I haven't checked yet but I am guessing there will be similar
> > issues with the interrupts.
> 
> No, this isn't an issue at all.  Look at how the regulator API resolves
> DT lookups for example, the structure of the driver offering the service
> should have no impact on anything referencing it.  The fact that Linux
> happens to split things up into a particular set of subsystems at the
> current time should have no bearing on the way that the DT bindings are
> written since that's just a detail of how Linux works.

There is currently only one other MFD driver (tps65910) which defines
the GPIOs on the main MFD node as we do in the Arizona driver and it
uses the 'hack' that I suggested in my first email of copying the
of_node.

tps65910_gpio->gpio_chip.of_node = tps65910->dev->of_node;

Looking around there seem to be quite a few drivers that copy
of_node pointers like this are we sure this isn't an acceptable
solution? I mean the arizona driver we know the components will
always be loaded as part of the MFD and thus will be freed before
the parent node.

Thanks,
Charles

