Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaGVQth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:49:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbaGVQtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:49:35 -0400
Date: Tue, 22 Jul 2014 12:49:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: jakob@vmware.com
Subject: vmwgfx: remove identical branches
Message-ID: <20140722164927.GA21479@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jakob@vmware.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8b7de6aa8468: "vmwgfx: Rework fence event action" removed the
tv_sec & tv_usec arguments to vmw_event_fence_action_create, which meant
that both sides of the if/else are now exactly the same.

Remove the flag check, and just do it unconditionally.

Spotted with Coverity.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 436b013b4231..a078e6bbaf0a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1124,16 +1124,10 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 
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
+	ret = vmw_event_fence_action_create(file_priv, fence,
+					    arg->flags,
+					    arg->user_data,
+					    true);
 
 	if (unlikely(ret != 0)) {
 		if (ret != -ERESTARTSYS)
