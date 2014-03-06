Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaCFKNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:13:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaCFKNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:13:42 -0500
Date: Thu, 6 Mar 2014 11:13:11 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Vincent =?iso-8859-15?Q?Stehl=E9?= <vincent.stehle@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: imx6qdl-sabresd.dtsi: Add red led
Message-ID: <20140306101311.GZ17250@pengutronix.de>
References: <20140305062216.GI8784@S2101-09.ap.freescale.net>
 <1394007383-21874-1-git-send-email-vincent.stehle@freescale.com>
 <20140305114223.GN8784@S2101-09.ap.freescale.net>
 <20140305193925.GY21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305193925.GY21483@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:04:08 up 193 days, 19:34, 57 users,  load average: 0.25, 0.22,
 0.21
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 07:39:26PM +0000, Russell King - ARM Linux wrote:
> On Wed, Mar 05, 2014 at 07:42:28PM +0800, Shawn Guo wrote:
> > It's not a hog pin, so shouldn't be added here.  (Right, most of the
> > existing pins shouldn't be here from the beginning)
> 
> On the subject of that kind of thing... I have an issue with the existing
> pinmux stuff.  This is a wider issue than your discussion above...
> 
> I regard the idea of requiring the pinmux to be configured as part of
> the driver probe a rather broken concept - yes, it makes sense in some
> scenarios, but for the vast majority of cases, it doesn't.
> 
> Let's take an example.  A pin is wired to a SPDIF transceiver.  The
> out-of-reset SoC configuration results in the pin turning the LED on
> in the SPDIF transceiver.
> 
> With the way stuff is setup, with the driver having the pinmux settings
> for itself, the point at which that pin gets configured is when the
> driver loads, which may be a module - so that can happen quite late in
> the boot sequence.  A failure to boot can result in it not happening at
> all.
> 
> So, this brings up the obvious question: is this proper behaviour of the
> hardware, or is this something we should do better with - such as where
> we know what the settings should be for a platform, and these settings
> never change, we arrange for that to happen at kernel boot time as a
> once-off.
> 
> For example, in the above case, we know it's board XYZ, we know that this
> pin is connected to the SPDIF transceiver, so maybe we should configure
> it early on in the boot sequence whether or not the driver has been
> configured and/or loaded.

I have a similar case here on my desk. Our customer provided us a
complete list of pinmux and drive strength settings which must just be
written into registers. It's very convenient to skip the entire kernel
pinmux setup. With the driver core setting up the pins this is easily
possible, we only have to skip the pinctrl nodes from the devices.
The only exception currently is the imx-esdhci which manually tries
to setup its pinmux.

So with the current pinctrl stuff it's possible to do pinctrl completely
in the bootloader or as Shawn suggested, you can also put it in the hog
group.

Maybe we just have to state somewhere that doing so is not just a
byproduct but instead can and should be done if necessary.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
