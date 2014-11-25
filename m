Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaKYNPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:15:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50808 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKYNPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:15:33 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 00/19] Add Support for USB DRD in AM437x
Date: Tue, 25 Nov 2014 18:41:36 +0530
Message-ID: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series add DRD suport for AM437x.

The serires adds 
	- USB DRD Library
		This Library facilitates in switching roles between HOST 	
		and Device. 
	- DWC3 OTG driver.
		This driver currently suports only the ID based switching


Felipe Balbi (2):
  usb: dwc3: core: Adapt to named interrupts
  arm: dts: am4372: Add named interrupt property for dwc3

George Cherian (17):
  usb: common: drd-lib: Add DRD lib for USB.
  usb: host xhci: fix up deallocation code
  usb: host: xhci-plat: Add support to pass XHCI_DRD_SUPPORT quirk
  usb: host xhci: Add XHCI_NEEDS_LHC_RESET quirk
  usb: host: xhci-plat: Add support to pass XHCI_NEEDS_LHC_RESET quirk
  usb: dwc3: host: Pass the XHCI_DRD_SUPPORT and XHCI_NEEDS_LHC_RESET
    quirk
  usb: host: xhci: Adapt xhci to use usb drd library
  usb: dwc3: core: Add dwc3_drd_helper function
  usb: dwc3: dwc3-omap: Make the wrapper interrupt shared
  usb: dwc3: Add seperate dwc3_gadget object to support gadget release
  usb: dwc3: gadget: Adapt gadget to drd library
  usb: dwc3: core: Add DWC3 OTG specific register defines
  usb: dwc3: otg: Add the initial otg driver for dwc3.
  arm: dts: omap5: Add named interrupt property for dwc3
  arm: dts: dra7: Add named interrupt property for dwc3
  arm: dts: exynos5250: Add named interrupt property for dwc3
  arm: dts: am43x evms: Make usb1 as OTG

 arch/arm/boot/dts/am4372.dtsi        |  18 +-
 arch/arm/boot/dts/am437x-gp-evm.dts  |   2 +-
 arch/arm/boot/dts/am437x-sk-evm.dts  |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts |   2 +-
 arch/arm/boot/dts/dra7.dtsi          |  28 ++-
 arch/arm/boot/dts/exynos5250.dtsi    |   7 +-
 arch/arm/boot/dts/omap5.dtsi         |   7 +-
 drivers/usb/Kconfig                  |  15 ++
 drivers/usb/common/Makefile          |   1 +
 drivers/usb/common/drd-lib.c         | 346 +++++++++++++++++++++++++++++++++++
 drivers/usb/dwc3/Makefile            |   4 +
 drivers/usb/dwc3/core.c              |  27 ++-
 drivers/usb/dwc3/core.h              |  93 +++++++++-
 drivers/usb/dwc3/dwc3-omap.c         |   4 +-
 drivers/usb/dwc3/ep0.c               |  35 ++--
 drivers/usb/dwc3/gadget.c            | 211 +++++++++++++++------
 drivers/usb/dwc3/gadget.h            |   1 +
 drivers/usb/dwc3/host.c              |   2 +
 drivers/usb/dwc3/otg.c               | 126 +++++++++++++
 drivers/usb/host/xhci-plat.c         |  22 +++
 drivers/usb/host/xhci.c              |  27 ++-
 drivers/usb/host/xhci.h              |   2 +
 include/linux/usb/drd.h              |  77 ++++++++
 include/linux/usb/xhci_pdriver.h     |   2 +
 24 files changed, 962 insertions(+), 99 deletions(-)
 create mode 100644 drivers/usb/common/drd-lib.c
 create mode 100644 drivers/usb/dwc3/otg.c
 create mode 100644 include/linux/usb/drd.h

-- 
1.8.3.1

