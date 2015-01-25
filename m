Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbbAYSJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:09:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbbAYSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Sinclair Yeh <syeh@vmware.com>
Subject: [PATCH 3.10 07/50] drm/vmwgfx: Fix fence event code
Date: Sun, 25 Jan 2015 10:06:57 -0800
Message-Id: <20150125180702.988159281@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1049,6 +1049,8 @@ int vmw_event_fence_action_create(struct
 	if (ret != 0)
 		goto out_no_queue;
 
+	return 0;
+
 out_no_queue:
 	event->base.destroy(&event->base);
 out_no_event:
@@ -1123,17 +1125,10 @@ int vmw_fence_event_ioctl(struct drm_dev
 
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


