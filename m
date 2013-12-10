Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3LJKF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:05:27 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62327 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3LJKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:05:22 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, sachin.kamat@linaro.org,
        b.zolnierkie@samsung.com, jg1.han@samsung.com, t.figa@samsung.com,
        christoffer.dall@linaro.org, joshi@samsung.com,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [PATCH V3 0/2] Exynos5250 SATA Support
Date: Tue, 10 Dec 2013 15:35:08 +0530
Message-Id: <1386669911-17319-1-git-send-email-yuvaraj.cd@samsung.com>
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

 .../devicetree/bindings/ata/exynos-sata-phy.txt    |   19 +-
 .../devicetree/bindings/ata/exynos-sata.txt        |   17 +-
 .../devicetree/bindings/ata/exynos_sataphy_i2c.txt |   12 ++
 arch/arm/boot/dts/exynos5250-arndale.dts           |    9 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |   16 +-
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/exynos5250_phy_i2c.c                   |   44 ++++
 drivers/phy/sata_phy_exynos5250.c                  |  219 ++++++++++++++++++++
 drivers/phy/sata_phy_exynos5250.h                  |   35 ++++
 11 files changed, 370 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/exynos_sataphy_i2c.txt
 create mode 100644 drivers/phy/exynos5250_phy_i2c.c
 create mode 100644 drivers/phy/sata_phy_exynos5250.c
 create mode 100644 drivers/phy/sata_phy_exynos5250.h

-- 
1.7.9.5

