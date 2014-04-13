Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaDML2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 07:28:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49231 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaDML15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 07:27:57 -0400
Date: Sun, 13 Apr 2014 13:27:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] tools: Consolidate types.h
Message-ID: <20140413112743.GB25088@pd.tnic>
References: <1393153753-2369-1-git-send-email-bp@alien8.de>
 <87eh2s55tg.fsf@rustcorp.com.au>
 <20140225070020.GA19504@pd.tnic>
 <87eh2r4c2d.fsf@rustcorp.com.au>
 <20140225140511.GD5982@ghostprotocols.net>
 <20140410173805.GA28613@pd.tnic>
 <20140411115930.GC1107@krava.brq.redhat.com>
 <20140412101455.GA30694@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140412101455.GA30694@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And while we're at it, let's do another consolidation:

---
From: Borislav Petkov <bp@suse.de>
Date: Sat, 12 Apr 2014 20:10:49 +0200
Subject: [PATCH] tools: Consolidate types.h

Combine all definitions into a common tools/include/linux/types.h and
kill the wild growth elsewhere. While at it, move u64_swap to its only
user, evsel.h.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 .../lockdep/uinclude => include}/linux/types.h     | 29 +++++++++++++++++-----
 tools/perf/MANIFEST                                |  1 +
 tools/perf/Makefile.perf                           |  3 +--
 tools/perf/arch/x86/include/perf_regs.h            |  2 +-
 tools/perf/arch/x86/util/tsc.c                     |  2 +-
 tools/perf/arch/x86/util/tsc.h                     |  2 +-
 tools/perf/perf.h                                  |  4 +--
 tools/perf/tests/attr.c                            |  7 ------
 tools/perf/tests/code-reading.c                    |  3 +--
 tools/perf/tests/dso-data.c                        |  2 +-
 tools/perf/tests/dwarf-unwind.c                    |  2 +-
 tools/perf/tests/keep-tracking.c                   |  2 +-
 tools/perf/tests/mmap-thread-lookup.c              |  2 +-
 tools/perf/tests/parse-no-sample-id-all.c          |  2 +-
 tools/perf/tests/perf-targz-src-pkg                | 10 +++++---
 tools/perf/tests/perf-time-to-tsc.c                |  3 +--
 tools/perf/tests/rdpmc.c                           |  2 +-
 tools/perf/tests/sample-parsing.c                  |  2 +-
 tools/perf/ui/browser.h                            |  4 +--
 tools/perf/ui/progress.h                           |  2 +-
 tools/perf/util/annotate.h                         |  2 +-
 tools/perf/util/build-id.h                         |  2 +-
 tools/perf/util/dso.h                              |  2 +-
 tools/perf/util/evsel.h                            |  9 +++++--
 tools/perf/util/header.h                           |  3 ++-
 tools/perf/util/include/linux/list.h               |  1 +
 tools/perf/util/include/linux/types.h              | 29 ----------------------
 tools/perf/util/map.h                              |  2 +-
 tools/perf/util/parse-events.h                     |  3 +--
 tools/perf/util/parse-events.y                     |  2 +-
 tools/perf/util/perf_regs.h                        |  2 +-
 tools/perf/util/pmu.h                              |  1 +
 tools/perf/util/pmu.y                              |  1 +
 tools/perf/util/stat.h                             |  2 +-
 tools/perf/util/svghelper.h                        |  2 +-
 tools/perf/util/top.h                              |  2 +-
 tools/perf/util/types.h                            | 24 ------------------
 tools/perf/util/unwind-libdw.c                     |  2 +-
 tools/perf/util/unwind.h                           |  2 +-
 tools/perf/util/util.h                             |  5 +++-
 tools/perf/util/values.h                           |  2 +-
 tools/virtio/linux/kernel.h                        |  7 ------
 tools/virtio/linux/types.h                         | 28 ---------------------
 43 files changed, 75 insertions(+), 146 deletions(-)
 rename tools/{lib/lockdep/uinclude => include}/linux/types.h (63%)
 delete mode 100644 tools/perf/util/include/linux/types.h
 delete mode 100644 tools/perf/util/types.h
 delete mode 100644 tools/virtio/linux/types.h

