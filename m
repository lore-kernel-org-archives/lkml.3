Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaLALVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:21:49 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:49889 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaLALVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:21:47 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <e03deffe4ad65951b6e9af9b07f95cff>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v14 01/12] drm: imx: imx-hdmi: make checkpatch happy
Date: Mon,  1 Dec 2014 19:21:16 +0800
Message-Id: <1417432876-12769-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com>
References: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com>
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
Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

---

Changes in v14: None
Changes in v13:
- patch against drm-next

Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6:
- rearrange the patch order

Changes in v5: None
Changes in v4:
- fix checkpatch CHECK

Changes in v3: None

 drivers/gpu/drm/imx/imx-hdmi.c | 97 +++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-hdmi.c b/drivers/gpu/drm/imx/imx-hdmi.c
index aaec6b2..79daec4 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.c
+++ b/drivers/gpu/drm/imx/imx-hdmi.c
@@ -163,7 +163,7 @@ static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 }
 
 static void hdmi_mask_writeb(struct imx_hdmi *hdmi, u8 data, unsigned int reg,
-		      u8 shift, u8 mask)
+			     u8 shift, u8 mask)
 {
 	hdmi_modb(hdmi, data << shift, mask, reg);
 }
@@ -327,7 +327,7 @@ static unsigned int hdmi_compute_cts(unsigned int freq, unsigned long pixel_clk,
 }
 
 static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
-	unsigned long pixel_clk)
+				     unsigned long pixel_clk)
 {
 	unsigned int clk_n, clk_cts;
 
@@ -338,7 +338,7 @@ static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
 
 	if (!clk_cts) {
 		dev_dbg(hdmi->dev, "%s: pixel clock not supported: %lu\n",
-			 __func__, pixel_clk);
+			__func__, pixel_clk);
 		return;
 	}
 
@@ -477,13 +477,11 @@ static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
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
 
@@ -535,21 +533,22 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
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
@@ -561,8 +560,9 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 		else
 			return;
 		output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_YCC422;
-	} else
+	} else {
 		return;
+	}
 
 	/* set the packetizer registers */
 	val = ((color_depth << HDMI_VP_PR_CD_COLOR_DEPTH_OFFSET) &
@@ -623,34 +623,34 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 }
 
 static inline void hdmi_phy_test_clear(struct imx_hdmi *hdmi,
-						unsigned char bit)
+				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLR_OFFSET,
 		  HDMI_PHY_TST0_TSTCLR_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_enable(struct imx_hdmi *hdmi,
-						unsigned char bit)
+					unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTEN_OFFSET,
 		  HDMI_PHY_TST0_TSTEN_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_clock(struct imx_hdmi *hdmi,
-						unsigned char bit)
+				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLK_OFFSET,
 		  HDMI_PHY_TST0_TSTCLK_MASK, HDMI_PHY_TST0);
 }
 
 static inline void hdmi_phy_test_din(struct imx_hdmi *hdmi,
-						unsigned char bit)
+				     unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST1);
 }
 
 static inline void hdmi_phy_test_dout(struct imx_hdmi *hdmi,
-						unsigned char bit)
+				      unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST2);
 }
@@ -666,21 +666,21 @@ static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
 }
 
 static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
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
 
 static int hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
-				     unsigned char addr)
+			      unsigned char addr)
 {
 	__hdmi_phy_i2c_write(hdmi, data, addr);
 	return 0;
@@ -839,7 +839,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 
 	hdmi_phy_test_clear(hdmi, 1);
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_SLAVE_ADDR_PHY_GEN2,
-			HDMI_PHY_I2CM_SLAVE_ADDR);
+		    HDMI_PHY_I2CM_SLAVE_ADDR);
 	hdmi_phy_test_clear(hdmi, 0);
 
 	/* PLL/MPLL Cfg - always match on final entry */
@@ -857,9 +857,8 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 			break;
 
 	if (i >= ARRAY_SIZE(curr_ctrl)) {
-		dev_err(hdmi->dev,
-				"Pixel clock %d - unsupported by HDMI\n",
-				hdmi->hdmi_data.video_mode.mpixelclock);
+		dev_err(hdmi->dev, "Pixel clock %d - unsupported by HDMI\n",
+			hdmi->hdmi_data.video_mode.mpixelclock);
 		return -EINVAL;
 	}
 
@@ -1223,21 +1222,21 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
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
@@ -1266,9 +1265,9 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	imx_hdmi_enable_video_path(hdmi);
 
 	/* not for DVI mode */
-	if (hdmi->hdmi_data.video_mode.mdvi)
+	if (hdmi->hdmi_data.video_mode.mdvi) {
 		dev_dbg(hdmi->dev, "%s DVI mode\n", __func__);
-	else {
+	} else {
 		dev_dbg(hdmi->dev, "%s CEA mode\n", __func__);
 
 		/* HDMI Initialization Step E - Configure audio */
@@ -1525,7 +1524,7 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 			dev_dbg(hdmi->dev, "EVENT=plugout\n");
 
 			hdmi_modb(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
-				HDMI_PHY_POL0);
+				  HDMI_PHY_POL0);
 
 			imx_hdmi_poweroff(hdmi);
 		}
@@ -1554,7 +1553,7 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 			 DRM_MODE_ENCODER_TMDS);
 
 	drm_connector_helper_add(&hdmi->connector,
-			&imx_hdmi_connector_helper_funcs);
+				 &imx_hdmi_connector_helper_funcs);
 	drm_connector_init(drm, &hdmi->connector, &imx_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
@@ -1671,11 +1670,11 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 
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


