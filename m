Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaAFO5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:57:54 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40528 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaAFO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:57:53 -0500
Date: Mon, 6 Jan 2014 20:27:48 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 04/85] drivers: gpu: Mark functions as static in ast_ttm.c
Message-ID: <a622093ba82d67cb5905fb7aa16e4cdf8415fdf7.1389018324.git.rashika.kheria@gmail.com>
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

Mark functions ast_ttm_global_release(), ast_ttm_bo_is_ast_bo() and
ast_ttm_tt_create() as static in drm/ast/ast_ttm.c because they are not
used outside this file.

This eliminates the following warnings in drm/ast/ast_ttm.c:
drivers/gpu/drm/ast/ast_ttm.c:84:1: warning: no previous prototype for
‘ast_ttm_global_release’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_ttm.c:105:6: warning: no previous prototype for
‘ast_ttm_bo_is_ast_bo’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_ttm.c:211:16: warning: no previous prototype for
‘ast_ttm_tt_create’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/ast/ast_ttm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 32aecb3..4ea9b17 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -80,7 +80,7 @@ static int ast_ttm_global_init(struct ast_private *ast)
 	return 0;
 }
 
-void
+static void
 ast_ttm_global_release(struct ast_private *ast)
 {
 	if (ast->ttm.mem_global_ref.release == NULL)
@@ -102,7 +102,7 @@ static void ast_bo_ttm_destroy(struct ttm_buffer_object *tbo)
 	kfree(bo);
 }
 
-bool ast_ttm_bo_is_ast_bo(struct ttm_buffer_object *bo)
+static bool ast_ttm_bo_is_ast_bo(struct ttm_buffer_object *bo)
 {
 	if (bo->destroy == &ast_bo_ttm_destroy)
 		return true;
@@ -208,7 +208,7 @@ static struct ttm_backend_func ast_tt_backend_func = {
 };
 
 
-struct ttm_tt *ast_ttm_tt_create(struct ttm_bo_device *bdev,
+static struct ttm_tt *ast_ttm_tt_create(struct ttm_bo_device *bdev,
 				 unsigned long size, uint32_t page_flags,
 				 struct page *dummy_read_page)
 {
-- 
1.7.9.5

