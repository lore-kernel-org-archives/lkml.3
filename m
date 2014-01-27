Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaA0OTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:19:41 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47356 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaA0OTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:19:39 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, sander@humilis.net
Cc: mark.rutland@arm.com, jg1.han@samsung.com, b.zolnierkie@samsung.com,
        joshi@samsung.com, t.figa@samsung.com, swarren@wwwdotorg.org,
        grant.likely@linaro.org, christoffer.dall@linaro.org,
        linux-ide@vger.kernel.org, Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [PATCH V7 0/2] Exynos5250 SATA Support
Date: Mon, 27 Jan 2014 19:49:24 +0530
Message-Id: <1390832366-23454-1-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enable the SATA support on Exynos5250 based boards.
It incorporates the generic phy framework to deal with sata phy.

This patch depends on the below patches
	[1]. drivers: phy: add generic PHY framework
		by Kishon Vijay Abraham I<kishon@ti.com>
	[2]. ata: ahci_platform: Manage SATA PHY
		by Roger Quadros <rogerq@ti.com>
	[3].ARM: dts: Add pmu sysreg node to exynos5250 and
		exynos5420 dtsi files
		by Leela Krishna Amudala <l.krishna@samsung.com>
	[4]. i2c: s3c2410 : Add polling mode support
		by Vasanth Ananthan <vasanth.a@samsung.com>

Changes from V6:
	1.Removed phy-exynos5250-sata-i2c.c,as it is not required
	  after moving to of_find_i2c_device_by_node().
	2.Changed struct __iomem pmureg tp struct regmap pmureg.
	3.Changed the wait_for_reg_status() to return 0 or -EFAULT.

Changes from V5:
	1.Rebased on latest generic PHY framework for-next tree.
	2.Minor nits such as indentations.

Changes from V4:
	1.Made Exynos5250 SATA PHY driver by default selects
	CONFIG_I2C and CONFIG_I2C_S3C2410, as SATA PHY driver
	depends on I2C.
	2.Used the new phandle "sata_phy_i2c" in the DT entry. 
	3.struct i2c_driver sataphy_i2c_driver made static which
	was earlier global type. 

Changes from V3:
	1.Moved the devicetree binding documentation
	from /bindings/ata/ to bindings/phy/ .
	2.Moved devm_phy_create call before to 
	the devm_phy_provider_register. 

Changes from V2:
	1.Removed of_match_table
	2.Moved to syscon interface for PMU handling.

Changes from V1:
	1. Dropped the patch 
	ahci: exynos: add ahci sata support on Exynos platform

	2.Adapt to latest generic PHY framework available in 
	git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git next
Yuvaraj Kumar C D (2):
  PHY: Exynos: Add Exynos5250 SATA PHY driver
  ARM: dts: Enable ahci sata and sata phy

 .../devicetree/bindings/ata/exynos-sata-phy.txt    |   14 --
 .../devicetree/bindings/ata/exynos-sata.txt        |   25 +-
 .../devicetree/bindings/phy/samsung-phy.txt        |   36 +++
 arch/arm/boot/dts/exynos5250-arndale.dts           |   11 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |   17 +-
 drivers/phy/Kconfig                                |   13 ++
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5250-sata.c                  |  244 ++++++++++++++++++++
 9 files changed, 336 insertions(+), 33 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
 create mode 100644 drivers/phy/phy-exynos5250-sata.c

-- 
1.7.9.5

