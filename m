Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaBFEps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 23:45:48 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:36821 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbaBFEpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:45:46 -0500
From: Pratyush Anand <pratyush.anand@st.com>
To: <arnd@arndb.de>
Cc: Pratyush Anand <pratyush.anand@st.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V4 0/8]PCI:Add SPEAr13xx PCie support
Date: Thu, 6 Feb 2014 10:14:47 +0530
Message-ID: <cover.1391661589.git.pratyush.anand@st.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First three patches are improvement and fixes for SPEAr13xx support.
Patches 4-6 add miphy40lp skelten driver and support for spear1310/40 miphy
wrapper. Patch 7 add support for SPEAr13xx PCIe.

These pathes are tested with linux-3.14-rc1 with following patch on the top of
it:
Author: Balaji T K <balajitk@ti.com>
Date:   Mon Jan 20 16:41:27 2014 +0200

    ata: ahci_platform: Manage SATA PHY

Tested with SPEAr1310 evaluation board:
	- INTEL PRO 100/100 EP card
	- USB xhci gen2 card
 	- Above cards connected through LeCROY PTC switch

Modifications for SATA are tested with SPEAr1340-evb board

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

PCIe driver support for SPEAr1310/40 platform board is added.

These patches are tested with SPEAr1310 evaluation board:
	- INTEL PRO 100/100 EP card
	- USB xhci gen2 card
 	- Above cards connected through LeCROY PTC switch

Cc: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: spear-devel@list.st.com
Cc: linux-kernel@vger.kernel.org

Mohit Kumar (2):
  SPEAr13xx: defconfig: Update
  MAINTAINERS: Add ST SPEAr13xx PCIe driver maintainer

Pratyush Anand (6):
  clk: SPEAr13xx: Fix pcie clock name
  SPEAr13xx: Fix static mapping table
  phy: st-miphy-40lp: Add skeleton driver
  SPEAr13xx: Fixup: Move SPEAr1340 SATA platform code to phy driver
  phy: st-miphy-40lp: Add SPEAr1310 and SPEAr1340 PCIe phy support
  pcie: SPEAr13xx: Add designware pcie support

 .../devicetree/bindings/arm/spear-misc.txt         |   4 +
 .../devicetree/bindings/pci/spear13xx-pcie.txt     |   7 +
 .../devicetree/bindings/phy/st-miphy40lp.txt       |  12 +
 MAINTAINERS                                        |   6 +
 arch/arm/boot/dts/spear1310-evb.dts                |   4 +
 arch/arm/boot/dts/spear1310.dtsi                   |  96 +++-
 arch/arm/boot/dts/spear1340-evb.dts                |   4 +
 arch/arm/boot/dts/spear1340.dtsi                   |  32 +-
 arch/arm/boot/dts/spear13xx.dtsi                   |  10 +-
 arch/arm/configs/spear13xx_defconfig               |  15 +
 arch/arm/mach-spear/Kconfig                        |   3 +
 arch/arm/mach-spear/include/mach/spear.h           |   4 +-
 arch/arm/mach-spear/spear1340.c                    | 127 +----
 arch/arm/mach-spear/spear13xx.c                    |   2 +-
 drivers/clk/spear/spear1310_clock.c                |   6 +-
 drivers/clk/spear/spear1340_clock.c                |   2 +-
 drivers/pci/host/Kconfig                           |   5 +
 drivers/pci/host/Makefile                          |   1 +
 drivers/pci/host/pcie-spear13xx.c                  | 414 ++++++++++++++++
 drivers/phy/Kconfig                                |   6 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-miphy40lp.c                        | 544 +++++++++++++++++++++
 22 files changed, 1166 insertions(+), 139 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt
 create mode 100644 Documentation/devicetree/bindings/pci/spear13xx-pcie.txt
 create mode 100644 Documentation/devicetree/bindings/phy/st-miphy40lp.txt
 create mode 100644 drivers/pci/host/pcie-spear13xx.c
 create mode 100644 drivers/phy/phy-miphy40lp.c

-- 
1.8.1.2

