Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3JMQSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:18:45 -0400
Received: from sauhun.de ([89.238.76.85]:56489 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab3JMQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:18:23 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drivers/gpu/drm/tilcdc: don't use devm_pinctrl_get_select_default() in probe
Date: Sun, 13 Oct 2013 18:17:47 +0200
Message-Id: <1381681071-6021-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c  | 6 ------
 drivers/gpu/drm/tilcdc/tilcdc_slave.c  | 6 ------
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c | 6 ------
 3 files changed, 18 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 86c6732..f0ff5f8 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/backlight.h>
 #include <video/display_timing.h>
 #include <video/of_display_timing.h>
@@ -358,7 +357,6 @@ static int panel_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	struct panel_module *panel_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	int ret = -EINVAL;
 
 
@@ -376,10 +374,6 @@ static int panel_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "panel", &panel_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 
 	panel_mod->timings = of_get_display_timings(node);
 	if (!panel_mod->timings) {
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index 595068b..4f3c969 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -17,7 +17,6 @@
 
 #include <linux/i2c.h>
 #include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 #include <drm/drm_encoder_slave.h>
 
 #include "tilcdc_drv.h"
@@ -320,7 +319,6 @@ static int slave_probe(struct platform_device *pdev)
 	struct device_node *i2c_node;
 	struct slave_module *slave_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	uint32_t i2c_phandle;
 	struct i2c_adapter *slavei2c;
 	int ret = -EINVAL;
@@ -366,10 +364,6 @@ static int slave_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "slave", &slave_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 	tilcdc_slave_probedefer(false);
 
 	return 0;
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index c38b56b..20f3d89 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -19,7 +19,6 @@
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "tilcdc_drv.h"
 
@@ -326,7 +325,6 @@ static int tfp410_probe(struct platform_device *pdev)
 	struct device_node *i2c_node;
 	struct tfp410_module *tfp410_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	uint32_t i2c_phandle;
 	int ret = -EINVAL;
 
@@ -344,10 +342,6 @@ static int tfp410_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "tfp410", &tfp410_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 	if (of_property_read_u32(node, "i2c", &i2c_phandle)) {
 		dev_err(&pdev->dev, "could not get i2c bus phandle\n");
 		goto fail;
-- 
1.8.4.rc3

