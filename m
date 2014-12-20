Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaLTWmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:42:23 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58453 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLTWmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:42:20 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: ast: ast_dp501.c:  Remove unused function
Date: Sat, 20 Dec 2014 23:45:07 +0100
Message-Id: <1419115507-12672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ast_load_dp501_microcode() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/ast/ast_dp501.c |   12 ------------
 drivers/gpu/drm/ast/ast_drv.h   |    1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_dp501.c b/drivers/gpu/drm/ast/ast_dp501.c
index 76f07f3..28c977c 100644
--- a/drivers/gpu/drm/ast/ast_dp501.c
+++ b/drivers/gpu/drm/ast/ast_dp501.c
@@ -4,18 +4,6 @@
 #include "ast_drv.h"
 MODULE_FIRMWARE("ast_dp501_fw.bin");
 
-int ast_load_dp501_microcode(struct drm_device *dev)
-{
-	struct ast_private *ast = dev->dev_private;
-	static char *fw_name = "ast_dp501_fw.bin";
-	int err;
-	err = request_firmware(&ast->dp501_fw, fw_name, dev->dev);
-	if (err)
-		return err;
-
-	return 0;
-}
-
 static void send_ack(struct ast_private *ast)
 {
 	u8 sendack;
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 86205a2..67a872d 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -393,7 +393,6 @@ void ast_post_gpu(struct drm_device *dev);
 u32 ast_mindwm(struct ast_private *ast, u32 r);
 void ast_moutdwm(struct ast_private *ast, u32 r, u32 v);
 /* ast dp501 */
-int ast_load_dp501_microcode(struct drm_device *dev);
 void ast_set_dp501_video_output(struct drm_device *dev, u8 mode);
 bool ast_launch_m68k(struct drm_device *dev);
 bool ast_backup_fw(struct drm_device *dev, u8 *addr, u32 size);
-- 
1.7.10.4

