Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3HPX63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:58:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab3HPWkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 105/133] drm/ast: invalidate page tables when pinning a BO
Date: Fri, 16 Aug 2013 15:34:07 -0700
Message-Id: <1376692475-28413-106-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 3ac65259328324de323dc006b52ff7c1a5b18d19 upstream.

same fix as cirrus and mgag200.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 09da339..d5902e2 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -348,6 +348,7 @@ int ast_bo_create(struct drm_device *dev, int size, int align,
 
 	astbo->gem.driver_private = NULL;
 	astbo->bo.bdev = &ast->ttm.bdev;
+	astbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	ast_ttm_placement(astbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
-- 
1.8.1.2

