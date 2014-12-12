Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbaLLCei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:34:38 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:40655 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLLCeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:34:36 -0500
X-IronPort-AV: E=Sophos;i="5.07,561,1413270000"; 
   d="scan'208";a="52876393"
From: Ray Jui <rjui@broadcom.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>
CC: Lucas Stach <l.stach@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v2 0/4] Add PCIe support to Broadcom iProc
Date: Thu, 11 Dec 2014 18:36:53 -0800
Message-ID: <1418351817-14898-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the initial PCIe support for Broadcom iProc family of
SoCs. This driver has been validated with Cygnus and NSP and is expected to
work on other iProc family of SoCs that deploy the same PCIe controller

Changes from v1:
 - Add standard PCI interrupt DT properties "#interrupt-cells",
   "interrupt-map-mask" and "interrupt-map" so legacy INTx interrupts can be
   supported by using standard PCI OF IRQ parsing function
 - Get rid of custom IRQ mapping function in the driver. Use
   of_irq_parse_and_map_pci instead

Ray Jui (4):
  pci: iProc: define Broadcom iProc PCIe binding
  PCI: iproc: Add Broadcom iProc PCIe driver
  ARM: mach-bcm: Enable PCIe support for iProc
  ARM: dts: enable PCIe for Broadcom Cygnus

 .../devicetree/bindings/pci/brcm,iproc-pcie.txt    |   74 ++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   52 ++
 arch/arm/boot/dts/bcm958300k.dts                   |    8 +
 arch/arm/mach-bcm/Kconfig                          |    1 +
 drivers/pci/host/Kconfig                           |    9 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pcie-iproc.c                      |  888 ++++++++++++++++++++
 7 files changed, 1033 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/brcm,iproc-pcie.txt
 create mode 100644 drivers/pci/host/pcie-iproc.c

-- 
1.7.9.5

