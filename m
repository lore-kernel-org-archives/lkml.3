Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaFDLrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:47:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10017 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaFDLr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:47:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jun 2014 04:42:18 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
Date: Wed, 4 Jun 2014 14:32:30 +0300
Message-ID: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds support for the onboard AHCI-compliant Serial ATA
controller found on Tegra124 systems-on-chip. The controller is
enabled on Jetson TK1. The series depends on Peter's efuse series 
and Thierry's yet to be submitted XUSB pinctrl driver.

A branch containing the series is located at 
	git://github.com/cyndis/linux.git
branch ahci-rel.

Mikko Perttunen (9):
  of: Add NVIDIA Tegra SATA controller binding
  ARM: tegra: Add SATA controller to Tegra124 device tree
  ARM: tegra: Add SATA and SATA power to Jetson TK1 device tree
  clk: tegra: Enable hardware control of SATA PLL
  clk: tegra: Add SATA clocks to Tegra124 initialization table
  ARM: tegra: Export tegra_powergate_power_on
  ahci: Increase AHCI_MAX_CLKS to 4
  ata: Add support for the Tegra124 SATA controller
  ARM: tegra: Add options for Tegra AHCI support to tegra_defconfig

 .../devicetree/bindings/ata/tegra-sata.txt         |  29 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  36 ++
 arch/arm/boot/dts/tegra124.dtsi                    |  24 ++
 arch/arm/configs/tegra_defconfig                   |   3 +
 arch/arm/mach-tegra/powergate.c                    |   1 +
 drivers/ata/Kconfig                                |   9 +
 drivers/ata/Makefile                               |   1 +
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/ahci_tegra.c                           | 386 +++++++++++++++++++++
 drivers/clk/tegra/clk-pll.c                        |   8 +
 drivers/clk/tegra/clk-tegra124.c                   |   2 +
 11 files changed, 500 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/ata/tegra-sata.txt
 create mode 100644 drivers/ata/ahci_tegra.c

-- 
1.8.1.5

