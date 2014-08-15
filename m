Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbaHOMkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:40:24 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:46867 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaHOMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:40:22 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, kgene.kim@samsung.com, maxime.ripard@free-electrons.com,
        linux-samsung-soc@vger.kernel.org
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH 0/9] phy: various misc cleanups to phy drivers
Date: Fri, 15 Aug 2014 13:40:07 +0100
Message-Id: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series some a few misc cleanups to the PHY drivers: -

1) Use module_platform_driver to register spear PHY drivers. This gets rid
of a lof of boiler plate code.

2) Remove .owner field from drivers using module_platform_driver, as this gets
overridden anyway in __platform_driver_register.

3) Remove OOM site specific failure messages. These are unecessary and make
the kernel bigger.

4) Add missing kzalloc error check, which could avoid NULL ptr dereference.

regards,

Peter.

Peter Griffin (9):
  phy: phy-omap-control: Remove unncessary site specific OOM messages
  phy: phy-mvebu-sata: Add missing error check for devm_kzalloc
  phy: phy-omap-usb2: Remove unncessary site specific OOM messages
  phy: phy-ti-pipe3: Remove unncessary site specific OOM messages
  phy: phy-spear1310-miphy: Remove unncessary site specific OOM messages
  phy: phy-spear1340-miphy: Remove unncessary site specific OOM messages
  phy: remove .owner field for drivers using module_platform_driver
  phy: phy-spear1310-miphy: Use module_platform_driver to register
    driver.
  phy: phy-spear1340-miphy: Use module_platform_driver to register
    driver.

 drivers/phy/phy-bcm-kona-usb2.c     |  1 -
 drivers/phy/phy-berlin-sata.c       |  1 -
 drivers/phy/phy-exynos-dp-video.c   |  1 -
 drivers/phy/phy-exynos-mipi-video.c |  1 -
 drivers/phy/phy-exynos5-usbdrd.c    |  1 -
 drivers/phy/phy-exynos5250-sata.c   |  1 -
 drivers/phy/phy-hix5hd2-sata.c      |  1 -
 drivers/phy/phy-miphy365x.c         |  1 -
 drivers/phy/phy-mvebu-sata.c        |  3 ++-
 drivers/phy/phy-omap-control.c      |  5 +----
 drivers/phy/phy-omap-usb2.c         |  9 ++-------
 drivers/phy/phy-qcom-apq8064-sata.c |  1 -
 drivers/phy/phy-qcom-ipq806x-sata.c |  1 -
 drivers/phy/phy-samsung-usb2.c      |  1 -
 drivers/phy/phy-spear1310-miphy.c   | 17 ++---------------
 drivers/phy/phy-spear1340-miphy.c   | 17 ++---------------
 drivers/phy/phy-sun4i-usb.c         |  1 -
 drivers/phy/phy-ti-pipe3.c          |  6 ++----
 drivers/phy/phy-twl4030-usb.c       |  1 -
 drivers/phy/phy-xgene.c             |  1 -
 20 files changed, 11 insertions(+), 60 deletions(-)

-- 
1.9.1

