Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3KYKCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:02:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56930 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab3KYKCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:02:30 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v3 00/10] Make dwc3 use Generic PHY Framework
Date: Mon, 25 Nov 2013 15:31:20 +0530
Message-ID: <1385373690-12170-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified dwc3 core to find PHYs only if the platform indicates that it has 
to use a PHY (using quirks). Adapted DWC3 and USB3 PHY to use Generic PHY
framework. Also  changed the name of USB3 PHY driver to PIPE3 PHY driver
since the same driver has to be used for SATA and PCIE too.

Changes from v2:
* added a couple of fixes. One is invoking phy_resume after phy_init and the
other is power off phy in error patch
* used quirks to identify if a particular platform does not have PHYs
* removed using separate header for pipe3 driver and also removed all referencs
to SATA and PCIe in pipe3 driver since it's not yet adapted for those drivers.

Changes from v1:
* The logic in which the driver detects the presence of PHYs has changed.
* patch ordering has changed
* udelay is replaced with usleep_range
* A patch to remove set_suspend callback which was deferred from Generic
PHY Framework series has been included.

Kishon Vijay Abraham I (10):
  usb: dwc3: invoke phy_resume after phy_init
  usb: dwc3: power off usb phy in error path
  usb: dwc3: preparation for adapting dwc3 to generic phy framework
  usb: dwc3: use quirks to know if a particualr platform doesn't have
    PHY
  usb: dwc3: adapt dwc3 core to use Generic PHY Framework
  Documentation: dt bindings: move ..usb/usb-phy.txt to
    ..phy/ti-phy.txt
  drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
  usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
  phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
  arm/dts: added dt properties to adapt to the new phy framwork

 .../bindings/{usb/usb-phy.txt => phy/ti-phy.txt}   |    8 +-
 Documentation/devicetree/bindings/usb/dwc3.txt     |    6 +-
 arch/arm/boot/dts/omap5.dtsi                       |    4 +
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-omap-usb2.c                        |   27 +--
 .../phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c}     |  232 ++++++++++++--------
 drivers/usb/dwc3/Kconfig                           |    2 +
 drivers/usb/dwc3/core.c                            |  189 +++++++++++-----
 drivers/usb/dwc3/core.h                            |   22 ++
 drivers/usb/dwc3/platform_data.h                   |    5 +
 drivers/usb/phy/Kconfig                            |   11 -
 drivers/usb/phy/Makefile                           |    1 -
 include/linux/{usb => phy}/omap_usb.h              |    3 -
 14 files changed, 320 insertions(+), 202 deletions(-)
 rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/ti-phy.txt} (88%)
 rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c} (55%)
 rename include/linux/{usb => phy}/omap_usb.h (95%)

-- 
1.7.10.4

