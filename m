Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaFENVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:21:09 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62119 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFENVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
Date: Thu, 5 Jun 2014 18:51:05 +0530
X-Google-Sender-Auth: sCUSxlKiV-dwXPC948FxhcxUlu8
Message-ID: <CAFp+6iE9Wu-VrNUiu9VaFrEBdGyfnv0z23ME-x3WxUjJRWBt9g@mail.gmail.com>
Subject: Re: [PATCHv2 0/6] phy: simplified phy lookup
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,


On Thu, Jun 5, 2014 at 6:22 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi,
>
> So the idea with these is that they should help to make it possible to
> request phys without caring about how they are mapped to the
> consumers, meaning, was is the mapping done in DT, ACPI, etc. Mapping
> phys to consumers can be now done with lookups similarly how clocks
> can be mapped in clkdev.c.
>
> Vivek needs to handle the phys of dwc3 also in xhci driver on
> Exynos5420 SoC, so I'm resending these now.

Thank you so much for your efforts.
This will greatly help me in preparing the patches for PHY tuning.

>
>
> Heikki Krogerus (6):
>   phy: safer to_phy() macro
>   phy: improved lookup method
>   arm: omap3: twl: use the new lookup method with usb phy
>   phy: remove the old lookup method
>   base: platform: name the device already during allocation
>   usb: dwc3: host: convey the PHYs to xhci
>
>  Documentation/phy.txt               |  66 +++++----------
>  arch/arm/mach-omap2/twl-common.c    |  18 ++---
>  drivers/base/platform.c             |  77 +++++++++++-------
>  drivers/phy/phy-bcm-kona-usb2.c     |   2 +-
>  drivers/phy/phy-core.c              | 156 +++++++++++++++++++++++++++++-------
>  drivers/phy/phy-exynos-dp-video.c   |   2 +-
>  drivers/phy/phy-exynos-mipi-video.c |   2 +-
>  drivers/phy/phy-exynos5-usbdrd.c    |   3 +-
>  drivers/phy/phy-exynos5250-sata.c   |   2 +-
>  drivers/phy/phy-mvebu-sata.c        |   2 +-
>  drivers/phy/phy-omap-usb2.c         |   2 +-
>  drivers/phy/phy-samsung-usb2.c      |   2 +-
>  drivers/phy/phy-sun4i-usb.c         |   2 +-
>  drivers/phy/phy-ti-pipe3.c          |   2 +-
>  drivers/phy/phy-twl4030-usb.c       |   4 +-
>  drivers/phy/phy-xgene.c             |   2 +-
>  drivers/usb/dwc3/host.c             |  22 +++--
>  include/linux/phy/phy.h             |  60 +++++++-------
>  18 files changed, 259 insertions(+), 167 deletions(-)
>
> --
> 2.0.0.rc4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
