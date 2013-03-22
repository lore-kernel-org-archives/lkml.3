Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab3CVOgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:36:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6532 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab3CVOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:34:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 22 Mar 2013 07:34:10 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv9 6/9] gpu: host1x: drm: Rename host1x to host1x_drm
Date: Fri, 22 Mar 2013 16:34:06 +0200
Message-ID: <1363962849-19872-7-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363962849-19872-1-git-send-email-tbergstrom@nvidia.com>
References: <1363962849-19872-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arto Merilainen <amerilainen@nvidia.com>

Both host1x and drm drivers have host1x structures. This patch
renames the host1x structure under drm to follow name host1x_drm.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/drm/dc.c     |    4 ++--
 drivers/gpu/host1x/drm/drm.c    |    4 ++--
 drivers/gpu/host1x/drm/drm.h    |   14 +++++++-------
 drivers/gpu/host1x/drm/fb.c     |    6 +++---
 drivers/gpu/host1x/drm/hdmi.c   |    4 ++--
 drivers/gpu/host1x/drm/host1x.c |   22 ++++++++++++----------
 6 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
index de94707..d1f6609 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -1097,7 +1097,7 @@ static const struct host1x_client_ops dc_client_ops = {
 
 static int tegra_dc_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct resource *regs;
 	struct tegra_dc *dc;
 	int err;
@@ -1160,7 +1160,7 @@ static int tegra_dc_probe(struct platform_device *pdev)
 
 static int tegra_dc_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 9d452df..6c59bcd 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -26,7 +26,7 @@
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 {
 	struct device *dev = drm->dev;
-	struct host1x *host1x;
+	struct host1x_drm *host1x;
 	int err;
 
 	host1x = dev_get_drvdata(dev);
@@ -69,7 +69,7 @@ static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 
 static void tegra_drm_lastclose(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	struct host1x_drm *host1x = drm->dev_private;
 
 	drm_fbdev_cma_restore_mode(host1x->fbdev);
 }
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
index a6c011d..7fedb6c 100644
--- a/drivers/gpu/host1x/drm/drm.h
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -18,7 +18,7 @@
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fixed.h>
 
-struct host1x {
+struct host1x_drm {
 	struct drm_device *drm;
 	struct device *dev;
 	void __iomem *regs;
@@ -44,7 +44,7 @@ struct host1x_client_ops {
 };
 
 struct host1x_client {
-	struct host1x *host1x;
+	struct host1x_drm *host1x;
 	struct device *dev;
 
 	const struct host1x_client_ops *ops;
@@ -52,12 +52,12 @@ struct host1x_client {
 	struct list_head list;
 };
 
-extern int host1x_drm_init(struct host1x *host1x, struct drm_device *drm);
-extern int host1x_drm_exit(struct host1x *host1x);
+extern int host1x_drm_init(struct host1x_drm *host1x, struct drm_device *drm);
+extern int host1x_drm_exit(struct host1x_drm *host1x);
 
-extern int host1x_register_client(struct host1x *host1x,
+extern int host1x_register_client(struct host1x_drm *host1x,
 				  struct host1x_client *client);
-extern int host1x_unregister_client(struct host1x *host1x,
+extern int host1x_unregister_client(struct host1x_drm *host1x,
 				    struct host1x_client *client);
 
 struct tegra_output;
@@ -66,7 +66,7 @@ struct tegra_dc {
 	struct host1x_client client;
 	spinlock_t lock;
 
-	struct host1x *host1x;
+	struct host1x_drm *host1x;
 	struct device *dev;
 
 	struct drm_crtc base;
diff --git a/drivers/gpu/host1x/drm/fb.c b/drivers/gpu/host1x/drm/fb.c
index 0391495..6ed885a 100644
--- a/drivers/gpu/host1x/drm/fb.c
+++ b/drivers/gpu/host1x/drm/fb.c
@@ -11,7 +11,7 @@
 
 static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	struct host1x_drm *host1x = drm->dev_private;
 
 	drm_fbdev_cma_hotplug_event(host1x->fbdev);
 }
@@ -23,7 +23,7 @@ static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
 
 int tegra_drm_fb_init(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	struct host1x_drm *host1x = drm->dev_private;
 	struct drm_fbdev_cma *fbdev;
 
 	drm->mode_config.min_width = 0;
@@ -46,7 +46,7 @@ int tegra_drm_fb_init(struct drm_device *drm)
 
 void tegra_drm_fb_exit(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	struct host1x_drm *host1x = drm->dev_private;
 
 	drm_fbdev_cma_fini(host1x->fbdev);
 }
diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
index bb747f6..f438f80 100644
--- a/drivers/gpu/host1x/drm/hdmi.c
+++ b/drivers/gpu/host1x/drm/hdmi.c
@@ -1189,7 +1189,7 @@ static const struct host1x_client_ops hdmi_client_ops = {
 
 static int tegra_hdmi_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_hdmi *hdmi;
 	struct resource *regs;
 	int err;
@@ -1278,7 +1278,7 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 
 static int tegra_hdmi_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
 	int err;
 
diff --git a/drivers/gpu/host1x/drm/host1x.c b/drivers/gpu/host1x/drm/host1x.c
index 92e25a7..c3d8ee5 100644
--- a/drivers/gpu/host1x/drm/host1x.c
+++ b/drivers/gpu/host1x/drm/host1x.c
@@ -21,7 +21,8 @@ struct host1x_drm_client {
 	struct list_head list;
 };
 
-static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
+static int host1x_add_drm_client(struct host1x_drm *host1x,
+				 struct device_node *np)
 {
 	struct host1x_drm_client *client;
 
@@ -37,7 +38,7 @@ static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
 	return 0;
 }
 
-static int host1x_activate_drm_client(struct host1x *host1x,
+static int host1x_activate_drm_client(struct host1x_drm *host1x,
 				      struct host1x_drm_client *drm,
 				      struct host1x_client *client)
 {
@@ -50,7 +51,7 @@ static int host1x_activate_drm_client(struct host1x *host1x,
 	return 0;
 }
 
-static int host1x_remove_drm_client(struct host1x *host1x,
+static int host1x_remove_drm_client(struct host1x_drm *host1x,
 				    struct host1x_drm_client *client)
 {
 	mutex_lock(&host1x->drm_clients_lock);
@@ -63,7 +64,7 @@ static int host1x_remove_drm_client(struct host1x *host1x,
 	return 0;
 }
 
-static int host1x_parse_dt(struct host1x *host1x)
+static int host1x_parse_dt(struct host1x_drm *host1x)
 {
 	static const char * const compat[] = {
 		"nvidia,tegra20-dc",
@@ -92,7 +93,7 @@ static int host1x_parse_dt(struct host1x *host1x)
 
 static int tegra_host1x_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x;
+	struct host1x_drm *host1x;
 	struct resource *regs;
 	int err;
 
@@ -156,14 +157,14 @@ err:
 
 static int tegra_host1x_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = platform_get_drvdata(pdev);
+	struct host1x_drm *host1x = platform_get_drvdata(pdev);
 
 	clk_disable_unprepare(host1x->clk);
 
 	return 0;
 }
 
-int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
+int host1x_drm_init(struct host1x_drm *host1x, struct drm_device *drm)
 {
 	struct host1x_client *client;
 
@@ -186,7 +187,7 @@ int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
 	return 0;
 }
 
-int host1x_drm_exit(struct host1x *host1x)
+int host1x_drm_exit(struct host1x_drm *host1x)
 {
 	struct platform_device *pdev = to_platform_device(host1x->dev);
 	struct host1x_client *client;
@@ -216,7 +217,8 @@ int host1x_drm_exit(struct host1x *host1x)
 	return 0;
 }
 
-int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
+int host1x_register_client(struct host1x_drm *host1x,
+			   struct host1x_client *client)
 {
 	struct host1x_drm_client *drm, *tmp;
 	int err;
@@ -244,7 +246,7 @@ int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
 	return 0;
 }
 
-int host1x_unregister_client(struct host1x *host1x,
+int host1x_unregister_client(struct host1x_drm *host1x,
 			     struct host1x_client *client)
 {
 	struct host1x_drm_client *drm, *tmp;
-- 
1.7.9.5

