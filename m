Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaCCLjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:39:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51463 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaCCLji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:39:38 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <rogerq@ti.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v5 0/6] Make dwc3 use Generic PHY Framework
Date: Mon, 3 Mar 2014 17:08:09 +0530
Message-ID: <1393846695-14644-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for optional PHY in dwc3 as not all SoCs having PHYs for DWC3
should be programmed. While this can be considered as a temporary fix,
a long term solution would be to add 'nop' PHY for platforms that does
not have programmable PHY.
Adapted DWC3 and USB3 PHY to use Generic PHY framework. Also changed the
name of USB3 PHY driver to PIPE3 PHY driver since the same driver has to
be used for SATA and PCIE too.

Changes from v4: (sending the entire patch series again)
* check the return values of phy_init and phy_power_on
* print errors if power_on or power_off of PHY fails.

Changes from v3: (Sent only adapt dwc3 core to use Generic PHY Framework) 
* avoided using quirks and rely on the return values of PHY APIs to find the
presence of PHY.

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

Kishon Vijay Abraham I (6):
  usb: dwc3: core: support optional PHYs
  usb: dwc3: adapt dwc3 core to use Generic PHY Framework
  drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
  usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
  phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
  arm/dts: added dt properties to adapt to the new phy framwork

 Documentation/devicetree/bindings/usb/dwc3.txt     |    6 +-
 arch/arm/boot/dts/omap5.dtsi                       |    5 +-
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-omap-usb2.c                        |   27 +--
 .../phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c}     |  240 ++++++++++++--------
 drivers/usb/dwc3/core.c                            |  116 +++++++---
 drivers/usb/dwc3/core.h                            |    7 +
 drivers/usb/phy/Kconfig                            |   11 -
 drivers/usb/phy/Makefile                           |    1 -
 include/linux/{usb => phy}/omap_usb.h              |    3 -
 11 files changed, 264 insertions(+), 164 deletions(-)
 rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c} (54%)
 rename include/linux/{usb => phy}/omap_usb.h (95%)

-- 
1.7.9.5

