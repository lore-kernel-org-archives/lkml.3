Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaLRGbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:31:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaLRGbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:31:48 -0500
Date: Wed, 17 Dec 2014 22:31:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-2wuk8vahl7voz0ie55f07c9k@git.kernel.org>
Cc: hpa@zytor.com, jolsa@redhat.com, eranian@google.com, acme@redhat.com,
        tglx@linutronix.de, paulus@samba.org, fweisbec@gmail.com,
        dzickus@redhat.com, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, adrian.hunter@intel.com, peterz@infradead.org,
        bp@suse.de, efault@gmx.de, mingo@kernel.org
Reply-To: acme@redhat.com, eranian@google.com, paulus@samba.org,
        fweisbec@gmail.com, dzickus@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, jolsa@redhat.com, mingo@kernel.org, efault@gmx.de,
        adrian.hunter@intel.com, bp@suse.de, peterz@infradead.org,
        dsahern@gmail.com, linux-kernel@vger.kernel.org, namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Introduce asm-generic/bitops.h
Git-Commit-ID: 88bcea43fdad515074f03aee75616f6562cb8b95
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

Commit-ID:  88bcea43fdad515074f03aee75616f6562cb8b95
Gitweb:     http://git.kernel.org/tip/88bcea43fdad515074f03aee75616f6562cb8b95
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 16 Dec 2014 10:53:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:16:25 -0300

tools: Introduce asm-generic/bitops.h

In preparation for moving linux/bitops.h from tools/perf/util/ to
tools/include/.

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
Link: http://lkml.kernel.org/n/tip-2wuk8vahl7voz0ie55f07c9k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops.h     | 24 ++++++++++++++++++++++++
 tools/perf/MANIFEST                    |  3 ++-
 tools/perf/Makefile.perf               |  1 +
 tools/perf/util/include/linux/bitops.h | 17 ++++++++++-------
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
new file mode 100644
index 0000000..6dfd9d5
--- /dev/null
+++ b/tools/include/asm-generic/bitops.h
@@ -0,0 +1,24 @@
+#ifndef __TOOLS_ASM_GENERIC_BITOPS_H
+#define __TOOLS_ASM_GENERIC_BITOPS_H
+
+/*
+ * tools/ copied this from include/asm-generic/bitops.h, bit by bit as it needed
+ * some functions.
+ *
+ * For the benefit of those who are trying to port Linux to another
+ * architecture, here are some C-language equivalents.  You should
+ * recode these in the native assembly language, if at all possible.
+ *
+ * C language equivalents written by Theodore Ts'o, 9/26/92
+ */
+
+#include <asm-generic/bitops/__ffs.h>
+#include <asm-generic/bitops/find.h>
+
+#ifndef _TOOLS_LINUX_BITOPS_H_
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <asm-generic/bitops/atomic.h>
+
+#endif /* __TOOLS_ASM_GENERIC_BITOPS_H */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index bfd7e22..86f115c 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -7,8 +7,9 @@ tools/lib/symbol/kallsyms.h
 tools/lib/util/find_next_bit.c
 tools/include/asm/bug.h
 tools/include/asm-generic/bitops/atomic.h
-tools/include/asm-generic/bitops/find.h
 tools/include/asm-generic/bitops/__ffs.h
+tools/include/asm-generic/bitops/find.h
+tools/include/asm-generic/bitops.h
 tools/include/linux/compiler.h
 tools/include/linux/export.h
 tools/include/linux/hash.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1aef417..3a73a95 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -235,6 +235,7 @@ LIB_H += util/include/linux/bitops.h
 LIB_H += ../include/asm-generic/bitops/atomic.h
 LIB_H += ../include/asm-generic/bitops/find.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h
+LIB_H += ../include/asm-generic/bitops.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += ../include/linux/log2.h
 LIB_H += util/include/linux/const.h
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 292aade..5237bc9 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_LINUX_BITOPS_H_
-#define _PERF_LINUX_BITOPS_H_
+#ifndef _TOOLS_LINUX_BITOPS_H_
+#define _TOOLS_LINUX_BITOPS_H_
 
 #include <linux/kernel.h>
 #include <linux/compiler.h>
@@ -19,6 +19,14 @@
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 #define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
 
+/*
+ * Include this here because some architectures need generic_ffs/fls in
+ * scope
+ *
+ * XXX: this needs to be asm/bitops.h, when we get to per arch optimizations
+ */
+#include <asm-generic/bitops.h>
+
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
 	     (bit) < (size);					\
@@ -30,14 +38,9 @@
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-#include <asm-generic/bitops/atomic.h>
-
 static inline unsigned long hweight_long(unsigned long w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-#include <asm-generic/bitops/__ffs.h>
-#include <asm-generic/bitops/find.h>
-
 #endif
