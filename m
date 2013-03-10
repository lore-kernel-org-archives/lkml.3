Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3CJNnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:43:32 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51007 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJNnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:43:31 -0400
From: Ghennadi Procopciuc <ghennadi.procopciuc1@gmail.com>
To: airlied@linux.ie
Cc: ghennadi.procopciuc1@gmail.com, airlied@redhat.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, davej@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] make 'vmw_fence_obj_add_action' static
Date: Sun, 10 Mar 2013 15:43:22 +0200
Message-Id: <1362923002-561-1-git-send-email-ghennadi.procopciuc1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following checkpatch warning :
drivers/gpu/drm/vmwgfx/vmwgfx_fence.c:274:6: warning: symbol
'vmw_fences_perform_actions' was not declared. Should it be static?

Signed-off-by: Ghennadi Procopciuc <ghennadi.procopciuc1@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 2762fe3..07a463f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -897,7 +897,7 @@ static void vmw_event_fence_action_cleanup(struct vmw_fence_action *action)
  * Note that the action callbacks may be executed before this function
  * returns.
  */
-void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
+static void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
 			      struct vmw_fence_action *action)
 {
 	struct vmw_fence_manager *fman = fence->fman;
-- 
1.7.10.4

