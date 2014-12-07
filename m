Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaLGM3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 07:29:01 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35743 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaLGM27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 07:28:59 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: gma500: tc35876x-dsi-lvds.c:  Remove unused function
Date: Sun,  7 Dec 2014 13:31:38 +0100
Message-Id: <1417955499-10939-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function tc35876x_exit() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c |   10 ----------
 drivers/gpu/drm/gma500/tc35876x-dsi-lvds.h |    1 -
 2 files changed, 11 deletions(-)

diff --git a/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c b/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c
index 771ff66..3def842 100644
--- a/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c
+++ b/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c
@@ -817,13 +817,3 @@ void tc35876x_init(struct drm_device *dev)
 
 	tc35876x_brightness_init(dev);
 }
-
-void tc35876x_exit(void)
-{
-	pr_debug("%s\n", __func__);
-
-	i2c_del_driver(&tc35876x_bridge_i2c_driver);
-
-	if (cmi_lcd_i2c_client)
-		i2c_del_driver(&cmi_lcd_i2c_driver);
-}
diff --git a/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.h b/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.h
index b14b7f9..cf9d6bb 100644
--- a/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.h
+++ b/drivers/gpu/drm/gma500/tc35876x-dsi-lvds.h
@@ -31,7 +31,6 @@ void tc35876x_brightness_control(struct drm_device *dev, int level);
 void tc35876x_toshiba_bridge_panel_off(struct drm_device *dev);
 void tc35876x_toshiba_bridge_panel_on(struct drm_device *dev);
 void tc35876x_init(struct drm_device *dev);
-void tc35876x_exit(void);
 
 extern const struct panel_funcs mdfld_tc35876x_funcs;
 
-- 
1.7.10.4

