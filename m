Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaKDEH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:07:26 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:48812 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaKDEHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:07:25 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 0/6] ARM: sun9i: Add USB host controller support for A80
Date: Tue,  4 Nov 2014 12:07:13 +0800
Message-Id: <1415074039-16590-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This series adds USB host controller (EHCI/OHCI) support for the Allwinner
A80 SoC. The A80 has 3 pairs of host controllers and USB PHYs. The PHYs,
unlike in previous SoCs, do not have low level control registers anymore.

As such, this series forgoes the original phy-sun4i-usb driver, and adds
a new, simpler driver for the USB PHYs. It may be possible to merge the
two, but given that work is being done on the OTG front for the earlier
SoCs, it may be better to merge them after support is complete.

USB0 corresponds to USB1 DP/DM pins; USB1 only has HSIC support; USB2 is
USB2 DP/DM externally. External pins labeled USB0 are for the USB 3.0 OTG
controller.

Patch 1 adds a80 specific support for usb-related clocks and resets.

Patch 2 adds the device tree nodes for the usb clocks.

Patch 3 adds a new generic phy driver for a80 usb phys. This has some
code that is the same as the original phy-sun4i-usb driver, but is simpler.

Patch 4 adds the 3 USB PHY nodes to the a80 dtsi.

Patch 5 adds the USB host controller nodes to the a80 dtsi.

Patch 6 adds the vbus regulator nodes and enables USB on the A80 Optimus
board.


Chen-Yu Tsai (6):
  clk: sunxi: Add support for sun9i a80 usb clocks and resets
  ARM: dts: sun9i: Add usb clock nodes to a80 dtsi
  phy: Add driver to support individual USB PHYs on sun9i
  ARM: dts: sun9i: Add usb phy nodes to a80 dtsi
  ARM: dts: sun9i: Add USB host controller nodes to a80 dtsi
  ARM: dts: sun9i: Enable USB support on A80 Optimus board

 Documentation/devicetree/bindings/clock/sunxi.txt  |   5 +
 .../devicetree/bindings/phy/sun9i-usb-phy.txt      |  34 +++
 arch/arm/boot/dts/sun9i-a80-optimus.dts            |  72 +++++++
 arch/arm/boot/dts/sun9i-a80.dtsi                   | 129 ++++++++++++
 drivers/clk/sunxi/Makefile                         |   1 +
 drivers/clk/sunxi/clk-usb.c                        | 192 +++++++++++++++++
 drivers/phy/Kconfig                                |  12 ++
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-sun9i-usb.c                        | 227 +++++++++++++++++++++
 9 files changed, 673 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/sun9i-usb-phy.txt
 create mode 100644 drivers/clk/sunxi/clk-usb.c
 create mode 100644 drivers/phy/phy-sun9i-usb.c

-- 
2.1.1

