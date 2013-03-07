Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3CGNTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:19:12 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:60812 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab3CGNS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:18:28 -0500
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: [PATCH v8 10/12] clk: Kconfig for Palmas clock driver
Date: Thu,  7 Mar 2013 13:17:54 +0000
Message-Id: <1362662276-20792-10-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/clk/Kconfig        |    8 ++++++++
 drivers/clk/Makefile       |    1 +
 drivers/leds/leds-palmas.c |   19 ++++++-------------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index a47e6ee..a8e0655 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -63,6 +63,14 @@ config CLK_TWL6040
 	  McPDM. McPDM module is using the external bit clock on the McPDM bus
 	  as functional clock.
 
+config CLK_PALMAS
+	tristate "Palmas PMIC Clock Support"
+	depends on MFD_PALMAS
+	---help---
+	  Enable clock support for the two clocks on Palmas PMIC chips:
+	  - A 32KHz audio-gated clock (primarily for audio devices)
+	  - A digitally-gated 32KHz clock
+
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 300d477..77dc283 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
 obj-$(CONFIG_CLK_TWL6040)	+= clk-twl6040.o
+obj-$(CONFIG_CLK_PALMAS)	+= clk-palmas.o
diff --git a/drivers/leds/leds-palmas.c b/drivers/leds/leds-palmas.c
index 4a35352..ea53bfe 100644
--- a/drivers/leds/leds-palmas.c
+++ b/drivers/leds/leds-palmas.c
@@ -341,37 +341,30 @@ static int  palmas_dt_to_pdata(struct device *dev,
 		struct device_node *node,
 		struct palmas_leds_platform_data *pdata)
 {
-	struct device_node *child_node;
 	int ret;
 	u32 prop;
 
-	child_node = of_get_child_by_name(node, "leds");
-	if (!child_node) {
-		dev_err(dev, "child node 'palmas_leds' not found\n");
-		return -EINVAL;
-	}
-
-	ret = of_property_read_u32(child_node, "ti,led1-current", &prop);
+	ret = of_property_read_u32(node, "ti,led1-current", &prop);
 	if (!ret)
 		pdata->led1_current = prop;
 
-	ret = of_property_read_u32(child_node, "ti,led2-current", &prop);
+	ret = of_property_read_u32(node, "ti,led2-current", &prop);
 	if (!ret)
 		pdata->led2_current = prop;
 
-	ret = of_property_read_u32(child_node, "ti,led3-current", &prop);
+	ret = of_property_read_u32(node, "ti,led3-current", &prop);
 	if (!ret)
 		pdata->led3_current = prop;
 
-	ret = of_property_read_u32(child_node, "ti,led4-current", &prop);
+	ret = of_property_read_u32(node, "ti,led4-current", &prop);
 	if (!ret)
 		pdata->led4_current = prop;
 
-	ret = of_property_read_u32(child_node, "ti,chrg-led-mode", &prop);
+	ret = of_property_read_u32(node, "ti,chrg-led-mode", &prop);
 	if (!ret)
 		pdata->chrg_led_mode = prop;
 
-	ret = of_property_read_u32(child_node, "ti,chrg-led-vbat-low", &prop);
+	ret = of_property_read_u32(node, "ti,chrg-led-vbat-low", &prop);
 	if (!ret)
 		pdata->chrg_led_vbat_low = prop;
 
-- 
1.7.0.4

