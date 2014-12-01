Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaLAUM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:12:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33645 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAUMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:12:54 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH 4/4] drm/msm/hdmi: don't call clk_round_rate to check hdmi pclk for MDP5
Date: Mon,  1 Dec 2014 15:12:47 -0500
Message-Id: <1417464767-29596-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock driver can support dynamic rate settings for HDMI
pixelclock, so don't need to use clk_round_rate to check if the
clockrate for specific mode is supported therefore more display
modes can be supported.

Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
index c458348..cf18896 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
@@ -355,8 +355,6 @@ static int hdmi_connector_mode_valid(struct drm_connector *connector,
 				 struct drm_display_mode *mode)
 {
 	struct hdmi_connector *hdmi_connector = to_hdmi_connector(connector);
-	struct hdmi *hdmi = hdmi_connector->hdmi;
-	const struct hdmi_platform_config *config = hdmi->config;
 	struct msm_drm_private *priv = connector->dev->dev_private;
 	struct msm_kms *kms = priv->kms;
 	long actual, requested;
@@ -365,13 +363,6 @@ static int hdmi_connector_mode_valid(struct drm_connector *connector,
 	actual = kms->funcs->round_pixclk(kms,
 			requested, hdmi_connector->hdmi->encoder);
 
-	/* for mdp5/apq8074, we manage our own pixel clk (as opposed to
-	 * mdp4/dtv stuff where pixel clk is assigned to mdp/encoder
-	 * instead):
-	 */
-	if (config->pwr_clk_cnt > 0)
-		actual = clk_round_rate(hdmi->pwr_clks[0], actual);
-
 	DBG("requested=%ld, actual=%ld", requested, actual);
 
 	if (actual != requested)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

