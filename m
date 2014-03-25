Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaCYAgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:36:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46248 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbaCYAgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:36:00 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Zhu <r65037@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Mohit Kumar <mohit.kumar@st.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RESEND: RFC PATCH 0/3] Add Keystone pcie driver
Date: Mon, 24 Mar 2014 20:35:23 -0400
Message-ID: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC to add Keystone pcie driver. I had some earlier discussion on
the pcie mailing about this driver and at that time I didn't have the driver
ported to dw core driver. I now have a driver working with intel's e1000e
ethernet driver and want to review this RFC on this list.

Kestone PCIE hardware is based on dw version 3.65. It lacks ATU port and
standard MSI controller found in newer version of the dw hardware. This version
uses registers in PCIE application space to configure MSI controller. It has 4
host irqs for legacy IRQs A/B/C/D and 8 host irqs to muliplex 32 MSI irqs.
Also has one host irq line for errors.

Please review and provide your comments.

CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>

Murali Karicheri (3):
  ARM: keystone: add pcie related options
  pci: designware: enhancements to support keystone pcie
  pcie: keystone: add pcie driver based on designware core driver

 .../devicetree/bindings/pci/pcie-keystone.txt      |   32 +
 arch/arm/mach-keystone/Kconfig                     |    2 +
 drivers/pci/host/Kconfig                           |    5 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/k2-platform.c                     |  191 +++++
 drivers/pci/host/pci-exynos.c                      |    2 +-
 drivers/pci/host/pci-imx6.c                        |    2 +-
 drivers/pci/host/pcie-designware.c                 |   99 ++-
 drivers/pci/host/pcie-designware.h                 |   14 +-
 drivers/pci/host/pcie-keystone.c                   |  860 ++++++++++++++++++++
 drivers/pci/host/pcie-ks-pdata.h                   |   19 +
 drivers/pci/quirks.c                               |   12 +
 12 files changed, 1203 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/pcie-keystone.txt
 create mode 100644 drivers/pci/host/k2-platform.c
 create mode 100644 drivers/pci/host/pcie-keystone.c
 create mode 100644 drivers/pci/host/pcie-ks-pdata.h

-- 
1.7.9.5

