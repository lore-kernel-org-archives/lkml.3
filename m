Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaCZN66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:58:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55076 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbaCZN64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:58:56 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>, <jg1.han@samsung.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <rnayak@ti.com>, <paul@pwsan.com>, <kishon@ti.com>
Subject: [RFC PATCH 00/12] PCIe support for DRA7xx
Date: Wed, 26 Mar 2014 19:27:40 +0530
Message-ID: <1395842272-15267-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for PCIe in DRA7xx including drivers and dt
data. PCIe in DRA7xx uses desingware IP and hence this re-uses the
pcie desingware driver (pcie-designware.c) by Jingoo.

This patch series depends on a few patches that is already in -next.

Tested broadcom PCIe card and XIO2000 bridge along with DGE530T ethernet
card.

Keerthy (2):
  ARM: dts: DRA7: Add divider table to optfclk_pciephy_div clock
  ARM: dts: DRA7: Change the parent of apll_pcie_in_clk_mux to
    dpll_pcie_ref_m2ldo_ck

Kishon Vijay Abraham I (10):
  phy: phy-omap-pipe3: Add support for PCIe PHY
  pci: host: pcie-dra7xx: add support for pcie-dra7xx controller
  pci: host: pcie-designware: Use *base-mask* for configuring the iATU
  arm: dra7xx: Add hwmod data for pcie1 phy and pcie2 phy
  arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems
  ARM: dts: dra7xx-clocks: Add missing 32khz clocks used for PHY
  ARM: dts: dra7: Add dt data for PCIe PHY control module
  ARM: dts: dra7: Add dt data for PCIe PHY
  ARM: dts: dra7: Add dt data for PCIe controller
  ARM: OMAP: Enable PCI for DRA7

 .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
 Documentation/devicetree/bindings/pci/ti-pci.txt   |   35 ++
 Documentation/devicetree/bindings/phy/ti-phy.txt   |    8 +-
 arch/arm/boot/dts/dra7.dtsi                        |   48 +++
 arch/arm/boot/dts/dra7xx-clocks.dtsi               |   11 +-
 arch/arm/mach-omap2/Kconfig                        |    2 +
 arch/arm/mach-omap2/cm2_7xx.h                      |    4 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  112 ++++++
 arch/arm/mach-omap2/prm7xx.h                       |    4 +
 drivers/pci/host/Kconfig                           |   10 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pcie-designware.c                 |   39 +-
 drivers/pci/host/pcie-designware.h                 |    1 +
 drivers/pci/host/pcie-dra7xx.c                     |  411 ++++++++++++++++++++
 drivers/phy/phy-ti-pipe3.c                         |   99 ++++-
 15 files changed, 750 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
 create mode 100644 drivers/pci/host/pcie-dra7xx.c

-- 
1.7.9.5

