Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936475Ab3DHPXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:23:37 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:41448 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936310Ab3DHPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:23:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH 3/5] dmaengine: ste_dma40: Move default memcpy configs into the driver
Date: Mon,  8 Apr 2013 16:23:09 +0100
Message-Id: <1365434591-21569-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are only two default memcpy configurations used for the DMA40
driver; one for physical memcpy and one for logical memcpy. Instead
of invariably passing the same configurations though platform data,
we're moving them into the driver instead.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/devices-db8500.c        |   28 -----------------------
 drivers/dma/ste_dma40.c                     |   32 +++++++++++++++++++++++++--
 include/linux/platform_data/dma-ste-dma40.h |    4 ----
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 2a63c19..c7da6e1 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -42,32 +42,6 @@ static struct resource dma40_resources[] = {
 	}
 };
 
-/* Default configuration for physcial memcpy */
-struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
-	.mode = STEDMA40_MODE_PHYSICAL,
-	.dir = STEDMA40_MEM_TO_MEM,
-
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.src_info.psize = STEDMA40_PSIZE_PHY_1,
-	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
-
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
-	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
-};
-/* Default configuration for logical memcpy */
-struct stedma40_chan_cfg dma40_memcpy_conf_log = {
-	.dir = STEDMA40_MEM_TO_MEM,
-
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.src_info.psize = STEDMA40_PSIZE_LOG_1,
-	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
-
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
-	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
-};
-
 /*
  * Mapping between destination event lines and physical device address.
  * The event line is tied to a device and therefore the address is constant.
@@ -150,8 +124,6 @@ static struct stedma40_platform_data dma40_plat_data = {
 	.dev_len = DB8500_DMA_NR_DEV,
 	.dev_rx = dma40_rx_map,
 	.dev_tx = dma40_tx_map,
-	.memcpy_conf_phy = &dma40_memcpy_conf_phy,
-	.memcpy_conf_log = &dma40_memcpy_conf_log,
 	.disabled_channels = {-1},
 };
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3ae5f99..ecca492 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -66,6 +66,34 @@ static int dma40_memcpy_channels[] = {
 	DB8500_DMA_MEMCPY_TX_5,
 };
 
+/* Default configuration for physcial memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
+	.mode = STEDMA40_MODE_PHYSICAL,
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_PHY_1,
+	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
+
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
+	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
+};
+
+/* Default configuration for logical memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_log = {
+	.mode = STEDMA40_MODE_LOGICAL,
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_LOG_1,
+	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
+
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
+	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
+};
+
 /**
  * enum 40_command - The different commands and/or statuses.
  *
@@ -2023,13 +2051,13 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 	dma_cap_mask_t cap = d40c->chan.device->cap_mask;
 
 	if (dma_has_cap(DMA_MEMCPY, cap) && !dma_has_cap(DMA_SLAVE, cap)) {
-		d40c->dma_cfg = *d40c->base->plat_data->memcpy_conf_log;
+		d40c->dma_cfg = dma40_memcpy_conf_log;
 		d40c->dma_cfg.src_dev_type = STEDMA40_DEV_SRC_MEMORY;
 		d40c->dma_cfg.dst_dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
 
 	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
 		   dma_has_cap(DMA_SLAVE, cap)) {
-		d40c->dma_cfg = *d40c->base->plat_data->memcpy_conf_phy;
+		d40c->dma_cfg = dma40_memcpy_conf_phy;
 	} else {
 		chan_err(d40c, "No memcpy\n");
 		return -EINVAL;
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index a808784..869c571 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -141,8 +141,6 @@ struct stedma40_chan_cfg {
  * @dev_len: length of dev_tx and dev_rx
  * @dev_tx: mapping between destination event line and io address
  * @dev_rx: mapping between source event line and io address
- * @memcpy_conf_phy: default configuration of physical channel memcpy
- * @memcpy_conf_log: default configuration of logical channel memcpy
  * @disabled_channels: A vector, ending with -1, that marks physical channels
  * that are for different reasons not available for the driver.
  * @soft_lli_chans: A vector, that marks physical channels will use LLI by SW
@@ -160,8 +158,6 @@ struct stedma40_platform_data {
 	u32				 dev_len;
 	const dma_addr_t		*dev_tx;
 	const dma_addr_t		*dev_rx;
-	struct stedma40_chan_cfg	*memcpy_conf_phy;
-	struct stedma40_chan_cfg	*memcpy_conf_log;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
 	int				*soft_lli_chans;
 	int				 num_of_soft_lli_chans;
-- 
1.7.10.4

