Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaCFOXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:23:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43982 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaCFOXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:23:44 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.comg>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 00/13] ARM: OMAP: SATA support for OMAP5 & DRA7
Date: Thu, 6 Mar 2014 16:22:52 +0200
Message-ID: <1394115785-28301-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds SATA support for OMAP5 uevm and DRA7-evm boards.

- Cleans up the ti-pipe3 PHY driver
- Adds SATA DPLL support to ti-pipe3 PHY driver
- Adds SATA nodes to hwmod and SoC DT data

Patches are based on 3.14-rc4 with balbi/next, linux-phy/next and
omap-for-v3.15/dt merged on top..

To test SATA you will also need [1].

[1] - http://article.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7285

Changelog:

v2
- use 'depends on' instead of 'select' OCP2SCP bus driver.
- Changed DT bindings for dra7-usb2 and am437-usb2 phy.

cheers,
-roger

---
Balaji T K (2):
  ARM: dts: omap5: add sata node
  ARM: dts: dra7: add OCP2SCP3 and SATA nodes

Keshava Munegowda (1):
  ARM: OMAP5: hwmod: Add ocp2scp3 and sata hwmods

Kishon Vijay Abraham I (1):
  phy: rename struct omap_control_usb to struct omap_control_phy

Nikhil Devshatwar (1):
  ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods

Roger Quadros (8):
  phy: omap-control: Update DT binding information
  phy: omap-control: update dra7 and am437 usb2 bindings
  phy: ti-pipe3: cleanup clock handling
  phy: ti-pipe3: Add SATA DPLL support
  phy: ti-pipe3: Don't get 'wkupclk' and 'refclk' for SATA PHY
  phy: ti-pipe3: streamline PHY operations
  phy: ti-pipe3: Fix suspend/resume and module reload
  phy: omap: Depend on OMAP_OCP2SCP bus driver

 Documentation/devicetree/bindings/phy/ti-phy.txt   |  40 ++-
 Documentation/devicetree/bindings/usb/omap-usb.txt |  24 --
 arch/arm/boot/dts/dra7.dtsi                        |  39 +++
 arch/arm/boot/dts/omap5.dtsi                       |  47 ++-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |  73 +++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  31 +-
 drivers/phy/Kconfig                                |  16 +-
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-omap-control.c                     | 320 +++++++++++++++++++++
 drivers/phy/phy-omap-usb2.c                        |   8 +-
 drivers/phy/phy-ti-pipe3.c                         | 269 ++++++++++-------
 drivers/usb/musb/omap2430.c                        |   2 +-
 drivers/usb/phy/Kconfig                            |  10 -
 drivers/usb/phy/Makefile                           |   1 -
 drivers/usb/phy/phy-omap-control.c                 | 319 --------------------
 include/linux/phy/omap_control_phy.h               |  89 ++++++
 include/linux/usb/omap_control_usb.h               |  89 ------
 17 files changed, 815 insertions(+), 563 deletions(-)
 create mode 100644 drivers/phy/phy-omap-control.c
 delete mode 100644 drivers/usb/phy/phy-omap-control.c
 create mode 100644 include/linux/phy/omap_control_phy.h
 delete mode 100644 include/linux/usb/omap_control_usb.h

-- 
1.8.3.2

