Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3L3NHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:07:15 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60148 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab3L3NHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:07:12 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: mark.rutland@arm.com, jg1.han@samsung.com, b.zolnierkie@samsung.com,
        joshi@samsung.com, t.figa@samsung.com, swarren@wwwdotorg.org,
        rob.herring@calxeda.com, grant.likely@linaro.org,
        christoffer.dall@linaro.org,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [PATCH V4 0/2] Exynos5250 SATA Support
Date: Mon, 30 Dec 2013 18:37:01 +0530
Message-Id: <1388408823-4963-1-git-send-email-yuvaraj.cd@samsung.com>
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
  Phy: Exynos: Add Exynos5250 sata phy driver
  ARM: dts: Enable ahci sata and sata phy

 .../devicetree/bindings/ata/exynos-sata-phy.txt    |   14 --
 .../devicetree/bindings/ata/exynos-sata.txt        |   25 ++-
 .../devicetree/bindings/phy/samsung-phy.txt        |   40 ++++
 arch/arm/boot/dts/exynos5250-arndale.dts           |   11 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |   16 +-
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/exynos5250_phy_i2c.c                   |   44 ++++
 drivers/phy/sata_phy_exynos5250.c                  |  220 ++++++++++++++++++++
 drivers/phy/sata_phy_exynos5250.h                  |   35 ++++
 11 files changed, 392 insertions(+), 33 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
 create mode 100644 drivers/phy/exynos5250_phy_i2c.c
 create mode 100644 drivers/phy/sata_phy_exynos5250.c
 create mode 100644 drivers/phy/sata_phy_exynos5250.h

-- 
1.7.9.5

