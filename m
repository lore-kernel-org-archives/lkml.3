Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbaLLACd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:33 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38003 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114AbaLLACU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:20 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] lib: bitmap: Change parameters of bitmap_fold to unsigned
Date: Fri, 12 Dec 2014 01:01:51 +0100
Message-Id: <1418342514-21630-6-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the sz and nbits parameters of bitmap_fold to unsigned int for
consistency with other bitmap_* functions, and to save another few
bytes in the generated code.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 2 +-
 lib/bitmap.c           | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index bf29a08bb3db..85e8fb091ed7 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -139,7 +139,7 @@ extern int bitmap_bitremap(int oldbit,
 extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
 		const unsigned long *relmap, unsigned int bits);
 extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
-		int sz, int bits);
+		unsigned int sz, unsigned int nbits);
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 42d5886c3680..1807d089eda7 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1015,15 +1015,15 @@ EXPORT_SYMBOL(bitmap_onto);
  * Example [2] for bitmap_onto() for why and how to use this.
  */
 void bitmap_fold(unsigned long *dst, const unsigned long *orig,
-			int sz, int bits)
+			unsigned int sz, unsigned int nbits)
 {
-	int oldbit;
+	unsigned int oldbit;
 
 	if (dst == orig)	/* following doesn't handle inplace mappings */
 		return;
-	bitmap_zero(dst, bits);
+	bitmap_zero(dst, nbits);
 
-	for_each_set_bit(oldbit, orig, bits)
+	for_each_set_bit(oldbit, orig, nbits)
 		set_bit(oldbit % sz, dst);
 }
 EXPORT_SYMBOL(bitmap_fold);
-- 
2.1.3

