Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031027AbaLLRQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:16:52 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:33593 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030596AbaLLRQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:16:50 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 0/5] Qualcomm PCIe and PCIe/PHY drivers
Date: Fri, 12 Dec 2014 19:13:56 +0200
Message-Id: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a Qualcomm PCIe root complex driver for
Snapdragon 805 (APQ8084). It also adds a PCIe PHY driver in generic
phy framework. The PCIe hardware use Designware IP core plus
Qualcomm application specific hw.

The first two patches add a PHY driver binding document and the 
PHY driver. Patches 3/5 and 4/5 add PCIe DT document and the driver.
Last 5/5 adds APQ8084 in mach-qcom as next multiplatform Qualcomm
SoC.

Comments are welcome!

regards,
Stan

Stanimir Varbanov (5):
  DT: phy: qcom: Add PCIe PHY devicetree bindings
  phy: qcom: Add Qualcomm PCIe PHY
  DT: PCI: qcom: Document PCIe devicetree bindings
  PCI: qcom: Add Qualcomm PCIe controller driver
  ARM: qcom: Add Qualcomm APQ8084 SoC

 .../devicetree/bindings/pci/qcom,pcie.txt          |  159 ++++++++
 .../devicetree/bindings/phy/qcom-pcie-phy.txt      |   62 +++
 arch/arm/mach-qcom/Kconfig                         |    7 +
 drivers/pci/host/Kconfig                           |    9 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pcie-qcom.c                       |  415 ++++++++++++++++++++
 drivers/phy/Kconfig                                |    7 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-qcom-pcie.c                        |  311 +++++++++++++++
 9 files changed, 972 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/qcom,pcie.txt
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-pcie-phy.txt
 create mode 100644 drivers/pci/host/pcie-qcom.c
 create mode 100644 drivers/phy/phy-qcom-pcie.c

