Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaBUOFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:05:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38759 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbaBUOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:05:46 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH] phy: restrict Samsung S5P/Exynos drivers to the respective architectures
Date: Fri, 21 Feb 2014 15:05:26 +0100
Message-Id: <1392991526-20895-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling these drivers on platforms not created by Samsung is useless
unless you're doing compile tests. So don't offer the users to enable
them without COMPILE_TEST for configs with S5P/Exynos disabled.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/phy/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index c7a551c2d5f1..82a98f1a5ec2 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -18,6 +18,7 @@ config GENERIC_PHY
 config PHY_EXYNOS_MIPI_VIDEO
 	depends on HAS_IOMEM
 	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
+	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
 	help
 	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung S5P
 	  and EXYNOS SoCs.
@@ -54,6 +55,7 @@ config TWL4030_USB
 config PHY_EXYNOS_DP_VIDEO
 	tristate "EXYNOS SoC series Display Port PHY driver"
 	depends on OF
+	depends on ARCH_EXYNOS || COMPILE_TEST
 	select GENERIC_PHY
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
-- 
1.8.5.3

