Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaEOQGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:06:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34279 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaEOQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:06:04 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [RESEND: PATCH v1 0/5] Add Keystone PCIe controller driver
Date: Thu, 15 May 2014 12:05:31 -0400
Message-ID: <1400169931-9724-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with some typos fixed...

This patch adds a PCIe controller driver for Keystone SoCs. This
is based on the original RFC patch series that I had sent earlier. I have
incorporated following comments against that series:-

 - Add an interrupt controller node for Legacy irq chip and use
   interrupt map/map-mask property to map legacy IRQs A/B/C/D
 - Add a Phy driver to replace the original serdes driver
 - Move common application register handling code to a separate
   file to allow re-use across other platforms that use older
   DW PCIe h/w
 - PCI quirk for maximum read request size. Check and override only
   if the maximum is higher than what controller can handle.
 - Converted to a module platform driver.

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>


Murali Karicheri (5):
  ARM: keystone: add pcie related options
  pci: designware: enhancements to support keystone pcie
  phy: pci serdes phy driver for keystone
  pci: dw: add common functions to support old hw based pci driver
  pci: keystone: add pcie driver based on designware core driver

 .../devicetree/bindings/pci/pcie-keystone.txt      |   68 ++++
 arch/arm/mach-keystone/Kconfig                     |    2 +
 drivers/pci/host/Kconfig                           |   12 +
 drivers/pci/host/Makefile                          |    2 +
 drivers/pci/host/pci-dw-old-msi.c                  |  150 ++++++++
 drivers/pci/host/pci-dw-old.c                      |  371 ++++++++++++++++++
 drivers/pci/host/pci-dw-old.h                      |   30 ++
 drivers/pci/host/pci-keystone.c                    |  400 ++++++++++++++++++++
 drivers/pci/host/pcie-designware.c                 |  101 +++--
 drivers/pci/host/pcie-designware.h                 |   42 +-
 drivers/pci/quirks.c                               |   13 +
 drivers/phy/Kconfig                                |    6 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-keystone.c                         |  230 +++++++++++
 14 files changed, 1388 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/pcie-keystone.txt
 create mode 100644 drivers/pci/host/pci-dw-old-msi.c
 create mode 100644 drivers/pci/host/pci-dw-old.c
 create mode 100644 drivers/pci/host/pci-dw-old.h
 create mode 100644 drivers/pci/host/pci-keystone.c
 create mode 100644 drivers/phy/phy-keystone.c

-- 
1.7.9.5

