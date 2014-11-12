Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090AbaKLDw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:52:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaKLB1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:27:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.17 104/319] drm/ast: Fix HW cursor image
Date: Wed, 12 Nov 2014 10:14:02 +0900
Message-Id: <20141112011009.800160245@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 1e99cfa8de0f0879091e33cd65fd60418d006ad9 upstream.

The translation from the X driver to the KMS one typo'ed a couple
of array indices, causing the HW cursor to look weird (blocky with
leaking edge colors). This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ast/ast_mode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1080,8 +1080,8 @@ static u32 copy_cursor_image(u8 *src, u8
 			srcdata32[1].ul = *((u32 *)(srcxor + 4)) & 0xf0f0f0f0;
 			data32.b[0] = srcdata32[0].b[1] | (srcdata32[0].b[0] >> 4);
 			data32.b[1] = srcdata32[0].b[3] | (srcdata32[0].b[2] >> 4);
-			data32.b[2] = srcdata32[0].b[1] | (srcdata32[1].b[0] >> 4);
-			data32.b[3] = srcdata32[0].b[3] | (srcdata32[1].b[2] >> 4);
+			data32.b[2] = srcdata32[1].b[1] | (srcdata32[1].b[0] >> 4);
+			data32.b[3] = srcdata32[1].b[3] | (srcdata32[1].b[2] >> 4);
 
 			writel(data32.ul, dstxor);
 			csum += data32.ul;


