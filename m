Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaHDEzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:55:55 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:46564 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaHDEzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:55:52 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <84347b3a9ea5aef27aabec6591555cba>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: mark yao <yzq@rock-chips.com>
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org,
        xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com,
        cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, mark yao <yzq@rock-chips.com>
Subject: [PATCH 7/9] drm: add Rockchip Soc rk3288 lvds connector
Date: Mon,  4 Aug 2014 12:54:34 +0800
Message-Id: <1407128074-1882-1-git-send-email-yzq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: mark yao <yzq@rock-chips.com>
---
 drivers/gpu/drm/rockchip/Kconfig                 |    1 +
 drivers/gpu/drm/rockchip/Makefile                |    2 +-
 drivers/gpu/drm/rockchip/connector/Kconfig       |    8 +
 drivers/gpu/drm/rockchip/connector/Makefile      |    4 +
 drivers/gpu/drm/rockchip/connector/rk3288_lvds.c |  332 ++++++++++++++++++++++
 drivers/gpu/drm/rockchip/connector/rk3288_lvds.h |   50 ++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c      |   13 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h      |    3 +
 8 files changed, 412 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/rockchip/connector/Kconfig
 create mode 100644 drivers/gpu/drm/rockchip/connector/Makefile
 create mode 100644 drivers/gpu/drm/rockchip/connector/rk3288_lvds.c
 create mode 100644 drivers/gpu/drm/rockchip/connector/rk3288_lvds.h

diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index ccce827..407cbb6 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -40,3 +40,4 @@ config DRM_ROCKCHIP_CONNECTOR
 	  such as lcd plane, lvds, edp , mipi, etc.
 
 source "drivers/gpu/drm/rockchip/lcdc/Kconfig"
+source "drivers/gpu/drm/rockchip/connector/Kconfig"
diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
index 6d49edc..7d5877a 100644
--- a/drivers/gpu/drm/rockchip/Makefile
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -8,6 +8,6 @@ rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_gem.o \
 		rockchip_drm_fb.o rockchip_drm_fbdev.o \
 		rockchip_panel.o
 
-obj-$(CONFIG_DRM_ROCKCHIP_CONNECTOR) += rockchip_drm_connector.o
+obj-$(CONFIG_DRM_ROCKCHIP_CONNECTOR) += rockchip_drm_connector.o connector/
 obj-$(CONFIG_DRM_ROCKCHIP_LCDC) += rockchip_drm_lcdc.o lcdc/
 obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
