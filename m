Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbbAYMWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 07:22:46 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35313 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbAYMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 07:22:25 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v2 0/9] ARM: sun9i: Add USB host controller support for A80
Date: Sun, 25 Jan 2015 20:22:01 +0800
Message-Id: <1422188530-1794-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is v2 of the sun9i A80 USB host support series.

This series adds USB host controller (EHCI/OHCI) support for the Allwinner
A80 SoC. The A80 has 3 pairs of host controllers and USB PHYs. The PHYs,
unlike in previous SoCs, do not have low level control registers anymore.

As such, this series forgoes the original phy-sun4i-usb driver, and adds
a new, simpler driver for the USB PHYs. It may be possible to merge the
two, but given that work is being done on the OTG front for the earlier
SoCs, it may be better to merge them after support is complete.

EHCI/OHCI0 corresponds to USB1 DP/DM pins; EHCI1 only has HSIC support;
EHCI2/OHCI/2 is USB2 DP/DM externally. External pins labeled USB0 are
for the USB 3.0 OTG controller.

Changes since v1:

  - Rework usb clock/reset driver to only enable ahb gate when child
    clock gates are enabled.

  - Add AHB_INCR16_BURST flag and HSIC specific bits to phy driver.

  - Renumber USB PHYs according to sunxi tradition, usbphy0 for OTG,
    usbphy1 and later for xHCI.

  - Add VBUS regulator for usb3 to sunxi common regulators.

  - Use common regulators for usb vbus regulators.

  - Adapt to label references in board dts file.

  - Use gpio and pinctrl macros in dts.


Patch 1 adds a80 specific support for usb-related clocks and resets.

Patch 2 adds the device tree nodes for the usb clocks.

Patch 3 adds a new generic phy driver for a80 usb phys. This has some
code that is the same as the original phy-sun4i-usb driver, but is simpler.

Patch 4 adds the 3 USB PHY nodes to the a80 dtsi.

Patch 5 adds the USB host controller nodes to the a80 dtsi.

Patch 6 adds a VBUS regulator for usb3 to sunxi common regulators.

Patch 7 enables USB on the A80 Optimus board.

Patch 8 enables sun9i USB PHY in sunxi_defconfig.

Patch 9 enables sun9i USB PHY in multi_v7_defconfig.

Regards,
ChenYu


Chen-Yu Tsai (9):
  clk: sunxi: Add support for sun9i a80 usb clocks and resets
  ARM: dts: sun9i: Add usb clock nodes to a80 dtsi
  phy: Add driver to support individual USB PHYs on sun9i
  ARM: dts: sun9i: Add usb phy nodes to a80 dtsi
  ARM: dts: sun9i: Add USB host controller nodes to a80 dtsi
  ARM: dts: sunxi: Add usb3_vbus regulator to common regulators dtsi
  ARM: dts: sun9i: Enable USB support on A80 Optimus board
  ARM: sunxi_defconfig: Enable CONFIG_PHY_SUN9I_USB
  ARM: multi_v7_defconfig: Enable CONFIG_PHY_SUN9I_USB

 Documentation/devicetree/bindings/clock/sunxi.txt  |   2 +
 .../devicetree/bindings/phy/sun9i-usb-phy.txt      |  34 +++
 arch/arm/boot/dts/sun9i-a80-optimus.dts            |  60 ++++++
 arch/arm/boot/dts/sun9i-a80.dtsi                   | 129 +++++++++++
 arch/arm/boot/dts/sunxi-common-regulators.dtsi     |  10 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 arch/arm/configs/sunxi_defconfig                   |   1 +
 drivers/clk/sunxi/Makefile                         |   1 +
 drivers/clk/sunxi/clk-usb.c                        | 193 +++++++++++++++++
 drivers/phy/Kconfig                                |  12 ++
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-sun9i-usb.c                        | 238 +++++++++++++++++++++
 12 files changed, 682 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/sun9i-usb-phy.txt
 create mode 100644 drivers/clk/sunxi/clk-usb.c
 create mode 100644 drivers/phy/phy-sun9i-usb.c

-- 
2.1.4

