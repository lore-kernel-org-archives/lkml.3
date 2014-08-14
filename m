Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaHNOYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:24:17 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57308 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaHNOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:15 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 0/7] usb-phy: samsung: Cleanup the unused drivers
Date: Thu, 14 Aug 2014 19:53:53 +0530
Message-Id: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- This series is based on 'usb-next' branch.

Now that we have support for USB PHY controllers for Exynos SoC series,
we are free to remove the older usb-phy support.
In the process, we are removing the entire phy-samsung-usb3 driver, and
besides that all support for Exynos4x and Exynos5 from phy-samsung-usb2
driver.

We have also removed the older USB-PHY support from ehci-exynos and ohci-exynos
since those drivers now can use newer GENERIC-PHYs, and don't need the older
USB-PHYs and related code anymore. These patches for ohci-exynos and ehci-exynos
now replaces the older sent patch for phy sequence cleanup for them.[1]

I have build-tested this series for exynos_defconfig and s3c64xx_defconfig,
and have tested the EHCI and OHCI operations on smdk5250 board, but
have not tested the actual working due to unavailability of S3C64XX
board. So can someone please help me testing this series.

[1] https://lkml.org/lkml/2014/8/5/142

Vivek Gautam (7):
  usb-phy: samsung-usb3: Remove older phy-samsung-usb3 driver
  usb-phy: samsung-usb2: Remove support for Exynos5250
  usb-phy: samsung-usb2: Remove support for Exynos4X12
  usb-phy: samsung-usb2: Remove support for Exynos4210
  usb-phy: samsung-usb2: Clean up to leave only S3C64XX support
  usb: host: ehci-exynos: Remove unnecessary usb-phy support
  usb: host: ohci-exynos: Remove unnecessary usb-phy support

 drivers/usb/host/ehci-exynos.c     |   53 +-----
 drivers/usb/host/ohci-exynos.c     |   64 +------
 drivers/usb/phy/Kconfig            |   16 --
 drivers/usb/phy/Makefile           |    2 -
 drivers/usb/phy/phy-samsung-usb.c  |  241 -----------------------
 drivers/usb/phy/phy-samsung-usb.h  |  349 ---------------------------------
 drivers/usb/phy/phy-samsung-usb2.c |  371 ++++++++----------------------------
 drivers/usb/phy/phy-samsung-usb2.h |  121 ++++++++++++
 drivers/usb/phy/phy-samsung-usb3.c |  350 ----------------------------------
 9 files changed, 213 insertions(+), 1354 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.h
 create mode 100644 drivers/usb/phy/phy-samsung-usb2.h
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c

-- 
1.7.10.4

