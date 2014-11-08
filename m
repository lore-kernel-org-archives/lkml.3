Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaKHFaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 00:30:20 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:44512 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaKHFaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 00:30:18 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <620cd6ad69264f1c1bf510b65fa254a3>
X-DNS-TYPE: 1
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Andy yan <andy.yan@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Subject: [PATCH V5 3/7] dw-hdmi: make checkpatch happy
Date: Sat,  8 Nov 2014 13:29:58 +0800
Message-Id: <1415424598-7533-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com>
References: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CHECK: Alignment should match open parenthesis
+       if ((hdmi->vic == 10) || (hdmi->vic == 11) ||
+               (hdmi->vic == 12) || (hdmi->vic == 13) ||

CHECK: braces {} should be used on all arms of this statement
+       if (hdmi->hdmi_data.video_mode.mdvi)
[...]
+       else {
[...]

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---
 drivers/gpu/drm/bridge/dw_hdmi.c | 97 ++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index 527014b..df52921 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -147,7 +147,7 @@ static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 }
 
 static void hdmi_mask_writeb(struct dw_hdmi *hdmi, u8 data, unsigned int reg,
-		      u8 shift, u8 mask)
+			     u8 shift, u8 mask)
 {
 	hdmi_modb(hdmi, data << shift, mask, reg);
 }
@@ -311,7 +311,7 @@ static unsigned int hdmi_compute_cts(unsigned int freq, unsigned long pixel_clk,
 }
 
 static void hdmi_set_clk_regenerator(struct dw_hdmi *hdmi,
-	unsigned long pixel_clk)
+				     unsigned long pixel_clk)
 {
 	unsigned int clk_n, clk_cts;
 
@@ -322,7 +322,7 @@ static void hdmi_set_clk_regenerator(struct dw_hdmi *hdmi,
 
 	if (!clk_cts) {
 		dev_dbg(hdmi->dev, "%s: pixel clock not supported: %lu\n",
-			 __func__, pixel_clk);
+			__func__, pixel_clk);
 		return;
 	}
 
@@ -461,13 +461,11 @@ static void dw_hdmi_update_csc_coeffs(struct dw_hdmi *hdmi)
 		u16 coeff_b = (*csc_coeff)[1][i];
 		u16 coeff_c = (*csc_coeff)[2][i];
 
-		hdmi_writeb(hdmi, coeff_a & 0xff,
-			HDMI_CSC_COEF_A1_LSB + i * 2);
+		hdmi_writeb(hdmi, coeff_a & 0xff, HDMI_CSC_COEF_A1_LSB + i * 2);
 		hdmi_writeb(hdmi, coeff_a >> 8, HDMI_CSC_COEF_A1_MSB + i * 2);
 		hdmi_writeb(hdmi, coeff_b & 0xff, HDMI_CSC_COEF_B1_LSB + i * 2);
 		hdmi_writeb(hdmi, coeff_b >> 8, HDMI_CSC_COEF_B1_MSB + i * 2);
-		hdmi_writeb(hdmi, coeff_c & 0xff,
-			HDMI_CSC_COEF_C1_LSB + i * 2);
+		hdmi_writeb(hdmi, coeff_c & 0xff, HDMI_CSC_COEF_C1_LSB + i * 2);
 		hdmi_writeb(hdmi, coeff_c >> 8, HDMI_CSC_COEF_C1_MSB + i * 2);
 	}
 
@@ -519,21 +517,22 @@ static void hdmi_video_packetize(struct dw_hdmi *hdmi)
 	struct hdmi_data_info *hdmi_data = &hdmi->hdmi_data;
 	u8 val, vp_conf;
 