diff --git a/tools/lib/lockdep/uinclude/linux/types.h b/tools/include/linux/types.h
similarity index 63%
rename from tools/lib/lockdep/uinclude/linux/types.h
rename to tools/include/linux/types.h
index 929938f426de..98d0cbcaa600 100644
--- a/tools/lib/lockdep/uinclude/linux/types.h
+++ b/tools/include/linux/types.h
@@ -1,8 +1,9 @@
-#ifndef _LIBLOCKDEP_LINUX_TYPES_H_
-#define _LIBLOCKDEP_LINUX_TYPES_H_
+#ifndef _TOOLS_LINUX_TYPES_H_
+#define _TOOLS_LINUX_TYPES_H_
 
 #include <stdbool.h>
 #include <stddef.h>
+#include <stdint.h>
 
 #define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
 #include <asm/types.h>
@@ -10,10 +11,22 @@
 struct page;
 struct kmem_cache;
 
-typedef unsigned gfp_t;
+typedef enum {
+	GFP_KERNEL,
+	GFP_ATOMIC,
+	__GFP_HIGHMEM,
+	__GFP_HIGH
+} gfp_t;
 
-typedef __u64 u64;
-typedef __s64 s64;
+/*
+ * We define u64 as uint64_t for every architecture
+ * so that we can print it with "%"PRIx64 without getting warnings.
+ *
+ * typedef __u64 u64;
+ * typedef __s64 s64;
+ */
+typedef uint64_t u64;
+typedef int64_t	s64;
 
 typedef __u32 u32;
 typedef __s32 s32;
@@ -35,6 +48,10 @@ typedef __s8  s8;
 #define __bitwise
 #endif
 
+#define __force
+#define __user
+#define __must_check
+#define __cold
 
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
@@ -55,4 +72,4 @@ struct hlist_node {
 	struct hlist_node *next, **pprev;
 };
 
-#endif
+#endif /* _TOOLS_LINUX_TYPES_H_ */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 81783c2037fc..45da209b6ed3 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -8,6 +8,7 @@ tools/include/asm/bug.h
 tools/include/linux/compiler.h
 tools/include/linux/hash.h
 tools/include/linux/export.h
+tools/include/linux/types.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 791ad6d1994e..acc86ea4320d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -227,7 +227,7 @@ LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/rbtree_augmented.h
 LIB_H += util/include/linux/string.h
-LIB_H += util/include/linux/types.h
+LIB_H += ../include/linux/types.h
 LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += ../include/asm/bug.h
@@ -252,7 +252,6 @@ LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
-LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/machine.h
 LIB_H += util/map.h
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index fc819ca34a7e..7df517acfef8 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -2,7 +2,7 @@
 #define ARCH_PERF_REGS_H
 
 #include <stdlib.h>
-#include "../../util/types.h"
+#include <linux/types.h>
 #include <asm/perf_regs.h>
 
 void perf_regs_load(u64 *regs);
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index b2519e49424f..40021fa3129b 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -4,7 +4,7 @@
 #include <linux/perf_event.h>
 
 #include "../../perf.h"
-#include "../../util/types.h"
+#include <linux/types.h>
 #include "../../util/debug.h"
 #include "tsc.h"
 
diff --git a/tools/perf/arch/x86/util/tsc.h b/tools/perf/arch/x86/util/tsc.h
index a24dec81c795..2affe0366b59 100644
--- a/tools/perf/arch/x86/util/tsc.h
+++ b/tools/perf/arch/x86/util/tsc.h
@@ -1,7 +1,7 @@
 #ifndef TOOLS_PERF_ARCH_X86_UTIL_TSC_H__
 #define TOOLS_PERF_ARCH_X86_UTIL_TSC_H__
 
