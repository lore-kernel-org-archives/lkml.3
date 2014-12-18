Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaLRGaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:30:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaLRGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:30:20 -0500
Date: Wed, 17 Dec 2014 22:29:35 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-gubysnp4a8hd98lxoeruak13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, peterz@infradead.org,
        adrian.hunter@intel.com, fweisbec@gmail.com, jolsa@redhat.com,
        hpa@zytor.com, paulus@samba.org, mingo@kernel.org, tglx@linutronix.de,
        bp@suse.de, efault@gmx.de, eranian@google.com, dsahern@gmail.com,
        namhyung@kernel.org, acme@redhat.com
Reply-To: hpa@zytor.com, jolsa@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dzickus@redhat.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, namhyung@kernel.org, dsahern@gmail.com,
        acme@redhat.com, efault@gmx.de, bp@suse.de, tglx@linutronix.de,
        mingo@kernel.org, paulus@samba.org, eranian@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Move __ffs implementation to tools/
 include/asm-generic/bitops/__ffs.h
Git-Commit-ID: 2dc0b9721956f4314364f68a99d8bef490870438
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2dc0b9721956f4314364f68a99d8bef490870438
Gitweb:     http://git.kernel.org/tip/2dc0b9721956f4314364f68a99d8bef490870438
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 15 Dec 2014 15:07:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:09:34 -0300

tools: Move __ffs implementation to tools/include/asm-generic/bitops/__ffs.h

To match the Linux kernel source code structure from where this code came from.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gubysnp4a8hd98lxoeruak13@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../include}/asm-generic/bitops/__ffs.h            |  8 ++---
 tools/perf/MANIFEST                                |  1 +
 tools/perf/Makefile.perf                           |  1 +
 tools/perf/util/include/linux/bitops.h             | 37 +---------------------
 4 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/include/asm-generic/bitops/__ffs.h b/tools/include/asm-generic/bitops/__ffs.h
similarity index 77%
copy from include/asm-generic/bitops/__ffs.h
copy to tools/include/asm-generic/bitops/__ffs.h
index 937d7c4..c941750 100644
--- a/include/asm-generic/bitops/__ffs.h
+++ b/tools/include/asm-generic/bitops/__ffs.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_GENERIC_BITOPS___FFS_H_
-#define _ASM_GENERIC_BITOPS___FFS_H_
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_
 
 #include <asm/types.h>
 
@@ -13,7 +13,7 @@ static __always_inline unsigned long __ffs(unsigned long word)
 {
 	int num = 0;
 
-#if BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64
 	if ((word & 0xffffffff) == 0) {
 		num += 32;
 		word >>= 32;
@@ -40,4 +40,4 @@ static __always_inline unsigned long __ffs(unsigned long word)
 	return num;
 }
 
-#endif /* _ASM_GENERIC_BITOPS___FFS_H_ */
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_ */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 344c4d3..39c0863 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -5,6 +5,7 @@ tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/__ffs.h
 tools/include/linux/compiler.h
 tools/include/linux/hash.h
 tools/include/linux/export.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 763e68f..dbf8ca6 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -232,6 +232,7 @@ LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/__ffs.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index c329416..762bb83 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -52,42 +52,7 @@ static inline unsigned long hweight_long(unsigned long w)
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
-/**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static __always_inline unsigned long __ffs(unsigned long word)
-{
-	int num = 0;
-
-#if BITS_PER_LONG == 64
-	if ((word & 0xffffffff) == 0) {
-		num += 32;
-		word >>= 32;
-	}
-#endif
-	if ((word & 0xffff) == 0) {
-		num += 16;
-		word >>= 16;
-	}
-	if ((word & 0xff) == 0) {
-		num += 8;
-		word >>= 8;
-	}
-	if ((word & 0xf) == 0) {
-		num += 4;
-		word >>= 4;
-	}
-	if ((word & 0x3) == 0) {
-		num += 2;
-		word >>= 2;
-	}
-	if ((word & 0x1) == 0)
-		num += 1;
-	return num;
-}
+#include <asm-generic/bitops/__ffs.h>
 
 typedef const unsigned long __attribute__((__may_alias__)) long_alias_t;
 
