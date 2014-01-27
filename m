Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaA0PJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:09:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:28527 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaA0PJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:09:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,729,1384329600"; 
   d="scan'208";a="473145138"
Date: Mon, 27 Jan 2014 17:08:55 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, george.cherian@ti.com,
        rogerq@ti.com, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
Message-ID: <20140127150855.GA17928@xps8300>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1390299099-14764-1-git-send-email-kishon@ti.com>
 <20140121144725.GF30451@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121144725.GF30451@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Tue, Jan 21, 2014 at 08:47:25AM -0600, Felipe Balbi wrote:
> On Tue, Jan 21, 2014 at 03:41:38PM +0530, Kishon Vijay Abraham I wrote:
> > Since PHYs for dwc3 is optional (not all SoCs that have DWC3 use PHYs),
> > do not return from probe if the USB PHY library returns -ENODEV as that
> 
> this isn't correct, they all have PHYs, some of them might not be
> controllable.
> 
> > indicates the platform does not have PHY.
> 
> not really, that indicates the current platform tried to grab a PHY and
> the PHY doesn't exist. If there's anybody with a non-controllable PHY
> and someone gives me a really good reason for not using the generic
> no-op PHY, then we should add a flag and we could:
> 
> 	if (!likely(dwc->flags & DWC3_USB2PHY_DRIVER_NOT_NEEDED))
> 		dwc3_grab_phys(dwc);

Why would you need to know if the PHY drivers are needed or not
explicitly in your controller driver?

> But I really want to see the argument against using no-op. As far as I
> could see, everybody needs a PHY driver one way or another, some
> platforms just haven't sent any PHY driver upstream and have their own
> hacked up solution to avoid using the PHY layer.

Not true in our case. Platforms using Intel's SoCs and chip sets may
or may not have controllable USB PHY. Quite often they don't. The
Baytrails have usually ULPI PHY for USB2, but that does not mean they
provide any vendor specific functions or any need for a driver in any
case.

Are we talking about the old USB PHY library or the new PHY framework
with the no-op PHY driver?

Well, in any case, I don't understand what is the purpose of the no-op
PHY driver. What are you drying to achieve with that?


Thanks,

-- 
heikki
