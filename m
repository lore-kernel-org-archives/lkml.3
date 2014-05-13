Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaEMKAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:00:39 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:65421 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884AbaEMKAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:00:30 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kishon@ti.com
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, kgene.kim@samsung.com, robh+dt@kernel.org,
        mark.rutland@arm.com, balbi@ti.com, sylvester.nawrocki@gmail.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v9 0/3] Add Exynos5 USB 3.0 phy driver based on generic PHY framework
Date: Tue, 13 May 2014 15:30:14 +0530
Message-Id: <1399975217-3231-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'next' branch of Kishon's phy tree (linux-phy).

Changes from v8:
 - Moved out the bindings documentation for the PHY in a separate patch
   to avoid checkpatch warnings.

Changes from v7:
 - Providing an **alternative** approach for pmu-offset;
   instead of getting it from DT, using offset definitions from
   a header file, and making use of it in the driver.
 - Using 'aliases' for getting channel numbers for multi-controller
   PHY, so as to distinguish between the pmu-offsets.
 - Added a header file in syscon/ for Exynos5 SoC's pmu offset
   definitions.
 - Addressed the review comments for nits:
   -- Changed 'usbdrd_phy_config' structure with 'exynos5_usbdrd_phy_config'
      and corresponding instance names.

Vivek Gautam (3):
  Documentation: Document Exynos5 USB 3.0 DRD PHY
  phy: Add new Exynos5 USB 3.0 PHY driver
  phy: exynos5-usbdrd: Add facility for VBUS supply

 .../devicetree/bindings/phy/samsung-phy.txt        |   47 ++
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5-usbdrd.c                   |  676 ++++++++++++++++++++
 include/linux/mfd/syscon/exynos5-pmu.h             |   44 ++
 5 files changed, 779 insertions(+)
 create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
 create mode 100644 include/linux/mfd/syscon/exynos5-pmu.h

-- 
1.7.10.4

