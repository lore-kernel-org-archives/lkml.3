Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab3CZLeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:34:22 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38604 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab3CZLeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:34:20 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 0/9] thermal: exynos: Add thermal driver for exynos5440
Date: Tue, 26 Mar 2013 17:03:53 +0530
Message-Id: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds TMU(Thermal management Unit) driver support for
exynos5440 platform. There are 3 instances of the TMU controllers so
necessary cleanup is done to handle multiple thermal zone.

Patch 1 [thermal: exynos: Adapt to temperature emulation core thermal]
is a re-post of the earlier posted patch,
https://patchwork.kernel.org/patch/2123131/.

All these patches are based on thermal maintainers git tree,
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.

Amit Daniel Kachhap (9):
  thermal: exynos: Adapt to temperature emulation core thermal
    framework
  thermal: exynos: Add support for instance based register/unregister
  thermal: exynos: Moving into samsung directory for easy maintenance.
  thermal: exynos: Bifurcate exynos thermal common and tmu controller
    code
  thermal: exynos: Make the zone handling dependent on trip count
  thermal: exynos: small cleanups to prepare for adding exynos5440
    driver
  thermal: exynos: Add support for exynos5440 TMU sensor.
  thermal: exynos: Parse the platform data from the device tree.
  ARM: dts: Add device tree node for exynos5440 TMU controller

 .../bindings/thermal/exynos5440-thermal.txt        |   93 ++
 Documentation/thermal/exynos_thermal_emulation     |    8 +-
 arch/arm/boot/dts/exynos5440.dtsi                  |   43 +
 drivers/thermal/Kconfig                            |   22 +-
 drivers/thermal/Makefile                           |    2 +-
 drivers/thermal/exynos_thermal.c                   | 1112 --------------------
 drivers/thermal/samsung/Kconfig                    |   32 +
 drivers/thermal/samsung/Makefile                   |    6 +
 drivers/thermal/samsung/exynos4210_thermal.c       |  658 ++++++++++++
 drivers/thermal/samsung/exynos5440_thermal.c       |  712 +++++++++++++
 drivers/thermal/samsung/exynos_common.c            |  515 +++++++++
 drivers/thermal/samsung/exynos_common.h            |   74 ++
 include/linux/platform_data/exynos_thermal.h       |   37 +-
 13 files changed, 2163 insertions(+), 1151 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/exynos5440-thermal.txt
 delete mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 drivers/thermal/samsung/Kconfig
 create mode 100644 drivers/thermal/samsung/Makefile
 create mode 100644 drivers/thermal/samsung/exynos4210_thermal.c
 create mode 100644 drivers/thermal/samsung/exynos5440_thermal.c
 create mode 100644 drivers/thermal/samsung/exynos_common.c
 create mode 100644 drivers/thermal/samsung/exynos_common.h

