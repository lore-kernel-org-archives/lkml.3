Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3JJPue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:50:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628Ab3JJPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 034/104] drm/ast: fix the ast open key function
Date: Thu, 10 Oct 2013 08:41:22 -0700
Message-Id: <1381419752-29733-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 2e8378136f28bea960cec643d3fa5d843c9049ec upstream.

When porting from UMS I mistyped this from the wrong place, AST noticed
and pointed it out, so we should fix it to be like the X.org driver.

Reported-by: Y.C. Chen <yc_chen@aspeedtech.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index cac9c9a..848f04b 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -175,7 +175,7 @@ uint8_t ast_get_index_reg_mask(struct ast_private *ast,
 
 static inline void ast_open_key(struct ast_private *ast)
 {
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xA1, 0xFF, 0x04);
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0x80, 0xA8);
 }
 
 #define AST_VIDMEM_SIZE_8M    0x00800000
-- 
1.8.1.2

