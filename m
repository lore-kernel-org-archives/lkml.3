Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaGVK5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46563 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbaGVK5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 00/28] PHY: for 3.17
Date: Tue, 22 Jul 2014 16:26:23 +0530
Message-ID: <1406026611-30493-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the PULL Request for 3.17 merge window. It adds regulator
support in PHY core and adds better support for multi-phy PHY providers.
It includes a bunch of new PHY drivers and some misc cleanups and fixes.

Let me know if I have to change something.

Cheers
Kishon

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for_3.17

for you to fetch changes up to 7ebdb52e192c4d496a9b3a87d47eba3eba3e1fd4:

  phy: miphy365x: Represent each PHY channel as a DT subnode (2014-07-22 12:46:43 +0530)

----------------------------------------------------------------
for_3.17

Adds regulator support in PHY core. PHY core is modified to support
representation of multi-phy PHY providers with each individual PHY
as sub-node OF PHY provider node. New PHY drivers adapted to PHY
framework (hix5hd2 SATA PHY, QCOM APQ8064 SATA PHY,
QCOM IPQ806x SATA PHY, Berlin SATA PHY and MiPHY356x). Existing
TI PIPE3 PHY can now be used for PCIe too. Includes misc fixes and
cleanups.

----------------------------------------------------------------
Andrew Lunn (1):
      phy: Remove ARCH_KIRKWOOD dependency

Antoine Ténart (2):
      phy: add a driver for the Berlin SATA PHY
      Documentation: bindings: add the Berlin SATA PHY

Jiancheng Xue (2):
      Documentation: Document Hisilicon hix5hd2 sata PHY
      phy: add hix5hd2-sata-phy driver

Jingoo Han (1):
      phy: exynos5-usbdrd: Make local functions static

Kamil Debski (1):
      phy: phy-samsung-usb2: Change phy power on/power off sequence

Kishon Vijay Abraham I (4):
      phy: phy-omap-pipe3: Add support for PCIe PHY
      phy: pipe3: insert delay to enumerate in GEN2 mode
      phy: core: Fix of_phy_provider_lookup to return PHY provider for sub node
      phy: core: Let node ptr of PHY point to PHY and not of PHY provider

Kumar Gala (2):
      phy: qcom: Add driver for QCOM IPQ806x SATA PHY
      phy: qcom: Add device tree bindings for IPQ806x SATA PHY

Lee Jones (4):
      phy: miphy365x: Add MiPHY365x header file for DT x Driver defines
      phy: miphy365x: Add Device Tree bindings for the MiPHY365x
      phy: miphy365x: Provide support for the MiPHY356x Generic PHY
      phy: miphy365x: Represent each PHY channel as a DT subnode

Marek Szyprowski (1):
      drivers: phy: exynos-usb2: add support for Exynos 3250

Roger Quadros (2):
      phy: core: Support regulator supply for PHY power
      phy: core: Add phy-supply to DT binding documentation

Sachin Kamat (5):
      phy: exynos-dp-video: Use PTR_ERR_OR_ZERO
      phy: exynos-mipi-video: Use PTR_ERR_OR_ZERO
      phy: sun4i-usb: Use PTR_ERR_OR_ZERO
      phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
      phy: Kconfig: Update config for Exynos USB DRD

Srinivas Kandagatla (3):
      phy: qcom: Add driver for QCOM APQ8064 SATA PHY
      phy: qcom: Add APQ8064 SATA PHY device tree bindings
      phy: qcom-apq8064: fix possible timeout without check

 .../devicetree/bindings/phy/berlin-sata-phy.txt    |   34 ++
 .../devicetree/bindings/phy/hix5hd2-phy.txt        |   22 +
 .../devicetree/bindings/phy/phy-bindings.txt       |    4 +
 .../devicetree/bindings/phy/phy-miphy365x.txt      |   76 +++
 .../bindings/phy/qcom-apq8064-sata-phy.txt         |   24 +
 .../bindings/phy/qcom-ipq806x-sata-phy.txt         |   23 +
 .../devicetree/bindings/phy/samsung-phy.txt        |    2 +
 Documentation/devicetree/bindings/phy/ti-phy.txt   |   23 +-
 Documentation/phy.txt                              |   10 +-
 drivers/phy/Kconfig                                |   78 ++-
 drivers/phy/Makefile                               |    5 +
 drivers/phy/phy-bcm-kona-usb2.c                    |    2 +-
 drivers/phy/phy-berlin-sata.c                      |  284 +++++++++
 drivers/phy/phy-core.c                             |   56 +-
 drivers/phy/phy-exynos-dp-video.c                  |    7 +-
 drivers/phy/phy-exynos-mipi-video.c                |    7 +-
 drivers/phy/phy-exynos4x12-usb2.c                  |  125 ++--
 drivers/phy/phy-exynos5-usbdrd.c                   |    9 +-
 drivers/phy/phy-exynos5250-sata.c                  |    2 +-
 drivers/phy/phy-exynos5250-usb2.c                  |    2 -
 drivers/phy/phy-hix5hd2-sata.c                     |  192 ++++++
 drivers/phy/phy-miphy365x.c                        |  636 ++++++++++++++++++++
 drivers/phy/phy-mvebu-sata.c                       |    2 +-
 drivers/phy/phy-omap-control.c                     |   52 +-
 drivers/phy/phy-omap-usb2.c                        |    2 +-
 drivers/phy/phy-qcom-apq8064-sata.c                |  289 +++++++++
 drivers/phy/phy-qcom-ipq806x-sata.c                |  211 +++++++
 drivers/phy/phy-samsung-usb2.c                     |    9 +-
 drivers/phy/phy-samsung-usb2.h                     |    5 +-
 drivers/phy/phy-sun4i-usb.c                        |    7 +-
 drivers/phy/phy-ti-pipe3.c                         |  107 +++-
 drivers/phy/phy-twl4030-usb.c                      |    2 +-
 drivers/phy/phy-xgene.c                            |    2 +-
 include/dt-bindings/phy/phy-miphy365x.h            |   14 +
 include/linux/phy/omap_control_phy.h               |   10 +
 include/linux/phy/phy.h                            |   17 +-
 36 files changed, 2218 insertions(+), 134 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-apq8064-sata-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-ipq806x-sata-phy.txt
 create mode 100644 drivers/phy/phy-berlin-sata.c
 create mode 100644 drivers/phy/phy-hix5hd2-sata.c
 create mode 100644 drivers/phy/phy-miphy365x.c
 create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c
 create mode 100644 drivers/phy/phy-qcom-ipq806x-sata.c
 create mode 100644 include/dt-bindings/phy/phy-miphy365x.h

-- 
1.7.9.5

