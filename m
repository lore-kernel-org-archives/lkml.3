Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaANXeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:34:44 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:46167 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751573AbaANXem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:34:42 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [RFC PATCH V2 0/4] APM X-Gene PCIe controller
Date: Tue, 14 Jan 2014 15:34:14 -0800
Message-Id: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AppliedMicro X-Gene PCIe host controller. The
driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
cards.

X-Gene PCIe controller driver has depedency on the pcie arch support for
arm64. The arm64 pcie arch support is not yet part of mainline Linux kernel
and approach for arch support is under discussion with arm64 maintainers.
The reference patch can be found here --> https://lkml.org/lkml/2013/10/23/244

If someone wishes to test PCIe on X-Gene, arch support patch must be applied
before the patches in this patch set.

changes since V1:
1. added PCI domain support
2. reading cpu and pci addresses from device tree to configure regions.
3. got rid of unnecessary wrappers for readl and writel.
4. got rid of endpoint configuration code.
5. added 'dma-ranges' property support to read inbound region configuration.
6. renamed host driver file to 'pci-xgene.c' from 'pcie-xgene.c'
7. dropped 'clock-names' property from bindings
8. added comments whereever requested.

Tanmay Inamdar (4):
  pci: APM X-Gene PCIe controller driver
  arm64:dts: APM X-Gene PCIe device tree nodes
  dt-bindings: pci: xgene pcie device tree bindings
  MAINTAINERS: entry for APM X-Gene PCIe host driver

 .../devicetree/bindings/pci/xgene-pcie.txt         |   45 +
 MAINTAINERS                                        |    7 +
 arch/arm64/boot/dts/apm-mustang.dts                |    4 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |  144 +++
 drivers/pci/host/Kconfig                           |   10 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-xgene.c                       |  934 ++++++++++++++++++++
 7 files changed, 1145 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt
 create mode 100644 drivers/pci/host/pci-xgene.c

-- 
1.7.9.5

