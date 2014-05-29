Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaE2GjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:39:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46970 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730AbaE2GjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:39:20 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        <kishon@ti.com>
Subject: [PATCH v2 00/18] PCIe support for DRA7xx
Date: Thu, 29 May 2014 12:08:02 +0530
Message-ID: <1401345500-20188-1-git-send-email-kishon@ti.com>
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

Changes from v1:
* removed external clock support fro APLL since the clock framework patches
  are still in RFC.
* The configuration address space should be given in *reg* and made the
  corresponding driver changes in pcie-designware.c
* Used untraslated address while programming ATU since that is needed for
  DRA7. With this PCIe should be made the child node of axi.
* Used a new irq domain for PCIe legacy interrupts.
* Added clocks and dt data for the second instance of PCIe controller (with
  status = disabled).

Changes from RFC:
* Added external clock support for PCIE APLL
* Miscellaneous cleanups in Documentation, macro naming etc..

[1] -> http://www.spinics.net/lists/linux-omap/msg106411.html
Keerthy (2):
  ARM: dts: DRA7: Add divider table to optfclk_pciephy_div clock
  ARM: dts: DRA7: Change the parent of apll_pcie_in_clk_mux to
    dpll_pcie_ref_m2ldo_ck

Kishon Vijay Abraham I (16):
  phy: phy-omap-pipe3: Add support for PCIe PHY
  phy: pipe3: insert delay to enumerate in GEN2 mode
  PCI: designware: Configuration space should be specified in 'reg'
  PCI: designware: use untranslated address while programming ATU
  PCI: host: pcie-dra7xx: add support for pcie-dra7xx controller
  arm: dra7xx: Add hwmod data for pcie1 phy and pcie2 phy
  arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems
  ARM: dts: dra7xx-clocks: Add missing 32khz clocks used for PHY
  ARM: dts: dra7: Add dt data for PCIe PHY control module
  ARM: dts: dra7xx-clocks: rename pcie clocks to accommodate second PHY
    instance
  ARM: dts: dra7xx-clocks: Add missing clocks for second PCIe PHY
    instance
  ARM: dts: dra7: Add dt data for PCIe PHY
  ARM: dts: dra7: Add dt data for PCIe controller
  ARM: OMAP: Enable PCI for DRA7
  PCI: host: pcie-dra7xx: use reset framework APIs to reset PCIe
  ARM: dts: dra7: Add *resets* property for PCIe dt node

 .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
 Documentation/devicetree/bindings/pci/ti-pci.txt   |   63 +++
 Documentation/devicetree/bindings/phy/ti-phy.txt   |   20 +-
 arch/arm/boot/dts/dra7.dtsi                        |  127 ++++++
 arch/arm/boot/dts/dra7xx-clocks.dtsi               |   39 +-
 arch/arm/mach-omap2/Kconfig                        |    2 +
 arch/arm/mach-omap2/cm2_7xx.h                      |    4 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  112 +++++
 arch/arm/mach-omap2/prm7xx.h                       |    4 +
 drivers/pci/host/Kconfig                           |   10 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-dra7xx.c                      |  470 ++++++++++++++++++++
 drivers/pci/host/pcie-designware.c                 |   66 ++-
 drivers/pci/host/pcie-designware.h                 |    4 +
 drivers/phy/phy-omap-control.c                     |   52 ++-
 drivers/phy/phy-ti-pipe3.c                         |  101 ++++-
 include/linux/phy/omap_control_phy.h               |   10 +
 17 files changed, 1041 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
 create mode 100644 drivers/pci/host/pci-dra7xx.c

-- 
1.7.9.5

