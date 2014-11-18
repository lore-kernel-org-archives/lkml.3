Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbaKROga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:36:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbaKROKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 095/206] drm/ast: Fix HW cursor image
Date: Tue, 18 Nov 2014 15:07:30 +0100
Message-Id: <3055e72f042a7e5566f02ca2be609426ba6f6efa.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1e99cfa8de0f0879091e33cd65fd60418d006ad9 upstream.

The translation from the X driver to the KMS one typo'ed a couple
of array indices, causing the HW cursor to look weird (blocky with
leaking edge colors). This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/ast/ast_mode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 7fc9f7272b56..e8f6418b6dec 100644
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
2.1.3

