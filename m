Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaAFOcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:32:46 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60926 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAFOco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:32:44 -0500
Date: Mon, 6 Jan 2014 20:02:39 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org, David Airlie <airlied@linux.ie>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 03/85] drivers: gpu: Mark functions as static in ast_mode.c
Message-ID: <a150684494c2187f15cbb4606337b0fc81902d57.1389018324.git.rashika.kheria@gmail.com>
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

Mark functions ast_set_sync_reg(), ast_set_dac_reg(),
ast_set_start_address_crt1(), ast_crtc_init(), ast_encoder_init(),
ast_connector_init(), ast_cursor_init(), ast_cursor_fini(),
ast_show_cursor() and ast_hide_cursor() as static in drm/ast/ast_mode.c
because they are not used outside this file.

This eliminates the following warning in drm/ast/ast_mode.c:
drivers/gpu/drm/ast/ast_mode.c:407:6: warning: no previous prototype for
‘ast_set_sync_reg’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:418:6: warning: no previous prototype for
‘ast_set_dac_reg’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:430:6: warning: no previous prototype for
‘ast_set_start_address_crt1’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:626:5: warning: no previous prototype for
‘ast_crtc_init’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:713:5: warning: no previous prototype for
‘ast_encoder_init’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:780:5: warning: no previous prototype for
‘ast_connector_init’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:813:5: warning: no previous prototype for
‘ast_cursor_init’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:850:6: warning: no previous prototype for
‘ast_cursor_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:968:6: warning: no previous prototype for
‘ast_show_cursor’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_mode.c:979:6: warning: no previous prototype for
‘ast_hide_cursor’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/ast/ast_mode.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 7fc9f72..cca063b 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -404,7 +404,7 @@ static void ast_set_ext_reg(struct drm_crtc *crtc, struct drm_display_mode *mode
 	}
 }
 
-void ast_set_sync_reg(struct drm_device *dev, struct drm_display_mode *mode,
+static void ast_set_sync_reg(struct drm_device *dev, struct drm_display_mode *mode,
 		      struct ast_vbios_mode_info *vbios_mode)
 {
 	struct ast_private *ast = dev->dev_private;
@@ -415,7 +415,7 @@ void ast_set_sync_reg(struct drm_device *dev, struct drm_display_mode *mode,
 	ast_io_write8(ast, AST_IO_MISC_PORT_WRITE, jreg);
 }
 
-bool ast_set_dac_reg(struct drm_crtc *crtc, struct drm_display_mode *mode,
+static bool ast_set_dac_reg(struct drm_crtc *crtc, struct drm_display_mode *mode,
 		     struct ast_vbios_mode_info *vbios_mode)
 {
 	switch (crtc->fb->bits_per_pixel) {
@@ -427,7 +427,7 @@ bool ast_set_dac_reg(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	return true;
 }
 
-void ast_set_start_address_crt1(struct drm_crtc *crtc, unsigned offset)
+static void ast_set_start_address_crt1(struct drm_crtc *crtc, unsigned offset)
 {
 	struct ast_private *ast = crtc->dev->dev_private;
 	u32 addr;
@@ -623,7 +623,7 @@ static const struct drm_crtc_funcs ast_crtc_funcs = {
 	.destroy = ast_crtc_destroy,
 };
 
-int ast_crtc_init(struct drm_device *dev)
+static int ast_crtc_init(struct drm_device *dev)
 {
 	struct ast_crtc *crtc;
 	int i;
@@ -710,7 +710,7 @@ static const struct drm_encoder_helper_funcs ast_enc_helper_funcs = {
 	.mode_set = ast_encoder_mode_set,
 };
 
-int ast_encoder_init(struct drm_device *dev)
+static int ast_encoder_init(struct drm_device *dev)
 {
 	struct ast_encoder *ast_encoder;
 
@@ -777,7 +777,7 @@ static const struct drm_connector_funcs ast_connector_funcs = {
 	.destroy = ast_connector_destroy,
 };
 
-int ast_connector_init(struct drm_device *dev)
+static int ast_connector_init(struct drm_device *dev)
 {
 	struct ast_connector *ast_connector;
 	struct drm_connector *connector;
@@ -810,7 +810,7 @@ int ast_connector_init(struct drm_device *dev)
 }
 
 /* allocate cursor cache and pin at start of VRAM */
-int ast_cursor_init(struct drm_device *dev)
+static int ast_cursor_init(struct drm_device *dev)
 {
 	struct ast_private *ast = dev->dev_private;
 	int size;
@@ -847,7 +847,7 @@ fail:
 	return ret;
 }
 
-void ast_cursor_fini(struct drm_device *dev)
+static void ast_cursor_fini(struct drm_device *dev)
 {
 	struct ast_private *ast = dev->dev_private;
 	ttm_bo_kunmap(&ast->cache_kmap);
@@ -965,7 +965,7 @@ static void ast_i2c_destroy(struct ast_i2c_chan *i2c)
 	kfree(i2c);
 }
 
-void ast_show_cursor(struct drm_crtc *crtc)
+static void ast_show_cursor(struct drm_crtc *crtc)
 {
 	struct ast_private *ast = crtc->dev->dev_private;
 	u8 jreg;
@@ -976,7 +976,7 @@ void ast_show_cursor(struct drm_crtc *crtc)
 	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xcb, 0xfc, jreg);
 }
 
-void ast_hide_cursor(struct drm_crtc *crtc)
+static void ast_hide_cursor(struct drm_crtc *crtc)
 {
 	struct ast_private *ast = crtc->dev->dev_private;
 	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xcb, 0xfc, 0x00);
-- 
1.7.9.5

