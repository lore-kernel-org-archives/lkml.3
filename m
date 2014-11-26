Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaKZURT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:17:19 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50689 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:17:18 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH 3/4] drm/msm/hdmi: rework HDMI IRQ hanlder
Date: Wed, 26 Nov 2014 15:17:11 -0500
Message-Id: <1417033031-11966-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the HPD interrupt when acking it, to avoid spurious
interrupt.

Change-Id: Icb64d7fa813380c7ffa3047058503ebab13ff4c4
Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
index caa1301..c458348 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
@@ -251,11 +251,11 @@ void hdmi_connector_irq(struct drm_connector *connector)
 			(hpd_int_status & HDMI_HPD_INT_STATUS_INT)) {
 		bool detected = !!(hpd_int_status & HDMI_HPD_INT_STATUS_CABLE_DETECTED);
 
-		DBG("status=%04x, ctrl=%04x", hpd_int_status, hpd_int_ctrl);
-
-		/* ack the irq: */
+		/* ack & disable (temporarily) HPD events: */
 		hdmi_write(hdmi, REG_HDMI_HPD_INT_CTRL,
-				hpd_int_ctrl | HDMI_HPD_INT_CTRL_INT_ACK);
+			HDMI_HPD_INT_CTRL_INT_ACK);
+
+		DBG("status=%04x, ctrl=%04x", hpd_int_status, hpd_int_ctrl);
 
 		/* detect disconnect if we are connected or visa versa: */
 		hpd_int_ctrl = HDMI_HPD_INT_CTRL_INT_EN;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

