Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaK0Gew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:34:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41690 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaK0G0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:20 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 00/25] phy: for 3.19
Date: Thu, 27 Nov 2014 11:55:52 +0530
Message-ID: <1417069577-1169-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please find the pull request for 3.19 merge window.

This contains improvements in phy core dealing with non-dt boot.
It also adds 3 new phy drivers armada375-usb2, berlin-usb and miphy28lp.

There is a patch that touches drivers/pinctrl since one of the PHY drivers
is present there and it has to be modified to use the modified
devm_phy_create API.

Let me know If I have to change something.

Thanks
Kishon

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.19

for you to fetch changes up to eee47538ec1f26198cf5da675975b61d7f16135b:

  phy: add support for USB cluster on the Armada 375 SoC (2014-11-26 11:07:14 +0530)

----------------------------------------------------------------
Improvements in phy-core specifically on PHY core finds the PHY in the case
of non-dt boot. Adds three new PHY drivers using the PHY framework and some
miscellaneous fixes and cleanups.

----------------------------------------------------------------
Andrew Lunn (1):
  Phy: DT binding documentation for Marvell MVEBU SATA phy.

Antoine Tenart (2):
  phy: add the Berlin USB PHY driver
  Documentation: bindings: add doc for the Berlin USB PHY

Gabriel FERNANDEZ (6):
  phy: Add PHY header file for DT x Driver defines
  phy: miphy28lp: Add Device Tree bindings for the MiPHY28lp
  phy: miphy28lp: Provide support for the MiPHY28lp Generic PHY
  phy: miphy28lp: Add SSC support for SATA
  phy: miphy28lp: Add SSC support for PCIE
  phy: miphy28lp: Tune tx impedance across Soc cuts

Gregory CLEMENT (3):
  phy: Use PTR_ERR_OR_ZERO to fix warning raised by coccinelle
  Phy: DT binding documentation for the Armada 375 USB cluster binding
  phy: add support for USB cluster on the Armada 375 SoC

Heikki Krogerus (5):
  phy: safer to_phy() macro
  phy: improved lookup method
  phy: twl4030: use the new lookup method
  phy: remove the old lookup method
  usb: dwc3: host: convey the PHYs to xhci

Kishon Vijay Abraham I (1):
  phy: phy-core: use the np present in of_phandle_args to get the PHY

Roman Byshko (1):
  phy: sun4i: add support for USB phy0

Sebastian Hesselbarth (3):
  phy: berlin-sata: Move PHY_BASE into private data struct
  phy: berlin-sata: Add support for BG2 SATA PHY
  phy: berlin-sata: Document BG2 compatible

Vivek Gautam (3):
  phy: exynos5-usbdrd: Add pipe-clk, utmi-clk and itp-clk support
  phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
  phy: exynos7-usbdrd: Update dependency for ARCH_EXYNOS

 Documentation/devicetree/bindings/ata/marvell.txt  |    6 +
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |    4 +-
 .../devicetree/bindings/phy/berlin-usb-phy.txt     |   16 +
 .../devicetree/bindings/phy/phy-miphy28lp.txt      |  128 ++
 .../devicetree/bindings/phy/phy-mvebu.txt          |   43 +
 .../devicetree/bindings/phy/samsung-phy.txt        |    6 +
 Documentation/phy.txt                              |   60 +-
 drivers/phy/Kconfig                                |   23 +-
 drivers/phy/Makefile                               |    3 +
 drivers/phy/phy-armada375-usb2.c                   |  158 +++
 drivers/phy/phy-bcm-kona-usb2.c                    |    2 +-
 drivers/phy/phy-berlin-sata.c                      |   36 +-
 drivers/phy/phy-berlin-usb.c                       |  223 ++++
 drivers/phy/phy-core.c                             |  115 +-
 drivers/phy/phy-exynos-dp-video.c                  |    2 +-
 drivers/phy/phy-exynos-mipi-video.c                |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |  139 ++-
 drivers/phy/phy-exynos5250-sata.c                  |    2 +-
 drivers/phy/phy-hix5hd2-sata.c                     |    7 +-
 drivers/phy/phy-miphy28lp.c                        | 1283 ++++++++++++++++++++
 drivers/phy/phy-miphy365x.c                        |    7 +-
 drivers/phy/phy-mvebu-sata.c                       |    2 +-
 drivers/phy/phy-omap-usb2.c                        |    2 +-
 drivers/phy/phy-qcom-apq8064-sata.c                |    3 +-
 drivers/phy/phy-qcom-ipq806x-sata.c                |    3 +-
 drivers/phy/phy-rcar-gen2.c                        |    2 +-
 drivers/phy/phy-samsung-usb2.c                     |    3 +-
 drivers/phy/phy-spear1310-miphy.c                  |    2 +-
 drivers/phy/phy-spear1340-miphy.c                  |    2 +-
 drivers/phy/phy-stih407-usb.c                      |    2 +-
 drivers/phy/phy-stih41x-usb.c                      |    7 +-
 drivers/phy/phy-sun4i-usb.c                        |   11 +-
 drivers/phy/phy-ti-pipe3.c                         |    2 +-
 drivers/phy/phy-twl4030-usb.c                      |    9 +-
 drivers/phy/phy-xgene.c                            |    2 +-
 drivers/pinctrl/pinctrl-tegra-xusb.c               |    4 +-
 drivers/usb/dwc3/host.c                            |   22 +-
 include/dt-bindings/phy/phy.h                      |   19 +
 include/linux/phy/phy.h                            |   52 +-
 39 files changed, 2210 insertions(+), 204 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-mvebu.txt
 create mode 100644 drivers/phy/phy-armada375-usb2.c
 create mode 100644 drivers/phy/phy-berlin-usb.c
 create mode 100644 drivers/phy/phy-miphy28lp.c
 create mode 100644 include/dt-bindings/phy/phy.h

-- 
1.7.9.5

