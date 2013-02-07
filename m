Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab3BGQDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:03:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39834 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab3BGQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:03:09 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <linux@arm.linux.org.uk>, <kishon@ti.com>,
        <mark.rutland@arm.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 00/14] Device tree support for OMAP HS USB Host
Date: Thu, 7 Feb 2013 18:02:40 +0200
Message-ID: <1360252974-7912-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds device tree support for OMAP's High Speed USB Host
subsystem. Board adaptation for Panda and Beagleboard is also provided.

Tested on Beagleboard.

Will not yet work on Pandaboard as PHY clock is not provided in device tree.
We will need to address the PHY clock as per the discussion.
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg84525.html

v2:
- Addressed review comments, hopefully device tree parsing is more
  compliant and robust now.
- Added one new patch to fix omap-ehci module auto loading

The following changes since commit 286752ff5401f4b1675c4c33d13252a96e66bcb3:

  USB: ehci-omap: Select NOP USB transceiver driver (2013-02-07 17:00:54 +0200)

are available in the git repository at:
  git@github.com:rogerq/linux.git usb-next-usbhost16-dt

Roger Quadros (14):
      usb: phy: nop: Add device tree support and binding information
      USB: phy: nop: Defer probe if device needs VCC/RESET
      mfd: omap-usb-tll: move configuration code to omap_tll_init()
      mfd: omap-usb-tll: Add device tree support
      USB: ehci-omap: Get platform resources by index rather than by name
      USB: ohci-omap3: Get platform resources by index rather than by name
      USB: ohci-omap3: Add device tree support and binding information
      USB: ehci-omap: Add device tree support and binding information
      mfd: omap-usb-host: Add device tree support and binding information
      ARM: dts: OMAP4: Add HS USB Host IP nodes
      ARM: dts: omap4-panda: Add USB Host support
      ARM: dts: OMAP3: Add HS USB Host IP nodes
      ARM: dts: omap3-beagle: Add USB Host support
      USB: ehci-omap: Fix autoloading of module

 .../devicetree/bindings/mfd/omap-usb-host.txt      |   80 ++++++++
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |   17 ++
 .../devicetree/bindings/usb/omap-ehci.txt          |   34 +++
 .../devicetree/bindings/usb/omap3-ohci.txt         |   17 ++
 .../devicetree/bindings/usb/usb-nop-xceiv.txt      |   34 +++
 arch/arm/boot/dts/omap3-beagle.dts                 |   71 +++++++
 arch/arm/boot/dts/omap3.dtsi                       |   31 +++
 arch/arm/boot/dts/omap4-panda.dts                  |   55 +++++
 arch/arm/boot/dts/omap4.dtsi                       |   30 +++
 drivers/mfd/omap-usb-host.c                        |  167 +++++++++++++++-
 drivers/mfd/omap-usb-tll.c                         |  213 ++++++++++----------
 drivers/mfd/omap-usb.h                             |    5 +-
 drivers/usb/host/ehci-omap.c                       |   46 ++++-
 drivers/usb/host/ohci-omap3.c                      |   24 ++-
 drivers/usb/otg/nop-usb-xceiv.c                    |   47 ++++-
 include/linux/usb/nop-usb-xceiv.h                  |    4 +
 16 files changed, 743 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-host.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
 create mode 100644 Documentation/devicetree/bindings/usb/omap-ehci.txt
 create mode 100644 Documentation/devicetree/bindings/usb/omap3-ohci.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt

-- 
1.7.4.1

