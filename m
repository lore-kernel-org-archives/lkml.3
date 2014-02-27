Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaB0OUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:20:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55289 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaB0OTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:19:03 -0500
From: Roger Quadros <rogerq@ti.com>
To: <lee.jones@linaro.org>, <tony@atomide.com>, <bcousson@baylibre.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v9 0/9] USB Host support for OMAP5 uEVM
Date: Thu, 27 Feb 2014 16:18:22 +0200
Message-ID: <1393510711-4697-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset brings up USB Host ports and Ethernet port on
the OMAP5 uEVM board.

It also does some cleanup with respect to DT clock binding
for the mfd/omap-usb-host driver.

Please queue these for -next.

Lee,

I've folded some platform data dependent patches with mfd patches
so that they don't break functionality when applied individually.
You can safely pull in all MFD patches (1 to 6).

Tony & Benoit,

Can you please accept patches 7, 8 and 9?

Thanks.

Tested on:
 - OMAP5 uEVM
 - Pandaboard ES Rev. B1
 - Beagleboard-XM Rev C2 (DT + Legacy)
 - Beagleboard Rev C4 (DT + Legacy)

Changelog:

v9:
- Folded dependent platform data patches into MFD patches.

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
Roger Quadros (9):
  mfd: omap-usb-host: Get clocks based on hardware revision
  mfd: omap-usb-host: Always fail on clk_get() error
  mfd: omap-usb-host: Use proper clock name instead of alias
  mfd: omap-usb-host: Use clock names as per function for reference
    clocks
  mfd: omap-usb-host: Update DT clock binding information
  mfd: omap-usb-tll: Update DT clock binding information
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

