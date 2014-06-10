Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaFJSwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:52:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54538 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaFJSwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:52:45 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2 0/8] Add Keystone PCIe controller driver
Date: Tue, 10 Jun 2014 14:51:19 -0400
Message-ID: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a PCIe controller driver for Keystone SoCs. This
is based on v1 of the series posted to the mailing list.

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Pratyush Anand <pratyush.anand@st.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Marek Vasut <marex@denx.de>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Grant Likely <grant.likely@linaro.org> 


Changelog:

V2
 - Split the designware pcie enhancement patch to multiple
   patches based on functionality added
 - Remove the quirk code and add a patch to fix mps/mrss
   tuning for ARM. Use kernel command line parameter
   pci=pcie_bus_perf to work with Keystone PCI Controller.
   Following patch addressed this.
     [PATCH v1] ARM: pci: add call to pcie_bus_configure_settings()
 - Add documentation for device tree bindings
 - Add separate interrupt controller nodes for MSI and Legacy
   IRQs and use irq map for legacy IRQ
 - Use compatibility to identify v3.65 version of the DW hardware
   and use it to customize the designware common code.
 - Use reg property for configuration space instead of range
 - Other minor updates based on code inspection. 

V1
 - Add an interrupt controller node for Legacy irq chip and use
   interrupt map/map-mask property to map legacy IRQs A/B/C/D
 - Add a Phy driver to replace the original serdes driver
 - Move common application register handling code to a separate
   file to allow re-use across other platforms that use older
   DW PCIe h/w
 - PCI quirk for maximum read request size. Check and override only
   if the maximum is higher than what controller can handle.
 - Converted to a module platform driver.


Murali Karicheri (8):
  PCI: designware: add rd[wr]_other_conf API
  PCI: designware: refactor host init code to re-use on v3.65 DW pci hw
  PCI: designware: update pcie core driver to work with dw hw version
    3.65
  PCI: designware: add msi controller functions for v3.65 hw
  PCI: designware: add PCI controller functions for v3.65 DW hw
  phy: Add serdes phy driver for keystone
  PCI: keystone: add pcie driver based on designware core driver
  ARM: keystone: add pcie related options

 .../devicetree/bindings/pci/designware-pcie.txt    |   42 ++
 .../devicetree/bindings/pci/pci-keystone.txt       |   56 +++
 .../bindings/phy/phy-keystone-serdes.txt           |   25 ++
 arch/arm/mach-keystone/Kconfig                     |    1 +
 drivers/pci/host/Kconfig                           |   12 +
 drivers/pci/host/Makefile                          |    2 +
 drivers/pci/host/pci-dw-v3_65-msi.c                |  149 +++++++
 drivers/pci/host/pci-dw-v3_65.c                    |  390 ++++++++++++++++++
 drivers/pci/host/pci-dw-v3_65.h                    |   34 ++
 drivers/pci/host/pci-keystone.c                    |  418 ++++++++++++++++++++
 drivers/pci/host/pcie-designware.c                 |  175 +++++---
 drivers/pci/host/pcie-designware.h                 |   42 +-
 drivers/phy/Kconfig                                |    6 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-keystone-serdes.c                  |  230 +++++++++++
 15 files changed, 1531 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-keystone-serdes.txt
 create mode 100644 drivers/pci/host/pci-dw-v3_65-msi.c
 create mode 100644 drivers/pci/host/pci-dw-v3_65.c
 create mode 100644 drivers/pci/host/pci-dw-v3_65.h
 create mode 100644 drivers/pci/host/pci-keystone.c
 create mode 100644 drivers/phy/phy-keystone-serdes.c

-- 
1.7.9.5

