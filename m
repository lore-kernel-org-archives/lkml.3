Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3EGNBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:01:33 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:60543 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3EGNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:01:31 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V3 0/20] thermal: exynos: Add thermal driver for exynos5440
Date: Tue,  7 May 2013 18:30:50 +0530
Message-Id: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V3:
* Added proper dependency of different exynos thermal Kconfig symbols. Basically 3
 Kconfig can be enabled now and corresponds to tmu driver. exynos common part
 and exynos configuration data. This issue was raised by Rui Zhang.

Changes in V2:
* Separated SOC data from TMU driver. This is as per suggestion from Eduardo.
* Merged the new file created for exynos5440 TMU controller with the existing
 TMU controller code.
* Removed the DT parsing code as now the SOC specific data are cleanly put
 inside the data specific file.
* Even the register definations/bitfields are treated as data as there is
 some variation across SOC's.

This patchset adds TMU(Thermal management Unit) driver support for
exynos5440 platform. There are 3 instances of the TMU controllers so
necessary cleanup/re-structure is done to handle multiple thermal zone.

Patch (exynos4: Add documentation for Exynos SoC thermal bindings) from
Lukasz Majewski is already posted to mainline. Adding it here for completeness.
(http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg17817.html)

Patch (thermal: exynos: Support thermal tripping ) from Jonghwan Choi is
added here with some changes.
(https://patchwork.kernel.org/patch/1668371/)

Patch (thermal: exynos: Support for TMU regulator defined at device tree)
is a repost of my earlier patch(https://patchwork-mail1.kernel.org/patch/2510771/) 
and adds regulator support.

Patch (ARM: dts: Add device tree node for exynos5440 TMU controller) can be
merged through exynos platform maintainer as this can cause merge conflict.

All these patches are based on thermal maintainers git tree,
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.

Amit Daniel Kachhap (20):
  thermal: exynos: Moving exynos thermal files into samsung directory
  thermal: exynos: Bifurcate exynos thermal common and tmu controller
    code
  thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
  thermal: exynos: Move exynos_thermal.h from include/* to driver/*
    folder
  thermal: exynos: Bifurcate exynos tmu driver and configuration data
  thermal: exynos: Add missing definations and code cleanup
  thermal: exynos: Add extra entries in the tmu platform data
  thermal: exynos: Support thermal tripping
  thermal: exynos: Move register definitions from driver file to data
    file
  thermal: exynos: Fix to clear only the generated interrupts
  thermal: exynos: Add support for instance based register/unregister
  thermal: exynos: Modify private_data to appropriate name driver_data
  thermal: exynos: Return success even if no cooling data supplied
  thermal: exynos: Make the zone handling dependent on trip count
  thermal: exynos: Add support to handle many instances of TMU
  thermal: exynos: Add features to check instead of using SOC type
  thermal: exynos: Add support for exynos5440 TMU sensor.
  Documentation: thermal: Explain the exynos thermal driver model
  thermal: exynos: Support for TMU regulator defined at device tree
  ARM: dts: Add device tree node for exynos5440 TMU controller

Lukasz Majewski (1):
  ARM: dts: thermal: exynos4: Add documentation for Exynos SoC thermal
    bindings

 .../devicetree/bindings/thermal/exynos-thermal.txt |   53 +
 Documentation/thermal/exynos_thermal               |   43 +-
 arch/arm/boot/dts/exynos5440.dtsi                  |   30 +
 drivers/thermal/Kconfig                            |   13 +-
 drivers/thermal/Makefile                           |    2 +-
 drivers/thermal/exynos_thermal.c                   | 1066 --------------------
 drivers/thermal/samsung/Kconfig                    |   28 +
 drivers/thermal/samsung/Makefile                   |    7 +
 drivers/thermal/samsung/exynos_thermal_common.c    |  401 ++++++++
 drivers/thermal/samsung/exynos_thermal_common.h    |   96 ++
 drivers/thermal/samsung/exynos_tmu.c               |  738 ++++++++++++++
 drivers/thermal/samsung/exynos_tmu.h               |  225 ++++
 drivers/thermal/samsung/exynos_tmu_data.c          |  224 ++++
 drivers/thermal/samsung/exynos_tmu_data.h          |  149 +++
 include/linux/platform_data/exynos_thermal.h       |  119 ---
 15 files changed, 1991 insertions(+), 1203 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt
 delete mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 drivers/thermal/samsung/Kconfig
 create mode 100644 drivers/thermal/samsung/Makefile
 create mode 100644 drivers/thermal/samsung/exynos_thermal_common.c
 create mode 100644 drivers/thermal/samsung/exynos_thermal_common.h
 create mode 100644 drivers/thermal/samsung/exynos_tmu.c
 create mode 100644 drivers/thermal/samsung/exynos_tmu.h
 create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
 create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
 delete mode 100644 include/linux/platform_data/exynos_thermal.h

