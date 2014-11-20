Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbaKTL3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:29:14 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:50751 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbaKTL3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:29:12 -0500
MIME-Version: 1.0
In-Reply-To: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
Date: Thu, 20 Nov 2014 16:59:11 +0530
Message-ID: <CAFp+6iGV7QBL7LCGXjN1p5-fFwUZJqEGg-p8rhe1AqwOtnfhVA@mail.gmail.com>
Subject: Re: [PATCHv5 0/7] phy: simplified phy lookup
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        andrew.kim@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Nov 19, 2014 at 8:58 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> This set will in practice just separate the creation of a phy and
> binding of it to the consumer. Mapping phys to consumers can be now
> done with lookups similarly how clocks can be mapped in clkdev.c.
>
> Vivek needs to handle the phys of dwc3 also in xhci driver on
> Exynos5420 SoC, so I'm resending these now.

This set of patches work fine for me.
Tested on usb-next with this series and my series for 5420 phy calibration:
[PATCH v7 0/2] Fine tune USB 3.0 PHY on exynos5420
https://lkml.org/lkml/2014/10/31/266

If you want here's my tested-by, again for entire series.

Tested-by: Vivek Gautam <gautam.vivek@samsung.com>

>
> Changes since v4:
> - Support for static lookups is dropped. The lookups can be now only
>   be created with phy_create_lookup()
>
> Changes since v3:
> - We can't rely on the order in which the phys are registered, so
>   using the name of the parent of the phy instance for matching
>   instead of the phy itself. The parent device is always the actual
>   physical device.
> - Using PHY_LOOKUP macro in twl-common.c as suggested by Kishon.
>
> Changes since v2:
> - Calling ida_simple_remove in release function as pointed out by Greg
>
>
> Heikki Krogerus (7):
>   phy: safer to_phy() macro
>   phy: improved lookup method
>   phy: twl4030: use the new lookup method
>   arm: omap3: twl: remove usb phy init data
>   phy: remove the old lookup method
>   base: platform: name the device already during allocation
>   usb: dwc3: host: convey the PHYs to xhci
>
>  Documentation/phy.txt                |  60 ++++++--------------
>  arch/arm/mach-omap2/twl-common.c     |  12 +---
>  drivers/base/platform.c              |  69 +++++++++++++----------
>  drivers/phy/phy-bcm-kona-usb2.c      |   2 +-
>  drivers/phy/phy-berlin-sata.c        |   2 +-
>  drivers/phy/phy-core.c               | 105 ++++++++++++++++++++++++-----------
>  drivers/phy/phy-exynos-dp-video.c    |   2 +-
>  drivers/phy/phy-exynos-mipi-video.c  |   2 +-
>  drivers/phy/phy-exynos5-usbdrd.c     |   3 +-
>  drivers/phy/phy-exynos5250-sata.c    |   2 +-
>  drivers/phy/phy-hix5hd2-sata.c       |   2 +-
>  drivers/phy/phy-miphy365x.c          |   2 +-
>  drivers/phy/phy-mvebu-sata.c         |   2 +-
>  drivers/phy/phy-omap-usb2.c          |   2 +-
>  drivers/phy/phy-qcom-apq8064-sata.c  |   3 +-
>  drivers/phy/phy-qcom-ipq806x-sata.c  |   3 +-
>  drivers/phy/phy-rcar-gen2.c          |   2 +-
>  drivers/phy/phy-samsung-usb2.c       |   3 +-
>  drivers/phy/phy-spear1310-miphy.c    |   2 +-
>  drivers/phy/phy-spear1340-miphy.c    |   2 +-
>  drivers/phy/phy-stih407-usb.c        |   2 +-
>  drivers/phy/phy-stih41x-usb.c        |   2 +-
>  drivers/phy/phy-sun4i-usb.c          |   2 +-
>  drivers/phy/phy-ti-pipe3.c           |   2 +-
>  drivers/phy/phy-twl4030-usb.c        |   9 ++-
>  drivers/phy/phy-xgene.c              |   2 +-
>  drivers/pinctrl/pinctrl-tegra-xusb.c |   4 +-
>  drivers/usb/dwc3/host.c              |  22 ++++++--
>  include/linux/i2c/twl.h              |   2 -
>  include/linux/phy/phy.h              |  52 +++++++----------
>  30 files changed, 195 insertions(+), 186 deletions(-)
>
> --
> 2.1.3
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
