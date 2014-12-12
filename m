Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbaLLACf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:35 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:40814 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995AbaLLACT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:19 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] lib: bitmap: Update bitmap_onto to unsigned
Date: Fri, 12 Dec 2014 01:01:50 +0100
Message-Id: <1418342514-21630-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the nbits parameter of bitmap_onto to unsigned int for
consistency with other bitmap_* functions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 2 +-
 lib/bitmap.c           | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 0106f02e5a93..bf29a08bb3db 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -137,7 +137,7 @@ extern void bitmap_remap(unsigned long *dst, const unsigned long *src,
 extern int bitmap_bitremap(int oldbit,
 		const unsigned long *old, const unsigned long *new, int bits);
 extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
-		const unsigned long *relmap, int bits);
+		const unsigned long *relmap, unsigned int bits);
 extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 		int sz, int bits);
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
diff --git a/lib/bitmap.c b/lib/bitmap.c
index b499ab6ada29..42d5886c3680 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -975,9 +975,9 @@ EXPORT_SYMBOL(bitmap_bitremap);
  * All bits in @dst not set by the above rule are cleared.
  */
 void bitmap_onto(unsigned long *dst, const unsigned long *orig,
-			const unsigned long *relmap, int bits)
+			const unsigned long *relmap, unsigned int bits)
 {
-	int n, m;       	/* same meaning as in above comment */
+	unsigned int n, m;       	/* same meaning as in above comment */
 
 	if (dst == orig)	/* following doesn't handle inplace mappings */
 		return;
-- 
2.1.3

