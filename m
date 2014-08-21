Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaHULcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:32:24 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:45906 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131AbaHULcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:32:22 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: airlied@linux.ie, daniel.vetter@ffwll.ch, robdclark@gmail.com
Cc: guido@vanguardiasur.com.ar, thomas.wood@intel.com, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] drm: tilcdc: Make of_device_id array const
Date: Thu, 21 Aug 2014 16:59:30 +0530
Message-Id: <1408620570-10740-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c    |    4 ++--
 drivers/gpu/drm/tilcdc/tilcdc_panel.c  |    4 ++--
 drivers/gpu/drm/tilcdc/tilcdc_slave.c  |    4 ++--
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 6be623b..57b0a19 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -47,7 +47,7 @@ void tilcdc_slave_probedefer(bool defered)
 	slave_probing = defered;
 }
 
-static struct of_device_id tilcdc_of_match[];
+static const struct of_device_id tilcdc_of_match[];
 
 static struct drm_framebuffer *tilcdc_fb_create(struct drm_device *dev,
 		struct drm_file *file_priv, struct drm_mode_fb_cmd2 *mode_cmd)
@@ -594,7 +594,7 @@ static int tilcdc_pdev_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id tilcdc_of_match[] = {
+static const struct of_device_id tilcdc_of_match[] = {
 		{ .compatible = "ti,am33xx-tilcdc", },
 		{ },
 };
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 4c7aa1d..19aacc8 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -337,7 +337,7 @@ static struct tilcdc_panel_info *of_get_panel_info(struct device_node *np)
 	return info;
 }
 
-static struct of_device_id panel_of_match[];
+static const struct of_device_id panel_of_match[];
 
 static int panel_probe(struct platform_device *pdev)
 {
@@ -410,7 +410,7 @@ static int panel_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id panel_of_match[] = {
+static const struct of_device_id panel_of_match[] = {
 		{ .compatible = "ti,tilcdc,panel", },
 		{ },
 };
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index 3775fd4..1cab937 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -304,7 +304,7 @@ static const struct tilcdc_module_ops slave_module_ops = {
  * Device:
  */
 
-static struct of_device_id slave_of_match[];
+static const struct of_device_id slave_of_match[];
 
 static int slave_probe(struct platform_device *pdev)
 {
@@ -385,7 +385,7 @@ static int slave_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id slave_of_match[] = {
+static const struct of_device_id slave_of_match[] = {
 		{ .compatible = "ti,tilcdc,slave", },
 		{ },
 };
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index 354c47c..1bd8e81 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -304,7 +304,7 @@ static const struct tilcdc_module_ops tfp410_module_ops = {
  * Device:
  */
 
-static struct of_device_id tfp410_of_match[];
+static const struct of_device_id tfp410_of_match[];
 
 static int tfp410_probe(struct platform_device *pdev)
 {
@@ -394,7 +394,7 @@ static int tfp410_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id tfp410_of_match[] = {
+static const struct of_device_id tfp410_of_match[] = {
 		{ .compatible = "ti,tilcdc,tfp410", },
 		{ },
 };
-- 
1.7.9.5

