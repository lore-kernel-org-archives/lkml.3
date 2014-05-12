Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbaELM4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:56:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58246 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754515AbaELM4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:56:34 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: kgene.kim@samsung.com, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        sylvester.nawrocki@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] phy: exynos-mipi-video: fix check on array index
Date: Mon, 12 May 2014 14:56:28 +0200
Message-Id: <1399899388-13101-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The phys array is of size EXYNOS_MIPI_PHYS_NUM. Trying to access the
index EXYNOS_MIPI_PHYS_NUM should return an error.

Fixes: 069d2e26e9d6 "phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs"

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/phy/phy-exynos-mipi-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index 7f139326a642..ff026689358c 100644
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
1.9.1

