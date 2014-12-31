Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaLaIUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:20:33 -0500
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:37568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986AbaLaIU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:20:27 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v8 16/21] drm: panel: Add support for Himax HX8369A MIPI DSI panel
Date: Wed, 31 Dec 2014 16:23:34 +0800
Message-ID: <1420014219-915-17-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
References: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(104016003)(84676001)(50466002)(76176999)(92566001)(21056001)(64706001)(31966008)(87936001)(47776003)(6806004)(50226001)(46102003)(48376002)(85426001)(20776003)(107046002)(99396003)(2351001)(106466001)(81156004)(62966003)(97736003)(120916001)(68736005)(69596002)(110136001)(77156002)(36756003)(50986999)(4396001)(19580395003)(19580405001)(77096005)(2950100001)(89996001)(86362001)(575784001)(229853001)(2004002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 0442E569BC
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 08:20:24.6575
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0625
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Himax HX8369A MIPI DSI panel.

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v7->v8:
 * Remove several unnecessary headers included in the driver.

v6->v7:
 * Address Andrzej Hajda's following comments.
 * Simplify the return logic in hx8369a_dcs_write().
 * Replace the macro hx8369a_dsi_init_helper() with a function array to improve
   the code quality.
 * Handle error cases during getting gpios in probe().
 * Add 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'.

v5->v6:
 * Make the checkpatch.pl script be happier.
 * Do not set the dsi channel number to be zero in probe(), because the MIPI DSI
   bus driver would set it.

v4->v5:
 * Address Andrzej Hajda's comments.
 * Get the bs-gpios property instead of the bs[3:0]-gpios properties.
 * Implement error propagation for panel register configurations.
 * Other minor changes to improve the code quality.

v3->v4:
 * Move the relevant dt-bindings to a separate patch to address Stefan
   Wahren's comment.

v2->v3:
 * Sort the included header files alphabetically.

v1->v2:
 * Address almost all comments from Thierry Reding.
 * Remove several DT properties as they can be implied by the compatible string.
 * Add the HIMAX/himax prefixes to the driver's Kconfig name and driver name.
 * Move the driver's Makefile entry place to sort the entries alphabetically.
 * Reuse several standard DCS functions instead of inventing wheels.
 * Move the panel resetting and power logics to the driver probe/remove stages.
   This may simplify panel prepare/unprepare hooks. The power consumption should
   not change a lot at DPMS since the panel enters sleep mode at that time.
 * Add the module author.
 * Other minor changes, such as coding style issues.

 drivers/gpu/drm/panel/Kconfig               |   5 +
 drivers/gpu/drm/panel/Makefile              |   1 +
 drivers/gpu/drm/panel/panel-himax-hx8369a.c | 610 ++++++++++++++++++++++++++++
 3 files changed, 616 insertions(+)
 create mode 100644 drivers/gpu/drm/panel/panel-himax-hx8369a.c

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 024e98e..81b0bf0 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -16,6 +16,11 @@ config DRM_PANEL_SIMPLE
 	  that it can be automatically turned off when the panel goes into a
 	  low power state.
 
+config DRM_PANEL_HIMAX_HX8369A
+	tristate "Himax HX8369A panel"
+	depends on OF
+	select DRM_MIPI_DSI
+
 config DRM_PANEL_LD9040
 	tristate "LD9040 RGB/SPI panel"
 	depends on OF && SPI
diff --git a/drivers/gpu/drm/panel/Makefile b/drivers/gpu/drm/panel/Makefile
index 4b2a043..d5dbe06 100644
--- a/drivers/gpu/drm/panel/Makefile
+++ b/drivers/gpu/drm/panel/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_DRM_PANEL_SIMPLE) += panel-simple.o
+obj-$(CONFIG_DRM_PANEL_HIMAX_HX8369A) += panel-himax-hx8369a.o
 obj-$(CONFIG_DRM_PANEL_LD9040) += panel-ld9040.o
 obj-$(CONFIG_DRM_PANEL_S6E8AA0) += panel-s6e8aa0.o
 obj-$(CONFIG_DRM_PANEL_SHARP_LQ101R1SX01) += panel-sharp-lq101r1sx01.o