-	if (hdmi_data->enc_out_format == RGB
-		|| hdmi_data->enc_out_format == YCBCR444) {
-		if (!hdmi_data->enc_color_depth)
+	if (hdmi_data->enc_out_format == RGB ||
+	    hdmi_data->enc_out_format == YCBCR444) {
+		if (!hdmi_data->enc_color_depth) {
 			output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_BYPASS;
-		else if (hdmi_data->enc_color_depth == 8) {
+		} else if (hdmi_data->enc_color_depth == 8) {
 			color_depth = 4;
 			output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_BYPASS;
-		} else if (hdmi_data->enc_color_depth == 10)
+		} else if (hdmi_data->enc_color_depth == 10) {
 			color_depth = 5;
-		else if (hdmi_data->enc_color_depth == 12)
+		} else if (hdmi_data->enc_color_depth == 12) {
 			color_depth = 6;
-		else if (hdmi_data->enc_color_depth == 16)
+		} else if (hdmi_data->enc_color_depth == 16) {
 			color_depth = 7;
-		else
+		} else {
 			return;
+		}
 	} else if (hdmi_data->enc_out_format == YCBCR422_8BITS) {
 		if (!hdmi_data->enc_color_depth ||
 		    hdmi_data->enc_color_depth == 8)
@@ -545,8 +544,9 @@ static void hdmi_video_packetize(struct dw_hdmi *hdmi)
 		else
 			return;
 		output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_YCC422;
-	} else
+	} else {
 		return;
+	}
 
 	/* set the packetizer registers */
 	val = ((color_depth << HDMI_VP_PR_CD_COLOR_DEPTH_OFFSET) &
@@ -607,34 +607,34 @@ static void hdmi_video_packetize(struct dw_hdmi *hdmi)
 }
 
 static inline void hdmi_phy_test_clear(struct dw_hdmi *hdmi,
-						unsigned char bit)
+				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLR_OFFSET,
 		  HDMI_PHY_TST0_TSTCLR_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_enable(struct dw_hdmi *hdmi,
-						unsigned char bit)
+					unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTEN_OFFSET,
 		  HDMI_PHY_TST0_TSTEN_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_clock(struct dw_hdmi *hdmi,
-						unsigned char bit)
+				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLK_OFFSET,
 		  HDMI_PHY_TST0_TSTCLK_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_din(struct dw_hdmi *hdmi,
-						unsigned char bit)
+				     unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST1);
 }
 
 static inline void hdmi_phy_test_dout(struct dw_hdmi *hdmi,
-						unsigned char bit)
+				      unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST2);
 }
@@ -650,21 +650,21 @@ static bool hdmi_phy_wait_i2c_done(struct dw_hdmi *hdmi, int msec)
 }
 
 static void __hdmi_phy_i2c_write(struct dw_hdmi *hdmi, unsigned short data,
-			      unsigned char addr)
+				 unsigned char addr)
 {
 	hdmi_writeb(hdmi, 0xFF, HDMI_IH_I2CMPHY_STAT0);
 	hdmi_writeb(hdmi, addr, HDMI_PHY_I2CM_ADDRESS_ADDR);
 	hdmi_writeb(hdmi, (unsigned char)(data >> 8),
-		HDMI_PHY_I2CM_DATAO_1_ADDR);
+		    HDMI_PHY_I2CM_DATAO_1_ADDR);
 	hdmi_writeb(hdmi, (unsigned char)(data >> 0),
-		HDMI_PHY_I2CM_DATAO_0_ADDR);
+		    HDMI_PHY_I2CM_DATAO_0_ADDR);
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_OPERATION_ADDR_WRITE,
-		HDMI_PHY_I2CM_OPERATION_ADDR);
+		    HDMI_PHY_I2CM_OPERATION_ADDR);
 	hdmi_phy_wait_i2c_done(hdmi, 1000);
 }
 
 static int hdmi_phy_i2c_write(struct dw_hdmi *hdmi, unsigned short data,
-				     unsigned char addr)
+			      unsigned char addr)
 {
 	__hdmi_phy_i2c_write(hdmi, data, addr);
 	return 0;
@@ -760,7 +760,7 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 
 	hdmi_phy_test_clear(hdmi, 1);
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_SLAVE_ADDR_PHY_GEN2,
-			HDMI_PHY_I2CM_SLAVE_ADDR);
+		    HDMI_PHY_I2CM_SLAVE_ADDR);
 	hdmi_phy_test_clear(hdmi, 0);
 
 	/* PLL/MPLL Cfg - always match on final entry */
@@ -777,9 +777,8 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 			break;
 
 	if (curr_ctr[i].mpixelclock == (~0UL)) {
-		dev_err(hdmi->dev,
-				"Pixel clock %d - unsupported by HDMI\n",
-				hdmi->hdmi_data.video_mode.mpixelclock);
+		dev_err(hdmi->dev, "Pixel clock %d - unsupported by HDMI\n",
+			hdmi->hdmi_data.video_mode.mpixelclock);
 		return -EINVAL;
 	}
 
