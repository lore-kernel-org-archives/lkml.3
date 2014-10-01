Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaJASgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:36:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57515 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbaJASgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:36:35 -0400
Date: Wed, 1 Oct 2014 11:36:32 -0700
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, boot: fix warning on 32-bit builds
Message-ID: <20141001183632.GA11431@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building 32-bit threw a warning on kASLR enabled builds:

arch/x86/boot/compressed/aslr.c: In function ‘mem_avoid_overlap’:
arch/x86/boot/compressed/aslr.c:198:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   avoid.start = (u64)ptr;
                 ^

This fixes the warning; unsigned long should have been used here.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index d39189ba7f8e..f302dc45ce08 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -195,7 +195,7 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 	while (ptr) {
 		struct mem_vector avoid;
 
-		avoid.start = (u64)ptr;
+		avoid.start = (unsigned long)ptr;
 		avoid.size = sizeof(*ptr) + ptr->len;
 
 		if (mem_overlaps(img, &avoid))
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
