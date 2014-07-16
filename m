Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbaGPIzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:55:32 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14648 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaGPIz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:55:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Jul 2014 01:44:09 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <hdegoede@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v3 0/8] Serial ATA support for NVIDIA Tegra124
Date: Wed, 16 Jul 2014 11:54:15 +0300
Message-ID: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds support for the onboard AHCI-compliant Serial ATA
controller found on Tegra124 systems-on-chip.

A branch containing the series is located at 
	git://github.com/cyndis/linux.git
branch ahci-rel-v3.

Changes in v3:
- Fixed style issues in driver
- Changed resource management to use libahci_platform's functions
  I opted to not add reset_control support to libahci_platform yet
  in the interest of getting this series into 3.17. Adding support
  probably requires breaking the existing API and getting ACKs from
  the maintainers of each platform driver.
- Removed code that reads the calibration set to use from fuses.
  The new-style fuse driver this requires is also going in for 3.17,
  so this should make merging easier. For now, the driver defaults
  to assuming FUSE_SATA_CALIB = 0, which works at least for my testing
  hardware. This should be changed to read the actual fuse once the
  fuse series has landed.

Mikko Perttunen (8):
  of: Add NVIDIA Tegra SATA controller binding
  ARM: tegra: Add SATA controller to Tegra124 device tree
  ARM: tegra: Add SATA and SATA power to Jetson TK1 device tree
  clk: tegra: Enable hardware control of SATA PLL
  clk: tegra: Add SATA clocks to Tegra124 initialization table
  ata: ahci_platform: Increase AHCI_MAX_CLKS to 4
  ata: Add support for the Tegra124 SATA controller
  ARM: tegra: Add options for Tegra AHCI support to tegra_defconfig

 .../devicetree/bindings/ata/tegra-sata.txt         |  30 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  35 ++
 arch/arm/boot/dts/tegra124.dtsi                    |  25 ++
 arch/arm/configs/tegra_defconfig                   |   3 +
 drivers/ata/Kconfig                                |   9 +
 drivers/ata/Makefile                               |   1 +
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/ahci_tegra.c                           | 406 +++++++++++++++++++++
 drivers/clk/tegra/clk-pll.c                        |   8 +
 drivers/clk/tegra/clk-tegra124.c                   |   2 +
 10 files changed, 520 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/ata/tegra-sata.txt
 create mode 100644 drivers/ata/ahci_tegra.c

-- 
1.8.1.5

