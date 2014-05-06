Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbaEFNen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:34:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54791 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaEFNek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:34:40 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 00/17] PCIe support for DRA7xx
Date: Tue, 6 May 2014 19:03:46 +0530
Message-ID: <1399383244-14556-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for PCIe in DRA7xx including drivers and dt
data. PCIe in DRA7xx uses desingware IP and hence this re-uses the
pcie desingware driver (pcie-designware.c) by Jingoo.

The last couple of patches are marked as *TEMP* since the TI reset driver [1]
is not yet merged and is in RFC.

Tested broadcom PCIe card and XIO2000 bridge along with DGE530T ethernet
card.

Changes from RFC:
* Added external clock support for PCIE APLL
* Miscellaneous cleanups in Documentation, macro naming etc..

[1] -> http://www.spinics.net/lists/linux-omap/msg106411.html

Keerthy (2):
  ARM: dts: DRA7: Add divider table to optfclk_pciephy_div clock
  ARM: dts: DRA7: Change the parent of apll_pcie_in_clk_mux to
    dpll_pcie_ref_m2ldo_ck

Kishon Vijay Abraham I (15):
  phy: phy-omap-pipe3: Add support for PCIe PHY
  phy: omap-control: add external clock support for PCIe PHY
  phy: ti-pipe3: add external clock support for PCIe PHY
  phy: pipe3: insert delay to enumerate in GEN2 mode
  pci: host: pcie-dra7xx: add support for pcie-dra7xx controller
  pci: host: pcie-designware: Use *base-mask* for configuring the iATU
  arm: dra7xx: Add hwmod data for pcie1 phy and pcie2 phy
  arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems
  ARM: dts: dra7xx-clocks: Add missing 32khz clocks used for PHY
  ARM: dts: dra7: Add dt data for PCIe PHY control module
  ARM: dts: dra7: Add dt data for PCIe PHY
  ARM: dts: dra7: Add dt data for PCIe controller
  ARM: OMAP: Enable PCI for DRA7
  pci: host: pcie-dra7xx: use reset framework APIs to reset PCIe
  ARM: dts: dra7: Add *resets* property for PCIe dt node

 .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
 Documentation/devicetree/bindings/pci/ti-pci.txt   |   35 ++
 Documentation/devicetree/bindings/phy/ti-phy.txt   |   21 +-
 arch/arm/boot/dts/dra7.dtsi                        |   55 +++
 arch/arm/boot/dts/dra7xx-clocks.dtsi               |   11 +-
 arch/arm/mach-omap2/Kconfig                        |    2 +
 arch/arm/mach-omap2/cm2_7xx.h                      |    4 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  112 ++++++
 arch/arm/mach-omap2/prm7xx.h                       |    4 +
 drivers/pci/host/Kconfig                           |   10 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-dra7xx.c                      |  395 ++++++++++++++++++++
 drivers/pci/host/pcie-designware.c                 |   39 +-
 drivers/pci/host/pcie-designware.h                 |    1 +
 drivers/phy/phy-omap-control.c                     |   92 ++++-
 drivers/phy/phy-ti-pipe3.c                         |  142 +++++--
 include/linux/phy/omap_control_phy.h               |   23 ++
 17 files changed, 898 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
 create mode 100644 drivers/pci/host/pci-dra7xx.c

-- 
1.7.9.5

