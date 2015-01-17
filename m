Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbbAQKMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:12:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44313 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbAQKMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:12:46 -0500
Date: Sat, 17 Jan 2015 02:11:31 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-a1e91dx3apzqw5kbdt7ut21s@git.kernel.org>
Cc: JBeulich@suse.com, efault@gmx.de, peterz@infradead.org, jolsa@redhat.com,
        namhyung@kernel.org, mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de, eranian@google.com,
        paulus@samba.org, bp@suse.de, dzickus@redhat.com, fweisbec@gmail.com
Reply-To: namhyung@kernel.org, jolsa@redhat.com, mingo@kernel.org,
        hpa@zytor.com, acme@redhat.com, dsahern@gmail.com, efault@gmx.de,
        JBeulich@suse.com, peterz@infradead.org, paulus@samba.org, bp@suse.de,
        dzickus@redhat.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, adrian.hunter@intel.com, eranian@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Remove bitops/
 hweight usage of bits in tools/perf
Git-Commit-ID: 25cd480e447eba47b8bdad1c9f95cadc074abc75
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

Commit-ID:  25cd480e447eba47b8bdad1c9f95cadc074abc75
Gitweb:     http://git.kernel.org/tip/25cd480e447eba47b8bdad1c9f95cadc074abc75
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 13 Jan 2015 10:19:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:29 -0300

tools: Remove bitops/hweight usage of bits in tools/perf

We need to use lib/hweight.c for that, just like we do for lib/rbtree.c,
so tools need to link hweight.o. For now do it directly, but we need to
have a tools/lib/lk.a or .so that collects these goodies...

Reported-by: Jan Beulich <JBeulich@suse.com>
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
Link: http://lkml.kernel.org/n/tip-a1e91dx3apzqw5kbdt7ut21s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops.h               |  2 ++
 tools/include/asm-generic/bitops/arch_hweight.h  |  1 +
 tools/include/asm-generic/bitops/const_hweight.h |  1 +
 tools/include/asm-generic/bitops/hweight.h       |  7 ++++++
 tools/include/linux/bitops.h                     |  7 +++++-
 tools/perf/MANIFEST                              |  6 +++++
 tools/perf/Makefile.perf                         |  7 +++++-
 tools/perf/util/hweight.c                        | 31 ------------------------
 tools/perf/util/include/asm/hweight.h            |  8 ------
 tools/perf/util/python-ext-sources               |  2 +-
 10 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
index 6eedba1..653d1ba 100644
--- a/tools/include/asm-generic/bitops.h
+++ b/tools/include/asm-generic/bitops.h
@@ -22,6 +22,8 @@
 #error only <linux/bitops.h> can be included directly
 #endif
 
+#include <asm-generic/bitops/hweight.h>
+
 #include <asm-generic/bitops/atomic.h>
 
 #endif /* __TOOLS_ASM_GENERIC_BITOPS_H */
diff --git a/tools/include/asm-generic/bitops/arch_hweight.h b/tools/include/asm-generic/bitops/arch_hweight.h
new file mode 100644
index 0000000..318bb2b
--- /dev/null
+++ b/tools/include/asm-generic/bitops/arch_hweight.h
@@ -0,0 +1 @@
+#include "../../../../include/asm-generic/bitops/arch_hweight.h"
diff --git a/tools/include/asm-generic/bitops/const_hweight.h b/tools/include/asm-generic/bitops/const_hweight.h
new file mode 100644
index 0000000..0afd644
--- /dev/null
+++ b/tools/include/asm-generic/bitops/const_hweight.h
@@ -0,0 +1 @@
+#include "../../../../include/asm-generic/bitops/const_hweight.h"
diff --git a/tools/include/asm-generic/bitops/hweight.h b/tools/include/asm-generic/bitops/hweight.h
new file mode 100644
index 0000000..290120c
--- /dev/null
+++ b/tools/include/asm-generic/bitops/hweight.h
@@ -0,0 +1,7 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_HWEIGHT_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_HWEIGHT_H_
+
+#include <asm-generic/bitops/arch_hweight.h>
+#include <asm-generic/bitops/const_hweight.h>
+
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index 26005a15..5ad9ee1 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -1,9 +1,9 @@
 #ifndef _TOOLS_LINUX_BITOPS_H_
 #define _TOOLS_LINUX_BITOPS_H_
 
