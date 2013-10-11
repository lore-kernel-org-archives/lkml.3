Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab3JKLNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:13:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3JKKmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 002/100] drm/ast: fix the ast open key function
Date: Fri, 11 Oct 2013 11:40:32 +0100
Message-Id: <1381488130-30235-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 2e8378136f28bea960cec643d3fa5d843c9049ec upstream.

When porting from UMS I mistyped this from the wrong place, AST noticed
and pointed it out, so we should fix it to be like the X.org driver.

Reported-by: Y.C. Chen <yc_chen@aspeedtech.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ast/ast_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 85a6eeb..49920a7 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -176,7 +176,7 @@ uint8_t ast_get_index_reg_mask(struct ast_private *ast,
 
 static inline void ast_open_key(struct ast_private *ast)
 {
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xA1, 0xFF, 0x04);
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0x80, 0xA8);
 }
 
 #define AST_VIDMEM_SIZE_8M    0x00800000
-- 
1.8.3.2

