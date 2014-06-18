Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967186AbaFRO15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:27:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5424 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966958AbaFRO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:27:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jun 2014 07:18:32 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 0/7] Serial ATA support for NVIDIA Tegra124
Date: Wed, 18 Jun 2014 17:23:19 +0300
Message-ID: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds support for the onboard AHCI-compliant Serial ATA
controller found on Tegra124 systems-on-chip. The series depends on
Thierry's XUSB pinctrl driver.

A branch containing the series is located at 
	git://github.com/cyndis/linux.git
branch ahci-rel-v2.

Mikko Perttunen (7):
  of: Add NVIDIA Tegra SATA controller binding
  ARM: tegra: Add SATA controller to Tegra124 device tree
  ARM: tegra: Add SATA and SATA power to Jetson TK1 device tree
  clk: tegra: Enable hardware control of SATA PLL
  clk: tegra: Add SATA clocks to Tegra124 initialization table
  ata: Add support for the Tegra124 SATA controller
  ARM: tegra: Add options for Tegra AHCI support to tegra_defconfig

 .../devicetree/bindings/ata/tegra-sata.txt         |  30 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  35 ++
 arch/arm/boot/dts/tegra124.dtsi                    |  25 ++
 arch/arm/configs/tegra_defconfig                   |   3 +
 drivers/ata/Kconfig                                |   9 +
 drivers/ata/Makefile                               |   1 +
 drivers/ata/ahci_tegra.c                           | 448 +++++++++++++++++++++
 drivers/clk/tegra/clk-pll.c                        |   8 +
 drivers/clk/tegra/clk-tegra124.c                   |   2 +
 9 files changed, 561 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/tegra-sata.txt
 create mode 100644 drivers/ata/ahci_tegra.c

-- 
1.8.1.5

