Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3GHLO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:14:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54520 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab3GHLOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:14:55 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 0/4] usb: musb: fix USB enumeration issue in OMAP3 platform
Date: Mon, 8 Jul 2013 16:44:13 +0530
Message-ID: <1373282057-20181-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes the USB enumeration issue caused because of the controller
not able to get a reference to the PHY because of incorrect binding in the
board file.

In the case of non-dt boot, the platform specific initialization file
(board file) will do usb_bind_phy that binds the usb controller with the
PHY using device names. After the device names are created using 
PLATFORM_DEVID_AUTO, our original method of binding by device names doesn't
work reliably (since the device name changes). Hence the usb controller
is made to use labels for getting the PHY.

Here the PHY name is added in the plat data of USB controller device which
should be used by the controller driver to get the PHY.
Two new APIs usb_get_phy_by_name and devm_usb_get_phy_by_name are added to
be used by the controller to get the PHY by name.

Changes from v1:
*) Rebased to the latest mainline kernel

Changes from RFC
*) Changed the signature of usb_get_phy_by_name() not to use struct device *

Kishon Vijay Abraham I (4):
  arm: omap: Add phy binding info for musb in plat data
  usb: phy: add a new API to get PHY ref by label
  usb: musb: omap: use the new API to get PHY reference by label
  arm: omap: remove using usb_bind_phy for binding musb and phy

 arch/arm/mach-omap2/board-2430sdp.c          |    1 -
 arch/arm/mach-omap2/board-3430sdp.c          |    1 -
 arch/arm/mach-omap2/board-cm-t35.c           |    1 -
 arch/arm/mach-omap2/board-devkit8000.c       |    1 -
 arch/arm/mach-omap2/board-igep0020.c         |    1 -
 arch/arm/mach-omap2/board-ldp.c              |    1 -
 arch/arm/mach-omap2/board-omap3beagle.c      |    1 -
 arch/arm/mach-omap2/board-omap3evm.c         |    1 -
 arch/arm/mach-omap2/board-omap3logic.c       |    1 -
 arch/arm/mach-omap2/board-omap3pandora.c     |    1 -
 arch/arm/mach-omap2/board-omap3stalker.c     |    1 -
 arch/arm/mach-omap2/board-omap3touchbook.c   |    1 -
 arch/arm/mach-omap2/board-overo.c            |    1 -
 arch/arm/mach-omap2/board-rm680.c            |    1 -
 arch/arm/mach-omap2/board-rx51.c             |    1 -
 arch/arm/mach-omap2/board-zoom-peripherals.c |    1 -
 arch/arm/mach-omap2/usb-musb.c               |    3 +
 drivers/usb/musb/musb_core.c                 |    1 +
 drivers/usb/musb/musb_core.h                 |    1 +
 drivers/usb/musb/omap2430.c                  |    2 +-
 drivers/usb/phy/phy.c                        |   77 ++++++++++++++++++++++++++
 include/linux/usb/musb.h                     |    3 +
 include/linux/usb/phy.h                      |   14 +++++
 23 files changed, 100 insertions(+), 17 deletions(-)

-- 
1.7.10.4

