Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaCETji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:39:38 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39279 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752943AbaCETjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:39:37 -0500
Date: Wed, 5 Mar 2014 19:39:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: imx6qdl-sabresd.dtsi: Add red led
Message-ID: <20140305193925.GY21483@n2100.arm.linux.org.uk>
References: <20140305062216.GI8784@S2101-09.ap.freescale.net> <1394007383-21874-1-git-send-email-vincent.stehle@freescale.com> <20140305114223.GN8784@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305114223.GN8784@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 07:42:28PM +0800, Shawn Guo wrote:
> It's not a hog pin, so shouldn't be added here.  (Right, most of the
> existing pins shouldn't be here from the beginning)

On the subject of that kind of thing... I have an issue with the existing
pinmux stuff.  This is a wider issue than your discussion above...

I regard the idea of requiring the pinmux to be configured as part of
the driver probe a rather broken concept - yes, it makes sense in some
scenarios, but for the vast majority of cases, it doesn't.

Let's take an example.  A pin is wired to a SPDIF transceiver.  The
out-of-reset SoC configuration results in the pin turning the LED on
in the SPDIF transceiver.

With the way stuff is setup, with the driver having the pinmux settings
for itself, the point at which that pin gets configured is when the
driver loads, which may be a module - so that can happen quite late in
the boot sequence.  A failure to boot can result in it not happening at
all.

So, this brings up the obvious question: is this proper behaviour of the
hardware, or is this something we should do better with - such as where
we know what the settings should be for a platform, and these settings
never change, we arrange for that to happen at kernel boot time as a
once-off.

For example, in the above case, we know it's board XYZ, we know that this
pin is connected to the SPDIF transceiver, so maybe we should configure
it early on in the boot sequence whether or not the driver has been
configured and/or loaded.

Comments?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
