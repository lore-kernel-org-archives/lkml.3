Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaEPNFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:05:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51858 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbaEPNDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/11] phy: exynos-mipi-video: fix check on array index
Date: Fri, 16 May 2014 18:32:59 +0530
Message-ID: <1400245387-14445-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400245387-14445-1-git-send-email-kishon@ti.com>
References: <1400245387-14445-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Ténart <antoine.tenart@free-electrons.com>

The phys array is of size EXYNOS_MIPI_PHYS_NUM. Trying to access the
index EXYNOS_MIPI_PHYS_NUM should return an error.

Fixes: 069d2e26e9d6 "phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs"

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-exynos-mipi-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index 7f13932..ff02668 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -101,7 +101,7 @@ static struct phy *exynos_mipi_video_phy_xlate(struct device *dev,
 {
 	struct exynos_mipi_video_phy *state = dev_get_drvdata(dev);
 
-	if (WARN_ON(args->args[0] > EXYNOS_MIPI_PHYS_NUM))
+	if (WARN_ON(args->args[0] >= EXYNOS_MIPI_PHYS_NUM))
 		return ERR_PTR(-ENODEV);
 
 	return state->phys[args->args[0]].phy;
-- 
1.7.9.5

