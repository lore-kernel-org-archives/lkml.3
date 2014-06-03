Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaFCMko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:40:44 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64703 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaFCMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:40:43 -0400
Date: Tue, 3 Jun 2014 14:40:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot changes for v3.16
Message-ID: <20140603124038.GA27513@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   # HEAD: a9a17104a112a67a7bf0679b734704c130eb5faa x86, boot: Remove misc.h inclusion from compressed/string.c

Two small cleanups.

 Thanks,

	Ingo

------------------>
Vivek Goyal (2):
      x86, boot: Do not include boot.h in string.c
      x86, boot: Remove misc.h inclusion from compressed/string.c


 arch/x86/boot/compressed/string.c | 4 ----
 arch/x86/boot/string.c            | 9 ++-------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index f3c57e3..00e788b 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,9 +1,5 @@
-#include "misc.h"
 #include "../string.c"
 
-/* misc.h might pull in string_32.h which has a macro for memcpy. undef that */
-#undef memcpy
-
 #ifdef CONFIG_X86_32
 void *memcpy(void *dest, const void *src, size_t n)
 {
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 5339040..493f3fd 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -12,14 +12,9 @@
  * Very basic string functions
  */
 
-#include "boot.h"
+#include <linux/types.h>
+#include "ctype.h"
 
-/*
- * This file gets included in compressed/string.c which might pull in
- * string_32.h and which in turn maps memcmp to __builtin_memcmp(). Undo
- * that first.
- */
-#undef memcmp
 int memcmp(const void *s1, const void *s2, size_t len)
 {
 	u8 diff;
