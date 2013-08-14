Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3HNNIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:08:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51048 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3HNNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:08:15 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] tile: use asm-generic/bitops/builtin-*.h
Date: Wed, 14 Aug 2013 22:07:30 +0900
Message-Id: <1376485650-5227-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definisions of __ffs(), __fls(), and ffs() for tile are almost same
as asm-generic/bitops-*.h.  The only difference is that it is defined
as __always_inline or inline.  So this switches to use those headers.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/bitops.h | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
index bd186c4..a7ac45e 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -28,16 +28,7 @@
 #include <asm/bitops_32.h>
 #endif
 
-/**
- * __ffs - find first set bit in word
- * @word: The word to search
- *
- * Undefined if no set bit exists, so code should check against 0 first.
- */
-static inline unsigned long __ffs(unsigned long word)
-{
-	return __builtin_ctzl(word);
-}
+#include <asm-generic/bitops/builtin-__ffs.h>
 
 /**
  * ffz - find first zero bit in word
@@ -50,32 +41,9 @@ static inline unsigned long ffz(unsigned long word)
 	return __builtin_ctzl(~word);
 }
 
-/**
- * __fls - find last set bit in word
- * @word: The word to search
- *
- * Undefined if no set bit exists, so code should check against 0 first.
- */
-static inline unsigned long __fls(unsigned long word)
-{
-	return (sizeof(word) * 8) - 1 - __builtin_clzl(word);
-}
+#include <asm-generic/bitops/builtin-__fls.h>
 
-/**
- * ffs - find first set bit in word
- * @x: the word to search
- *
- * This is defined the same way as the libc and compiler builtin ffs
- * routines, therefore differs in spirit from the other bitops.
- *
- * ffs(value) returns 0 if value is 0 or the position of the first
- * set bit if value is nonzero. The first (least significant) bit
- * is at position 1.
- */
-static inline int ffs(int x)
-{
-	return __builtin_ffs(x);
-}
+#include <asm-generic/bitops/builtin-ffs.h>
 
 static inline int fls64(__u64 w)
 {
-- 
1.8.3.1

