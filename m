Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3GJP6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:58:49 -0400
Received: from sauhun.de ([89.238.76.85]:44291 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3GJP6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:58:48 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Benoit Parrot <bparrot@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Darren Etheridge <detheridge@ti.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 01/12] drivers/gpu/drm/tilcdc: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:36 +0100
Message-Id: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c  |    6 ------
 drivers/gpu/drm/tilcdc/tilcdc_slave.c  |    6 ------
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c |    6 ------
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
index dfffaf0..2bdbe5e 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -18,7 +18,6 @@
 #include <linux/i2c.h>
 #include <linux/of_i2c.h>
 #include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 #include <drm/drm_encoder_slave.h>
 
 #include "tilcdc_drv.h"
@@ -296,7 +295,6 @@ static int slave_probe(struct platform_device *pdev)
 	struct device_node *i2c_node;
 	struct slave_module *slave_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	uint32_t i2c_phandle;
 	struct i2c_adapter *slavei2c;
 	int ret = -EINVAL;
@@ -342,10 +340,6 @@ static int slave_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "slave", &slave_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 	tilcdc_slave_probedefer(false);
 
 	return 0;
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index 925c7cd..a38be60 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -20,7 +20,6 @@
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "tilcdc_drv.h"
 
@@ -327,7 +326,6 @@ static int tfp410_probe(struct platform_device *pdev)
 	struct device_node *i2c_node;
 	struct tfp410_module *tfp410_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	uint32_t i2c_phandle;
 	int ret = -EINVAL;
 
@@ -345,10 +343,6 @@ static int tfp410_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "tfp410", &tfp410_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 	if (of_property_read_u32(node, "i2c", &i2c_phandle)) {
 		dev_err(&pdev->dev, "could not get i2c bus phandle\n");
 		goto fail;
-- 
1.7.10.4

