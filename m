Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3HLLHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:07:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43682 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab3HLLHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:07:45 -0400
Date: Mon, 12 Aug 2013 12:07:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@kernel.org" <devicetree@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
Message-ID: <20130812110714.GA6616@e106331-lin.cambridge.arm.com>
References: <20130811190826.GH6427@sirena.org.uk>
 <Pine.LNX.4.44L0.1308112146410.29546-100000@netrider.rowland.org>
 <20130812095136.GJ6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812095136.GJ6427@sirena.org.uk>
Thread-Topic: Non-enumerable devices on USB and other enumerable buses
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Olof]

On Mon, Aug 12, 2013 at 10:51:36AM +0100, Mark Brown wrote:
> On Sun, Aug 11, 2013 at 09:53:01PM -0400, Alan Stern wrote:
> > On Sun, 11 Aug 2013, Mark Brown wrote:
> 
> > > One example that's bugging me right now is that on the Insignal Arndale
> > > platform there's a USB hub connected to one of the USB ports on the SoC
> > > (not as a PHY, it seems we also need the internal PHY running to talk to
> > > the device).  The hub needs to be "plugged" into the SoC after the SoC
> > > USB controller has started with some GPIOs so we need to tell the system
> > > that the hub exists and needs to be synchronised with the USB controller.
> 
> > On the surface, this seems like a particularly simple case.  Why wait 
> > until the SoC's USB controller has started?  Why not "plug in" the hub 
> > via the GPIOs right from the beginning?
> 
> I tried that, it doesn't seem to work - for some reason it seems that
> the hub is only successfully enumerated if it starts after its parent is
> running.  I don't know enough about USB to speculate on why that might
> be, the GPIOs are brining the device out of reset not applying power or
> anything.
> 
> > > Another case that's going to be problematic once it's in mainline is
> > > Slimbus - this is a bus used in some embedded audio subsystems which is
> > > enumerable in a similar manner to USB but where the devices on the bus
> > > are normally powered up only on demand (causing them to hotplug when
> > > used and unplug when idle) and have at least interrupt lines wired to
> > > the SoC using a normal interrupt outside the enumerable bus.
> 
> > That is indeed more difficult, because it requires geniune cooperation 
> > between the bus and platform subsystems.
> 
> Yeah.  You might want to do the same with for example a USB network
> controller when you're in flight only mode, that seems to be one of the
> more common reasons for doing this sort of thing with USB.

As I understand it, the wifi chip on the Snow Chromebook has a similar
issue -- it hangs off of a probeable SDIO bus, but needs a regulator
poked for it to turn on and become probeable (see
exynos_wifi_bt_set_power in [1]).

Thanks,
Mark.

[1] http://git.chromium.org/gitweb/?p=chromiumos/third_party/kernel.git;a=blob;f=arch/arm/mach-exynos/mach-exynos5-dt.c;h=d131241ea78b7d89df21e676e284ddfd369b4da0;hb=refs/heads/chromeos-3.4