@@ -1143,21 +1142,21 @@ static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 	}
 
 	if ((hdmi->vic == 6) || (hdmi->vic == 7) ||
-		(hdmi->vic == 21) || (hdmi->vic == 22) ||
-		(hdmi->vic == 2) || (hdmi->vic == 3) ||
-		(hdmi->vic == 17) || (hdmi->vic == 18))
+	    (hdmi->vic == 21) || (hdmi->vic == 22) ||
+	    (hdmi->vic == 2) || (hdmi->vic == 3) ||
+	    (hdmi->vic == 17) || (hdmi->vic == 18))
 		hdmi->hdmi_data.colorimetry = HDMI_COLORIMETRY_ITU_601;
 	else
 		hdmi->hdmi_data.colorimetry = HDMI_COLORIMETRY_ITU_709;
 
 	if ((hdmi->vic == 10) || (hdmi->vic == 11) ||
-		(hdmi->vic == 12) || (hdmi->vic == 13) ||
-		(hdmi->vic == 14) || (hdmi->vic == 15) ||
-		(hdmi->vic == 25) || (hdmi->vic == 26) ||
-		(hdmi->vic == 27) || (hdmi->vic == 28) ||
-		(hdmi->vic == 29) || (hdmi->vic == 30) ||
-		(hdmi->vic == 35) || (hdmi->vic == 36) ||
-		(hdmi->vic == 37) || (hdmi->vic == 38))
+	    (hdmi->vic == 12) || (hdmi->vic == 13) ||
+	    (hdmi->vic == 14) || (hdmi->vic == 15) ||
+	    (hdmi->vic == 25) || (hdmi->vic == 26) ||
+	    (hdmi->vic == 27) || (hdmi->vic == 28) ||
+	    (hdmi->vic == 29) || (hdmi->vic == 30) ||
+	    (hdmi->vic == 35) || (hdmi->vic == 36) ||
+	    (hdmi->vic == 37) || (hdmi->vic == 38))
 		hdmi->hdmi_data.video_mode.mpixelrepetitionoutput = 1;
 	else
 		hdmi->hdmi_data.video_mode.mpixelrepetitionoutput = 0;
@@ -1186,9 +1185,9 @@ static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 	dw_hdmi_enable_video_path(hdmi);
 
 	/* not for DVI mode */
-	if (hdmi->hdmi_data.video_mode.mdvi)
+	if (hdmi->hdmi_data.video_mode.mdvi) {
 		dev_dbg(hdmi->dev, "%s DVI mode\n", __func__);
-	else {
+	} else {
 		dev_dbg(hdmi->dev, "%s CEA mode\n", __func__);
 
 		/* HDMI Initialization Step E - Configure audio */
@@ -1453,7 +1452,7 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 			dev_dbg(hdmi->dev, "EVENT=plugout\n");
 
 			hdmi_modb(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
-				HDMI_PHY_POL0);
+				  HDMI_PHY_POL0);
 
 			dw_hdmi_poweroff(hdmi);
 		}
@@ -1480,7 +1479,7 @@ static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 			 DRM_MODE_ENCODER_TMDS);
 
 	drm_connector_helper_add(&hdmi->connector,
-			&dw_hdmi_connector_helper_funcs);
+				 &dw_hdmi_connector_helper_funcs);
 	drm_connector_init(drm, &hdmi->connector, &dw_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
@@ -1531,11 +1530,11 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
 		hdmi->priv = hdmi->plat_data->setup(pdev);
 	/* Product and revision IDs */
 	dev_info(dev,
-		"Detected HDMI controller 0x%x:0x%x:0x%x:0x%x\n",
-		hdmi_readb(hdmi, HDMI_DESIGN_ID),
-		hdmi_readb(hdmi, HDMI_REVISION_ID),
-		hdmi_readb(hdmi, HDMI_PRODUCT_ID0),
-		hdmi_readb(hdmi, HDMI_PRODUCT_ID1));
+		 "Detected HDMI controller 0x%x:0x%x:0x%x:0x%x\n",
+		 hdmi_readb(hdmi, HDMI_DESIGN_ID),
+		 hdmi_readb(hdmi, HDMI_REVISION_ID),
+		 hdmi_readb(hdmi, HDMI_PRODUCT_ID0),
+		 hdmi_readb(hdmi, HDMI_PRODUCT_ID1));
 
 	initialize_hdmi_ih_mutes(hdmi);
 
-- 
1.9.1

