Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbaLLACV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:21 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:52423 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbaLLACR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:17 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] lib: bitmap: More signed->unsigned conversions
Date: Fri, 12 Dec 2014 01:01:47 +0100
Message-Id: <1418342514-21630-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency with the other bitmap_* functions, also make the nbits
parameter of bitmap_zero, bitmap_fill and bitmap_copy unsigned.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index e1c8d080c427..0106f02e5a93 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -156,33 +156,33 @@ extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
 #define small_const_nbits(nbits) \
 	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
 
-static inline void bitmap_zero(unsigned long *dst, int nbits)
+static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = 0UL;
 	else {
-		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+		unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
 		memset(dst, 0, len);
 	}
 }
 
-static inline void bitmap_fill(unsigned long *dst, int nbits)
+static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
 {
-	size_t nlongs = BITS_TO_LONGS(nbits);
+	unsigned int nlongs = BITS_TO_LONGS(nbits);
 	if (!small_const_nbits(nbits)) {
-		int len = (nlongs - 1) * sizeof(unsigned long);
+		unsigned int len = (nlongs - 1) * sizeof(unsigned long);
 		memset(dst, 0xff,  len);
 	}
 	dst[nlongs - 1] = BITMAP_LAST_WORD_MASK(nbits);
 }
 
 static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
-			int nbits)
+			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src;
 	else {
-		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+		unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
 		memcpy(dst, src, len);
 	}
 }
-- 
2.1.3

