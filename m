Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbaFSSuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:50:01 -0400
Received: from sauhun.de ([89.238.76.85]:37034 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbaFSSt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:49:28 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/3] DRM: Armada: Use devm_ioremap_resource
Date: Thu, 19 Jun 2014 20:48:59 +0200
Message-Id: <1403203741-5113-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Behera <tushar.behera@linaro.org>

While at it, propagate the error code.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpu/drm/armada/armada_crtc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_crtc.c b/drivers/gpu/drm/armada/armada_crtc.c
index 81c34f949dfc..3aedf9e993e6 100644
--- a/drivers/gpu/drm/armada/armada_crtc.c
+++ b/drivers/gpu/drm/armada/armada_crtc.c
@@ -1039,11 +1039,9 @@ int armada_drm_crtc_create(struct drm_device *dev, unsigned num,
 	if (ret)
 		return ret;
 
-	base = devm_request_and_ioremap(dev->dev, res);
-	if (!base) {
-		DRM_ERROR("failed to ioremap register\n");
-		return -ENOMEM;
-	}
+	base = devm_ioremap_resource(dev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	dcrtc = kzalloc(sizeof(*dcrtc), GFP_KERNEL);
 	if (!dcrtc) {
-- 
2.0.0

