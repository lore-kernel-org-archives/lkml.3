Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212AbaGCWrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:47:10 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42661 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810AbaGCWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:31 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 05/18] lib: bitmap: Remove unnecessary mask from bitmap_complement
Date: Fri,  4 Jul 2014 00:42:51 +0200
Message-Id: <1404427384-11422-6-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the extra bits are "don't care", there is no reason to mask the
last word to the used bits when complementing. This shaves off yet a
few bytes.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 2 +-
 lib/bitmap.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 21fb52f..f42d72d 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -225,7 +225,7 @@ static inline void bitmap_complement(unsigned long *dst, const unsigned long *sr
 			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
+		*dst = ~(*src);
 	else
 		__bitmap_complement(dst, src, nbits);
 }
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0f2f845..4387e3c 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -93,7 +93,7 @@ void __bitmap_complement(unsigned long *dst, const unsigned long *src, unsigned
 		dst[k] = ~src[k];
 
 	if (bits % BITS_PER_LONG)
-		dst[k] = ~src[k] & BITMAP_LAST_WORD_MASK(bits);
+		dst[k] = ~src[k];
 }
 EXPORT_SYMBOL(__bitmap_complement);
 
-- 
1.9.2

