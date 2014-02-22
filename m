Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaBVSAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:00:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaBVR7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:59:54 -0500
Date: Sat, 22 Feb 2014 09:59:04 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-cd0cfad74eb88e54ba9d205da3ed376e48981448@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org,
        peterz@infradead.org, penberg@kernel.org, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
        arjan@linux.intel.com, namhyung@gmail.com, stfomichev@yandex-team.ru,
        adrian.hunter@intel.com, bp@suse.de, rric@kernel.org
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com, efault@gmx.de,
        penberg@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, paulus@samba.org, arjan@linux.intel.com,
        namhyung@gmail.com, stfomichev@yandex-team.ru, adrian.hunter@intel.com,
        bp@suse.de, rric@kernel.org
In-Reply-To: <1386605664-24041-3-git-send-email-bp@alien8.de>
References: <1386605664-24041-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move fs.* to lib/api/fs/
Git-Commit-ID: cd0cfad74eb88e54ba9d205da3ed376e48981448
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

Commit-ID:  cd0cfad74eb88e54ba9d205da3ed376e48981448
Gitweb:     http://git.kernel.org/tip/cd0cfad74eb88e54ba9d205da3ed376e48981448
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 9 Dec 2013 17:14:24 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:49 -0300

perf tools: Move fs.* to lib/api/fs/

Move to generic library and kill magic.h as it is needed only in fs.h.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386605664-24041-3-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/Makefile                                     |  2 ++
 tools/{perf/util => lib/api/fs}/fs.c                       | 11 ++++++++---
 tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} | 12 +++++-------
 tools/perf/Makefile.perf                                   |  3 ---
 tools/perf/tests/parse-events.c                            |  2 +-
 tools/perf/util/cpumap.c                                   |  2 +-
 tools/perf/util/fs.h                                       |  7 -------
 tools/perf/util/pmu.c                                      |  2 +-
 tools/perf/util/python-ext-sources                         |  2 +-
 tools/perf/util/record.c                                   |  2 +-
 tools/perf/util/util.c                                     |  2 +-
 11 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index ed2f51e..ce00f7e 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -9,8 +9,10 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += fs/debugfs.h
+LIB_H += fs/fs.h
 
 LIB_OBJS += $(OUTPUT)fs/debugfs.o
+LIB_OBJS += $(OUTPUT)fs/fs.o
 
 LIBFILE = libapikfs.a
 
diff --git a/tools/perf/util/fs.c b/tools/lib/api/fs/fs.c
similarity index 91%
rename from tools/perf/util/fs.c
rename to tools/lib/api/fs/fs.c
index f5be1f2..5b5eb78 100644
--- a/tools/perf/util/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -1,8 +1,13 @@
+/* TODO merge/factor in debugfs.c here */
 
-/* TODO merge/factor into tools/lib/lk/debugfs.c */
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/vfs.h>
 
-#include "util.h"
-#include "util/fs.h"
+#include "debugfs.h"
+#include "fs.h"
 
 static const char * const sysfs__fs_known_mountpoints[] = {
 	"/sys",
diff --git a/tools/perf/util/include/linux/magic.h b/tools/lib/api/fs/fs.h
similarity index 50%
rename from tools/perf/util/include/linux/magic.h
rename to tools/lib/api/fs/fs.h
index 07d63cf..cb70495 100644
--- a/tools/perf/util/include/linux/magic.h
+++ b/tools/lib/api/fs/fs.h
@@ -1,9 +1,5 @@
-#ifndef _PERF_LINUX_MAGIC_H_
-#define _PERF_LINUX_MAGIC_H_
-
-#ifndef DEBUGFS_MAGIC
-#define DEBUGFS_MAGIC          0x64626720
-#endif
+#ifndef __API_FS__
+#define __API_FS__
 
 #ifndef SYSFS_MAGIC
 #define SYSFS_MAGIC            0x62656572
@@ -13,4 +9,6 @@
 #define PROC_SUPER_MAGIC       0x9fa0
 #endif
 
-#endif
+const char *sysfs__mountpoint(void);
+const char *procfs__mountpoint(void);
+#endif /* __API_FS__ */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f99a392..869b34a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -218,7 +218,6 @@ LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/export.h
-LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
@@ -244,7 +243,6 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/fs.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
@@ -306,7 +304,6 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/fs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 4db0ae6..8605ff5 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -2,7 +2,7 @@
 #include "parse-events.h"
 #include "evsel.h"
 #include "evlist.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <api/fs/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index a9b48c4..7fe4994 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,5 +1,5 @@
 #include "util.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
deleted file mode 100644
index 5e09ce1..0000000
--- a/tools/perf/util/fs.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __PERF_FS
-#define __PERF_FS
-
-const char *sysfs__mountpoint(void);
-const char *procfs__mountpoint(void);
-
-#endif /* __PERF_FS */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index b752ecb..00a7dcb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -3,7 +3,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <dirent.h>
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <locale.h>
 #include "util.h"
 #include "pmu.h"
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 595bfc7..16a475a 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -17,6 +17,6 @@ util/xyarray.c
 util/cgroup.c
 util/rblist.c
 util/strlist.c
-util/fs.c
+../lib/api/fs/fs.c
 util/trace-event.c
 ../../lib/rbtree.c
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 3737625..049e0a0 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -2,7 +2,7 @@
 #include "evsel.h"
 #include "cpumap.h"
 #include "parse-events.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include "util.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 42ad667..9f66549 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,6 +1,6 @@
 #include "../perf.h"
 #include "util.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <sys/mman.h>
 #ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
