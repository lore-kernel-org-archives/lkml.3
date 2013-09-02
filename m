Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3IBPoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:44:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47126 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab3IBPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:44:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rogerq@ti.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] Make dwc3 use Generic PHY Framework and misc cleanup
Date: Mon, 2 Sep 2013 21:13:04 +0530
Message-ID: <1378136591-7463-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified dwc3 core to find PHYs only if the platform indicates that it has
to use a PHY. Adapted DWC3 and USB3 PHY to use Generic PHY framework. Also
changed the name of USB3 PHY driver to PIPE3 PHY driver since the same driver
has to be used for SATA and PCIE too.

This series also includes a bunch of misc cleanups and also renamed
omap_control_usb to omap_control_phy (done on top of rogers patches [1])

Did g_zero enumeration testing on OMAP4 PANDA and did xhci testing in
OMAP5 uEvm.

I have pushed this branch to http://git.gitorious.org/linuxphy/linuxphy.git
dwc3_generic_phy

[1] -> git://github.com/rogerq/linux.git usb-control-module

Kishon Vijay Abraham I (7):
  usb: dwc3: get "usb_phy" only if the platform indicates the presence
    of PHY
  usb: dwc3: adapt dwc3 core to use Generic PHY Framework
  drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
  Documentation: dt bindings: move ..usb/usb-phy.txt to
    ..phy/omap-phy.txt
  phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
  arm/dts: added dt properties to adapt to the new phy framwork
  drivers: phy: renamed struct omap_control_usb to struct
    omap_control_phy

 .../bindings/{usb/usb-phy.txt => phy/omap-phy.txt} |    7 +-
 Documentation/devicetree/bindings/usb/dwc3.txt     |    6 +-
 arch/arm/boot/dts/omap5.dtsi                       |    5 +-
 drivers/phy/Kconfig                                |   22 +-
 drivers/phy/Makefile                               |    2 +
 drivers/{usb => }/phy/phy-omap-control.c           |  164 +++++++--------
 .../phy/phy-omap-usb3.c => phy/phy-omap-pipe3.c}   |  212 +++++++++++---------
 drivers/phy/phy-omap-usb2.c                        |   10 +-
 drivers/usb/dwc3/Kconfig                           |    2 +
 drivers/usb/dwc3/core.c                            |  109 ++++++----
 drivers/usb/dwc3/core.h                            |    7 +
 drivers/usb/dwc3/platform_data.h                   |    1 +
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/usb/phy/Kconfig                            |   11 -
 drivers/usb/phy/Makefile                           |    2 -
 drivers/usb/phy/phy-twl6030-usb.c                  |    2 +-
 .../omap_control_usb.h => phy/omap_control_phy.h}  |   32 +--
 include/linux/{usb/omap_usb.h => phy/omap_pipe3.h} |   33 +--
 include/linux/{usb => phy}/omap_usb.h              |    3 -
 19 files changed, 348 insertions(+), 284 deletions(-)
 rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/omap-phy.txt} (88%)
 rename drivers/{usb => }/phy/phy-omap-control.c (55%)
 rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-omap-pipe3.c} (55%)
 rename include/linux/{usb/omap_control_usb.h => phy/omap_control_phy.h} (69%)
 copy include/linux/{usb/omap_usb.h => phy/omap_pipe3.h} (52%)
 rename include/linux/{usb => phy}/omap_usb.h (95%)

-- 
1.7.10.4

