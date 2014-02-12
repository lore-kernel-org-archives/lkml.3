Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaBLKTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:19:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42316 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaBLKTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:19:39 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v7 00/12] USB Host support for OMAP5 uEVM
Date: Wed, 12 Feb 2014 12:18:41 +0200
Message-ID: <1392200333-28397-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit, Tony & Lee,

This patchset brings up USB Host ports and Ethernet port on
the OMAP5 uEVM board. Please queue these for -next.

Tested on:
 - OMAP5 uEVM
 - Pandaboard ES Rev. B1
 - Beagleboard-XM Rev C2
 - Beagleboard Rev C4.

Changelog:

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

--

Roger Quadros (12):
  mfd: omap-usb-host: Use resource managed clk_get()
  mfd: omap-usb-host: Get clocks based on hardware revision
  mfd: omap-usb-host: Use clock names as per function for reference
    clocks
  mfd: omap-usb-host: Update DT clock binding information
  mfd: omap-usb-tll: Update DT clock binding information
  ARM: dts: omap4: Update omap-usb-host node
  ARM: dts: omap5: Update omap-usb-host node
  ARM: dts: omap4-panda: Provide USB PHY clock
  ARM: dts: omap5-uevm: Provide USB PHY clock
  ARM: OMAP2+: Remove legacy_init_ehci_clk()
  ARM: dts: OMAP2+: Get rid of incompatible ids for USB host nodes
  usb: omap: dts: Update DT binding example usage

 .../devicetree/bindings/mfd/omap-usb-host.txt      |  23 +++
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |  10 ++
 .../devicetree/bindings/usb/ehci-omap.txt          |   2 +-
 .../devicetree/bindings/usb/ohci-omap3.txt         |   2 +-
 arch/arm/boot/dts/omap3.dtsi                       |   4 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi          |   8 +-
 arch/arm/boot/dts/omap4.dtsi                       |  10 +-
 arch/arm/boot/dts/omap5-uevm.dts                   |   8 +-
 arch/arm/boot/dts/omap5.dtsi                       |  10 +-
 arch/arm/mach-omap2/pdata-quirks.c                 |  16 --
 drivers/mfd/omap-usb-host.c                        | 171 ++++++++++-----------
 11 files changed, 136 insertions(+), 128 deletions(-)

-- 
1.8.3.2

