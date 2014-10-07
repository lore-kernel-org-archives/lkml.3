Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaJGKTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:19:44 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41396 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaJGKTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:19:41 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v2 0/4] usb: dwc3/phy-exynos5-usbdrd: Extend support to Exynos7
Date: Tue,  7 Oct 2014 15:49:32 +0530
Message-Id: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding required support for clocks and additional VBUS regulators
to enable USB 3.0 support on Exynos7 SoC.

This series depends for ACRH_EXYNOS7 support on following series:
[PATCH v5 0/8] arch: arm64: Enable support for Samsung Exynos7 SoC
http://www.spinics.net/lists/linux-samsung-soc/msg37047.html

The series is based on usb-next branch.

Changes since v1:
 -- Addressed review comments for unnecessary warning messages after
    clk_get() fails for dwc3-exynos and phy-exynos5-usbdrd.
 -- Assigned "exynos->sclk" as well as "phy_drd->utmiclk" and
    "phy_drd->pipeclk" to NULL in case of clk_get() failure to avoid
    unnecessary check for clock.
 -- Modified dependency for symbol PHY_EXYNOS5_USBDRD to depend on
    ARCH_EXYNOS which includes both Exynos5 as well as Exynos7.
 -- Dropped [PATCH 4/5] usb: dwc3: Adding Kconfig dependency for Exynos7
    from v1 of this series, since its not required now.

Vivek Gautam (4):
  dwc3: exynos: Add support for SCLK present on Exynos7
  phy: exynos5-usbdrd: Add pipe-clk and utmi-clk support
  phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
  phy: exynos7-usbdrd: Update dependency for ARCH_EXYNOS

 .../devicetree/bindings/phy/samsung-phy.txt        |    4 ++
 drivers/phy/Kconfig                                |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |   52 +++++++++++++++++++-
 drivers/usb/dwc3/dwc3-exynos.c                     |   16 ++++++
 4 files changed, 71 insertions(+), 3 deletions(-)

-- 
1.7.10.4

