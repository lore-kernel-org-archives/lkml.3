Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab3LIJ0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:26:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:38777 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab3LIJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,856,1378882800"; 
   d="scan'208";a="446865357"
Date: Mon, 9 Dec 2013 11:26:04 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, bcousson@baylibre.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, tony@atomide.com,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, s.nawrocki@samsung.com, galak@codeaurora.org
Subject: Re: [PATCH v3 04/10] usb: dwc3: use quirks to know if a particualr
 platform doesn't have PHY
Message-ID: <20131209092604.GC5231@xps8300>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1385373690-12170-5-git-send-email-kishon@ti.com>
 <20131204144027.GB21055@xps8300>
 <52A01E86.50406@ti.com>
 <20131205075828.GA32583@xps8300>
 <52A56DA1.1010808@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A56DA1.1010808@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 09, 2013 at 12:43:37PM +0530, Kishon Vijay Abraham I wrote:
> On Thursday 05 December 2013 01:28 PM, Heikki Krogerus wrote:
> >On Thu, Dec 05, 2013 at 12:04:46PM +0530, Kishon Vijay Abraham I wrote:
> >>On Wednesday 04 December 2013 08:10 PM, Heikki Krogerus wrote:
> >>>On Mon, Nov 25, 2013 at 03:31:24PM +0530, Kishon Vijay Abraham I wrote:
> >>>>There can be systems which does not have an external phy, so get
> >>>>phy only if no quirks are added that indicates the PHY is not present.
> >>>>Introduced two quirk flags to indicate the *absence* of usb2 phy and
> >>>>usb3 phy. Also remove checking if return value is -ENXIO since it's now
> >>>>changed to always enable usb_phy layer.
> >>>
> >>>Can you guys explain why is something like this needed? Like with
> >>>clocks and gpios, the device drivers shouldn't need to care any more
> >>>if the platform has the phys or not. -ENODEV tells you your platform
> >>
> >>Shouldn't we report if a particular platform needs a PHY and not able to get
> >>it. How will a user know if a particular controller is not working because it's
> >>not able to get and initialize the PHYs? Don't you think in such cases it's
> >>better to fail (and return from probe) because the controller will not work
> >>anyway without the PHY?
> >
> >My point is that you do not need to separately tell this to the driver
> >like you do with the quirks (if you did, then you would need to fix
> >your framework and not hack the drivers).
> >
> >Like I said, ENODEV tells you that there is no phy on this platform
> >for you, allowing you to safely continue. If your phy driver is not
> >loaded, the framework already returns EPROBE_DEFER, right. Any other
> 
> right. but that doesn't consider broken dt data. With quirks we'll
> able to tell if a controller in a particular platform has PHY or not
> without depending on the dt data.

Broken dt data? What kind of scenario are you thinking here? Do you
mean case where the dt does not describe the phy on a platform that
depends on it? Shouldn't that problem be fixed in the dt and not
hacked in the drivers? Or are you thinking about something else?

Is there a case where something like that is actually happening?

Br,

-- 
heikki
