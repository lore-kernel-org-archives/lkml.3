Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaANPsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:48:46 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1670 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751921AbaANPqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:46:16 -0500
From: Richard Weinberger <richard@nod.at>
To: kishon@ti.com, anton@enomsg.org, dwmw2@infradead.org,
        richardcochran@gmail.com, lidza.louina@gmail.com,
        gregkh@linuxfoundation.org, jic23@kernel.org, davem@davemloft.net
Cc: sebastian.hesselbarth@gmail.com, florian@openwrt.org,
        thomas.petazzoni@free-electrons.com, lars@metafoo.de, marex@denx.de,
        acourbot@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-iio@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/7] phy,exynos: Add dependency on HAS_IOMEM
Date: Tue, 14 Jan 2014 16:45:42 +0100
Message-Id: <1389714345-20165-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389714345-20165-1-git-send-email-richard@nod.at>
References: <1389714345-20165-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/built-in.o: In function `exynos_mipi_video_phy_probe':
drivers/phy/phy-exynos-mipi-video.c:130: undefined reference to `devm_ioremap_resource'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 330ef2d..a8b17ce 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -16,6 +16,7 @@ config GENERIC_PHY
 	  framework should select this config.
 
 config PHY_EXYNOS_MIPI_VIDEO
+	depends on HAS_IOMEM
 	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
 	help
 	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung S5P
-- 
1.8.1.4

