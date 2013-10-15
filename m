Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab3JOTzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:55:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34754 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759113Ab3JOTz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:55:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 0/7] Make dwc3 use Generic PHY Framework
Date: Wed, 16 Oct 2013 01:24:10 +0530
Message-ID: <1381866857-3861-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

Looks like most of the patches are dependent on Generic PHY Framework except
the first one. Let me know if I have to take these patches with your ACK or
you'll take it yourself.
******************************************************************
Modified dwc3 core to find PHYs only if the platform indicates that it has 
to use a PHY. Adapted DWC3 and USB3 PHY to use Generic PHY framework. Also 
changed the name of USB3 PHY driver to PIPE3 PHY driver since the same driver 
has to be used for SATA and PCIE too.

Changes from v1:
* The logic in which the driver detects the presence of PHYs has changed.
* patch ordering has changed
* udelay is replaced with usleep_range
* A patch to remove set_suspend callback which was deferred from Generic
PHY Framework series has been included.

Kishon Vijay Abraham I (7):
  usb: dwc3: get "usb_phy" only if the platform indicates the presence
    of PHY's
  usb: dwc3: adapt dwc3 core to use Generic PHY Framework
  Documentation: dt bindings: move ..usb/usb-phy.txt to
    ..phy/ti-phy.txt
  drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
  usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
  phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
  arm/dts: added dt properties to adapt to the new phy framwork

 .../bindings/{usb/usb-phy.txt => phy/ti-phy.txt}   |    9 +-
 Documentation/devicetree/bindings/usb/dwc3.txt     |    6 +-
 arch/arm/boot/dts/omap5.dtsi                       |    5 +-
 drivers/phy/Kconfig                                |   10 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-omap-usb2.c                        |   27 +--
 .../phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c}     |  206 +++++++++++---------
 drivers/usb/dwc3/Kconfig                           |    2 +
 drivers/usb/dwc3/core.c                            |  124 ++++++++----
 drivers/usb/dwc3/core.h                            |    7 +
 drivers/usb/dwc3/platform_data.h                   |    4 +
 drivers/usb/phy/Kconfig                            |   11 --
 drivers/usb/phy/Makefile                           |    1 -
 include/linux/{usb => phy}/omap_usb.h              |    3 -
 include/linux/{usb/omap_usb.h => phy/ti_pipe3.h}   |   33 +---
 15 files changed, 248 insertions(+), 201 deletions(-)
 rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/ti-phy.txt} (86%)
 rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c} (57%)
 copy include/linux/{usb => phy}/omap_usb.h (95%)
 rename include/linux/{usb/omap_usb.h => phy/ti_pipe3.h} (53%)

-- 
1.7.10.4

