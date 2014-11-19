Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaKSP22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:28:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:1978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbaKSP21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:28:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="639756103"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrew.kim@intel.com
Subject: [PATCHv5 0/7] phy: simplified phy lookup
Date: Wed, 19 Nov 2014 17:28:16 +0200
Message-Id: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set will in practice just separate the creation of a phy and
binding of it to the consumer. Mapping phys to consumers can be now
done with lookups similarly how clocks can be mapped in clkdev.c.

Vivek needs to handle the phys of dwc3 also in xhci driver on
Exynos5420 SoC, so I'm resending these now.

Changes since v4:
- Support for static lookups is dropped. The lookups can be now only
  be created with phy_create_lookup()

Changes since v3:
- We can't rely on the order in which the phys are registered, so
  using the name of the parent of the phy instance for matching
  instead of the phy itself. The parent device is always the actual
  physical device.
- Using PHY_LOOKUP macro in twl-common.c as suggested by Kishon.

Changes since v2:
- Calling ida_simple_remove in release function as pointed out by Greg


Heikki Krogerus (7):
  phy: safer to_phy() macro
  phy: improved lookup method
  phy: twl4030: use the new lookup method
  arm: omap3: twl: remove usb phy init data
  phy: remove the old lookup method
  base: platform: name the device already during allocation
  usb: dwc3: host: convey the PHYs to xhci

 Documentation/phy.txt                |  60 ++++++--------------
 arch/arm/mach-omap2/twl-common.c     |  12 +---
 drivers/base/platform.c              |  69 +++++++++++++----------
 drivers/phy/phy-bcm-kona-usb2.c      |   2 +-
 drivers/phy/phy-berlin-sata.c        |   2 +-
 drivers/phy/phy-core.c               | 105 ++++++++++++++++++++++++-----------
 drivers/phy/phy-exynos-dp-video.c    |   2 +-
 drivers/phy/phy-exynos-mipi-video.c  |   2 +-
 drivers/phy/phy-exynos5-usbdrd.c     |   3 +-
 drivers/phy/phy-exynos5250-sata.c    |   2 +-
 drivers/phy/phy-hix5hd2-sata.c       |   2 +-
 drivers/phy/phy-miphy365x.c          |   2 +-
 drivers/phy/phy-mvebu-sata.c         |   2 +-
 drivers/phy/phy-omap-usb2.c          |   2 +-
 drivers/phy/phy-qcom-apq8064-sata.c  |   3 +-
 drivers/phy/phy-qcom-ipq806x-sata.c  |   3 +-
 drivers/phy/phy-rcar-gen2.c          |   2 +-
 drivers/phy/phy-samsung-usb2.c       |   3 +-
 drivers/phy/phy-spear1310-miphy.c    |   2 +-
 drivers/phy/phy-spear1340-miphy.c    |   2 +-
 drivers/phy/phy-stih407-usb.c        |   2 +-
 drivers/phy/phy-stih41x-usb.c        |   2 +-
 drivers/phy/phy-sun4i-usb.c          |   2 +-
 drivers/phy/phy-ti-pipe3.c           |   2 +-
 drivers/phy/phy-twl4030-usb.c        |   9 ++-
 drivers/phy/phy-xgene.c              |   2 +-
 drivers/pinctrl/pinctrl-tegra-xusb.c |   4 +-
 drivers/usb/dwc3/host.c              |  22 ++++++--
 include/linux/i2c/twl.h              |   2 -
 include/linux/phy/phy.h              |  52 +++++++----------
 30 files changed, 195 insertions(+), 186 deletions(-)

-- 
2.1.3

