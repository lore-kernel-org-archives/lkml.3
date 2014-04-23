Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaDWObJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:31:09 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60047 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaDWObG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:06 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, robh+dt@kernel.org, gregkh@linuxfoundation.org,
        olof@lixom.net, balbi@ti.com, jg1.han@samsung.com, t.figa@samsung.com
Subject: [PATCH 0/9] Enable USB 3.0 support on Exynos5 systems
Date: Wed, 23 Apr 2014 20:00:42 +0530
Message-Id: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'for-next' branch of Kgene's linux-samsung tree.
Tested with phy-driver[1] patches and peach-pit dts[2].

This is the DT split part of the patch-series[3].

Patches:  usb-phy: samsung-usb3: Remove older phy-samsung-usb3 driver
          ARM: exynos_defconfig: Remove SAMSUNG_USB3PHY config
are removing the older phy-samsung-usb3 driver. Have included this driver patch
in this series since we are moving the device tree of DWC3 controller to new
phy driver, so we wouldn't be needing this older driver anymore.

[1]: [PATCH v6 1/2] phy: Add new Exynos5 USB 3.0 PHY driver
     http://www.spinics.net/lists/linux-usb/msg106185.html
     [PATCH v6 2/2] phy: exynos5-usbdrd: Add facility for VBUS supply
     http://www.spinics.net/lists/linux-usb/msg106184.html

[2]: [PATCH] ARM: dts: Add peach-pit board support
     http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg28846.html

[3]: [PATCH V4 0/5] Add Exynos5 USB 3.0 phy driver based on generic PHY framework
     https://lkml.org/lkml/2014/4/8/247

Vivek Gautam (9):
  dt: exynos5420: Enable support for USB 3.0 PHY controller
  dt: exynos5420: Enable support for DWC3 controller
  dt: exynos5250: Enable support for generic USB DRD phy
  dts: exynos5250: Update DWC3 usb controller to use new phy driver
  dts: exynos5250-snow: Add Vbus regulator for USB 3.0
  dts: exynos5420-peach-pit: Add Vbus regulator for USB 3.0
  dts: exynos5420-smdk5420: Add Vbus regulator for USB 3.0
  usb-phy: samsung-usb3: Remove older phy-samsung-usb3 driver
  ARM: exynos_defconfig: Remove SAMSUNG_USB3PHY config

 arch/arm/boot/dts/exynos5250-snow.dts      |   22 ++
 arch/arm/boot/dts/exynos5250.dtsi          |   21 +-
 arch/arm/boot/dts/exynos5420-peach-pit.dts |   44 ++++
 arch/arm/boot/dts/exynos5420-smdk5420.dts  |   46 ++++
 arch/arm/boot/dts/exynos5420.dtsi          |   54 +++++
 arch/arm/configs/exynos_defconfig          |    1 -
 drivers/usb/phy/Kconfig                    |    8 -
 drivers/usb/phy/Makefile                   |    1 -
 drivers/usb/phy/phy-samsung-usb.h          |   80 -------
 drivers/usb/phy/phy-samsung-usb3.c         |  350 ----------------------------
 10 files changed, 175 insertions(+), 452 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c

-- 
1.7.10.4

