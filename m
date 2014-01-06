Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbaAFQv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:51:28 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55464 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaAFQv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:51:26 -0500
Date: Mon, 6 Jan 2014 22:21:21 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 85/85] drivers: gpu: Mark functions as static in
 vmwgfx_fence.c
Message-ID: <d81293e7879c5ae27dabc33cdf5b3c3f56630a48.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static because they are not used outside the file
drm/vmwgfx/vmwgfx_fence.c.

This eliminates the following warnings in drm/vmwgfx/vmwgfx_fence.c:
drivers/gpu/drm/vmwgfx/vmwgfx_fence.c:274:6: warning: no previous prototype for ‘vmw_fences_perform_actions’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_fence.c:900:6: warning: no previous prototype for ‘vmw_fence_obj_add_action’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_fence.c:996:5: warning: no previous prototype for ‘vmw_event_fence_action_create’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index c62d20e..79c060d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -271,7 +271,7 @@ void vmw_fence_obj_unreference(struct vmw_fence_obj **fence_p)
 	spin_unlock_irq(&fman->lock);
 }
 
-void vmw_fences_perform_actions(struct vmw_fence_manager *fman,
+static void vmw_fences_perform_actions(struct vmw_fence_manager *fman,
 				struct list_head *list)
 {
 	struct vmw_fence_action *action, *next_action;
@@ -897,7 +897,7 @@ static void vmw_event_fence_action_cleanup(struct vmw_fence_action *action)
  * Note that the action callbacks may be executed before this function
  * returns.
  */
-void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
+static void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
 			      struct vmw_fence_action *action)
 {
 	struct vmw_fence_manager *fman = fence->fman;
@@ -993,7 +993,7 @@ struct vmw_event_fence_pending {
 	struct drm_vmw_event_fence event;
 };
 
-int vmw_event_fence_action_create(struct drm_file *file_priv,
+static int vmw_event_fence_action_create(struct drm_file *file_priv,
 				  struct vmw_fence_obj *fence,
 				  uint32_t flags,
 				  uint64_t user_data,
-- 
1.7.9.5

