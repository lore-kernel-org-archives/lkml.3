Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883AbbA1F0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:26:34 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:50099 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761657AbbA1F0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:26:32 -0500
From: Behan Webster <behanw@converseincode.com>
To: torvalds@linux-foundation.org
Cc: behanw@converseincode.com, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "Christopher Li" <sparse@chrisli.org>
Subject: [PATCH] Mark inline functions as __maybe_unused
Date: Tue, 27 Jan 2015 21:26:19 -0800
Message-Id: <1422422779-3876-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clang warns if inline functions aren't used. By making them __maybe_unused
there is no warning for either gcc nor clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Christopher Li" <sparse@chrisli.org>
---
 include/linux/compiler-gcc.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 02ae99e..c7b98fb 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -53,14 +53,14 @@
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
-# define inline		inline		__attribute__((always_inline)) notrace
-# define __inline__	__inline__	__attribute__((always_inline)) notrace
-# define __inline	__inline	__attribute__((always_inline)) notrace
+# define inline		inline		__attribute__((always_inline)) notrace __maybe_unused
+# define __inline__	__inline__	__attribute__((always_inline)) notrace __maybe_unused
+# define __inline	__inline	__attribute__((always_inline)) notrace __maybe_unused
 #else
 /* A lot of inline functions can cause havoc with function tracing */
-# define inline		inline		notrace
-# define __inline__	__inline__	notrace
-# define __inline	__inline	notrace
+# define inline		inline		notrace __maybe_unused
+# define __inline__	__inline__	notrace __maybe_unused
+# define __inline	__inline	notrace __maybe_unused
 #endif
 
 #define __deprecated			__attribute__((deprecated))
-- 
1.9.1

