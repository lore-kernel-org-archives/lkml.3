Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbaGCWoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:44:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33325 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaGCWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:46 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 16/18] lib: bitmap: Add missing mask in bitmap_shift_right
Date: Fri,  4 Jul 2014 00:43:02 +0200
Message-Id: <1404427384-11422-17-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no guarantee that *src does not contain garbage bits outside
the lower nbits, so we need to mask it before the shift-and-assign.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 2100378..75df61d 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -284,7 +284,7 @@ static inline void bitmap_shift_right(unsigned long *dst,
 			const unsigned long *src, int n, int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = *src >> n;
+		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> n;
 	else
 		__bitmap_shift_right(dst, src, n, nbits);
 }
-- 
1.9.2

