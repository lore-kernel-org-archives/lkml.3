Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3I2Tzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:55:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab3I2T2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 22/49] drm/ast: fix the ast open key function
Date: Sun, 29 Sep 2013 12:26:56 -0700
Message-Id: <20130929191604.507792304@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 2e8378136f28bea960cec643d3fa5d843c9049ec upstream.

When porting from UMS I mistyped this from the wrong place, AST noticed
and pointed it out, so we should fix it to be like the X.org driver.

Reported-by: Y.C. Chen <yc_chen@aspeedtech.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ast/ast_drv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -177,7 +177,7 @@ uint8_t ast_get_index_reg_mask(struct as
 
 static inline void ast_open_key(struct ast_private *ast)
 {
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xA1, 0xFF, 0x04);
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0x80, 0xA8);
 }
 
 #define AST_VIDMEM_SIZE_8M    0x00800000