diff --git a/drivers/gpu/drm/rockchip/connector/Kconfig b/drivers/gpu/drm/rockchip/connector/Kconfig
new file mode 100644
index 0000000..248942f
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/Kconfig
@@ -0,0 +1,8 @@
+config RK3288_LVDS
+	bool "RK3288 lvds connector support"
+	depends on DRM_ROCKCHIP_CONNECTOR
+	help
+	  Choose this option if you have a rk3288 lvds connector.
+	  rk3288 lvds transmitter support ttl rgb, lvds and dual lvds
+	  mode, dual lvds mode is support for the plane which need dual
+	  lvds channels.
diff --git a/drivers/gpu/drm/rockchip/connector/Makefile b/drivers/gpu/drm/rockchip/connector/Makefile
new file mode 100644
index 0000000..dcfbdef
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for display connector like lvds edp mipi
+#
+obj-$(CONFIG_RK3288_LVDS)	+= rk3288_lvds.o
diff --git a/drivers/gpu/drm/rockchip/connector/rk3288_lvds.c b/drivers/gpu/drm/rockchip/connector/rk3288_lvds.c
new file mode 100644
index 0000000..3ca4c6f
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/rk3288_lvds.c
@@ -0,0 +1,332 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:
+ *      hjc <hjc@rock-chips.com>
+ *      mark yao <mark.yao@rock-chips.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+#include <video/display_timing.h>
+
+#include "../rockchip_drm_connector.h"
+#include "../rockchip_drm_lcdc.h"
+#include "rk3288_lvds.h"
+
+/*
+ * @grf_offset: offset inside the grf regmap for setting the rockchip lvds
+ */
+struct rk3288_lvds_soc_data {
+	int grf_gpio1d_iomux;
+	int grf_soc_con6;
+	int grf_soc_con7;
+};
+
+struct rk3288_lvds {
+	void *base;
+	int format;
+	struct drm_display_mode mode;
+	struct device *dev;
+	void __iomem *regs;
+	struct regmap *grf;
+	struct rk3288_lvds_soc_data *soc_data;
+	struct clk *pclk;
+	bool standby;
+};
+
+static inline void lvds_writel(struct rk3288_lvds *lvds, u32 offset, u32 val)
+{
+	writel_relaxed(val, lvds->regs + offset);
+	writel_relaxed(val, lvds->regs + offset + 0x100);
+}
+
+static inline int lvds_name_to_format(const char *s)
+{
+	if (!s)
+		return 0;
+
+	if (strncmp(s, "jeida", 6) == 0)
+		return LVDS_FORMAT_JEIDA;
+	else if (strncmp(s, "vesa", 6) == 0)
+		return LVDS_FORMAT_VESA;
+
+	return 0;
+}
+
+static void rk3288_lvds_disable(struct rockchip_connector *conn)
+{
+	struct rk3288_lvds *lvds = conn->priv;
+	int ret = 0;
+
+	if (lvds->standby)
+		return;
+
+	ret = regmap_write(lvds->grf, lvds->soc_data->grf_soc_con7, 0xffff8000);
+	if (ret != 0)
+		dev_err(lvds->dev, "Could not write to GRF: %d\n", ret);
+	/* disable tx */
+	writel_relaxed(0x00, lvds->regs + LVDS_CFG_REG_21);
+	/* disable pll */
+	writel_relaxed(0xff, lvds->regs + LVDS_CFG_REG_C);
+
+	clk_disable_unprepare(lvds->pclk);
+	lvds->standby = true;
+}
+
+static void rk3288_lvds_en(struct rockchip_connector *conn)
+{
+	struct rk3288_lvds *lvds = conn->priv;
+	struct drm_display_mode *mode = &lvds->mode;
+	u32 val = 0;
+	u32 h_bp = mode->htotal - mode->hsync_start;
+	u8 pin_hsync = (conn->flags & DISPLAY_FLAGS_HSYNC_HIGH) ? 1 : 0;
+	u8 pin_den = (conn->flags & DISPLAY_FLAGS_DE_HIGH) ? 1 : 0;
+	u8 pin_dclk = (conn->flags & DISPLAY_FLAGS_PIXDATA_POSEDGE) ? 1 : 0;
+	u8 lvds_format = lvds->format;
+	u8 type = conn->type;
+	int lcdc_id = 1;
+	int ret = 0;
+
+	if (!lvds->standby)
+		return;
+
+	/* enable clk */
+	ret = clk_prepare_enable(lvds->pclk);
+	if (ret < 0) {
+		dev_err(lvds->dev, "failed to enable lvds pclk %d\n", ret);
+		return;
+	}
+	/* lcdc1 = vop little, lcdc0 = vop big */
+	if (lcdc_id == 1)
+		val = LVDS_SEL_VOP_LIT | (LVDS_SEL_VOP_LIT << 16);
+	else
+		val = LVDS_SEL_VOP_LIT << 16;
+	ret = regmap_write(lvds->grf, lvds->soc_data->grf_soc_con6, val);
+	if (ret != 0) {
+		dev_err(lvds->dev, "Could not write to GRF: %d\n", ret);
+		return;
+	}
+
+	val = lvds_format;
+	if (type == ROCKCHIP_DISPLAY_TYPE_DUAL_LVDS)
+		val |= LVDS_DUAL | LVDS_CH0_EN | LVDS_CH1_EN;
+	else if (type == ROCKCHIP_DISPLAY_TYPE_LVDS)
+		val |= LVDS_CH0_EN;
+	else if (type == ROCKCHIP_DISPLAY_TYPE_RGB)
+		val |= LVDS_TTL_EN | LVDS_CH0_EN | LVDS_CH1_EN;
+
+	if (h_bp & 0x01)
+		val |= LVDS_START_PHASE_RST_1;
+
+	val |= (pin_dclk << 8) | (pin_hsync << 9) |
+		(pin_den << 10);
+	val |= (0xffff << 16);
+	ret = regmap_write(lvds->grf, lvds->soc_data->grf_soc_con7, val);
+	if (ret != 0) {
+		dev_err(lvds->dev, "Could not write to GRF: %d\n", ret);
+		return;
+	}
+
+	if (type == ROCKCHIP_DISPLAY_TYPE_RGB) {
+		val = 0x007f007f;
+		ret = regmap_write(lvds->grf, lvds->soc_data->grf_gpio1d_iomux,
+				   val);
+		if (ret != 0) {
+			dev_err(lvds->dev, "Could not write to GRF: %d\n", ret);
+			return;
+		}
+
+		lvds_writel(lvds, LVDS_CH0_REG_0, 0x7f);
+		lvds_writel(lvds, LVDS_CH0_REG_1, 0x40);
+		lvds_writel(lvds, LVDS_CH0_REG_2, 0x00);
+
+		lvds_writel(lvds, LVDS_CH0_REG_4, 0x3f);
+		lvds_writel(lvds, LVDS_CH0_REG_5, 0x3f);
+		lvds_writel(lvds, LVDS_CH0_REG_3, 0x46);
+		lvds_writel(lvds, LVDS_CH0_REG_D, 0x0a);
+		lvds_writel(lvds, LVDS_CH0_REG_20, 0x44);
+		writel_relaxed(0x00, lvds->regs + LVDS_CFG_REG_C);
+		writel_relaxed(0x92, lvds->regs + LVDS_CFG_REG_21);
+
+		lvds_writel(lvds, 0x100, 0x7f);
+		lvds_writel(lvds, 0x104, 0x40);
+		lvds_writel(lvds, 0x108, 0x00);
+		lvds_writel(lvds, 0x10c, 0x46);
+		lvds_writel(lvds, 0x110, 0x3f);
+		lvds_writel(lvds, 0x114, 0x3f);
+		lvds_writel(lvds, 0x134, 0x0a);
+	} else {
+		lvds_writel(lvds, LVDS_CH0_REG_0, 0xbf);
+		lvds_writel(lvds, LVDS_CH0_REG_1, 0x3f);
+		lvds_writel(lvds, LVDS_CH0_REG_2, 0xfe);
+		lvds_writel(lvds, LVDS_CH0_REG_3, 0x46);
+		lvds_writel(lvds, LVDS_CH0_REG_4, 0x00);
+		lvds_writel(lvds, LVDS_CH0_REG_D, 0x0a);
+		lvds_writel(lvds, LVDS_CH0_REG_20, 0x44);
+		writel_relaxed(0x00, lvds->regs + LVDS_CFG_REG_C);
+		writel_relaxed(0x92, lvds->regs + LVDS_CFG_REG_21);
+	}
+
+	lvds->standby = false;
+}
+
+static int rk3288_lvds_setmode(struct rockchip_connector *conn,
+			       struct drm_display_mode *mode)
+{
+	struct rk3288_lvds *lvds = conn->priv;
+
+	memcpy(&lvds->mode, mode, sizeof(*mode));
+
+	return 0;
+}
+
+static struct rockchip_connector lvds_conn = {
+	.enable = rk3288_lvds_en,
+	.disable = rk3288_lvds_disable,
+	.setmode = rk3288_lvds_setmode,
+};
+
+static struct rk3288_lvds_soc_data soc_data[2] = {
+	{.grf_gpio1d_iomux = 0x000c,
+	 .grf_soc_con6 = 0x025c,
+	 .grf_soc_con7 = 0x0260},
+	{.grf_gpio1d_iomux = -1,
+	 .grf_soc_con6 = -1,
+	/* no lvds switching needed */
+	 .grf_soc_con7 = -1},
+};
+
+static const struct of_device_id rk3288_lvds_dt_ids[] = {
+	{.compatible = "rockchip,rk3288-lvds",
+	 .data = (void *)&soc_data[0] },
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, rockchip_lvds_dt_ids);
+
+static int rk3288_lvds_probe(struct platform_device *pdev)
+{
+	struct rk3288_lvds *lvds;
+	struct resource *res;
+	struct device_node *np = pdev->dev.of_node;
+	const char *name;
+	const struct of_device_id *match;
+	u32 i;
+
+	if (!np) {
+		dev_err(&pdev->dev, "Missing device tree node.\n");
+		return -EINVAL;
+	}
+
+	lvds = devm_kzalloc(&pdev->dev, sizeof(struct rk3288_lvds), GFP_KERNEL);
+	if (!lvds) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	match = of_match_node(rk3288_lvds_dt_ids, np);
+	lvds->soc_data = (struct rk3288_lvds_soc_data *)match->data;
+	/*
+	 * The control bit is located in the GRF register space.
+	 */
+	if (lvds->soc_data->grf_gpio1d_iomux >= 0) {
+		lvds->grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
+		if (IS_ERR(lvds->grf)) {
+			dev_err(&pdev->dev,
+				"rockchip-lvds needs rockchip,grf property\n");
+			return PTR_ERR(lvds->grf);
+		}
+	}
+
+	if (of_property_read_string(np, "rockchip,data-mapping", &name))
+		/* default set it as format jeida */
+		lvds->format = LVDS_FORMAT_JEIDA;
+	else
+		lvds->format = lvds_name_to_format(name);
+
+	if (of_property_read_u32(np, "rockchip,data-width", &i)) {
+		lvds->format |= LVDS_24BIT;
+	} else {
+		if (i == 24) {
+			lvds->format |= LVDS_24BIT;
+		} else if (i == 18) {
+			lvds->format |= LVDS_18BIT;
+		} else {
+			dev_err(&pdev->dev,
+				"rockchip-lvds unsupport data-width[%d]\n", i);
+			return -EINVAL;
+		}
+	}
+
+	lvds->dev = &pdev->dev;
+
+	lvds_conn.priv = lvds;
+	lvds_conn.dev = &pdev->dev;
+	lvds_conn.type = ROCKCHIP_DISPLAY_TYPE_LVDS;
+	lvds->base = rockchip_connector_register(&lvds_conn);
+	if (!lvds->base)
+		return -EINVAL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	lvds->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(lvds->regs)) {
+		dev_err(&pdev->dev, "ioremap reg failed\n");
+		return PTR_ERR(lvds->regs);
+	}
+
+	lvds->pclk = devm_clk_get(&pdev->dev, "pclk_lvds");
+	if (IS_ERR(lvds->pclk)) {
+		dev_err(&pdev->dev, "get clk failed\n");
+		return PTR_ERR(lvds->pclk);
+	}
+
+	lvds->standby = true;
+
+	platform_set_drvdata(pdev, lvds);
+	dev_set_name(lvds->dev, "rk3288-lvds");
+
+	dev_info(&pdev->dev, "rk3288 lvds driver probe success\n");
+
+	return 0;
+}
+
+static int rk3288_lvds_remove(struct platform_device *pdev)
+{
+	struct rk3288_lvds *lvds = lvds_conn.priv;
+
+	rk3288_lvds_disable(&lvds_conn);
+	rockchip_connector_unregister(lvds->base);
+
+	return 0;
+}
+
+struct platform_driver rk3288_lvds_driver = {
+	.probe = rk3288_lvds_probe,
+	.remove = rk3288_lvds_remove,
+	.driver = {
+		   .name = "rk3288-lvds",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(rk3288_lvds_dt_ids),
+	},
+};
diff --git a/drivers/gpu/drm/rockchip/connector/rk3288_lvds.h b/drivers/gpu/drm/rockchip/connector/rk3288_lvds.h
new file mode 100644
index 0000000..61c71cc
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/rk3288_lvds.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:
+ *      hjc <hjc@rock-chips.com>
+ *      mark yao <mark.yao@rock-chips.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _RK3288_LVDS_
+#define _RK3288_LVDS_
+
+#define LVDS_CH0_REG_0			0x00
+#define LVDS_CH0_REG_1			0x04
+#define LVDS_CH0_REG_2			0x08
+#define LVDS_CH0_REG_3			0x0c
+#define LVDS_CH0_REG_4			0x10
+#define LVDS_CH0_REG_5			0x14
+#define LVDS_CH0_REG_9			0x24
+#define LVDS_CFG_REG_C			0x30
+#define LVDS_CH0_REG_D			0x34
+#define LVDS_CH0_REG_F			0x3c
+#define LVDS_CH0_REG_20			0x80
+#define LVDS_CFG_REG_21			0x84
+
+#define LVDS_SEL_VOP_LIT		(1 << 3)
+
+#define LVDS_FMT_MASK			(0x07 << 16)
+#define LVDS_MSB			(0x01 << 3)
+#define LVDS_DUAL			(0x01 << 4)
+#define LVDS_FMT_1			(0x01 << 5)
+#define LVDS_TTL_EN			(0x01 << 6)
+#define LVDS_START_PHASE_RST_1		(0x01 << 7)
+#define LVDS_DCLK_INV			(0x01 << 8)
+#define LVDS_CH0_EN			(0x01 << 11)
+#define LVDS_CH1_EN			(0x01 << 12)
+#define LVDS_PWRDN			(0x01 << 15)
+
+#define LVDS_24BIT		(0 << 1)
+#define LVDS_18BIT		(1 << 1)
+#define LVDS_FORMAT_VESA	(0 << 0)
+#define LVDS_FORMAT_JEIDA	(1 << 0)
+#endif /* _RK3288_LVDS_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
index 4871867..59187aa 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
@@ -558,6 +558,12 @@ static int rockchip_drm_init(void)
 		goto out_lcdc;
 #endif
 
