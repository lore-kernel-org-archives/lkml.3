Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3JaLJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:09:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33067 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3JaLJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:09:39 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, dri-devel@lists.freedesktop.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 2/5] DRM: Armada: Use devm_ioremap_resource
Date: Thu, 31 Oct 2013 16:38:04 +0530
Message-Id: <1383217687-12037-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
References: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, propagate the error code.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: dri-devel@lists.freedesktop.org
CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/armada/armada_crtc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_crtc.c b/drivers/gpu/drm/armada/armada_crtc.c
index d8e3982..2b6e7b7 100644
--- a/drivers/gpu/drm/armada/armada_crtc.c
+++ b/drivers/gpu/drm/armada/armada_crtc.c
@@ -1037,11 +1037,9 @@ int armada_drm_crtc_create(struct drm_device *dev, unsigned num,
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
1.7.9.5

