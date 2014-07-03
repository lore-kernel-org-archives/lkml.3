Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbaGCWsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:48:01 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:47889 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692AbaGCWnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:25 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 01/18] lib: bitmap: Make nbits parameter of bitmap_empty unsigned
Date: Fri,  4 Jul 2014 00:42:47 +0200
Message-Id: <1404427384-11422-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler can generate slightly smaller and simpler code when it
knows that "nbits" is non-negative. Since no-one passes a
negative bit-count, this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 4 ++--
 lib/bitmap.c           | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7ad6345..3d3fd6b 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -88,7 +88,7 @@
  * lib/bitmap.c provides these functions:
  */
 
-extern int __bitmap_empty(const unsigned long *bitmap, int bits);
+extern int __bitmap_empty(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_full(const unsigned long *bitmap, int bits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
                 	const unsigned long *bitmap2, int bits);
@@ -257,7 +257,7 @@ static inline int bitmap_subset(const unsigned long *src1,
 		return __bitmap_subset(src1, src2, nbits);
 }
 
-static inline int bitmap_empty(const unsigned long *src, int nbits)
+static inline int bitmap_empty(const unsigned long *src, unsigned nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06f7e4f..3789110 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -40,9 +40,9 @@
  * for the best explanations of this ordering.
  */
 
-int __bitmap_empty(const unsigned long *bitmap, int bits)
+int __bitmap_empty(const unsigned long *bitmap, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (bitmap[k])
 			return 0;
-- 
1.9.2