+#ifdef CONFIG_RK3288_LVDS
+	ret = platform_driver_register(&rk3288_lvds_driver);
+	if (ret)
+		goto out_lvds;
+#endif
+
 	rockchip_drm_pdev = platform_device_register_simple("rockchip-drm", -1,
 							    NULL, 0);
 	if (IS_ERR(rockchip_drm_pdev)) {
@@ -574,6 +580,10 @@ static int rockchip_drm_init(void)
 out_drm_driver:
 	platform_device_unregister(rockchip_drm_pdev);
 out_drm_pdev:
+#ifdef CONFIG_RK3288_LVDS
+	platform_driver_unregister(&rk3288_lvds_driver);
+out_lvds:
+#endif
 #ifdef CONFIG_DRM_ROCKCHIP_LCDC
 	platform_driver_unregister(&rockchip_lcdc_platform_driver);
 out_lcdc:
@@ -586,6 +596,9 @@ static void rockchip_drm_exit(void)
 {
 	platform_device_unregister(rockchip_drm_pdev);
 	platform_driver_unregister(&rockchip_drm_platform_driver);
+#ifdef CONFIG_RK3288_LVDS
+	platform_driver_unregister(&rk3288_lvds_driver);
+#endif
 #ifdef CONFIG_DRM_ROCKCHIP_LCDC
 	platform_driver_unregister(&rockchip_lcdc_platform_driver);
 #endif
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
index c0c1d89..d28f4dc 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
@@ -125,4 +125,7 @@ extern struct platform_driver rockchip_panel_platform_driver;
 #ifdef CONFIG_DRM_ROCKCHIP_LCDC
 extern struct platform_driver rockchip_lcdc_platform_driver;
 #endif
+#ifdef CONFIG_RK3288_LVDS
+extern struct platform_driver rk3288_lvds_driver;
+#endif
 #endif /* _ROCKCHIP_DRM_DRV_H_ */
-- 
1.7.9.5


