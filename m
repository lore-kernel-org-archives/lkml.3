Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbbAZTJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:09:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52952 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbbAZTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:09:04 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH] drm/msm/mdp: full mode set if crtc enable state is changed
Date: Mon, 26 Jan 2015 14:08:46 -0500
Message-Id: <1422299326-8119-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crtc state may not reflect the current crtc state if drm_fb_helper_blank
is called to turn dpms off without turning crtc off. A full modeset in
this case to solve the problem.

Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
index eea209e..60d0f58 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
@@ -310,6 +310,13 @@ static int mdp5_crtc_atomic_check(struct drm_crtc *crtc,
 			return -EINVAL;
 	}
 
+	/*
+	 * check if the crtc state matches with the current state
+	 * if not match, force a full mode set
+	 */
+	if (state->enable != mdp5_crtc->enabled)
+		state->mode_changed = true;
+
 	/* verify that there are not too many planes attached to crtc
 	 * and that we don't have conflicting mixer stages:
 	 */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

