Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaHULeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:34:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:29682 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbaHULeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="591291250"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCHv3 0/6] phy: simplified phy lookup
Date: Thu, 21 Aug 2014 14:33:17 +0300
Message-Id: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So the idea with these is that they should help to make it possible to
request phys without caring about how they are mapped to the
consumers, meaning, was is the mapping done in DT, ACPI, etc. Mapping
phys to consumers can be now done with lookups similarly how clocks
can be mapped in clkdev.c.

Vivek needs to handle the phys of dwc3 also in xhci driver on
Exynos5420 SoC, so I'm resending these now.

Changes since v2:
- Calling ida_simple_remove in release function as pointed out by Greg


Heikki Krogerus (6):
  phy: safer to_phy() macro
  phy: improved lookup method
  arm: omap3: twl: use the new lookup method with usb phy
  phy: remove the old lookup method
  base: platform: name the device already during allocation
  usb: dwc3: host: convey the PHYs to xhci

 Documentation/phy.txt               |  66 +++++----------
 arch/arm/mach-omap2/twl-common.c    |  18 ++---
 drivers/base/platform.c             |  69 +++++++++-------
 drivers/phy/phy-bcm-kona-usb2.c     |   2 +-
 drivers/phy/phy-core.c              | 156 +++++++++++++++++++++++++++++-------
 drivers/phy/phy-exynos-dp-video.c   |   2 +-
 drivers/phy/phy-exynos-mipi-video.c |   2 +-
 drivers/phy/phy-exynos5-usbdrd.c    |   3 +-
 drivers/phy/phy-exynos5250-sata.c   |   2 +-
 drivers/phy/phy-mvebu-sata.c        |   2 +-
 drivers/phy/phy-omap-usb2.c         |   2 +-
 drivers/phy/phy-samsung-usb2.c      |   3 +-
 drivers/phy/phy-sun4i-usb.c         |   2 +-
 drivers/phy/phy-ti-pipe3.c          |   2 +-
 drivers/phy/phy-twl4030-usb.c       |   4 +-
 drivers/phy/phy-xgene.c             |   2 +-
 drivers/usb/dwc3/host.c             |  22 +++--
 include/linux/phy/phy.h             |  61 +++++++-------
 18 files changed, 253 insertions(+), 167 deletions(-)

-- 
2.1.0