diff --git a/drivers/gpu/drm/panel/panel-himax-hx8369a.c b/drivers/gpu/drm/panel/panel-himax-hx8369a.c
new file mode 100644
index 0000000..34b9a40
--- /dev/null
+++ b/drivers/gpu/drm/panel/panel-himax-hx8369a.c
@@ -0,0 +1,610 @@
+/*
+ * Himax HX8369A panel driver.
+ *
+ * Copyright (C) 2011-2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver is based on Samsung s6e8aa0 panel driver.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_mipi_dsi.h>
+#include <drm/drm_panel.h>
+
+#include <linux/gpio/consumer.h>
+#include <linux/of_device.h>
+#include <linux/regulator/consumer.h>
+
+#define WRDISBV		0x51
+#define WRCTRLD		0x53
+#define WRCABC		0x55
+#define SETPOWER	0xb1
+#define SETDISP		0xb2
+#define SETCYC		0xb4
+#define SETVCOM		0xb6
+#define SETEXTC		0xb9
+#define SETMIPI		0xba
+#define SETPANEL	0xcc
+#define SETGIP		0xd5
+#define SETGAMMA	0xe0
+
+#define HX8369A_MIN_BRIGHTNESS	0x00
+#define HX8369A_MAX_BRIGHTNESS	0xff
+
+enum hx8369a_mpu_interface {
+	HX8369A_DBI_TYPE_A_8BIT,
+	HX8369A_DBI_TYPE_A_9BIT,
+	HX8369A_DBI_TYPE_A_16BIT,
+	HX8369A_DBI_TYPE_A_18BIT,
+	HX8369A_DBI_TYPE_B_8BIT,
+	HX8369A_DBI_TYPE_B_9BIT,
+	HX8369A_DBI_TYPE_B_16BIT,
+	HX8369A_DBI_TYPE_B_18BIT,
+	HX8369A_DSI_CMD_MODE,
+	HX8369A_DBI_TYPE_B_24BIT,
+	HX8369A_DSI_VIDEO_MODE,
+	HX8369A_MDDI,
+	HX8369A_DPI_DBI_TYPE_C_OPT1,
+	HX8369A_DPI_DBI_TYPE_C_OPT2,
+	HX8369A_DPI_DBI_TYPE_C_OPT3
+};
+
+enum hx8369a_resolution {
+	HX8369A_RES_480_864,
+	HX8369A_RES_480_854,
+	HX8369A_RES_480_800,
+	HX8369A_RES_480_640,
+	HX8369A_RES_360_640,
+	HX8369A_RES_480_720,
+};
+
+struct hx8369a_panel_desc {
+	const struct drm_display_mode *mode;
+
+	/* ms */
+	unsigned int power_on_delay;
+	unsigned int reset_delay;
+
+	unsigned int dsi_lanes;
+};
+
+struct hx8369a {
+	struct device *dev;
+	struct drm_panel panel;
+
+	const struct hx8369a_panel_desc *pd;
+
+	struct regulator_bulk_data supplies[5];
+	struct gpio_desc *reset_gpio;
+	struct gpio_desc *bs_gpio[4];
+	u8 res_sel;
+};
+
+static inline struct hx8369a *panel_to_hx8369a(struct drm_panel *panel)
+{
+	return container_of(panel, struct hx8369a, panel);
+}
+
+static int hx8369a_dcs_write(struct hx8369a *ctx, const char *func,
+			     const void *data, size_t len)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	ssize_t ret;
+
+	ret = mipi_dsi_dcs_write_buffer(dsi, data, len);
+	if (ret < 0)
+		dev_err(ctx->dev, "%s failed: %d\n", func, ret);
+	return ret;
+}
+
+#define hx8369a_dcs_write_seq(ctx, seq...) \
+({ \
+	const u8 d[] = { seq }; \
+	BUILD_BUG_ON_MSG(ARRAY_SIZE(d) > 64, \
+			 "DCS sequence too big for stack"); \
+	hx8369a_dcs_write(ctx, __func__, d, ARRAY_SIZE(d)); \
+})
+
+#define hx8369a_dcs_write_seq_static(ctx, seq...) \
+({ \
+	static const u8 d[] = { seq }; \
+	hx8369a_dcs_write(ctx, __func__, d, ARRAY_SIZE(d)); \
+})
+
+static int hx8369a_dsi_set_display_related_register(struct hx8369a *ctx)
+{
+	u8 sec_p = (ctx->res_sel << 4) | 0x03;
+
+	return hx8369a_dcs_write_seq(ctx, SETDISP, 0x00, sec_p, 0x03,
+			   0x03, 0x70, 0x00, 0xff, 0x00, 0x00, 0x00,
+			   0x00, 0x03, 0x03, 0x00, 0x01);
+}
+
+static int hx8369a_dsi_set_display_waveform_cycle(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, SETCYC, 0x00, 0x1d,
+					0x5f, 0x0e, 0x06);
+}
+
+static int hx8369a_dsi_set_gip(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, SETGIP, 0x00, 0x04,
+				 0x03, 0x00, 0x01, 0x05, 0x1c, 0x70,
+				 0x01, 0x03, 0x00, 0x00, 0x40, 0x06,
+				 0x51, 0x07, 0x00, 0x00, 0x41, 0x06,
+				 0x50, 0x07, 0x07, 0x0f, 0x04);
+}
+
+static int hx8369a_dsi_set_power(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, SETPOWER, 0x01, 0x00,
+				   0x34, 0x06, 0x00, 0x0f, 0x0f, 0x2a,
+				   0x32, 0x3f, 0x3f, 0x07, 0x3a, 0x01,
+				   0xe6, 0xe6, 0xe6, 0xe6, 0xe6);
+}
+
+static int hx8369a_dsi_set_vcom_voltage(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, SETVCOM, 0x56, 0x56);
+}
+
+static int hx8369a_dsi_set_panel(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, SETPANEL, 0x02);
+}
+
+static int hx8369a_dsi_set_gamma_curve(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, SETGAMMA, 0x00, 0x1d,
+				   0x22, 0x38, 0x3d, 0x3f, 0x2e, 0x4a,
+				   0x06, 0x0d, 0x0f, 0x13, 0x15, 0x13,
+				   0x16, 0x10, 0x19, 0x00, 0x1d, 0x22,
+				   0x38, 0x3d, 0x3f, 0x2e, 0x4a, 0x06,
+				   0x0d, 0x0f, 0x13, 0x15, 0x13, 0x16,
+				   0x10, 0x19);
+}
+
+static int hx8369a_dsi_set_mipi(struct hx8369a *ctx)
+{
+	u8 eleventh_p = ctx->pd->dsi_lanes == 2 ? 0x11 : 0x10;
+
+	return hx8369a_dcs_write_seq(ctx, SETMIPI, 0x00, 0xa0, 0xc6,
+				 0x00, 0x0a, 0x00, 0x10, 0x30, 0x6f,
+				 0x02, eleventh_p, 0x18, 0x40);
+}
+
+static int hx8369a_dsi_set_interface_pixel_fomat(struct hx8369a *ctx)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	u8 format;
+	int ret;
+
+	switch (dsi->format) {
+	case MIPI_DSI_FMT_RGB888:
+	case MIPI_DSI_FMT_RGB666:
+		format = 0x77;
+		break;
+	case MIPI_DSI_FMT_RGB565:
+		format = 0x55;
+		break;
+	case MIPI_DSI_FMT_RGB666_PACKED:
+		format = 0x66;
+		break;
+	default:
+		dev_err(ctx->dev, "unsupported DSI pixel format\n");
+		return -EINVAL;
+	}
+
+	ret = mipi_dsi_dcs_set_pixel_format(dsi, format);
+	if (ret < 0)
+		dev_err(ctx->dev, "%s failed: %d\n", __func__, ret);
+	return ret;
+}
+
+static int hx8369a_dsi_set_column_address(struct hx8369a *ctx)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	const struct drm_display_mode *mode = ctx->pd->mode;
+	int ret;
+
+	ret = mipi_dsi_dcs_set_column_address(dsi, 0, mode->hdisplay - 1);
+	if (ret < 0)
+		dev_err(ctx->dev, "%s failed: %d\n", __func__, ret);
+	return ret;
+}
+
+static int hx8369a_dsi_set_page_address(struct hx8369a *ctx)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	const struct drm_display_mode *mode = ctx->pd->mode;
+	int ret;
+
+	ret = mipi_dsi_dcs_set_page_address(dsi, 0, mode->vdisplay - 1);
+	if (ret < 0)
+		dev_err(ctx->dev, "%s failed: %d\n", __func__, ret);
+	return ret;
+}
+
+static int hx8369a_dsi_write_display_brightness(struct hx8369a *ctx,
+						u8 brightness)
+{
+	return hx8369a_dcs_write_seq(ctx, WRDISBV, brightness);
+}
+
+static int hx8369a_dsi_write_cabc(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, WRCABC, 0x01);
+}
+
+static int hx8369a_dsi_write_control_display(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, WRCTRLD, 0x24);
+}
+
+static int hx8369a_dsi_panel_init(struct hx8369a *ctx)
+{
+	int (*funcs[])(struct hx8369a *ctx) = {
+		hx8369a_dsi_set_display_related_register,
+		hx8369a_dsi_set_display_waveform_cycle,
+		hx8369a_dsi_set_gip,
+		hx8369a_dsi_set_power,
+		hx8369a_dsi_set_vcom_voltage,
+		hx8369a_dsi_set_panel,
+		hx8369a_dsi_set_gamma_curve,
+		hx8369a_dsi_set_mipi,
+		hx8369a_dsi_set_interface_pixel_fomat,
+		hx8369a_dsi_set_column_address,
+		hx8369a_dsi_set_page_address,
+		hx8369a_dsi_write_cabc,
+		hx8369a_dsi_write_control_display,
+	};
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
+		ret = funcs[i](ctx);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int hx8369a_dsi_set_extension_command(struct hx8369a *ctx)
+{
+	return hx8369a_dcs_write_seq_static(ctx, SETEXTC, 0xff, 0x83, 0x69);
+}
+
+static int hx8369a_dsi_set_maximum_return_packet_size(struct hx8369a *ctx,
+						      u16 size)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	int ret;
+
+	ret = mipi_dsi_set_maximum_return_packet_size(dsi, size);
+	if (ret < 0)
+		dev_err(ctx->dev,
+			"error %d setting maximum return packet size to %d\n",
+			ret, size);
+	return ret;
+}
+
+static int hx8369a_dsi_set_sequence(struct hx8369a *ctx)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	int ret;
+
+	ret = hx8369a_dsi_set_extension_command(ctx);
+	if (ret < 0)
+		goto out;
+
+	ret = hx8369a_dsi_set_maximum_return_packet_size(ctx, 4);
+	if (ret < 0)
+		goto out;
+
+	ret = hx8369a_dsi_panel_init(ctx);
+	if (ret < 0)
+		goto out;
+
+	ret = mipi_dsi_dcs_exit_sleep_mode(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to exit sleep mode: %d\n", ret);
+		goto out;
+	}
+
+	ret = mipi_dsi_dcs_set_display_on(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to set display on: %d\n", ret);
+		goto out;
+	}
+
+	/*
+	 * It's necessary to wait 120msec after sending the Sleep Out
+	 * command before Sleep In command can be sent, according to
+	 * the HX8369A data sheet.
+	 */
+	msleep(120);
+out:
+	return ret;
+}
+
+static int hx8369a_dsi_disable(struct drm_panel *panel)
+{
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+
+	return hx8369a_dsi_write_display_brightness(ctx,
+						HX8369A_MIN_BRIGHTNESS);
+}
+
+static int hx8369a_dsi_unprepare(struct drm_panel *panel)
+{
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	int ret;
+
+	ret = mipi_dsi_dcs_enter_sleep_mode(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to enter sleep mode: %d\n", ret);
+		goto out;
+	}
+
+	ret = mipi_dsi_dcs_set_display_off(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to set display off: %d\n", ret);
+		goto out;
+	}
+
+	/*
+	 * This is to allow time for the supply voltages and clock
+	 * circuits to stablize, according to the HX8369A data sheet.
+	 */
+	msleep(5);
+out:
+	return ret;
+}
+
+static int hx8369a_dsi_prepare(struct drm_panel *panel)
+{
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+
+	return hx8369a_dsi_set_sequence(ctx);
+}
+
+static int hx8369a_dsi_enable(struct drm_panel *panel)
+{
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+
+	return hx8369a_dsi_write_display_brightness(ctx,
+						HX8369A_MAX_BRIGHTNESS);
+}
+
+static int hx8369a_get_modes(struct drm_panel *panel)
+{
+	struct drm_connector *connector = panel->connector;
+	struct drm_device *drm = panel->drm;
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+	struct drm_display_mode *mode;
+	const struct drm_display_mode *m = ctx->pd->mode;
+
+	mode = drm_mode_duplicate(drm, m);
+	if (!mode) {
+		dev_err(drm->dev, "failed to add mode %ux%u@%u\n",
+			m->hdisplay, m->vdisplay, m->vrefresh);
+		return 0;
+	}
+
+	drm_mode_set_name(mode);
+	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+
+	connector->display_info.bpc = 8;
+	connector->display_info.width_mm = mode->width_mm;
+	connector->display_info.height_mm = mode->height_mm;
+
+	drm_mode_probed_add(connector, mode);
+
+	return 1;
+}
+
+static const struct drm_panel_funcs hx8369a_dsi_drm_funcs = {
+	.disable = hx8369a_dsi_disable,
+	.unprepare = hx8369a_dsi_unprepare,
+	.prepare = hx8369a_dsi_prepare,
+	.enable = hx8369a_dsi_enable,
+	.get_modes = hx8369a_get_modes,
+};
+
+static int hx8369a_power_on(struct hx8369a *ctx)
+{
+	int ret;
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(ctx->supplies), ctx->supplies);
+	if (ret < 0)
+		return ret;
+
+	msleep(ctx->pd->power_on_delay);
+
+	gpiod_set_value(ctx->reset_gpio, 1);
+	usleep_range(50, 60);
+	gpiod_set_value(ctx->reset_gpio, 0);
+
+	msleep(ctx->pd->reset_delay);
+
+	return 0;
+}
+
+static int hx8369a_power_off(struct hx8369a *ctx)
+{
+	return regulator_bulk_disable(ARRAY_SIZE(ctx->supplies), ctx->supplies);
+}
+
+static void hx8369a_vm_to_res_sel(struct hx8369a *ctx)
+{
+	const struct drm_display_mode *mode = ctx->pd->mode;
+
+	switch (mode->hdisplay) {
+	case 480:
+		switch (mode->vdisplay) {
+		case 864:
+			ctx->res_sel = HX8369A_RES_480_864;
+			break;
+		case 854:
+			ctx->res_sel = HX8369A_RES_480_854;
+			break;
+		case 800:
+			ctx->res_sel = HX8369A_RES_480_800;
+			break;
+		case 640:
+			ctx->res_sel = HX8369A_RES_480_640;
+			break;
+		case 720:
+			ctx->res_sel = HX8369A_RES_480_720;
+			break;
+		default:
+			break;
+		}
+		break;
+	case 360:
+		if (mode->vdisplay == 640)
+			ctx->res_sel = HX8369A_RES_360_640;
+		break;
+	default:
+		break;
+	}
+}
+
+static const struct drm_display_mode truly_tft480800_16_e_mode = {
+	.clock = 26400,
+	.hdisplay = 480,
+	.hsync_start = 480 + 8,
+	.hsync_end = 480 + 8 + 8,
+	.htotal = 480 + 8 + 8 + 8,
+	.vdisplay = 800,
+	.vsync_start = 800 + 6,
+	.vsync_end = 800 + 6 + 6,
+	.vtotal = 800 + 6 + 6 + 6,
+	.vrefresh = 60,
+	.width_mm = 45,
+	.height_mm = 76,
+};
+
+static const struct hx8369a_panel_desc truly_tft480800_16_e_dsi = {
+	.mode = &truly_tft480800_16_e_mode,
+	.power_on_delay = 10,
+	.reset_delay = 10,
+	.dsi_lanes = 2,
+};
+
+static const struct of_device_id hx8369a_dsi_of_match[] = {
+	{
+		.compatible = "truly,tft480800-16-e-dsi",
+		.data = &truly_tft480800_16_e_dsi,
+	}, {
+		/* sentinel */
+	},
+};
+MODULE_DEVICE_TABLE(of, hx8369a_dsi_of_match);
+
+static int hx8369a_dsi_probe(struct mipi_dsi_device *dsi)
+{
+	struct device *dev = &dsi->dev;
+	const struct of_device_id *of_id =
+			of_match_device(hx8369a_dsi_of_match, dev);
+	struct hx8369a *ctx;
+	int ret, i;
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->dev = dev;
+
+	if (of_id) {
+		ctx->pd = of_id->data;
+	} else {
+		dev_err(dev, "cannot find compatible device\n");
+		return -ENODEV;
+	}
+
+	hx8369a_vm_to_res_sel(ctx);
+
+	ctx->supplies[0].supply = "vdd1";
+	ctx->supplies[1].supply = "vdd2";
+	ctx->supplies[2].supply = "vdd3";
+	ctx->supplies[3].supply = "dsi-vcc";
+	ctx->supplies[4].supply = "vpp";
+	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ctx->supplies),
+				      ctx->supplies);
+	if (ret < 0) {
+		dev_info(dev, "failed to get regulators: %d\n", ret);
+		return ret;
+	}
+
+	ctx->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(ctx->reset_gpio)) {
+		dev_info(dev, "cannot get reset-gpios %ld\n",
+			 PTR_ERR(ctx->reset_gpio));
+		return PTR_ERR(ctx->reset_gpio);
+	}
+
+	for (i = 0; i < 4; i++) {
+		ctx->bs_gpio[i] = devm_gpiod_get_index_optional(dev, "bs", i,
+								GPIOD_OUT_HIGH);
+		if (!IS_ERR_OR_NULL(ctx->bs_gpio[i])) {
+			dev_dbg(dev, "bs%d-gpio is configured\n", i);
+		} else if (IS_ERR(ctx->bs_gpio[i])) {
+			dev_info(dev, "failed to get bs%d-gpio\n", i);
+			return PTR_ERR(ctx->bs_gpio[i]);
+		}
+	}
+
+	ret = hx8369a_power_on(ctx);
+	if (ret < 0) {
+		dev_err(dev, "cannot power on\n");
+		return ret;
+	}
+
+	drm_panel_init(&ctx->panel);
+	ctx->panel.dev = dev;
+	ctx->panel.funcs = &hx8369a_dsi_drm_funcs;
+
+	ret = drm_panel_add(&ctx->panel);
+	if (ret < 0)
+		return ret;
+
+	mipi_dsi_set_drvdata(dsi, ctx);
+
+	dsi->lanes = ctx->pd->dsi_lanes;
+	dsi->format = MIPI_DSI_FMT_RGB888;
+	dsi->mode_flags = MIPI_DSI_MODE_VIDEO |
+			  MIPI_DSI_MODE_VIDEO_BURST |
+			  MIPI_DSI_MODE_VIDEO_SYNC_PULSE;
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0)
+		drm_panel_remove(&ctx->panel);
+
+	return ret;
+}
+
+static int hx8369a_dsi_remove(struct mipi_dsi_device *dsi)
+{
+	struct hx8369a *ctx = mipi_dsi_get_drvdata(dsi);
+
+	mipi_dsi_detach(dsi);
+	drm_panel_remove(&ctx->panel);
+	return hx8369a_power_off(ctx);
+}
+
+static struct mipi_dsi_driver hx8369a_dsi_driver = {
+	.probe = hx8369a_dsi_probe,
+	.remove = hx8369a_dsi_remove,
+	.driver = {
+		.name = "panel-hx8369a-dsi",
+		.of_match_table = hx8369a_dsi_of_match,
+	},
+};
+module_mipi_dsi_driver(hx8369a_dsi_driver);
+
+MODULE_DESCRIPTION("Himax HX8369A panel driver");
+MODULE_AUTHOR("Liu Ying <Ying.Liu@freescale.com>");
+MODULE_LICENSE("GPL v2");
-- 
2.1.0

