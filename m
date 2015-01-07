Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbbAGVcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:32:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57353 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbbAGVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:31:59 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH] drm/msm/mdp5: fix parameter type for mdp5_ctl_set_intf()
Date: Wed,  7 Jan 2015 16:31:42 -0500
Message-Id: <1420666302-5159-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mdp5_ctl_set_intf()'s second argument should be "int", not "enum mdp5_intf".
The passed in value is "intf", not "intf_id".

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c | 2 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
index dea4505..1511290 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
@@ -95,7 +95,7 @@ u32 ctl_read(struct mdp5_ctl *ctl, u32 reg)
 }
 
 
-int mdp5_ctl_set_intf(struct mdp5_ctl *ctl, enum mdp5_intf intf)
+int mdp5_ctl_set_intf(struct mdp5_ctl *ctl, int intf)
 {
 	unsigned long flags;
 	static const enum mdp5_intfnum intfnum[] = {
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h
index 1018519..ad48788 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h
@@ -34,7 +34,7 @@ void mdp5_ctlm_destroy(struct mdp5_ctl_manager *ctlm);
  */
 struct mdp5_ctl *mdp5_ctlm_request(struct mdp5_ctl_manager *ctlm, struct drm_crtc *crtc);
 
-int mdp5_ctl_set_intf(struct mdp5_ctl *ctl, enum mdp5_intf intf);
+int mdp5_ctl_set_intf(struct mdp5_ctl *ctl, int intf);
 
 int mdp5_ctl_set_cursor(struct mdp5_ctl *ctl, bool enable);
 
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

