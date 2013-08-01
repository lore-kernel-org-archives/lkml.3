Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3HAOFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:05:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57463 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab3HAOFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:05:20 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/7] phy: omap-usb: Support multiple instances and new types
Date: Thu, 1 Aug 2013 17:05:08 +0300
Message-ID: <1375365915-21380-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset does the following:

* Restructure and add support for new PHY types. We now support the follwing
four types

 TYPE1 - if it has otghs_control mailbox register (e.g. on OMAP4)
 TYPE2 - if it has Power down bit in control_dev_conf register. e.g. USB2 PHY
 TYPE3 - if it has DPLL and individual Rx & Tx power control. e.g. USB3 PHY or SATA PHY
 TYPE4 - if it has both power down and power aux registers. e.g. USB2 PHY on DRA7

* Have only one power control API "omap_control_usb_phy_power()" instead of a
different one for each PHY type.

* Get rid of omap_get_control_dev() so that we can support multiple instances
of the control device. We take advantage of the fact that omap control USB device
is only present on OMAP4 onwards and hence only supports DT boot. The users
of control USB device can get a reference to it from the device node's phandle.

Patches are based on top of v3.11-rc3 with balbi/next on top.

Smoke tested on OMAP4 panda with MUSB in gadget mode (g_zero).

You can find the patches in branch
 usb-control-module
in git tree
 git://github.com/rogerq/linux.git

cheers,
-roger

Roger Quadros (7):
  usb: phy: omap: Add new PHY types and remove
    omap_control_usb3_phy_power()
  usb: phy: omap-usb2: Don't use omap_get_control_dev()
  usb: phy: omap-usb3: Don't use omap_get_control_dev()
  usb: musb: omap2430: Don't use omap_get_control_dev()
  usb: phy: omap: get rid of omap_get_control_dev()
  ARM: dts: omap4: update omap-control-usb nodes
  ARM: dts: omap5: update omap-control-usb node

 Documentation/devicetree/bindings/usb/omap-usb.txt |   23 ++--
 arch/arm/boot/dts/omap4.dtsi                       |   17 ++-
 arch/arm/boot/dts/omap5.dtsi                       |   18 ++-
 drivers/usb/musb/omap2430.c                        |   22 +++-
 drivers/usb/phy/phy-omap-control.c                 |  160 ++++++++++---------
 drivers/usb/phy/phy-omap-usb2.c                    |   20 ++-
 drivers/usb/phy/phy-omap-usb3.c                    |   26 +++-
 include/linux/usb/omap_control_usb.h               |   23 +--
 8 files changed, 182 insertions(+), 127 deletions(-)

-- 
1.7.4.1

