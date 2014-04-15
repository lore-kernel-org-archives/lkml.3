Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaDOLur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:50:47 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53048 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbaDOLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:50:42 -0400
From: Mohit Kumar <mohit.kumar@st.com>
To: <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Mohit Kumar <mohit.kumar@st.com>
Subject: [PATCH V8 0/9] PCI: Add SPEAr13xx PCie support
Date: Tue, 15 Apr 2014 17:19:42 +0530
Message-ID: <cover.1397555158.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch# 1 and 2: Improvement and fixes for SPEAr13xx support.
Patch# 3,4 and 6: Add DT bindings for spear1310/40-miphy, misc and pcie node
Patch# 5: Add spear1310/40-miphy driver and support for spear1310/40 
miphy wrapper.
Patch# 7-9: Add SPEAr13xx PCIe driver and dt support.

These pathes are tested with linux-3.15 tag of arm-soc tree.
Tested with SPEAr1310 evaluation board with:
	- INTEL PRO 100/100 EP card
	- USB xhci gen2 card
 	- Above cards connected through LeCROY PTC switch

Modifications for SATA are tested with SPEAr1340-evb board

Changes since v7:
- Rebase over for-linus-3.15 tag of arm-soc tree so that complete patch series
 can be applied cleanly.
- Incorporated few comments on comment style and superfluous comments
Changes since v6:
- Split miphy driver for SPEAr1310 and SPEAr1340
- Some cleanup and incorporated other minor comments
Changes since v5:
- Split DT bindings for misc, miphy-40lp and pcie node into sepearte patches
- Merge config options PCIE_SPEAR13XX and PCI_MSI into defconfig patch 
- Incorporated other minor comments
Changes since v4:
- Uses per device function pointers passed from .data field to
  the of_device_id instead of of_device_is_compatible.
- Incorporated other minor comments from v4

Changes since v3:
- Phy driver renamed to phy-miphy40lp
- ahci phy hook patch used as suggested by Arnd
- Incorporated other minor comments from v3

Changes since v2:
- Incorporated comments to move SPEAr13xx PCIe and SATA phy specific routines to
  the phy framework
- Modify ahci driver to include phy hooks
- phy-core driver modifications for subsys_initcall() 
 
Changes since v1:
- Few patches of the series are already accepted and applied to mainline e.g.
 pcie designware driver improvements,fixes for IO translation bug, PCIe dw
 driver maintainer. So dropped these from v2.
- Incorporated comment to move the common/reset PCIe code to the seperate driver
- PCIe and SATA share common PHY configuration registers, so move SATA
 platform code to the system config driver
Fourth patch is improves pcie designware driver and fixes the IO
translation bug. IO translation bug fix leads to the working of PCIe EP devices
connected to RC through switch.

Mohit Kumar (1):
  SPEAr13xx: defconfig: Update

Pratyush Anand (8):
  clk: SPEAr13XX: Fix pcie clock name
  SPEAr13XX: Fix static mapping table
  phy: SPEAr1310/40-miphy: Add binding information
  SPEAr: misc: Add binding information
  phy: SPEAr1310/40-miphy: Add phy driver for PCIe and SATA
  SPEAr13XX: Add binding information for PCIe controller
  SPEAr13XX: dts: Add PCIe node information
  pcie: SPEAr13xx: Add designware wrapper support

 .../devicetree/bindings/arm/spear-misc.txt         |    9 +
 .../devicetree/bindings/pci/spear13xx-pcie.txt     |   14 +
 .../devicetree/bindings/phy/st-spear1310-miphy.txt |   12 +
 .../devicetree/bindings/phy/st-spear1340-miphy.txt |   11 +
 MAINTAINERS                                        |    6 +
 arch/arm/boot/dts/spear1310-evb.dts                |    4 +
 arch/arm/boot/dts/spear1310.dtsi                   |   93 +++++-
 arch/arm/boot/dts/spear1340-evb.dts                |    4 +
 arch/arm/boot/dts/spear1340.dtsi                   |   30 ++-
 arch/arm/boot/dts/spear13xx.dtsi                   |    9 +-
 arch/arm/configs/spear13xx_defconfig               |   16 +
 arch/arm/mach-spear/Kconfig                        |    4 +
 arch/arm/mach-spear/include/mach/spear.h           |    4 +-
 arch/arm/mach-spear/spear1340.c                    |  127 +------
 arch/arm/mach-spear/spear13xx.c                    |    2 +-
 drivers/clk/spear/spear1310_clock.c                |    6 +-
 drivers/clk/spear/spear1340_clock.c                |    2 +-
 drivers/pci/host/Kconfig                           |    8 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pcie-spear13xx.c                  |  407 ++++++++++++++++++++
 drivers/phy/Kconfig                                |   12 +
 drivers/phy/Makefile                               |    2 +
 drivers/phy/phy-spear1310-miphy.c                  |  274 +++++++++++++
 drivers/phy/phy-spear1340-miphy.c                  |  300 ++++++++++++++
 24 files changed, 1218 insertions(+), 139 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt
 create mode 100644 Documentation/devicetree/bindings/pci/spear13xx-pcie.txt
 create mode 100644 Documentation/devicetree/bindings/phy/st-spear1310-miphy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/st-spear1340-miphy.txt
 create mode 100644 drivers/pci/host/pcie-spear13xx.c
 create mode 100644 drivers/phy/phy-spear1310-miphy.c
 create mode 100644 drivers/phy/phy-spear1340-miphy.c

