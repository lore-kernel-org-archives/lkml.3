Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaIXNrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:47:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38781 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaIXNrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:24 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 00/22] PHY: for 3.18
Date: Wed, 24 Sep 2014 19:16:58 +0530
Message-ID: <1411566440-19169-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the PULL Request for 3.18 merge window.
It includes 3 new PHY drivers adapted to the PHY framework and 
misc cleanups and fixes.

Let me know if I have to change something.

Cheers
Kishon

The following changes since commit 452b6361c4d9baf6940adb7b1316e0f386c39799:

  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2014-09-23 16:47:34 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/phy-for_3.18

for you to fetch changes up to 4f0eb5d7efe375859b15c97f453113a242bf057b:

  phy: remove .owner field for drivers using module_platform_driver (2014-09-24 15:18:34 +0530)

----------------------------------------------------------------
Adds 3 new PHY drivers stih407, stih41x and rcar gen2 PHY. It also
includes miscellaneous cleanup of other PHY drivers.

----------------------------------------------------------------
Peter Griffin (15):
      phy: phy-omap-control: Remove unncessary site specific OOM messages
      phy: phy-mvebu-sata: Add missing error check for devm_kzalloc
      phy: phy-omap-usb2: Remove unncessary site specific OOM messages
      phy: phy-ti-pipe3: Remove unncessary site specific OOM messages
      phy: phy-spear1310-miphy: Remove unncessary site specific OOM messages
      phy: phy-spear1340-miphy: Remove unncessary site specific OOM messages
      phy: phy-spear1310-miphy: Use module_platform_driver to register driver.
      phy: phy-spear1340-miphy: Use module_platform_driver to register driver.
      phy: phy-stih407-usb: Add usb picoPHY driver found on stih407 SoC family
      phy: phy-stih407-usb: Add dt documentation for USB picophy found on stih407 SoC family
      MAINTAINERS: Add phy-stih407-usb.c file to ARCH/STI architecture
      phy: phy-stih41x-usb: Add usb phy support for STiH41x SoCs.
      phy: phy-stih41x-usb: Add dt documentation for USB phy on STiH415/6
      MAINTAINERS: Add phy-stih41x-usb.c to ARCH/STI architecture
      phy: remove .owner field for drivers using module_platform_driver

Sergei Shtylyov (1):
      phy: Renesas R-Car Gen2 PHY driver

Tony Lindgren (5):
      usb: phy: twl4030-usb: Remove unused irq_enabled
      usb: phy: twl4030-usb: Simplify phy init to use runtime PM
      usb: phy: twl4030-usb: Move code from twl4030_phy_power to the runtime PM calls
      usb: phy: twl4030-usb: Remove asleep and rely on runtime PM
      usb: phy: twl4030-usb: Use mutex instead of spinlock for protecting the data

Vivek Gautam (1):
      phy: exynos-dp-video: Use syscon support to control pmu register

 .../devicetree/bindings/phy/phy-stih407-usb.txt    |   30 ++
 .../devicetree/bindings/phy/phy-stih41x-usb.txt    |   24 ++
 .../devicetree/bindings/phy/rcar-gen2-phy.txt      |   51 +++
 .../devicetree/bindings/phy/samsung-phy.txt        |    7 +-
 MAINTAINERS                                        |    2 +
 drivers/phy/Kconfig                                |   24 ++
 drivers/phy/Makefile                               |    3 +
 drivers/phy/phy-bcm-kona-usb2.c                    |    1 -
 drivers/phy/phy-berlin-sata.c                      |    1 -
 drivers/phy/phy-exynos-dp-video.c                  |   80 +++--
 drivers/phy/phy-exynos-mipi-video.c                |    1 -
 drivers/phy/phy-exynos5-usbdrd.c                   |    1 -
 drivers/phy/phy-exynos5250-sata.c                  |    1 -
 drivers/phy/phy-hix5hd2-sata.c                     |    1 -
 drivers/phy/phy-miphy365x.c                        |    1 -
 drivers/phy/phy-mvebu-sata.c                       |    3 +-
 drivers/phy/phy-omap-control.c                     |    5 +-
 drivers/phy/phy-omap-usb2.c                        |    9 +-
 drivers/phy/phy-qcom-apq8064-sata.c                |    1 -
 drivers/phy/phy-qcom-ipq806x-sata.c                |    1 -
 drivers/phy/phy-rcar-gen2.c                        |  341 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.c                     |    1 -
 drivers/phy/phy-spear1310-miphy.c                  |   17 +-
 drivers/phy/phy-spear1340-miphy.c                  |   17 +-
 drivers/phy/phy-stih407-usb.c                      |  177 ++++++++++
 drivers/phy/phy-stih41x-usb.c                      |  187 +++++++++++
 drivers/phy/phy-sun4i-usb.c                        |    1 -
 drivers/phy/phy-ti-pipe3.c                         |    6 +-
 drivers/phy/phy-twl4030-usb.c                      |  125 +++----
 drivers/phy/phy-xgene.c                            |    1 -
 30 files changed, 955 insertions(+), 165 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih41x-usb.txt
 create mode 100644 Documentation/devicetree/bindings/phy/rcar-gen2-phy.txt
 create mode 100644 drivers/phy/phy-rcar-gen2.c
 create mode 100644 drivers/phy/phy-stih407-usb.c
 create mode 100644 drivers/phy/phy-stih41x-usb.c

-- 
1.7.9.5

