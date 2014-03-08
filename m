Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaCHJ3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:29:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46923 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaCHJ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:29:33 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 00/28] PHY for 3.15
Date: Sat, 8 Mar 2014 14:59:01 +0530
Message-ID: <1394270969-11851-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the PULL REQUEST for 3.15 merge window.
More users are starting to use the generic PHY framework including USB and
SATA PHY in exynos, USB in sunxi and multi-purpose PHY (currently only SATA)
in APM. There is also a patch to adapt USB3 PHY driver (PIPE3) used in OMAP
to generic PHY framework and use the same driver for SATA.
It also includes few fixes and cleanups.

Please let me know if you want me to make any changes.

Cheers
Kishon

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for_3.15

for you to fetch changes up to 303fd52cda953d14dc82ac82b570761599eb9ab2:

  PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver (2014-03-08 12:39:51 +0530)

----------------------------------------------------------------
Add new PHY drivers for SATA and USB in exynos, for USB in sunxi,
and a multi-purpose PHY in APM, all adapted to generic PHY framework.
Adapted USB3 PHY driver in OMAP to generic PHY driver and also used
the same driver for SATA in OMAP. It also includes miscellaneous cleanups
and fixes.

----------------------------------------------------------------
Austin Beam (1):
      phy: omap-usb2: Provide workaround for USB2PHY false disconnect

George Cherian (2):
      phy: omap-usb2: Adapt phy-omap-usb2 for AM437x
      phy: omap-usb2: Add different compatible for OMAP5

Hans de Goede (1):
      PHY: sunxi: Add driver for sunxi usb phy

Kamil Debski (4):
      phy: core: Add an exported of_phy_get function
      phy: core: Add devm_of_phy_get to phy-core
      phy: Add new Exynos USB 2.0 PHY driver
      phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver

Kishon Vijay Abraham I (4):
      drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
      usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
      phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
      phy: rename struct omap_control_usb to struct omap_control_phy

Loc Ho (2):
      Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation
      PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver

Roger Quadros (7):
      phy: omap-control: update dra7 and am437 usb2 bindings
      phy: ti-pipe3: cleanup clock handling
      phy: ti-pipe3: Add SATA DPLL support
      phy: ti-pipe3: Don't get 'wkupclk' and 'refclk' for SATA PHY
      phy: ti-pipe3: streamline PHY operations
      phy: ti-pipe3: Fix suspend/resume and module reload
      phy: omap: Depend on OMAP_OCP2SCP bus driver

Sachin Kamat (3):
      usb: phy: twl4030-usb: Silence checkpatch warnings
      usb: phy: twl4030-usb: Remove redundant semicolon
      usb: phy: bcm-kona-usb2: Use PTR_ERR_OR_ZERO

Sebastian Hesselbarth (1):
      phy: mvebu-sata: prepare new Dove DT Kconfig variable

Sylwester Nawrocki (2):
      phy: Select PHY_EXYNOS_MIPI_VIDEO by default for ARCH_EXYNOS
      phy: Select PHY_EXYNOS_DP_VIDEO by default for ARCH_EXYNOS

Yuvaraj Kumar C D (1):
      PHY: Exynos: Add Exynos5250 SATA PHY driver

 .../devicetree/bindings/phy/apm-xgene-phy.txt      |   79 +
 .../devicetree/bindings/phy/samsung-phy.txt        |   54 +
 .../devicetree/bindings/phy/sun4i-usb-phy.txt      |   26 +
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 +-
 Documentation/phy/samsung-usb2.txt                 |  135 ++
 drivers/phy/Kconfig                                |  107 +-
 drivers/phy/Makefile                               |    9 +
 drivers/phy/phy-bcm-kona-usb2.c                    |    4 +-
 drivers/phy/phy-core.c                             |   76 +-
 drivers/phy/phy-exynos4210-usb2.c                  |  261 +++
 drivers/phy/phy-exynos4x12-usb2.c                  |  328 ++++
 drivers/phy/phy-exynos5250-sata.c                  |  251 +++
 drivers/phy/phy-exynos5250-usb2.c                  |  404 +++++
 drivers/{usb => }/phy/phy-omap-control.c           |  169 +-
 drivers/phy/phy-omap-usb2.c                        |  131 +-
 drivers/phy/phy-samsung-usb2.c                     |  228 +++
 drivers/phy/phy-samsung-usb2.h                     |   67 +
 drivers/phy/phy-sun4i-usb.c                        |  331 ++++
 drivers/phy/phy-ti-pipe3.c                         |  470 ++++++
 drivers/phy/phy-twl4030-usb.c                      |    6 +-
 drivers/phy/phy-xgene.c                            | 1750 ++++++++++++++++++++
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/usb/phy/Kconfig                            |   21 -
 drivers/usb/phy/Makefile                           |    2 -
 drivers/usb/phy/phy-omap-usb3.c                    |  361 ----
 drivers/usb/phy/phy-twl6030-usb.c                  |    2 +-
 .../omap_control_usb.h => phy/omap_control_phy.h}  |   36 +-
 include/linux/{usb => phy}/omap_usb.h              |   14 +-
 include/linux/phy/phy.h                            |   15 +
 29 files changed, 4797 insertions(+), 548 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/sun4i-usb-phy.txt
 create mode 100644 Documentation/phy/samsung-usb2.txt
 create mode 100644 drivers/phy/phy-exynos4210-usb2.c
 create mode 100644 drivers/phy/phy-exynos4x12-usb2.c
 create mode 100644 drivers/phy/phy-exynos5250-sata.c
 create mode 100644 drivers/phy/phy-exynos5250-usb2.c
 rename drivers/{usb => }/phy/phy-omap-control.c (53%)
 create mode 100644 drivers/phy/phy-samsung-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.h
 create mode 100644 drivers/phy/phy-sun4i-usb.c
 create mode 100644 drivers/phy/phy-ti-pipe3.c
 create mode 100644 drivers/phy/phy-xgene.c
 delete mode 100644 drivers/usb/phy/phy-omap-usb3.c
 rename include/linux/{usb/omap_control_usb.h => phy/omap_control_phy.h} (68%)
 rename include/linux/{usb => phy}/omap_usb.h (86%)
-- 
1.7.9.5