+#include <asm/types.h>
 #include <linux/kernel.h>
 #include <linux/compiler.h>
-#include <asm/hweight.h>
 
 #ifndef __WORDSIZE
 #define __WORDSIZE (__SIZEOF_LONG__ * 8)
@@ -19,6 +19,11 @@
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 #define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
 
+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 83e2887..fbbfdc3 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -6,12 +6,15 @@ tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/lib/util/find_next_bit.c
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/arch_hweight.h
 tools/include/asm-generic/bitops/atomic.h
+tools/include/asm-generic/bitops/const_hweight.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/asm-generic/bitops/__fls.h
 tools/include/asm-generic/bitops/find.h
 tools/include/asm-generic/bitops/fls64.h
 tools/include/asm-generic/bitops/fls.h
+tools/include/asm-generic/bitops/hweight.h
 tools/include/asm-generic/bitops.h
 tools/include/linux/bitops.h
 tools/include/linux/compiler.h
@@ -19,6 +22,8 @@ tools/include/linux/export.h
 tools/include/linux/hash.h
 tools/include/linux/log2.h
 tools/include/linux/types.h
+include/asm-generic/bitops/arch_hweight.h
+include/asm-generic/bitops/const_hweight.h
 include/asm-generic/bitops/fls64.h
 include/asm-generic/bitops/__fls.h
 include/asm-generic/bitops/fls.h
@@ -29,6 +34,7 @@ include/linux/list.h
 include/linux/hash.h
 include/linux/stringify.h
 lib/find_next_bit.c
+lib/hweight.c
 lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1f71a32..aa6a504 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -232,12 +232,15 @@ LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += ../include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/arch_hweight.h
 LIB_H += ../include/asm-generic/bitops/atomic.h
+LIB_H += ../include/asm-generic/bitops/const_hweight.h
 LIB_H += ../include/asm-generic/bitops/find.h
 LIB_H += ../include/asm-generic/bitops/fls64.h
 LIB_H += ../include/asm-generic/bitops/fls.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h
 LIB_H += ../include/asm-generic/bitops/__fls.h
+LIB_H += ../include/asm-generic/bitops/hweight.h
 LIB_H += ../include/asm-generic/bitops.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += ../include/linux/log2.h
@@ -255,7 +258,6 @@ LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += ../include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
-LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
@@ -745,6 +747,9 @@ $(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/hweight.o: ../../lib/hweight.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 $(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/util/hweight.c b/tools/perf/util/hweight.c
deleted file mode 100644
index 5c1d0d0..0000000
--- a/tools/perf/util/hweight.c
+++ /dev/null
@@ -1,31 +0,0 @@
-#include <linux/bitops.h>
-
-/**
- * hweightN - returns the hamming weight of a N-bit word
- * @x: the word to weigh
- *
- * The Hamming Weight of a number is the total number of bits set in it.
- */
-
-unsigned int hweight32(unsigned int w)
-{
-	unsigned int res = w - ((w >> 1) & 0x55555555);
-	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
-	res = (res + (res >> 4)) & 0x0F0F0F0F;
-	res = res + (res >> 8);
-	return (res + (res >> 16)) & 0x000000FF;
-}
-
-unsigned long hweight64(__u64 w)
-{
-#if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
-#elif BITS_PER_LONG == 64
-	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
-	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
-	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
-	res = res + (res >> 8);
-	res = res + (res >> 16);
-	return (res + (res >> 32)) & 0x00000000000000FFul;
-#endif
-}
diff --git a/tools/perf/util/include/asm/hweight.h b/tools/perf/util/include/asm/hweight.h
deleted file mode 100644
index 36cf26d..0000000
--- a/tools/perf/util/include/asm/hweight.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef PERF_HWEIGHT_H
-#define PERF_HWEIGHT_H
-
-#include <linux/types.h>
-unsigned int hweight32(unsigned int w);
-unsigned long hweight64(__u64 w);
-
-#endif /* PERF_HWEIGHT_H */
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 16a475a..6c6a695 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -10,7 +10,7 @@ util/ctype.c
 util/evlist.c
 util/evsel.c
 util/cpumap.c
-util/hweight.c
+../../lib/hweight.c
 util/thread_map.c
 util/util.c
 util/xyarray.c
