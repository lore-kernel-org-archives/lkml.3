Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3LDOki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:40:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:6779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab3LDOkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:40:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,824,1378882800"; 
   d="scan'208";a="438414299"
Date: Wed, 4 Dec 2013 16:40:27 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, balbi@ti.com
Cc: bcousson@baylibre.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, tony@atomide.com,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, s.nawrocki@samsung.com, galak@codeaurora.org
Subject: Re: [PATCH v3 04/10] usb: dwc3: use quirks to know if a particualr
 platform doesn't have PHY
Message-ID: <20131204144027.GB21055@xps8300>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1385373690-12170-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385373690-12170-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Kishon, sorry I did not see this v3 set.

On Mon, Nov 25, 2013 at 03:31:24PM +0530, Kishon Vijay Abraham I wrote:
> There can be systems which does not have an external phy, so get
> phy only if no quirks are added that indicates the PHY is not present.
> Introduced two quirk flags to indicate the *absence* of usb2 phy and
> usb3 phy. Also remove checking if return value is -ENXIO since it's now
> changed to always enable usb_phy layer.

Can you guys explain why is something like this needed? Like with
clocks and gpios, the device drivers shouldn't need to care any more
if the platform has the phys or not. -ENODEV tells you your platform
does not have them, so go ahead and continue when getting the phy.

I just tested removing the phy registering from dwc3-pci.c and all I
had to do was to add IS_ERR(<phy>) checks where the old usb phys were
used and everything worked fine?

What am I missing?

Br,

-- 
heikki
