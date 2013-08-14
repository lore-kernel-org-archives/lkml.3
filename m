Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3HNNH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:07:57 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45789 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3HNNH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:07:56 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH] ia64: use asm-generic/bitops/builtin-ffs.h
Date: Wed, 14 Aug 2013 22:06:59 +0900
Message-Id: <1376485619-5166-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definision of ffs() for ia64 is almost same as
asm-generic/bitops/builtin-ffs.h.  The only difference is that it is
defined as inline function or macro function.  So this switches to use
the header.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/include/asm/bitops.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 8e20bff..c27eccd 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -425,13 +425,7 @@ __fls (unsigned long x)
 
 #include <asm-generic/bitops/fls64.h>
 
-/*
- * ffs: find first bit set. This is defined the same way as the libc and
- * compiler builtin ffs routines, therefore differs in spirit from the above
- * ffz (man ffs): it operates on "int" values only and the result value is the
- * bit number + 1.  ffs(0) is defined to return zero.
- */
-#define ffs(x)	__builtin_ffs(x)
+#include <asm-generic/bitops/builtin-ffs.h>
 
 /*
  * hweightN: returns the hamming weight (i.e. the number
-- 
1.8.3.1

