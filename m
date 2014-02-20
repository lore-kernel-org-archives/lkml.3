Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBTLko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:40:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42416 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaBTLkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:40:42 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v8 00/14] USB Host support for OMAP5 uEVM
Date: Thu, 20 Feb 2014 13:39:55 +0200
Message-ID: <1392896409-5101-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit, Tony & Lee,

This patchset brings up USB Host ports and Ethernet port on
the OMAP5 uEVM board.

It also does some cleanup with respect to DT clock binding
for the mfd/omap-usb-host driver.

Please queue these for -next.

Tested on:
 - OMAP5 uEVM
 - Pandaboard ES Rev. B1
 - Beagleboard-XM Rev C2 (DT + Legacy)
 - Beagleboard Rev C4 (DT + Legacy)

Changelog:

v8:
- Addressed review comments and split patch
  "mfd: omap-usb-host: Get clocks based on hardware revision"
- Removed unnecessary usb host dummy clocks on OMAP3
- Removed unnecessary clock alias "ehci_logic_fck" for OMAP3
- Rebased on 3.14-rc3

v7:
- Rebased on 3.14-rc2
- Removed incompatible ids from DT files and examples

v6:
- Initialized clocks to -ENODEV and split patch 3.

v5:
- Expose all clocks in the DT binding document for mfd:omap-usb-host
and mfd:omap-usb-tll

v4:
- Updated DT binding document for clock binding

v3:
- Rebased on top of 3.13-rc7

cheers,
-roger

---
Roger Quadros (14):
  mfd: omap-usb-host: Get clocks based on hardware revision
  mfd: omap-usb-host: Always fail on clk_get() error
  mfd: omap-usb-host: Use clock names as per function for reference
    clocks
  mfd: omap-usb-host: Update DT clock binding information
  mfd: omap-usb-tll: Update DT clock binding information
  CLK: TI: OMAP3: Get rid of unused USB Host dummy clocks
  ARM: OMAP3: hwmod data: Remove optional clock from usb_host_hs module
  ARM: dts: omap4: Update omap-usb-host node
  ARM: dts: omap5: Update omap-usb-host node
  ARM: dts: omap4-panda: Provide USB PHY clock
  ARM: dts: omap5-uevm: Provide USB PHY clock
  ARM: OMAP2+: Remove legacy_init_ehci_clk()
  ARM: dts: OMAP2+: Get rid of incompatible ids for USB host nodes
  usb: omap: dts: Update DT binding example usage

 .../devicetree/bindings/mfd/omap-usb-host.txt      |  23 ++++
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |  10 ++
 .../devicetree/bindings/usb/ehci-omap.txt          |   2 +-
 .../devicetree/bindings/usb/ohci-omap3.txt         |   2 +-
 arch/arm/boot/dts/omap3.dtsi                       |   4 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi          |   8 +-
 arch/arm/boot/dts/omap4.dtsi                       |  10 +-
 arch/arm/boot/dts/omap5-uevm.dts                   |   8 +-
 arch/arm/boot/dts/omap5.dtsi                       |  10 +-
 arch/arm/mach-omap2/cclock3xxx_data.c              |   4 -
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   6 --
 arch/arm/mach-omap2/pdata-quirks.c                 |  16 ---
 drivers/clk/ti/clk-3xxx.c                          |   4 -
 drivers/mfd/omap-usb-host.c                        | 116 ++++++++++++++-------
 14 files changed, 135 insertions(+), 88 deletions(-)

-- 
1.8.3.2

