Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaLaIXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:23:38 -0500
Received: from mail-bn1on0148.outbound.protection.outlook.com ([157.56.110.148]:3904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751487AbaLaIUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:20:12 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v8 12/21] drm/bridge: Add Synopsys DesignWare MIPI DSI host controller driver
Date: Wed, 31 Dec 2014 16:23:30 +0800
Message-ID: <1420014219-915-13-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
References: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(479174004)(189002)(199003)(104016003)(84676001)(50466002)(76176999)(92566001)(21056001)(64706001)(31966008)(87936001)(47776003)(6806004)(50226001)(46102003)(48376002)(85426001)(20776003)(107046002)(99396003)(2351001)(106466001)(81156004)(62966003)(97736003)(120916001)(68736005)(69596002)(110136001)(77156002)(36756003)(50986999)(4396001)(19580395003)(19580405001)(77096005)(2950100001)(89996001)(86362001)(575784001)(229853001)(2004002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 0442E569BC
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 08:20:09.3572
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0625
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Synopsys DesignWare MIPI DSI host controller driver support.
Currently, the driver supports the burst with sync pulses mode only.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v7->v8:
 * Fix the driver's Kconfig so that we may pass the allmodconfig for ARM.

v6->v7:
 * None.

v5->v6:
 * Make the checkpatch.pl script be happier.

v4->v5:
 * Remove 'dsi->panel = NULL;' in dw_mipi_dsi_host_detach() to address
   Andrzej Hajda's comment.

v3->v4:
 * Move the relevant dt-bindings to a separate patch to address Stefan
   Wahren's comment.

v2->v3:
 * Newly introduced in v3 to address Andy Yan's comment.  This is based on
   the i.MX MIPI DSI driver in v2.  To make the Synopsys DesignWare MIPI DSI
   host controller driver less platform-dependant, this patch places it at
   the drm/bridge directory as a DRM bridge driver.

 drivers/gpu/drm/bridge/Kconfig       |  10 +
 drivers/gpu/drm/bridge/Makefile      |   1 +
 drivers/gpu/drm/bridge/dw_mipi_dsi.c | 996 +++++++++++++++++++++++++++++++++++
 include/drm/bridge/dw_mipi_dsi.h     |  27 +
 4 files changed, 1034 insertions(+)
 create mode 100644 drivers/gpu/drm/bridge/dw_mipi_dsi.c
 create mode 100644 include/drm/bridge/dw_mipi_dsi.h

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 884923f..318b325 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -1,3 +1,13 @@
+config DRM_DW_MIPI_DSI
+	tristate "Synopsys DesignWare MIPI DSI host controller bridge"
+	depends on DRM
+	select DRM_KMS_HELPER
+	select DRM_MIPI_DSI
+	select DRM_PANEL
+	help
+	  Choose this if you want to use the Synopsys DesignWare MIPI DSI host
+	  controller bridge.
+
 config DRM_PTN3460
 	tristate "PTN3460 DP/LVDS bridge"
 	depends on DRM
diff --git a/drivers/gpu/drm/bridge/Makefile b/drivers/gpu/drm/bridge/Makefile
index b4733e1..b326ad5 100644
--- a/drivers/gpu/drm/bridge/Makefile
+++ b/drivers/gpu/drm/bridge/Makefile
@@ -1,3 +1,4 @@
 ccflags-y := -Iinclude/drm
 
+obj-$(CONFIG_DRM_DW_MIPI_DSI) += dw_mipi_dsi.o
 obj-$(CONFIG_DRM_PTN3460) += ptn3460.o
diff --git a/drivers/gpu/drm/bridge/dw_mipi_dsi.c b/drivers/gpu/drm/bridge/dw_mipi_dsi.c
new file mode 100644
index 0000000..2b54d44
--- /dev/null
+++ b/drivers/gpu/drm/bridge/dw_mipi_dsi.c
@@ -0,0 +1,996 @@
+/*
+ * Synopsys DesignWare(DW) MIPI DSI Host Controller
+ *
+ * Copyright (C) 2011-2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/math64.h>
+#include <linux/module.h>
+#include <drm/bridge/dw_mipi_dsi.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_mipi_dsi.h>
+#include <drm/drm_panel.h>
+#include <video/mipi_display.h>
+
+#define DSI_VERSION			0x00
+
+#define DSI_PWR_UP			0x04
+#define RESET				0
+#define POWERUP				BIT(0)
+
+#define DSI_CLKMGR_CFG			0x08
+#define TO_CLK_DIVIDSION(div)		(((div) & 0xff) << 8)
+#define TX_ESC_CLK_DIVIDSION(div)	(((div) & 0xff) << 0)
+
+#define DSI_DPI_CFG			0x0c
+#define EN18_LOOSELY			BIT(10)
+#define COLORM_ACTIVE_LOW		BIT(9)
+#define SHUTD_ACTIVE_LOW		BIT(8)
+#define HSYNC_ACTIVE_LOW		BIT(7)
+#define VSYNC_ACTIVE_LOW		BIT(6)
+#define DATAEN_ACTIVE_LOW		BIT(5)
+#define DPI_COLOR_CODING_16BIT_1	(0x0 << 2)
+#define DPI_COLOR_CODING_16BIT_2	(0x1 << 2)
+#define DPI_COLOR_CODING_16BIT_3	(0x2 << 2)
+#define DPI_COLOR_CODING_18BIT_1	(0x3 << 2)
+#define DPI_COLOR_CODING_18BIT_2	(0x4 << 2)
+#define DPI_COLOR_CODING_24BIT		(0x5 << 2)
+#define DPI_VID(vid)			(((vid) & 0x3) << 0)
+
+#define DSI_DBI_CFG			0x10
+#define DSI_DBIS_CMDSIZE		0x14
+
+#define DSI_PCKHDL_CFG			0x18
+#define GEN_VID_RX(vid)			(((vid) & 0x3) << 5)
+#define EN_CRC_RX			BIT(4)
+#define EN_ECC_RX			BIT(3)
+#define EN_BTA				BIT(2)
+#define EN_EOTN_RX			BIT(1)
+#define EN_EOTP_TX			BIT(0)
+
+#define DSI_VID_MODE_CFG		0x1c
+#define FRAME_BTA_ACK			BIT(11)
+#define EN_NULL_PKT			BIT(10)
+#define EN_NULL_PKT_MASK		BIT(10)
+#define EN_MULTI_PKT			BIT(9)
+#define ENABLE_LOW_POWER		(0x3f << 3)
+#define ENABLE_LOW_POWER_MASK		(0x3f << 3)
+#define VID_MODE_TYPE_NONBURST_SYNC_PULSES	(0x0 << 1)
+#define VID_MODE_TYPE_NONBURST_SYNC_EVENTS	(0x1 << 1)
+#define VID_MODE_TYPE_BURST_SYNC_PULSES		(0x3 << 1)
+#define VID_MODE_TYPE_MASK			(0x3 << 1)
+#define ENABLE_VIDEO_MODE			BIT(0)
+#define DISABLE_VIDEO_MODE			0
+#define ENABLE_VIDEO_MODE_MASK			BIT(0)
+
+#define DSI_VID_PKT_CFG			0x20
+#define NULL_PKT_SIZE(b)		(((b) & 0x3f) << 21)
+#define NUM_CHUNKS(n)			(((n) & 0x3f) << 11)
+#define VID_PKT_SIZE(p)			(((p) & 0x7ff) << 0)
+#define VID_PKT_MAX_SIZE		0x7ff
+
+#define DSI_CMD_MODE_CFG		0x24
+#define EN_TEAR_FX			BIT(14)
+#define EN_ACK_RQST			BIT(13)
+#define DCS_LW_TX_LP			BIT(12)
+#define GEN_LW_TX_LP			BIT(11)
+#define MAX_RD_PKT_SIZE_LP		BIT(10)
+#define DCS_SW_2P_TX_LP			BIT(9)
+#define DCS_SW_1P_TX_LP			BIT(8)
+#define DCS_SW_0P_TX_LP			BIT(7)
+#define GEN_SR_2P_TX_LP			BIT(6)
+#define GEN_SR_1P_TX_LP			BIT(5)
+#define GEN_SR_0P_TX_LP			BIT(4)
+#define GEN_SW_2P_TX_LP			BIT(3)
+#define GEN_SW_1P_TX_LP			BIT(2)
+#define GEN_SW_0P_TX_LP			BIT(1)
+#define ENABLE_CMD_MODE			BIT(0)
+#define DISABLE_CMD_MODE		0
+#define ENABLE_CMD_MODE_MASK		BIT(0)
+#define CMD_MODE_ALL_LP			(DCS_LW_TX_LP | \
+					 GEN_LW_TX_LP | \
+					 MAX_RD_PKT_SIZE_LP | \
+					 DCS_SW_2P_TX_LP | \
+					 DCS_SW_1P_TX_LP | \
+					 DCS_SW_0P_TX_LP | \
+					 GEN_SR_2P_TX_LP | \
+					 GEN_SR_1P_TX_LP | \
+					 GEN_SR_0P_TX_LP | \
+					 GEN_SW_2P_TX_LP | \
+					 GEN_SW_1P_TX_LP | \
+					 GEN_SW_0P_TX_LP)
+
+#define DSI_TMR_LINE_CFG		0x28
+#define HLINE_TIME(lbcc)		(((lbcc) & 0x3fff) << 18)
+#define HBP_TIME(lbcc)			(((lbcc) & 0x1ff) << 9)
+#define HSA_TIME(lbcc)			(((lbcc) & 0x1ff) << 0)
+
+#define DSI_VTIMING_CFG			0x2c
+#define V_ACTIVE_LINES(line)		(((line) & 0x7ff) << 16)
+#define VFP_LINES(line)			(((line) & 0x3f) << 10)
+#define VBP_LINES(line)			(((line) & 0x3f) << 4)
+#define VSA_LINES(line)			(((line) & 0xf) << 0)
+
+#define DSI_PHY_TMR_CFG			0x30
+#define PHY_HS2LP_TIME(lbcc)		(((lbcc) & 0xff) << 20)
+#define PHY_LP2HS_TIME(lbcc)		(((lbcc) & 0xff) << 12)
+#define BTA_TIME(lbcc)			(((lbcc) & 0xfff) << 0)
+
+#define DSI_GEN_HDR			0x34
+#define GEN_HDATA(data)			(((data) & 0xffff) << 8)
+#define GEN_HDATA_MASK			(0xffff << 8)
+#define GEN_HTYPE(type)			(((type) & 0xff) << 0)
+#define GEN_HTYPE_MASK			0xff
+
+#define DSI_GEN_PLD_DATA		0x38
+
+#define DSI_CMD_PKT_STATUS		0x3c
+#define GEN_CMD_EMPTY			BIT(0)
+#define GEN_CMD_FULL			BIT(1)
+#define GEN_PLD_W_EMPTY			BIT(2)
+#define GEN_PLD_W_FULL			BIT(3)
+#define GEN_PLD_R_EMPTY			BIT(4)
+#define GEN_RD_CMD_BUSY			BIT(6)
+
+#define DSI_TO_CNT_CFG			0x40
+#define DSI_ERROR_ST0			0x44
+#define DSI_ERROR_ST1			0x48
+#define DSI_ERROR_MSK0			0x4c
+#define DSI_ERROR_MSK1			0x50
+
+#define DSI_PHY_RSTZ			0x54
+#define PHY_DISABLECLK			0
+#define PHY_ENABLECLK			BIT(2)
+#define PHY_RSTZ			0
+#define PHY_UNRSTZ			BIT(1)
+#define PHY_SHUTDOWNZ			0
+#define PHY_UNSHUTDOWNZ			BIT(0)
+
+#define DSI_PHY_IF_CFG			0x58
+#define N_LANES(n)			((((n) - 1) & 0x3) << 0)
+#define PHY_STOP_WAIT_TIME(cycle)	(((cycle) & 0x3ff) << 2)
+
+#define DSI_PHY_IF_CTRL			0x5c
+#define PHY_IF_CTRL_RESET		0x0
+#define TX_REQ_CLK_HS			BIT(0)
+
+#define DSI_PHY_STATUS			0x60
+#define LOCK				BIT(0)
+#define STOP_STATE_CLK_LANE		BIT(2)
+
+#define DSI_PHY_TST_CTRL0		0x64
+#define PHY_TESTCLK			BIT(1)
+#define PHY_UNTESTCLK			0
+#define PHY_TESTCLR			BIT(0)
+#define PHY_UNTESTCLR			0
+
+#define DSI_PHY_TST_CTRL1		0x68
+#define PHY_TESTEN			BIT(16)
+#define PHY_UNTESTEN			0
+#define PHY_TESTDOUT(n)			(((n) & 0xff) << 8)
+#define PHY_TESTDIN(n)			(((n) & 0xff) << 0)
+
+#define PHY_STATUS_TIMEOUT		10
+#define CMD_PKT_STATUS_TIMEOUT		20
+
+struct dw_mipi_dsi {
+	struct mipi_dsi_host dsi_host;
+	struct drm_connector connector;
+	struct drm_encoder *encoder;
+	struct drm_bridge *bridge;
+	struct drm_panel *panel;
+	struct device *dev;
+
+	void __iomem *base;
+
+	struct clk *pllref_clk;
+	struct clk *cfg_clk;
+
+	unsigned int lane_mbps; /* per lane */
+	u32 channel;
+	u32 lanes;
+	u32 format;
+	struct drm_display_mode *mode;
+
+	const struct dw_mipi_dsi_plat_data *pdata;
+
+	bool enabled;
+};
+
+enum {
+	STATUS_TO_CLEAR,
+	STATUS_TO_SET,
+};
+
+enum dw_mipi_dsi_mode {
+	DW_MIPI_DSI_CMD_MODE,
+	DW_MIPI_DSI_VID_MODE,
+};
+
+struct dphy_pll_testdin_map {
+	unsigned int max_mbps;
+	u8 testdin;
+};
+
+/* The table is based on 27MHz DPHY pll reference clock. */
+static const struct dphy_pll_testdin_map dptdin_map[] = {
+	{160, 0x04}, {180, 0x24}, {200, 0x44}, {210, 0x06},
+	{240, 0x26}, {250, 0x46}, {270, 0x08}, {300, 0x28},
+	{330, 0x48}, {360, 0x2a}, {400, 0x4a}, {450, 0x0c},
+	{500, 0x2c}, {550, 0x0e}, {600, 0x2e}, {650, 0x10},
+	{700, 0x30}, {750, 0x12}, {800, 0x32}, {850, 0x14},
+	{900, 0x34}, {950, 0x54}, {1000, 0x74}
+};
+
+static inline struct dw_mipi_dsi *host_to_dsi(struct mipi_dsi_host *host)
+{
+	return container_of(host, struct dw_mipi_dsi, dsi_host);
+}
+
+static inline struct dw_mipi_dsi *con_to_dsi(struct drm_connector *con)
+{
+	return container_of(con, struct dw_mipi_dsi, connector);
+}
+
+int dw_mipi_dsi_get_encoder_pixel_format(struct drm_encoder *encoder)
+{
+	struct dw_mipi_dsi *dsi = encoder->bridge->driver_private;
+
+	return dsi->format;
+}
+EXPORT_SYMBOL_GPL(dw_mipi_dsi_get_encoder_pixel_format);
+
+static int max_mbps_to_testdin(unsigned int max_mbps)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dptdin_map); i++)
+		if (dptdin_map[i].max_mbps == max_mbps)
+			return dptdin_map[i].testdin;
+
+	return -EINVAL;
+}
+
+static inline void dsi_write(struct dw_mipi_dsi *dsi, u32 reg, u32 val)
+{
+	writel(val, dsi->base + reg);
+}
+
+static inline u32 dsi_read(struct dw_mipi_dsi *dsi, u32 reg)
+{
+	return readl(dsi->base + reg);
+}
+
+static inline void dsi_modify(struct dw_mipi_dsi *dsi, u32 reg,
+			      u32 mask, u32 val)
+{
+	u32 v;
+
+	v = readl(dsi->base + reg);
+	v &= ~mask;
+	v |= val;
+	writel(v, dsi->base + reg);
+}
+
+static int check_status(struct dw_mipi_dsi *dsi, u32 reg, u32 status,
+			unsigned int timeout, bool to_set)
+{
+	unsigned long expire;
+	bool out;
+	u32 val;
+
+	expire = jiffies + msecs_to_jiffies(timeout);
+	for (;;) {
+		val = dsi_read(dsi, reg);
+		out = to_set ? ((val & status) == status) : !(val & status);
+		if (out)
+			break;
+
+		if (time_after(jiffies, expire))
+			return -ETIMEDOUT;
+
+		cpu_relax();
+	}
+
+	return 0;
+}
+
+/*
+ * The controller should generate 2 frames before
+ * preparing the peripheral.
+ */
+static void dw_mipi_dsi_wait_for_two_frames(struct dw_mipi_dsi *dsi)
+{
+	unsigned long expire;
+	int refresh, two_frames;
+
+	refresh = drm_mode_vrefresh(dsi->mode);
+	two_frames = DIV_ROUND_UP(MSEC_PER_SEC, refresh) * 2;
+
+	expire = jiffies + msecs_to_jiffies(two_frames);
+	while (time_before(jiffies, expire))
+		cpu_relax();
+}
+
+static int dw_mipi_dsi_config_testdin(struct dw_mipi_dsi *dsi)
+{
+	int ret, testdin;
+
+	testdin = max_mbps_to_testdin(dsi->lane_mbps);
+	if (testdin < 0) {
+		dev_err(dsi->dev,
+			"failed to get testdin for %dmbps lane clock\n",
+			dsi->lane_mbps);
+		return testdin;
+	}
+
+	dsi_write(dsi, DSI_PHY_IF_CTRL, PHY_IF_CTRL_RESET);
+	dsi_write(dsi, DSI_PWR_UP, POWERUP);
+
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_UNTESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL1, PHY_TESTEN | PHY_TESTDOUT(0) |
+					  PHY_TESTDIN(0x44));
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_TESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_UNTESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL1, PHY_UNTESTEN | PHY_TESTDOUT(0) |
+					  PHY_TESTDIN(testdin));
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_TESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_UNTESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_RSTZ,      PHY_ENABLECLK | PHY_UNRSTZ |
+					  PHY_UNSHUTDOWNZ);
+	ret = check_status(dsi, DSI_PHY_STATUS, LOCK,
+			   PHY_STATUS_TIMEOUT, STATUS_TO_SET);
+	if (ret < 0) {
+		dev_err(dsi->dev, "failed to wait for phy lock state\n");
+		return ret;
+	}
+	ret = check_status(dsi, DSI_PHY_STATUS, STOP_STATE_CLK_LANE,
+			   PHY_STATUS_TIMEOUT, STATUS_TO_SET);
+	if (ret < 0) {
+		dev_err(dsi->dev,
+			"failed to wait for phy clk lane stop state\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static int dw_mipi_dsi_get_lane_bps(struct dw_mipi_dsi *dsi,
+				    unsigned int *final_mbps)
+{
+	int bpp, i;
+	unsigned int target_mbps, mpclk;
+	unsigned long pllref;
+
+	bpp = mipi_dsi_pixel_format_to_bpp(dsi->format);
+	if (bpp < 0) {
+		dev_err(dsi->dev, "failed to get bpp for pixel format %d\n",
+			dsi->format);
+		return bpp;
+	}
+
+	pllref = clk_get_rate(dsi->pllref_clk);
+	if (pllref != 27000000)
+		dev_warn(dsi->dev, "expect 27MHz DPHY pll reference clock\n");
+
+	mpclk = DIV_ROUND_UP(dsi->mode->clock, MSEC_PER_SEC);
+	if (mpclk) {
+		/* take 1/0.7 blanking overhead into consideration */
+		target_mbps = (mpclk * (bpp / dsi->lanes) * 10) / 7;
+	} else {
+		dev_dbg(dsi->dev, "use default 1Gbps DPHY pll clock\n");
+		target_mbps = 1000;
+	}
+
+	dev_dbg(dsi->dev, "target DPHY pll clock frequency is %uMbps\n",
+		target_mbps);
+
+	for (i = 0; i < ARRAY_SIZE(dptdin_map); i++) {
+		if (target_mbps < dptdin_map[i].max_mbps) {
+			*final_mbps = dptdin_map[i].max_mbps;
+			dev_dbg(dsi->dev,
+				"real DPHY pll clock frequency is %uMbps\n",
+				*final_mbps);
+			return 0;
+		}
+	}
+
+	dev_err(dsi->dev, "DPHY clock frequency %uMbps is out of range\n",
+						target_mbps);
+
+	return -EINVAL;
+}
+
+static int dw_mipi_dsi_host_attach(struct mipi_dsi_host *host,
+				   struct mipi_dsi_device *device)
+{
+	struct dw_mipi_dsi *dsi = host_to_dsi(host);
+
+	if (device->lanes > dsi->pdata->max_data_lanes) {
+		dev_err(dsi->dev, "the number of data lanes(%d) is too many\n",
+				device->lanes);
+		return -EINVAL;
+	}
+
+	if (!(device->mode_flags & MIPI_DSI_MODE_VIDEO_BURST) ||
+	    !(device->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)) {
+		dev_err(dsi->dev, "device mode is unsupported\n");
+		return -EINVAL;
+	}
+
+	if (device->format != MIPI_DSI_FMT_RGB888 &&
+	    device->format != MIPI_DSI_FMT_RGB565) {
+		dev_err(dsi->dev, "device pixel format is unsupported\n");
+		return -EINVAL;
+	}
+
+	dsi->lanes = device->lanes;
+	dsi->channel = device->channel;
+	dsi->format = device->format;
+	dsi->panel = of_drm_find_panel(device->dev.of_node);
+	drm_panel_attach(dsi->panel, &dsi->connector);
+
+	return 0;
+}
+
+static int dw_mipi_dsi_host_detach(struct mipi_dsi_host *host,
+				   struct mipi_dsi_device *device)
+{
+	struct dw_mipi_dsi *dsi = host_to_dsi(host);
+
+	drm_panel_detach(dsi->panel);
+
+	return 0;
+}
+
+static int dw_mipi_dsi_gen_pkt_hdr_write(struct dw_mipi_dsi *dsi, u32 val)
+{
+	int ret;
+
+	ret = check_status(dsi, DSI_CMD_PKT_STATUS, GEN_CMD_FULL,
+			   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_CLEAR);
+	if (ret < 0) {
+		dev_err(dsi->dev, "failed to get available command FIFO\n");
+		return ret;
+	}
+
+	dsi_write(dsi, DSI_GEN_HDR, val);
+
+	ret = check_status(dsi, DSI_CMD_PKT_STATUS,
+			   GEN_CMD_EMPTY | GEN_PLD_W_EMPTY,
+			   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_SET);
+	if (ret < 0) {
+		dev_err(dsi->dev, "failed to write command FIFO\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int dw_mipi_dsi_dcs_short_write(struct dw_mipi_dsi *dsi,
+				       const struct mipi_dsi_msg *msg)
+{
+	const u16 *tx_buf = msg->tx_buf;
+	u32 val = GEN_HDATA(*tx_buf) | GEN_HTYPE(msg->type);
+
+	if (msg->tx_len > 2) {
+		dev_err(dsi->dev, "too long tx buf length %d for short write\n",
+			msg->tx_len);
+		return -EINVAL;
+	}
+
+	return dw_mipi_dsi_gen_pkt_hdr_write(dsi, val);
+}
+
+static int dw_mipi_dsi_dcs_long_write(struct dw_mipi_dsi *dsi,
+				      const struct mipi_dsi_msg *msg)
+{
+	const u32 *tx_buf = msg->tx_buf;
+	int len = msg->tx_len, pld_data_bytes = sizeof(*tx_buf), ret;
+	u32 val = GEN_HDATA(msg->tx_len) | GEN_HTYPE(msg->type);
+	u32 remainder = 0;
+
+	if (msg->tx_len < 3) {
+		dev_err(dsi->dev, "wrong tx buf length %d for long write\n",
+			msg->tx_len);
+		return -EINVAL;
+	}
+
+	while (DIV_ROUND_UP(len, pld_data_bytes)) {
+		if (len < pld_data_bytes) {
+			memcpy(&remainder, tx_buf, len);
+			dsi_write(dsi, DSI_GEN_PLD_DATA, remainder);
+			len = 0;
+		} else {
+			dsi_write(dsi, DSI_GEN_PLD_DATA, *tx_buf);
+			tx_buf++;
+			len -= pld_data_bytes;
+		}
+		ret = check_status(dsi, DSI_CMD_PKT_STATUS, GEN_PLD_W_FULL,
+				   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_CLEAR);
+		if (ret < 0) {
+			dev_err(dsi->dev,
+				"failed to get available write payload FIFO\n");
+			return ret;
+		}
+	}
+
+	return dw_mipi_dsi_gen_pkt_hdr_write(dsi, val);
+}
+
+static ssize_t dw_mipi_dsi_host_transfer(struct mipi_dsi_host *host,
+					 const struct mipi_dsi_msg *msg)
+{
+	struct dw_mipi_dsi *dsi = host_to_dsi(host);
+	int ret;
+
+	switch (msg->type) {
+	case MIPI_DSI_DCS_SHORT_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
+	case MIPI_DSI_SET_MAXIMUM_RETURN_PACKET_SIZE:
+		ret = dw_mipi_dsi_dcs_short_write(dsi, msg);
+		break;
+	case MIPI_DSI_DCS_LONG_WRITE:
+		ret = dw_mipi_dsi_dcs_long_write(dsi, msg);
+		break;
+	default:
+		dev_err(dsi->dev, "unsupported message type\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct mipi_dsi_host_ops dw_mipi_dsi_host_ops = {
+	.attach = dw_mipi_dsi_host_attach,
+	.detach = dw_mipi_dsi_host_detach,
+	.transfer = dw_mipi_dsi_host_transfer,
+};
+
+static enum drm_connector_status
+dw_mipi_dsi_detect(struct drm_connector *connector, bool force)
+{
+	return connector_status_connected;
+}
+
+static void dw_mipi_dsi_drm_connector_destroy(struct drm_connector *connector)
+{
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
+}
+
+static struct drm_connector_funcs dw_mipi_dsi_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.detect = dw_mipi_dsi_detect,
+	.destroy = dw_mipi_dsi_drm_connector_destroy,
+};
+
+static int dw_mipi_dsi_connector_get_modes(struct drm_connector *connector)
+{
+	struct dw_mipi_dsi *dsi = con_to_dsi(connector);
+
+	return drm_panel_get_modes(dsi->panel);
+}
+
+static enum drm_mode_status dw_mipi_dsi_mode_valid(
+					struct drm_connector *connector,
+					struct drm_display_mode *mode)
+{
+	struct dw_mipi_dsi *dsi = con_to_dsi(connector);
+
+	enum drm_mode_status mode_status = MODE_OK;
+
+	if (dsi->pdata->mode_valid)
+		mode_status = dsi->pdata->mode_valid(connector, mode);
+
+	return mode_status;
+}
+
+static struct drm_encoder *dw_mipi_dsi_connector_best_encoder(
+					struct drm_connector *connector)
+{
+	struct dw_mipi_dsi *dsi = con_to_dsi(connector);
+
+	return dsi->encoder;
+}
+
+static struct drm_connector_helper_funcs dw_mipi_dsi_connector_helper_funcs = {
+	.get_modes = dw_mipi_dsi_connector_get_modes,
+	.mode_valid = dw_mipi_dsi_mode_valid,
+	.best_encoder = dw_mipi_dsi_connector_best_encoder,
+};
+
+static void dw_mipi_dsi_video_mode_config(struct dw_mipi_dsi *dsi)
+{
+	u32 val;
+
+	val = VID_MODE_TYPE_BURST_SYNC_PULSES | ENABLE_LOW_POWER;
+
+	dsi_write(dsi, DSI_VID_MODE_CFG, val);
+}
+
+static void dw_mipi_dsi_set_mode(struct dw_mipi_dsi *dsi,
+				 enum dw_mipi_dsi_mode mode)
+{
+	if (mode == DW_MIPI_DSI_CMD_MODE) {
+		dsi_write(dsi, DSI_PWR_UP, RESET);
+		dsi_modify(dsi, DSI_CMD_MODE_CFG,
+			   ENABLE_CMD_MODE_MASK, ENABLE_CMD_MODE);
+		dsi_modify(dsi, DSI_VID_MODE_CFG,
+			   ENABLE_VIDEO_MODE_MASK, DISABLE_VIDEO_MODE);
+		dsi_write(dsi, DSI_PWR_UP, POWERUP);
+	} else {
+		dsi_write(dsi, DSI_PWR_UP, RESET);
+		dsi_modify(dsi, DSI_CMD_MODE_CFG,
+			   ENABLE_CMD_MODE_MASK, DISABLE_CMD_MODE);
+
+		dw_mipi_dsi_video_mode_config(dsi);
+
+		dsi_modify(dsi, DSI_VID_MODE_CFG,
+			   ENABLE_VIDEO_MODE_MASK, ENABLE_VIDEO_MODE);
+		dsi_write(dsi, DSI_PWR_UP, POWERUP);
+		dsi_write(dsi, DSI_PHY_IF_CTRL, TX_REQ_CLK_HS);
+	}
+}
+
+static void dw_mipi_dsi_disable(struct dw_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PHY_IF_CTRL, PHY_IF_CTRL_RESET);
+	dsi_write(dsi, DSI_PWR_UP, RESET);
+	dsi_write(dsi, DSI_PHY_RSTZ, PHY_RSTZ);
+}
+
+static void dw_mipi_dsi_bridge_enable(struct drm_bridge *bridge)
+{
+	struct dw_mipi_dsi *dsi = bridge->driver_private;
+
+	if (dsi->enabled)
+		return;
+
+	clk_prepare_enable(dsi->cfg_clk);
+	dw_mipi_dsi_config_testdin(dsi);
+	dw_mipi_dsi_set_mode(dsi, DW_MIPI_DSI_VID_MODE);
+	dw_mipi_dsi_wait_for_two_frames(dsi);
+	dw_mipi_dsi_set_mode(dsi, DW_MIPI_DSI_CMD_MODE);
+	drm_panel_prepare(dsi->panel);
+	dw_mipi_dsi_set_mode(dsi, DW_MIPI_DSI_VID_MODE);
+	clk_disable_unprepare(dsi->cfg_clk);
+
+	drm_panel_enable(dsi->panel);
+
+	dsi->enabled = true;
+}
+
+static void dw_mipi_dsi_bridge_disable(struct drm_bridge *bridge)
+{
+	struct dw_mipi_dsi *dsi = bridge->driver_private;
+	unsigned long expire;
+
+	if (!dsi->enabled)
+		return;
+
+	drm_panel_disable(dsi->panel);
+
+	clk_prepare_enable(dsi->cfg_clk);
+	dw_mipi_dsi_set_mode(dsi, DW_MIPI_DSI_CMD_MODE);
+	drm_panel_unprepare(dsi->panel);
+	dw_mipi_dsi_set_mode(dsi, DW_MIPI_DSI_VID_MODE);
+
+	/*
+	 * This is necessary to make sure the peripheral
+	 * will be driven normally when the display is
+	 * enabled again later.
+	 */
+	expire = jiffies + msecs_to_jiffies(120);
+	while (time_before(jiffies, expire))
+		cpu_relax();
+
+	dw_mipi_dsi_set_mode(dsi, DW_MIPI_DSI_CMD_MODE);
+	dw_mipi_dsi_disable(dsi);
+	clk_disable_unprepare(dsi->cfg_clk);
+
+	dsi->enabled = false;
+}
+
+static void dw_mipi_dsi_bridge_nope(struct drm_bridge *bridge)
+{
+	/* do nothing */
+}
+
+static void dw_mipi_dsi_init(struct dw_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PWR_UP, RESET);
+	dsi_write(dsi, DSI_PHY_RSTZ, PHY_DISABLECLK | PHY_RSTZ | PHY_SHUTDOWNZ);
+	dsi_write(dsi, DSI_CLKMGR_CFG, TO_CLK_DIVIDSION(1) |
+					TX_ESC_CLK_DIVIDSION(7));
+}
+
+static void dw_mipi_dsi_dpi_config(struct dw_mipi_dsi *dsi,
+				   struct drm_display_mode *mode)
+{
+	u32 val = 0;
+
+	if (!(mode->flags & DRM_MODE_FLAG_PVSYNC))
+		val |= VSYNC_ACTIVE_LOW;
+	if (!(mode->flags & DRM_MODE_FLAG_PHSYNC))
+		val |= HSYNC_ACTIVE_LOW;
+
+	switch (dsi->format) {
+	case MIPI_DSI_FMT_RGB888:
+		val |= DPI_COLOR_CODING_24BIT;
+		break;
+	case MIPI_DSI_FMT_RGB666:
+		val |= DPI_COLOR_CODING_18BIT_2;
+		val |= EN18_LOOSELY;
+		break;
+	case MIPI_DSI_FMT_RGB666_PACKED:
+		val |= DPI_COLOR_CODING_18BIT_1;
+		break;
+	case MIPI_DSI_FMT_RGB565:
+		val |= DPI_COLOR_CODING_16BIT_1;
+		break;
+	}
+
+	val |= DPI_VID(dsi->channel);
+
+	dsi_write(dsi, DSI_DPI_CFG, val);
+}
+
+static void dw_mipi_dsi_packet_handler_config(struct dw_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PCKHDL_CFG, EN_CRC_RX | EN_ECC_RX | EN_BTA);
+}
+
+static void dw_mipi_dsi_video_packet_config(struct dw_mipi_dsi *dsi,
+					    struct drm_display_mode *mode)
+{
+	dsi_write(dsi, DSI_VID_PKT_CFG, VID_PKT_SIZE(mode->hdisplay));
+}
+
+static void dw_mipi_dsi_command_mode_config(struct dw_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_CMD_MODE_CFG, CMD_MODE_ALL_LP | ENABLE_CMD_MODE);
+}
+
+/* Get lane byte clock cycles. */
+static u64 dw_mipi_dsi_get_hcomponent_lbcc(struct dw_mipi_dsi *dsi,
+					   u64 hcomponent)
+{
+	u64 frac, lbcc;
+
+	lbcc = hcomponent * dsi->lane_mbps * USEC_PER_SEC / 8;
+	frac = do_div(lbcc, dsi->mode->clock * MSEC_PER_SEC);
+	if (frac)
+		lbcc++;
+
+	return lbcc;
+}
+
+static void dw_mipi_dsi_line_timer_config(struct dw_mipi_dsi *dsi)
+{
+	u32 val = 0, htotal, hsa, hbp, lbcc;
+	struct drm_display_mode *mode = dsi->mode;
+
+	htotal = mode->htotal;
+	hsa = mode->hsync_end - mode->hsync_start;
+	hbp = mode->htotal - mode->hsync_end;
+
+	lbcc = dw_mipi_dsi_get_hcomponent_lbcc(dsi, htotal);
+	val |= HLINE_TIME(lbcc);
+
+	lbcc = dw_mipi_dsi_get_hcomponent_lbcc(dsi, hsa);
+	val |= HSA_TIME(lbcc);
+
+	lbcc = dw_mipi_dsi_get_hcomponent_lbcc(dsi, hbp);
+	val |= HBP_TIME(lbcc);
+
+	dsi_write(dsi, DSI_TMR_LINE_CFG, val);
+}
+
+static void dw_mipi_dsi_vertical_timing_config(struct dw_mipi_dsi *dsi)
+{
+	u32 val, vactive, vsa, vfp, vbp;
+	struct drm_display_mode *mode = dsi->mode;
+
+	vactive = mode->vdisplay;
+	vsa = mode->vsync_end - mode->vsync_start;
+	vfp = mode->vsync_start - mode->vdisplay;
+	vbp = mode->vtotal - mode->vsync_end;
+
+	val = V_ACTIVE_LINES(vactive) | VSA_LINES(vsa) |
+	      VFP_LINES(vfp) | VBP_LINES(vbp);
+
+	dsi_write(dsi, DSI_VTIMING_CFG, val);
+}
+
+static void dw_mipi_dsi_dphy_timing_config(struct dw_mipi_dsi *dsi)
+{
+	u32 val;
+
+	val = PHY_HS2LP_TIME(0x40) | PHY_LP2HS_TIME(0x40) |
+	      BTA_TIME(0xd00);
+
+	dsi_write(dsi, DSI_PHY_TMR_CFG, val);
+}
+
+static void dw_mipi_dsi_dphy_interface_config(struct dw_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PHY_IF_CFG, PHY_STOP_WAIT_TIME(0x20) |
+						N_LANES(dsi->lanes));
+}
+
+static void dw_mipi_dsi_clear_err(struct dw_mipi_dsi *dsi)
+{
+	dsi_read(dsi, DSI_ERROR_ST0);
+	dsi_read(dsi, DSI_ERROR_ST1);
+	dsi_write(dsi, DSI_ERROR_MSK0, 0);
+	dsi_write(dsi, DSI_ERROR_MSK1, 0);
+}
+
+static void dw_mipi_dsi_bridge_mode_set(struct drm_bridge *bridge,
+					struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode)
+{
+	struct dw_mipi_dsi *dsi = bridge->driver_private;
+	int ret;
+
+	dsi->mode = mode;
+
+	ret = dw_mipi_dsi_get_lane_bps(dsi, &dsi->lane_mbps);
+	if (ret < 0)
+		return;
+
+	clk_prepare_enable(dsi->cfg_clk);
+	dw_mipi_dsi_init(dsi);
+	dw_mipi_dsi_dpi_config(dsi, mode);
+	dw_mipi_dsi_packet_handler_config(dsi);
+	dw_mipi_dsi_video_mode_config(dsi);
+	dw_mipi_dsi_video_packet_config(dsi, mode);
+	dw_mipi_dsi_command_mode_config(dsi);
+	dw_mipi_dsi_line_timer_config(dsi);
+	dw_mipi_dsi_vertical_timing_config(dsi);
+	dw_mipi_dsi_dphy_timing_config(dsi);
+	dw_mipi_dsi_dphy_interface_config(dsi);
+	dw_mipi_dsi_clear_err(dsi);
+	dw_mipi_dsi_config_testdin(dsi);
+	dw_mipi_dsi_wait_for_two_frames(dsi);
+	drm_panel_prepare(dsi->panel);
+	clk_disable_unprepare(dsi->cfg_clk);
+}
+
+static bool dw_mipi_dsi_bridge_mode_fixup(struct drm_bridge *bridge,
+					const struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void dw_mipi_dsi_bridge_destroy(struct drm_bridge *bridge)
+{
+	drm_bridge_cleanup(bridge);
+	kfree(bridge);
+}
+
+static struct drm_bridge_funcs dw_mipi_dsi_bridge_funcs = {
+	.enable = dw_mipi_dsi_bridge_enable,
+	.disable = dw_mipi_dsi_bridge_disable,
+	.pre_enable = dw_mipi_dsi_bridge_nope,
+	.post_disable = dw_mipi_dsi_bridge_nope,
+	.mode_set = dw_mipi_dsi_bridge_mode_set,
+	.mode_fixup = dw_mipi_dsi_bridge_mode_fixup,
+	.destroy = dw_mipi_dsi_bridge_destroy,
+};
+
+static int dw_mipi_dsi_register(struct drm_device *drm, struct dw_mipi_dsi *dsi)
+{
+	struct drm_encoder *encoder = dsi->encoder;
+	struct drm_bridge *bridge;
+	int ret;
+
+	bridge = devm_kzalloc(drm->dev, sizeof(*bridge), GFP_KERNEL);
+	if (!bridge)
+		return -ENOMEM;
+
+	dsi->bridge = bridge;
+	bridge->driver_private = dsi;
+
+	ret = drm_bridge_init(drm, bridge, &dw_mipi_dsi_bridge_funcs);
+	if (ret) {
+		dev_err(drm->dev, "failed to initialize bridge with drm\n");
+		return ret;
+	}
+
+	encoder->bridge = bridge;
+
+	drm_connector_helper_add(&dsi->connector,
+			&dw_mipi_dsi_connector_helper_funcs);
+	drm_connector_init(drm, &dsi->connector, &dw_mipi_dsi_connector_funcs,
+			   DRM_MODE_CONNECTOR_DSI);
+
+	drm_mode_connector_attach_encoder(&dsi->connector, dsi->encoder);
+
+	return 0;
+}
+
+int dw_mipi_dsi_bind(struct device *dev, struct device *master, void *data,
+		     struct drm_encoder *encoder, struct resource *res,
+		     const struct dw_mipi_dsi_plat_data *pdata)
+{
+	struct drm_device *drm = data;
+	struct dw_mipi_dsi *dsi;
+	u32 val;
+	int ret;
+
+	dsi = devm_kzalloc(dev, sizeof(*dsi), GFP_KERNEL);
+	if (!dsi)
+		return -ENOMEM;
+
+	dsi->pdata = pdata;
+	dsi->dev = dev;
+	dsi->dsi_host.ops = &dw_mipi_dsi_host_ops;
+	dsi->dsi_host.dev = dev;
+	dsi->encoder = encoder;
+
+	dsi->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dsi->base))
+		return PTR_ERR(dsi->base);
+
+	dsi->pllref_clk = devm_clk_get(dev, "pllref");
+	if (IS_ERR(dsi->pllref_clk)) {
+		ret = PTR_ERR(dsi->pllref_clk);
+		dev_err(dev, "Unable to get pll reference clock: %d\n", ret);
+		return ret;
+	}
+	clk_prepare_enable(dsi->pllref_clk);
+
+	dsi->cfg_clk = devm_clk_get(dev, "core_cfg");
+	if (IS_ERR(dsi->cfg_clk)) {
+		ret = PTR_ERR(dsi->cfg_clk);
+		dev_err(dev, "Unable to get configuration clock: %d\n", ret);
+		goto err_pllref;
+	}
+
+	clk_prepare_enable(dsi->cfg_clk);
+	val = dsi_read(dsi, DSI_VERSION);
+	clk_disable_unprepare(dsi->cfg_clk);
+
+	dev_info(dev, "version number is 0x%08x\n", val);
+
+	ret = dw_mipi_dsi_register(drm, dsi);
+	if (ret)
+		goto err_pllref;
+
+	dev_set_drvdata(dev, dsi);
+
+	return mipi_dsi_host_register(&dsi->dsi_host);
+
+err_pllref:
+	clk_disable_unprepare(dsi->pllref_clk);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dw_mipi_dsi_bind);
+
+void dw_mipi_dsi_unbind(struct device *dev, struct device *master, void *data)
+{
+	struct dw_mipi_dsi *dsi = dev_get_drvdata(dev);
+
+	mipi_dsi_host_unregister(&dsi->dsi_host);
+	clk_disable_unprepare(dsi->pllref_clk);
+}
+EXPORT_SYMBOL_GPL(dw_mipi_dsi_unbind);
+
+MODULE_DESCRIPTION("Synopsys DesignWare MIPI DSI host controller driver");
+MODULE_AUTHOR("Liu Ying <Ying.Liu@freescale.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/drm/bridge/dw_mipi_dsi.h b/include/drm/bridge/dw_mipi_dsi.h
new file mode 100644
index 0000000..e84e355
--- /dev/null
+++ b/include/drm/bridge/dw_mipi_dsi.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#ifndef __DW_MIPI_DSI__
+#define __DW_MIPI_DSI__
+
+#include <drm/drmP.h>
+
+struct dw_mipi_dsi_plat_data {
+	unsigned int max_data_lanes;
+	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
+					   struct drm_display_mode *mode);
+};
+
+int dw_mipi_dsi_get_encoder_pixel_format(struct drm_encoder *encoder);
+
+int dw_mipi_dsi_bind(struct device *dev, struct device *master, void *data,
+		     struct drm_encoder *encoder, struct resource *res,
+		     const struct dw_mipi_dsi_plat_data *pdata);
+void dw_mipi_dsi_unbind(struct device *dev, struct device *master, void *data);
+#endif	/* __DW_MIPI_DSI__ */
-- 
2.1.0

