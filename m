Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbaGCWnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:43:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60869 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772AbaGCWn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:28 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 03/18] lib: bitmap: Make nbits parameter of bitmap_equal unsigned
Date: Fri,  4 Jul 2014 00:42:49 +0200
Message-Id: <1404427384-11422-4-git-send-email-linux@rasmusvillemoes.dk>
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
 include/linux/bitmap.h | 2 +-
 lib/bitmap.c           | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index bc7e520..1e0f46c 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -91,7 +91,7 @@
 extern int __bitmap_empty(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_full(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
-                	const unsigned long *bitmap2, int bits);
+			  const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
 			int bits);
 extern void __bitmap_shift_right(unsigned long *dst,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 9859f38..d6bb955 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -71,9 +71,9 @@ int __bitmap_full(const unsigned long *bitmap, unsigned int bits)
 EXPORT_SYMBOL(__bitmap_full);
 
 int __bitmap_equal(const unsigned long *bitmap1,
-		const unsigned long *bitmap2, int bits)
+		const unsigned long *bitmap2, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (bitmap1[k] != bitmap2[k])
 			return 0;
-- 
1.9.2

