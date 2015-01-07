Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbbAGV23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:28:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57126 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbbAGV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:27:51 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 2/3] drm/msm/hdmi: Add HDMI platform config for apq8084
Date: Wed,  7 Jan 2015 16:27:26 -0500
Message-Id: <1420666047-3690-3-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1420666047-3690-1-git-send-email-sviau@codeaurora.org>
References: <1420666047-3690-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change add the regulator/clock configuration for MDP5 v1.3.
This config is close to the one already existing for 8x74, except
that one more regulator is needed (hpd-5v-en).

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 Documentation/devicetree/bindings/drm/msm/hdmi.txt |  1 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/drm/msm/hdmi.txt b/Documentation/devicetree/bindings/drm/msm/hdmi.txt
index aca917f..c25d5aa 100644
--- a/Documentation/devicetree/bindings/drm/msm/hdmi.txt
+++ b/Documentation/devicetree/bindings/drm/msm/hdmi.txt
@@ -2,6 +2,7 @@ Qualcomm adreno/snapdragon hdmi output
 
 Required properties:
 - compatible: one of the following
+   * "qcom,hdmi-tx-8084"
    * "qcom,hdmi-tx-8660"
    * "qcom,hdmi-tx-8960"
 - reg: Physical base address and length of the controller's registers
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index a9092d6..c2fe4fa 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -334,6 +334,22 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 		config.hpd_clk_cnt   = ARRAY_SIZE(hpd_clk_names);
 		config.pwr_clk_names = pwr_clk_names;
 		config.pwr_clk_cnt   = ARRAY_SIZE(pwr_clk_names);
+	} else if (of_device_is_compatible(of_node, "qcom,hdmi-tx-8084")) {
+		static const char *hpd_reg_names[] = {"hpd-gdsc", "hpd-5v", "hpd-5v-en"};
+		static const char *pwr_reg_names[] = {"core-vdda", "core-vcc"};
+		static const char *hpd_clk_names[] = {"iface_clk", "core_clk", "mdp_core_clk"};
+		static unsigned long hpd_clk_freq[] = {0, 19200000, 0};
+		static const char *pwr_clk_names[] = {"extp_clk", "alt_iface_clk"};
+		config.phy_init      = hdmi_phy_8x74_init;
+		config.hpd_reg_names = hpd_reg_names;
+		config.hpd_reg_cnt   = ARRAY_SIZE(hpd_reg_names);
+		config.pwr_reg_names = pwr_reg_names;
+		config.pwr_reg_cnt   = ARRAY_SIZE(pwr_reg_names);
+		config.hpd_clk_names = hpd_clk_names;
+		config.hpd_freq      = hpd_clk_freq;
+		config.hpd_clk_cnt   = ARRAY_SIZE(hpd_clk_names);
+		config.pwr_clk_names = pwr_clk_names;
+		config.pwr_clk_cnt   = ARRAY_SIZE(pwr_clk_names);
 	} else if (of_device_is_compatible(of_node, "qcom,hdmi-tx-8960")) {
 		static const char *hpd_clk_names[] = {"core_clk", "master_iface_clk", "slave_iface_clk"};
 		static const char *hpd_reg_names[] = {"core-vdda", "hdmi-mux"};
@@ -439,6 +455,7 @@ static int hdmi_dev_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id dt_match[] = {
+	{ .compatible = "qcom,hdmi-tx-8084" },
 	{ .compatible = "qcom,hdmi-tx-8074" },
 	{ .compatible = "qcom,hdmi-tx-8960" },
 	{ .compatible = "qcom,hdmi-tx-8660" },
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

