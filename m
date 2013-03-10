Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3CJNeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:34:24 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53420 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJNeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:34:23 -0400
From: Ghennadi Procopciuc <ghennadi.procopciuc1@gmail.com>
To: airlied@linux.ie
Cc: airlied@redhat.com, ghennadi.procopciuc1@gmail.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, davej@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] make 'vmw_fences_perform_actions' static
Date: Sun, 10 Mar 2013 15:34:14 +0200
Message-Id: <1362922454-13967-1-git-send-email-ghennadi.procopciuc1@gmail.com>
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
index e0846e6..2762fe3 100644
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
-- 
1.7.10.4

