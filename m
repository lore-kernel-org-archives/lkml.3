Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab3CMQY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:24:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20790 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933149Ab3CMQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:24:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/RgOi5QClkzYme2+qHzEgC
Date: Wed, 13 Mar 2013 09:24:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, b-cousson@ti.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 00/24] ARM: OMAP2+: Adapt to ehci-omap changes for 3.10
Message-ID: <20130313162454.GE26093@atomide.com>
References: <1363088606-2692-1-git-send-email-rogerq@ti.com>
 <20130312164007.GZ26093@atomide.com>
 <5140821B.2030902@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5140821B.2030902@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130313 06:46]:
> On 03/12/2013 06:40 PM, Tony Lindgren wrote:
> > * Roger Quadros <rogerq@ti.com> [130312 04:47]:
> >> Hi Tony,
> >>
> >> These patches provide the SoC side code required to support
> >> the changes in the OMAP USB Host drivers done in [1], [2] & [3].
> > ... 
> > 
> >>  arch/arm/mach-omap2/board-3430sdp.c                |   97 +++++++++++++++-
> >>  arch/arm/mach-omap2/board-3630sdp.c                |  100 +++++++++++++++-
> >>  arch/arm/mach-omap2/board-am3517crane.c            |   95 +++++++++++++--
> >>  arch/arm/mach-omap2/board-am3517evm.c              |   66 ++++++++++-
> >>  arch/arm/mach-omap2/board-cm-t35.c                 |   95 ++++++++++++++-
> >>  arch/arm/mach-omap2/board-cm-t3517.c               |   97 +++++++++++++++-
> >>  arch/arm/mach-omap2/board-devkit8000.c             |   20 ++--
> >>  arch/arm/mach-omap2/board-generic.c                |   67 +++++++++++
> >>  arch/arm/mach-omap2/board-igep0020.c               |  112 ++++++++++++++++---
> >>  arch/arm/mach-omap2/board-omap3beagle.c            |   93 +++++++++++++--
> >>  arch/arm/mach-omap2/board-omap3evm.c               |   62 ++++++++--
> >>  arch/arm/mach-omap2/board-omap3pandora.c           |   52 +++++++--
> >>  arch/arm/mach-omap2/board-omap3stalker.c           |   52 +++++++-
> >>  arch/arm/mach-omap2/board-omap3touchbook.c         |   62 +++++++++-
> >>  arch/arm/mach-omap2/board-omap4panda.c             |  122 ++++++++++++++------
> >>  arch/arm/mach-omap2/board-overo.c                  |   54 ++++++++-
> >>  arch/arm/mach-omap2/board-zoom.c                   |   56 ++++++++-
> > 
> > Can't you have some mach-omap2/ehci-common.c that takes care
> > of the initializiation to avoid this much addition to the
> > board-*.c files? You may be able to have just a common function
> > to do it and pass few parameters?
> 
> Since we moved reset and power handling for the USB PHYs from omap-echi
> driver into the USB PHY driver we need to define the regulator data
> for RESET and Power line of each PHY. So most of the code added is just
> regulator data for the PHY rather than omap-ehci.

It seems that you're now repeating minor variations of the same PHY
over and over again though.
 
> Instead of a common function, I can implement some macros that make it
> easier to define the regulators for the PHY in the board files.
> Does this sound OK?
> 
> Personally I don't like such macros because it hides the implementation
> and is difficult to read/debug.

I'd prefer a common function to initialize the PHY though as it sounds
like using macros would just allocate similar PHY many times which seems
unnecessary.

Regards,

Tony
