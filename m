Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaJIVLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJIVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 059/163] drm/ast: open key before detect chips
Date: Thu,  9 Oct 2014 14:01:24 -0700
Message-Id: <1412888588-26755-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Y.C. Chen" <yc_chen@aspeedtech.com>

commit 8f372e250ae5f4a5faf87ca1a629d0ae59db65b6 upstream.

Some config settings like 3rd TX chips will not get correctly
if the extended reg is protected

Signed-off-by: Y.C. Chen <yc_chen@aspeedtech.com>
Reviewed-by: Egbert Eich <eich@suse.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index af0b868..df1266d 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -66,6 +66,7 @@ uint8_t ast_get_index_reg_mask(struct ast_private *ast,
 static int ast_detect_chip(struct drm_device *dev)
 {
 	struct ast_private *ast = dev->dev_private;
+	ast_open_key(ast);
 
 	if (dev->pdev->device == PCI_CHIP_AST1180) {
 		ast->chip = AST1100;
-- 
1.9.1