-#include "../../util/types.h"
+#include <linux/types.h>
 
 struct perf_tsc_conversion {
 	u16 time_shift;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 1138c412ff95..83ac8de3c8b5 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -165,9 +165,8 @@
 #include <sys/types.h>
 #include <sys/syscall.h>
 
+#include <linux/types.h>
 #include <linux/perf_event.h>
-#include "util/types.h"
-#include <stdbool.h>
 
 /*
  * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
@@ -194,7 +193,6 @@ static inline unsigned long long rdclock(void)
 /*
  * Pick up some kernel type conventions:
  */
-#define __user
 #define asmlinkage
 
 #define unlikely(x)	__builtin_expect(!!(x), 0)
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 00218f503b2e..2dfc9ad0e6f2 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -1,4 +1,3 @@
-
 /*
  * The struct perf_event_attr test support.
  *
@@ -19,14 +18,8 @@
  * permissions. All the event text files are stored there.
  */
 
-/*
- * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
- * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
- */
-#define __SANE_USERSPACE_TYPES__
 #include <stdlib.h>
 #include <stdio.h>
-#include <inttypes.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include "../perf.h"
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 653a8fe2db95..103974eae373 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -1,8 +1,7 @@
-#include <sys/types.h>
+#include <linux/types.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
-#include <inttypes.h>
 #include <ctype.h>
 #include <string.h>
 
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 9cc81a3eb9b4..3e6cb171e3d3 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -1,7 +1,7 @@
 #include "util.h"
 
 #include <stdlib.h>
-#include <sys/types.h>
+#include <linux/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <string.h>
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index c059ee81c038..108f0cd49f4e 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -1,5 +1,5 @@
 #include <linux/compiler.h>
-#include <sys/types.h>
+#include <linux/types.h>
 #include <unistd.h>
 #include "tests.h"
 #include "debug.h"
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index 497957f269d8..7a5ab7b0b8f6 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -1,4 +1,4 @@
-#include <sys/types.h>
+#include <linux/types.h>
 #include <unistd.h>
 #include <sys/prctl.h>
 
diff --git a/tools/perf/tests/mmap-thread-lookup.c b/tools/perf/tests/mmap-thread-lookup.c
index cb73e1ff9cab..428539cc72da 100644
--- a/tools/perf/tests/mmap-thread-lookup.c
+++ b/tools/perf/tests/mmap-thread-lookup.c
@@ -1,6 +1,6 @@
 #include <unistd.h>
 #include <sys/syscall.h>
-#include <sys/types.h>
+#include <linux/types.h>
 #include <sys/mman.h>
 #include <pthread.h>
 #include <stdlib.h>
diff --git a/tools/perf/tests/parse-no-sample-id-all.c b/tools/perf/tests/parse-no-sample-id-all.c
index e117b6c6a248..905019f9b740 100644
--- a/tools/perf/tests/parse-no-sample-id-all.c
+++ b/tools/perf/tests/parse-no-sample-id-all.c
@@ -1,4 +1,4 @@
-#include <sys/types.h>
+#include <linux/types.h>
 #include <stddef.h>
 
 #include "tests.h"
diff --git a/tools/perf/tests/perf-targz-src-pkg b/tools/perf/tests/perf-targz-src-pkg
index 238aa3927c71..3017d82a700f 100755
--- a/tools/perf/tests/perf-targz-src-pkg
+++ b/tools/perf/tests/perf-targz-src-pkg
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # Test one of the main kernel Makefile targets to generate a perf sources tarball
 # suitable for build outside the full kernel sources.
 #
@@ -7,15 +7,17 @@
 # like when we made some files that were in tools/perf/ available to other tools/
 # codebases by moving it to tools/include/, etc.
 
+set -x
+
 PERF=$1
 cd ${PERF}/../..
 make perf-targz-src-pkg > /dev/null
 TARBALL=$(ls -rt perf-*.tar.gz)
 TMP_DEST=$(mktemp -d)
 tar xf ${TARBALL} -C $TMP_DEST
-rm -f ${TARBALL}
+# rm -f ${TARBALL}
 cd - > /dev/null
-make -C $TMP_DEST/perf*/tools/perf > /dev/null 2>&1
+make -C $TMP_DEST/perf*/tools/perf > w.log 2>&1
 RC=$?
-rm -rf ${TMP_DEST}
+# rm -rf ${TMP_DEST}
 exit $RC
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 47146d388dbf..3b7cd4d32dcb 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -1,7 +1,6 @@
 #include <stdio.h>
-#include <sys/types.h>
 #include <unistd.h>
-#include <inttypes.h>
+#include <linux/types.h>
 #include <sys/prctl.h>
 
 #include "parse-events.h"
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index 46649c25fa5e..e59143fd9e71 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -2,7 +2,7 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <sys/mman.h>
-#include "types.h"
+#include <linux/types.h>
 #include "perf.h"
 #include "debug.h"
 #include "tests.h"
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 0014d3c8c21c..7ae8d17db3d9 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -1,5 +1,5 @@
 #include <stdbool.h>
-#include <inttypes.h>
+#include <linux/types.h>
 
 #include "util.h"
 #include "event.h"
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 118cca29dd26..03d4d6295f10 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -1,9 +1,7 @@
 #ifndef _PERF_UI_BROWSER_H_
 #define _PERF_UI_BROWSER_H_ 1
 
-#include <stdbool.h>
-#include <sys/types.h>
-#include "../types.h"
+#include <linux/types.h>
 
 #define HE_COLORSET_TOP		50
 #define HE_COLORSET_MEDIUM	51
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index 29ec8efffefb..f34f89eb607c 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_UI_PROGRESS_H_
 #define _PERF_UI_PROGRESS_H_ 1
 
-#include <../types.h>
+#include <linux/types.h>
 
 void ui_progress__finish(void);
  
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 56ad4f5287de..112d6e268150 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -3,7 +3,7 @@
 
 #include <stdbool.h>
 #include <stdint.h>
-#include "types.h"
+#include <linux/types.h>
 #include "symbol.h"
 #include "hist.h"
 #include "sort.h"
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 845ef865eced..ae392561470b 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -4,7 +4,7 @@
 #define BUILD_ID_SIZE 20
 
 #include "tool.h"
-#include "types.h"
+#include <linux/types.h>
 
 extern struct perf_tool build_id__mark_dso_hit_ops;
 struct dso;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ab06f1c03655..38efe95a7fdd 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 #include <linux/rbtree.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/types.h>
 #include "map.h"
 #include "build-id.h"
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0c9926cfb292..f392ac83949f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -5,12 +5,17 @@
 #include <stdbool.h>
 #include <stddef.h>
 #include <linux/perf_event.h>
-#include "types.h"
+#include <linux/types.h>
 #include "xyarray.h"
 #include "cgroup.h"
 #include "hist.h"
 #include "symbol.h"
- 
+
+union u64_swap {
+	u64 val64;
+	u32 val32[2];
+};
+
 struct perf_counts_values {
 	union {
 		struct {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index a2d047bdf4ef..4aae21a676e1 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -4,8 +4,9 @@
 #include <linux/perf_event.h>
 #include <sys/types.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/types.h>
 #include "event.h"
+#include "util.h"
 
 #include <linux/bitmap.h>
 
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index bfe0a2afd0d2..76ddbc726343 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/types.h>
 
 #include "../../../../include/linux/list.h"
 
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
deleted file mode 100644
index eb464786c084..000000000000
--- a/tools/perf/util/include/linux/types.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef _PERF_LINUX_TYPES_H_
-#define _PERF_LINUX_TYPES_H_
-
-#include <asm/types.h>
-
-#ifndef __bitwise
-#define __bitwise
-#endif
-
-#ifndef __le32
-typedef __u32 __bitwise __le32;
-#endif
-
-#define DECLARE_BITMAP(name,bits) \
-	unsigned long name[BITS_TO_LONGS(bits)]
-
-struct list_head {
-	struct list_head *next, *prev;
-};
-
-struct hlist_head {
-	struct hlist_node *first;
-};
-
-struct hlist_node {
-	struct hlist_node *next, **pprev;
-};
-
-#endif
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f00f058afb3b..e5d18e2e7f10 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -6,7 +6,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/types.h>
 
 enum map_type {
 	MAP__FUNCTION = 0,
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4b3c70..df094b4ed5ed 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -6,9 +6,8 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/types.h>
 #include <linux/perf_event.h>
-#include "types.h"
 
 struct list_head;
 struct perf_evsel;
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec333f1..e7822e0fcac6 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -9,7 +9,7 @@
 
 #include <linux/compiler.h>
 #include <linux/list.h>
-#include "types.h"
+#include <linux/types.h>
 #include "util.h"
 #include "parse-events.h"
 #include "parse-events-bison.h"
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index d6e8b6a8d7f3..79c78f74e0cf 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
-#include "types.h"
+#include <linux/types.h>
 #include "event.h"
 
 #ifdef HAVE_PERF_REGS_SUPPORT
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 8b64125a9281..1ad0380dd856 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -4,6 +4,7 @@
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
 #include <stdbool.h>
+#include "util.h"
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index bfd7e8509869..a044c5c707ea 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -8,6 +8,7 @@
 #include <linux/list.h>
 #include <linux/bitmap.h>
 #include <string.h>
+#include "util.h"
 #include "pmu.h"
 
 extern int perf_pmu_lex (void);
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index ae8ccd7227cf..5667fc3e39cf 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_STATS_H
 #define __PERF_STATS_H
 
-#include "types.h"
+#include <linux/types.h>
 
 struct stats
 {
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index f7b4d6e699ea..e3aff5332e30 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_SVGHELPER_H
 #define __PERF_SVGHELPER_H
 
-#include "types.h"
+#include <linux/types.h>
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index dab14d0ad3d0..f92c37abb0a8 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -2,7 +2,7 @@
 #define __PERF_TOP_H 1
 
 #include "tool.h"
-#include "types.h"
+#include <linux/types.h>
 #include <stddef.h>
 #include <stdbool.h>
 #include <termios.h>
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
deleted file mode 100644
index c51fa6b70a28..000000000000
--- a/tools/perf/util/types.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef __PERF_TYPES_H
-#define __PERF_TYPES_H
-
-#include <stdint.h>
-
-/*
- * We define u64 as uint64_t for every architecture
- * so that we can print it with "%"PRIx64 without getting warnings.
- */
-typedef uint64_t	   u64;
-typedef int64_t		   s64;
-typedef unsigned int	   u32;
-typedef signed int	   s32;
-typedef unsigned short	   u16;
-typedef signed short	   s16;
-typedef unsigned char	   u8;
-typedef signed char	   s8;
-
-union u64_swap {
-	u64 val64;
-	u32 val32[2];
-};
-
-#endif /* __PERF_TYPES_H */
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 67db73ec3dab..5ec80a575b50 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -7,7 +7,7 @@
 #include "unwind-libdw.h"
 #include "machine.h"
 #include "thread.h"
-#include "types.h"
+#include <linux/types.h>
 #include "event.h"
 #include "perf_regs.h"
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index b031316f221a..f03061260b4e 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -1,7 +1,7 @@
 #ifndef __UNWIND_H
 #define __UNWIND_H
 
-#include "types.h"
+#include <linux/types.h>
 #include "event.h"
 #include "symbol.h"
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6995d66f225c..35cc878dc97e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -69,7 +69,7 @@
 #include <sys/ioctl.h>
 #include <inttypes.h>
 #include <linux/magic.h>
-#include "types.h"
+#include <linux/types.h>
 #include <sys/ttydefaults.h>
 #include <api/fs/debugfs.h>
 #include <termios.h>
@@ -129,6 +129,9 @@ void put_tracing_file(char *file);
 #endif
 #endif
 
+#define DECLARE_BITMAP(name,bits) \
+	unsigned long name[BITS_TO_LONGS(bits)]
+
 #define PERF_GTK_DSO  "libperf-gtk.so"
 
 /* General helper functions */
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
index 2fa967e1a88a..b21a80c6cf8d 100644
--- a/tools/perf/util/values.h
+++ b/tools/perf/util/values.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_VALUES_H
 #define __PERF_VALUES_H
 
-#include "types.h"
+#include <linux/types.h>
 
 struct perf_read_values {
 	int threads;
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index fba705963968..1e8ce6979c1e 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -38,13 +38,6 @@ struct page {
 
 #define __printf(a,b) __attribute__((format(printf,a,b)))
 
-typedef enum {
-	GFP_KERNEL,
-	GFP_ATOMIC,
-	__GFP_HIGHMEM,
-	__GFP_HIGH
-} gfp_t;
-
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
 
 extern void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
diff --git a/tools/virtio/linux/types.h b/tools/virtio/linux/types.h
deleted file mode 100644
index f8ebb9a2b3d6..000000000000
--- a/tools/virtio/linux/types.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef TYPES_H
-#define TYPES_H
-#include <stdint.h>
-
-#define __force
-#define __user
-#define __must_check
-#define __cold
-
-typedef uint64_t u64;
-typedef int64_t s64;
-typedef uint32_t u32;
-typedef int32_t s32;
-typedef uint16_t u16;
-typedef int16_t s16;
-typedef uint8_t u8;
-typedef int8_t s8;
-
-typedef uint64_t __u64;
-typedef int64_t __s64;
-typedef uint32_t __u32;
-typedef int32_t __s32;
-typedef uint16_t __u16;
-typedef int16_t __s16;
-typedef uint8_t __u8;
-typedef int8_t __s8;
-
-#endif /* TYPES_H */
-- 
1.9.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
