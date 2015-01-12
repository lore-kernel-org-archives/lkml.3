Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbbALSSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:18:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbbALSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 077/216] drm/vmwgfx: Fix fence event code
Date: Mon, 12 Jan 2015 18:03:14 +0000
Message-Id: <1421085933-32536-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 89669e7a7f96be3ee8d9a22a071d7c0d3b4428fc upstream.

The commit "vmwgfx: Rework fence event action" introduced a number of bugs
that are fixed with this commit:

a) A forgotten return stateemnt.
b) An if statement with identical branches.

Reported-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Reviewed-by: Sinclair Yeh <syeh@vmware.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 436b013b4231..b65272d7ea56 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1049,6 +1049,8 @@ static int vmw_event_fence_action_create(struct drm_file *file_priv,
 	if (ret != 0)
 		goto out_no_queue;
 
+	return 0;
+
 out_no_queue:
 	event->base.destroy(&event->base);
 out_no_event:
@@ -1124,17 +1126,10 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 
 	BUG_ON(fence == NULL);
 
-	if (arg->flags & DRM_VMW_FE_FLAG_REQ_TIME)
-		ret = vmw_event_fence_action_create(file_priv, fence,
-						    arg->flags,
-						    arg->user_data,
-						    true);
-	else
-		ret = vmw_event_fence_action_create(file_priv, fence,
-						    arg->flags,
-						    arg->user_data,
-						    true);
-
+	ret = vmw_event_fence_action_create(file_priv, fence,
+					    arg->flags,
+					    arg->user_data,
+					    true);
 	if (unlikely(ret != 0)) {
 		if (ret != -ERESTARTSYS)
 			DRM_ERROR("Failed to attach event to fence.\n");
-- 
2.1.4

