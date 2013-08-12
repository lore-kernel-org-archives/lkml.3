Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3HLSrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:47:16 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:48753 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3HLSrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:47:04 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 0/9] ARM: dove: DT PCIe support
Date: Mon, 12 Aug 2013 20:46:46 +0200
Message-Id: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the PCIe controllers found on Marvell
Dove SoCs. It depends on mvebu-pci patches sent by Thomas Petazzoni.
Also, it adds support for the Globalscale D3Plug - a Dove based board
comprising a USB3.0 dual port controller and a mini-PCIe port. The
mini-PCIe port has not been tested, but USB controller and attached
USB stick has been detected.

The patch set can be separated into two main parts and should be
taken by the respective maintainers. First five patches belong to
PCI driver for MVEBU SoCs, while last four patches are Marvell Dove
related. It is based on (unstable) mvebu/for-next branch with MSI
patches applied and will be rebased on request.

Devicetree and Doc MLs are not Cc'ed for the driver-only patches,
PCI ML and maintainer are not Cc'ed for the Dove-only patches.

Patches 1 and 2 fix some minor issues with pci-mvebu by moving
clk_prepare_enable before accessing any controller registers and
counting sucessfully registered ports only.

Patch 3 converts pci-mvebu from subsys_initcall registration to
normal platform driver registration to allow it to fail with
EPROBE_DEFER later.

Patch 4 adds DT parsing for reset (PERST#) GPIO pins and delay to
wait for PCIe devices after reset de-assertion.

Patch 5 finally adds a compatible to pci-mvebu for Dove SoCs.

Patch 6 updates dove_defconfig with some useful options for the
Si5351 i2c clock generator found on SolidRun CuBox, PCIe driver,
and USB3.0 xHCI driver.

Patches 7 and 8 add PCIe controller nodes to Dove SoC DT and
add support for the Globalscale D3Plug where this patches have
been tested on.

Patch 8 finally removes legacy PCIe driver init and clock
gate workarounds from DT based Dove init.

Sebastian Hesselbarth (9):
  PCI: mvebu: move clock enable before register access
  PCI: mvebu: increment nports only for registered ports
  PCI: mvebu: remove subsys_initcall
  PCI: mvebu: add support for reset on GPIO
  PCI: mvebu: add support for Marvell Dove SoCs
  ARM: dove: update dove_defconfig with SI5351, PCI, and xHCI
  ARM: dove: add PCIe controllers to SoC DT
  ARM: dove: add initial DT file for Globalscale D3Plug
  ARM: dove: remove legacy pcie and clock init

 .../devicetree/bindings/pci/mvebu-pci.txt          |    3 +
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/dove-d3plug.dts                  |  103 ++++++++++++++++++
 arch/arm/boot/dts/dove.dtsi                        |   54 ++++++++++
 arch/arm/configs/dove_defconfig                    |    4 +
 arch/arm/mach-dove/board-dt.c                      |   29 -----
 drivers/pci/host/Kconfig                           |    2 +-
 drivers/pci/host/pci-mvebu.c                       |  113 +++++++++++++-------
 8 files changed, 241 insertions(+), 68 deletions(-)
 create mode 100644 arch/arm/boot/dts/dove-d3plug.dts
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
-- 
1.7.10.4

