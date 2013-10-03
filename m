Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3JCKcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:32:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45207 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3JCKcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:32:41 -0400
Message-ID: <524D47A5.8000108@ti.com>
Date: Thu, 3 Oct 2013 13:32:05 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <p.zabel@pengutronix.de>,
        <broonie@kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 00/10] USB: phy: phy-nop: Manage RESET GPIO in the
 driver
References: <1380012836-29900-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1380012836-29900-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/24/2013 11:53 AM, Roger Quadros wrote:
> Hi,
> 
> Modelling the RESET line as a regulator supply wasn't a good idea
> as it abuses the regulator framework and makes adaptation
> code/data more complex.
> 
> Instead, manage the RESET gpio line directly in the driver.
> 
> This also makes us easy to migrate to a dedicated GPIO RESET controller
> whenever it becomes available.
> 
> Apart from RESET line changes this series also adds USB host support
> fro beagle-xm and fixes USB OTG port on beagle.
> 
> The full series is avilable at
> 	git://github.com/rogerq/linux.git
> in branch
> 	phy-reset

The branch is now updated based on v3.12-rc3.

cheers,
-roger

> 
> *NOTE:* As there are changes to platform data, Patch 1 needs to be shared
> between the arm-soc tree and usb tree.
> 
> Patch 1 is available at repo
> 	git://github.com/rogerq/linux.git
> in branch
> 	phy-reset-common
> 
> Patch 2 contains the phy-nop driver changes
> Patches 3 and 4 adapt legacy boot code to the phy-nop driver changes.
> Patches 5, 6 and 7 adapt DT data to the binding changes.
> Patch 8 is cleanup of omap3-beagle DT.
> Patch 9 adds USB host support to omap3-beagle-xm using the new binding.
> Patch 10 fixes USB OTG port on beagle.
> 
> Patches are based on v3.12-rc1
> 
> Tested leacy boot on omap3-beagle and omap3-beagle-xm
> Tested DT boot on omap3-beagle, omap3-beagle-xm and omap4-panda-es
> 
> v3:
> - Fix the Initial state of RESET line at probe time.
> - Update hsusb3_reset line on omap5-uevm as well.
> - Add patch 10 that fixes USB OTG port on beagle.
> 
> v2:
> - Added RESET GPIO polarity feature
> - Changed to gpio_set_value_cansleep()
> 
> cheers,
> -roger
> 
> Roger Quadros (10):
>   usb: phy: generic: Add gpio_reset to platform data
>   usb: phy: generic: Don't use regulator framework for RESET line
>   ARM: OMAP2+: omap-usb-host: Get rid of platform_data from struct
>     usbhs_phy_data
>   ARM: OMAP2+: usb-host: Adapt to USB phy-nop RESET line changes
>   ARM: dts: omap3-beagle: Use reset-gpios for hsusb2_reset
>   ARM: dts: omap4-panda: Use reset-gpios for hsusb1_reset
>   ARM: dts: omap5-uevm: Use reset-gpios for hsusb2/3_reset
>   ARM: dts: omap3-beagle: Make USB host pin naming consistent
>   ARM: dts: omap3-beagle-xm: Add USB Host support
>   ARM: dts: omap3-beagle: Add USB OTG PHY details
> 
>  .../devicetree/bindings/usb/usb-nop-xceiv.txt      |    7 +-
>  arch/arm/boot/dts/omap3-beagle-xm.dts              |   65 +++++++++++++--
>  arch/arm/boot/dts/omap3-beagle.dts                 |   44 +++++------
>  arch/arm/boot/dts/omap4-panda-common.dtsi          |   18 +----
>  arch/arm/boot/dts/omap5-uevm.dts                   |   26 +------
>  arch/arm/mach-omap2/board-omap3beagle.c            |    6 --
>  arch/arm/mach-omap2/usb-host.c                     |   18 ++--
>  arch/arm/mach-omap2/usb.h                          |    1 -
>  drivers/usb/phy/phy-am335x.c                       |    2 +-
>  drivers/usb/phy/phy-generic.c                      |   84 +++++++++++++-------
>  drivers/usb/phy/phy-generic.h                      |    6 +-
>  include/linux/usb/usb_phy_gen_xceiv.h              |    3 +-
>  12 files changed, 153 insertions(+), 127 deletions(-)
> 

