Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3C0VTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:19:16 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38633 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3C0VTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:19:15 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: inki.dae@samsung.com, dh09.lee@samsung.com, kyungmin.park@samsung.com,
        FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] video: exynos: remove useless safety check in list traversal
Date: Wed, 27 Mar 2013 23:19:05 +0200
Message-Id: <1364419145-30375-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_for_each_entry_safe() does not require safety check.
Patch found using coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/video/exynos/exynos_mipi_dsi.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index dd5e5e9..fe84f08 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -214,8 +214,6 @@ static struct mipi_dsim_ddi *exynos_mipi_dsi_find_lcd_device(
 	mutex_lock(&mipi_dsim_lock);
 
 	list_for_each_entry_safe(dsim_ddi, next, &dsim_ddi_list, list) {
-		if (!dsim_ddi)
-			goto out;
 
 		lcd_dev = dsim_ddi->dsim_lcd_dev;
 		if (!lcd_dev)
@@ -473,17 +471,15 @@ static int exynos_mipi_dsi_remove(struct platform_device *pdev)
 	clk_disable(dsim->clock);
 
 	list_for_each_entry_safe(dsim_ddi, next, &dsim_ddi_list, list) {
-		if (dsim_ddi) {
-			if (dsim->id != dsim_ddi->bus_id)
-				continue;
+		if (dsim->id != dsim_ddi->bus_id)
+			continue;
 
-			dsim_lcd_drv = dsim_ddi->dsim_lcd_drv;
+		dsim_lcd_drv = dsim_ddi->dsim_lcd_drv;
 
-			if (dsim_lcd_drv->remove)
-				dsim_lcd_drv->remove(dsim_ddi->dsim_lcd_dev);
+		if (dsim_lcd_drv->remove)
+			dsim_lcd_drv->remove(dsim_ddi->dsim_lcd_dev);
 
-			kfree(dsim_ddi);
-		}
+		kfree(dsim_ddi);
 	}
 
 	return 0;
-- 
1.7.9.5

