Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaKYKmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaKYKl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 119/254] drm/ast: Fix HW cursor image
Date: Tue, 25 Nov 2014 10:37:49 +0000
Message-Id: <1416912004-5928-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 1e99cfa8de0f0879091e33cd65fd60418d006ad9 upstream.

The translation from the X driver to the KMS one typo'ed a couple
of array indices, causing the HW cursor to look weird (blocky with
leaking edge colors). This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ast/ast_mode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 114aee941d46..1550d80ea2bc 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1088,8 +1088,8 @@ static u32 copy_cursor_image(u8 *src, u8 *dst, int width, int height)
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
2.1.0

