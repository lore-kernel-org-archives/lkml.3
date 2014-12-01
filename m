Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaLAUKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:10:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33249 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbaLAUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:10:17 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH 1/4] drm/msm/hdmi: use HPD interrupt to track connector status change
Date: Mon,  1 Dec 2014 15:09:40 -0500
Message-Id: <1417464580-29411-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPD interrupt can be tracked for each connector, so don't need
to poll the connector status for state change.

Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
index 4aca2a3..92fddd8 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
@@ -242,7 +242,7 @@ hotplug_work(struct work_struct *work)
 	struct hdmi_connector *hdmi_connector =
 		container_of(work, struct hdmi_connector, hpd_work);
 	struct drm_connector *connector = &hdmi_connector->base;
-	drm_helper_hpd_irq_event(connector->dev);
+	drm_kms_helper_hotplug_event(connector->dev);
 }
 
 void hdmi_connector_irq(struct drm_connector *connector)
@@ -431,9 +431,6 @@ struct drm_connector *hdmi_connector_init(struct hdmi *hdmi)
 			DRM_MODE_CONNECTOR_HDMIA);
 	drm_connector_helper_add(connector, &hdmi_connector_helper_funcs);
 
-	connector->polled = DRM_CONNECTOR_POLL_CONNECT |
-			DRM_CONNECTOR_POLL_DISCONNECT;
-
 	connector->interlace_allowed = 1;
 	connector->doublescan_allowed = 0;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

