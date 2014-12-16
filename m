Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaLPQ6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:58:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:46851 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaLPQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:58:03 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/18] tools: Move code originally from linux/log2.h to tools/include/linux/
Date: Tue, 16 Dec 2014 13:57:09 -0300
Message-Id: <1418749040-31807-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

>From tools/perf/util/include/linux, so that it becomes accessible to
other tools/.

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
Link: http://lkml.kernel.org/n/tip-uqohgzilp3ebd3cbybnf3luc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/log2.h | 26 ++++++++++++++++++++++++++
 tools/perf/MANIFEST        |  3 ++-
 tools/perf/Makefile.perf   |  1 +
 tools/perf/util/evlist.c   |  1 +
 tools/perf/util/util.h     | 11 -----------
 5 files changed, 30 insertions(+), 12 deletions(-)
 create mode 100644 tools/include/linux/log2.h

diff --git a/tools/include/linux/log2.h b/tools/include/linux/log2.h
new file mode 100644
index 000000000000..141b7665d842
--- /dev/null
+++ b/tools/include/linux/log2.h
@@ -0,0 +1,26 @@
+/* Integer base 2 logarithm calculation
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _TOOLS_LINUX_LOG2_H
+#define _TOOLS_LINUX_LOG2_H
+
+/*
+ *  Determine whether some value is a power of two, where zero is
+ * *not* considered a power of two.
+ */
+
+static inline __attribute__((const))
+bool is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
+#endif /* _TOOLS_LINUX_LOG2_H */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 39c08636357b..db7827fd2518 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -7,8 +7,9 @@ tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/linux/compiler.h
-tools/include/linux/hash.h
 tools/include/linux/export.h
+tools/include/linux/hash.h
+tools/include/linux/log2.h
 tools/include/linux/types.h
 include/linux/const.h
 include/linux/perf_event.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bfd86a32254a..bd6073e0dec7 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -234,6 +234,7 @@ LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h 
 LIB_H += ../include/linux/compiler.h
+LIB_H += ../include/linux/log2.h
 LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ac808680e61c..8eb92cf5d552 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -25,6 +25,7 @@
 
 #include <linux/bitops.h>
 #include <linux/hash.h>
+#include <linux/log2.h>
 
 static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 008b361b1758..25b22bbea066 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -269,17 +269,6 @@ void event_attr_init(struct perf_event_attr *attr);
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-/*
- *  Determine whether some value is a power of two, where zero is
- * *not* considered a power of two.
- */
-
-static inline __attribute__((const))
-bool is_power_of_2(unsigned long n)
-{
-	return (n != 0 && ((n & (n - 1)) == 0));
-}
-
 static inline unsigned next_pow2(unsigned x)
 {
 	if (!x)
-- 
1.9.3

