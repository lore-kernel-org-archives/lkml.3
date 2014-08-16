Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaHPTTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 15:19:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaHPTTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 15:19:13 -0400
From: Colin King <colin.king@canonical.com>
To: David Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: fix asssignment of vmw_bo_p to NULL
Date: Sat, 16 Aug 2014 20:19:08 +0100
Message-Id: <1408216748-4839-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

cppcheck detected an incorrect assignment:

 [drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c:903]: (warning) Assignment
 of function parameter has no effect outside the function. Did you
 forget dereferencing it?

the original assigment didn't do anything, instead *vmw_bo_p should
be set to NULL.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 7bfdaa1..b1632c4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -917,7 +917,7 @@ static int vmw_translate_mob_ptr(struct vmw_private *dev_priv,
 
 out_no_reloc:
 	vmw_dmabuf_unreference(&vmw_bo);
-	vmw_bo_p = NULL;
+	*vmw_bo_p = NULL;
 	return ret;
 }
 
-- 
2.1.0.rc1

