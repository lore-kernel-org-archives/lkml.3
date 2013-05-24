Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3EXKjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:39:42 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:34541 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3EXKjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:39:39 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 4/6] ASoC: ux500: Drop unused code from msp headers
Date: Fri, 24 May 2013 12:39:18 +0200
Message-Id: <1369391960-27320-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop unused fields and structures from ux500_msp_i2s header file, as
those looks like leftover from a previous implementation of the driver.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.h |  2 --
 sound/soc/ux500/ux500_msp_i2s.h | 31 -------------------------------
 2 files changed, 33 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.h b/sound/soc/ux500/ux500_msp_dai.h
index f531043..c721282 100644
--- a/sound/soc/ux500/ux500_msp_dai.h
+++ b/sound/soc/ux500/ux500_msp_dai.h
@@ -58,8 +58,6 @@ struct ux500_msp_i2s_drvdata {
 	unsigned int rx_mask;
 	int slots;
 	int slot_width;
-	u8 configured;
-	int data_delay;
 
 	/* Clocks */
 	unsigned int master_clk;
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index ccfcc32..d5e4176 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -341,11 +341,6 @@ enum msp_compress_mode {
 	MSP_COMPRESS_MODE_A_LAW = 3
 };
 
-enum msp_spi_burst_mode {
-	MSP_SPI_BURST_MODE_DISABLE = 0,
-	MSP_SPI_BURST_MODE_ENABLE = 1
-};
-
 enum msp_expand_mode {
 	MSP_EXPAND_MODE_LINEAR = 0,
 	MSP_EXPAND_MODE_LINEAR_SIGNED = 1,
@@ -454,21 +449,6 @@ struct msp_protdesc {
 	u32 clocks_per_frame;
 };
 
-struct i2s_message {
-	enum i2s_direction_t i2s_direction;
-	void *txdata;
-	void *rxdata;
-	size_t txbytes;
-	size_t rxbytes;
-	int dma_flag;
-	int tx_offset;
-	int rx_offset;
-	bool cyclic_dma;
-	dma_addr_t buf_addr;
-	size_t buf_len;
-	size_t period_len;
-};
-
 struct ux500_msp_config {
 	unsigned int f_inputclk;
 	unsigned int rx_clk_sel;
@@ -480,8 +460,6 @@ struct ux500_msp_config {
 	unsigned int tx_fsync_sel;
 	unsigned int rx_fifo_config;
 	unsigned int tx_fifo_config;
-	unsigned int spi_clk_mode;
-	unsigned int spi_burst_mode;
 	unsigned int loopback_enable;
 	unsigned int tx_data_enable;
 	unsigned int default_protdesc;
@@ -491,13 +469,9 @@ struct ux500_msp_config {
 	unsigned int direction;
 	unsigned int protocol;
 	unsigned int frame_freq;
-	unsigned int frame_size;
 	enum msp_data_size data_size;
 	unsigned int def_elem_len;
 	unsigned int iodelay;
-	void (*handler) (void *data);
-	void *tx_callback_data;
-	void *rx_callback_data;
 };
 
 struct ux500_msp {
@@ -506,15 +480,10 @@ struct ux500_msp {
 	struct device *dev;
 	struct stedma40_chan_cfg *dma_cfg_rx;
 	struct stedma40_chan_cfg *dma_cfg_tx;
-	struct dma_chan *tx_pipeid;
-	struct dma_chan *rx_pipeid;
 	enum msp_state msp_state;
-	int (*transfer) (struct ux500_msp *msp, struct i2s_message *message);
-	struct timer_list notify_timer;
 	int def_elem_len;
 	unsigned int dir_busy;
 	int loopback_enable;
-	u32 backup_regs[MAX_MSP_BACKUP_REGS];
 	unsigned int f_bitclk;
 };
 
-- 
1.8.2

