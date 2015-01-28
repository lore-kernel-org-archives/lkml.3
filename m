Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbbA2JGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:06:48 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44872 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754616AbbA2JGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:06:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/176] drm/vmwgfx: Fix fence event code
Date: Wed, 28 Jan 2015 15:28:21 +0100
Message-Id: <fc350ec820fa6851839f38d8a7de310ef7f5146f.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 89669e7a7f96be3ee8d9a22a071d7c0d3b4428fc upstream.

The commit "vmwgfx: Rework fence event action" introduced a number of bugs
that are fixed with this commit:

a) A forgotten return stateemnt.
b) An if statement with identical branches.

Reported-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Reviewed-by: Sinclair Yeh <syeh@vmware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index c62d20e8a6f1..ee742f14ddc2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1049,6 +1049,8 @@ int vmw_event_fence_action_create(struct drm_file *file_priv,
 	if (ret != 0)
 		goto out_no_queue;
 
+	return 0;
+
 out_no_queue:
 	event->base.destroy(&event->base);
 out_no_event:
@@ -1123,17 +1125,10 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 
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
2.2.2

