Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3IKE7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3IKE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:08 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jKcOo5hfD7YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RvnpK7MUcl4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=qxhprz7Bzh8pFVeTsJcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042922.323765637@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>
Subject: [181/251] drm/ast: invalidate page tables when pinning a BO
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0181-drm-ast-invalidate-page-tables-when-pinning-a-BO.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 3ac65259328324de323dc006b52ff7c1a5b18d19 ]

same fix as cirrus and mgag200.

Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/ast/ast_ttm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 2a6027c..566934c 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -348,6 +348,7 @@ int ast_bo_create(struct drm_device *dev, int size, int align,
 
 	astbo->gem.driver_private = NULL;
 	astbo->bo.bdev = &ast->ttm.bdev;
+	astbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	ast_ttm_placement(astbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
-- 
1.7.10.4


