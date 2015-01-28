Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763965AbbA2DQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:16:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762155AbbA2CgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 077/139] drm/vmwgfx: Fix fence event code
Date: Wed, 28 Jan 2015 14:20:20 -0800
Message-Id: <1422483682-15393-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index dc338fe..425a81b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1032,6 +1032,8 @@ int vmw_event_fence_action_create(struct drm_file *file_priv,
 	if (ret != 0)
 		goto out_no_queue;
 
+	return 0;
+
 out_no_queue:
 	event->base.destroy(&event->base);
 out_no_event:
@@ -1106,17 +1108,10 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 
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
1.9.1

