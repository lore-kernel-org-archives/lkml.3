Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaLRGat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:30:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58650 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaLRGar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:30:47 -0500
Date: Wed, 17 Dec 2014 22:29:55 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-uqohgzilp3ebd3cbybnf3luc@git.kernel.org>
Cc: namhyung@kernel.org, adrian.hunter@intel.com, acme@redhat.com,
        jolsa@redhat.com, bp@suse.de, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, dzickus@redhat.com,
        eranian@google.com, tglx@linutronix.de, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, efault@gmx.de
Reply-To: paulus@samba.org, peterz@infradead.org, tglx@linutronix.de,
        eranian@google.com, dzickus@redhat.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, efault@gmx.de, dsahern@gmail.com,
        adrian.hunter@intel.com, namhyung@kernel.org, jolsa@redhat.com,
        acme@redhat.com, mingo@kernel.org, bp@suse.de, hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Move code originally from linux/
 log2.h to tools/include/linux/
Git-Commit-ID: 0389cd1f5fda34c14941c37a39547d16af5d56e2
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

Commit-ID:  0389cd1f5fda34c14941c37a39547d16af5d56e2
Gitweb:     http://git.kernel.org/tip/0389cd1f5fda34c14941c37a39547d16af5d56e2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 15 Dec 2014 16:04:11 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:09:41 -0300

tools: Move code originally from linux/log2.h to tools/include/linux/

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
 fs/no-block.c => tools/include/linux/log2.h | 21 ++++++++++++---------
 tools/perf/MANIFEST                         |  3 ++-
 tools/perf/Makefile.perf                    |  1 +
 tools/perf/util/evlist.c                    |  1 +
 tools/perf/util/util.h                      | 11 -----------
 5 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/no-block.c b/tools/include/linux/log2.h
similarity index 51%
copy from fs/no-block.c
copy to tools/include/linux/log2.h
index 6e40e42..141b766 100644
--- a/fs/no-block.c
+++ b/tools/include/linux/log2.h
@@ -1,4 +1,4 @@
-/* no-block.c: implementation of routines required for non-BLOCK configuration
+/* Integer base 2 logarithm calculation
  *
  * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -9,15 +9,18 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/kernel.h>
-#include <linux/fs.h>
+#ifndef _TOOLS_LINUX_LOG2_H
+#define _TOOLS_LINUX_LOG2_H
 
-static int no_blkdev_open(struct inode * inode, struct file * filp)
+/*
+ *  Determine whether some value is a power of two, where zero is
+ * *not* considered a power of two.
+ */
+
+static inline __attribute__((const))
+bool is_power_of_2(unsigned long n)
 {
-	return -ENODEV;
+	return (n != 0 && ((n & (n - 1)) == 0));
 }
 
-const struct file_operations def_blk_fops = {
-	.open		= no_blkdev_open,
-	.llseek		= noop_llseek,
-};
+#endif /* _TOOLS_LINUX_LOG2_H */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 39c0863..db7827f 100644
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
index dbf8ca6..ec2be64 100644
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
index ac80868..8eb92cf 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -25,6 +25,7 @@
 
 #include <linux/bitops.h>
 #include <linux/hash.h>
+#include <linux/log2.h>
 
 static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 008b361..25b22bb 100644
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
