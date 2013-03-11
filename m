Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3CKUmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:42:00 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48437 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3CKUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:41:58 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: gpu: drm: i915: Replaced calls to kmalloc & memcpy with kmemdup
Date: Mon, 11 Mar 2013 22:39:42 +0200
Message-Id: <1363034382-22752-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to kmalloc followed by memcpy with a single call to kmemdup.
Also removed a now redundant if statement.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f61cb79..3cf8aed 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2335,11 +2335,8 @@ intel_dp_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
 			return NULL;
 
 		size = (intel_connector->edid->extensions + 1) * EDID_LENGTH;
-		edid = kmalloc(size, GFP_KERNEL);
-		if (!edid)
-			return NULL;
+		edid = kmemdup(intel_connector->edid, size, GFP_KERNEL);
 
-		memcpy(edid, intel_connector->edid, size);
 		return edid;
 	}
 
-- 
1.7.9.5

