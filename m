Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaJ0TJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:09:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaJ0TEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 081/105] drm/ast: Fix HW cursor image
Date: Mon, 27 Oct 2014 11:56:56 -0700
Message-Id: <1414436240-13879-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 1e99cfa8de0f0879091e33cd65fd60418d006ad9 upstream.

The translation from the X driver to the KMS one typo'ed a couple
of array indices, causing the HW cursor to look weird (blocky with
leaking edge colors). This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_mode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 7fc9f72..e8f6418 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1012,8 +1012,8 @@ static u32 copy_cursor_image(u8 *src, u8 *dst, int width, int height)
 			srcdata32[1].ul = *((u32 *)(srcxor + 4)) & 0xf0f0f0f0;
 			data32.b[0] = srcdata32[0].b[1] | (srcdata32[0].b[0] >> 4);
 			data32.b[1] = srcdata32[0].b[3] | (srcdata32[0].b[2] >> 4);
-			data32.b[2] = srcdata32[0].b[1] | (srcdata32[1].b[0] >> 4);
-			data32.b[3] = srcdata32[0].b[3] | (srcdata32[1].b[2] >> 4);
+			data32.b[2] = srcdata32[1].b[1] | (srcdata32[1].b[0] >> 4);
+			data32.b[3] = srcdata32[1].b[3] | (srcdata32[1].b[2] >> 4);
 
 			writel(data32.ul, dstxor);
 			csum += data32.ul;
-- 
1.9.1

