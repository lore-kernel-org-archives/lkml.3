Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab3BXWfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:35:50 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42445 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab3BXWft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:35:49 -0500
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: syamsidhardh@gmail.com, airlied@linux.ie, daniel.vetter@ffwll.ch
Subject: [PATCH] drm/i915: Fix missing variable initilization
Date: Mon, 25 Feb 2013 04:05:38 +0530
Message-Id: <1361745338-28522-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to initialize the variable wait to false.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/gpu/drm/i915/intel_ddi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index fc95ef0..5d0a687 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1391,8 +1391,8 @@ void intel_ddi_prepare_link_retrain(struct drm_encoder *encoder)
 	struct intel_dp *intel_dp = &intel_dig_port->dp;
 	struct drm_i915_private *dev_priv = encoder->dev->dev_private;
 	enum port port = intel_dig_port->port;
-	bool wait;
 	uint32_t val;
+	bool wait = false;
 
 	if (I915_READ(DP_TP_CTL(port)) & DP_TP_CTL_ENABLE) {
 		val = I915_READ(DDI_BUF_CTL(port));
-- 
1.7.9.5

