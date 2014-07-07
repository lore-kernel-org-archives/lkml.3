Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaGGGsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:48:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53613 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGGGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:48:43 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 0/8] phy: fixes for 3.16 -rc cycle
Date: Mon, 7 Jul 2014 12:18:17 +0530
Message-ID: <1404715705-5041-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please find the pull requeust for 3.16 -rc cycle for PHY subsystem.

It contains few fixes in phy-core and few other PHY drivers. It also adds
regulatore support in PHY core which is needed to get USB and SATA working in
DRA7xx.

Please consider merging this for this -rc cylce. Let me know if I have to
change something.

Cheers
Kishon

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.16-rc

for you to fetch changes up to 59a7ada8f05269172aa80cf92017a35abe6a0339:

  phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove (2014-07-04 20:43:26 +0530)

----------------------------------------------------------------
for 3.16-rc

Contains fixes in phy-core and other minor fixes in some of the other
PHY drivers. It also adds regulator support in PHY core needed to get
USB and SATA working in DRA7x. (These regulators were always on
previously).

----------------------------------------------------------------
Himangi Saraogi (1):
      usb: phy: omap-usb2: fix devm_ioremap_resource error detection code

Kamil Debski (1):
      phy: phy-samsung-usb2: Change phy power on/power off sequence

Maxime Ripard (1):
      phy: sun4i: depend on RESET_CONTROLLER

Roger Quadros (4):
      phy: core: Fix error path in phy_create()
      phy: core: Support regulator supply for PHY power
      phy: core: Add phy-supply to DT binding documentation
      phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove

Sjoerd Simons (1):
      drivers: phy: phy-samsung-usb2.c: Add missing MODULE_DEVICE_TABLE

 .../devicetree/bindings/phy/phy-bindings.txt       |    4 +
 drivers/phy/Kconfig                                |    1 +
 drivers/phy/phy-core.c                             |   33 +++++-
 drivers/phy/phy-exynos4x12-usb2.c                  |  112 +++++++++++++-------
 drivers/phy/phy-exynos5250-usb2.c                  |    2 -
 drivers/phy/phy-omap-usb2.c                        |   11 +-
 drivers/phy/phy-samsung-usb2.c                     |    1 +
 drivers/phy/phy-samsung-usb2.h                     |    3 +-
 include/linux/phy/phy.h                            |    2 +
 9 files changed, 122 insertions(+), 47 deletions(-)

-- 
1.7.9.5

