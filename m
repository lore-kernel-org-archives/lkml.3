Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaAMUym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/38] tools include: Move perf's linux/compiler.h to a generic place
Date: Mon, 13 Jan 2014 17:47:26 -0300
Message-Id: <1389646059-24881-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

So that it can be shared with others like libtraceevent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/compiler.h           | 30 ++++++++++++++++++++++++++++++
 tools/perf/Makefile.perf                 |  2 +-
 tools/perf/config/Makefile               |  1 +
 tools/perf/util/include/linux/compiler.h | 30 ------------------------------
 4 files changed, 32 insertions(+), 31 deletions(-)
 create mode 100644 tools/include/linux/compiler.h
 delete mode 100644 tools/perf/util/include/linux/compiler.h

diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
new file mode 100644
index 000000000000..0135ccf2a00c
--- /dev/null
+++ b/tools/include/linux/compiler.h
@@ -0,0 +1,30 @@
+#ifndef _TOOLS_LINUX_COMPILER_H_
+#define _TOOLS_LINUX_COMPILER_H_
+
+#ifndef __always_inline
+# define __always_inline	inline __attribute__((always_inline))
+#endif
+
+#define __user
+
+#ifndef __attribute_const__
+# define __attribute_const__
+#endif
+
+#ifndef __maybe_unused
+# define __maybe_unused		__attribute__((unused))
+#endif
+
+#ifndef __packed
+# define __packed		__attribute__((__packed__))
+#endif
+
+#ifndef __force
+# define __force
+#endif
+
+#ifndef __weak
+# define __weak			__attribute__((weak))
+#endif
+
+#endif /* _TOOLS_LINUX_COMPILER_H */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3638b0bd20dc..6be06767da7b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -211,7 +211,7 @@ LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
-LIB_H += util/include/linux/compiler.h
+LIB_H += ../include/linux/compiler.h
 LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d15b43b03c6..01dd43df0d04 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -232,6 +232,7 @@ endif
 
 CFLAGS += -I$(src-perf)/util/include
 CFLAGS += -I$(src-perf)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/tools/include/
 CFLAGS += -I$(srctree)/arch/$(ARCH)/include/uapi
 CFLAGS += -I$(srctree)/arch/$(ARCH)/include
 CFLAGS += -I$(srctree)/include/uapi
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
deleted file mode 100644
index b003ad7200b2..000000000000
--- a/tools/perf/util/include/linux/compiler.h
+++ /dev/null
@@ -1,30 +0,0 @@
-#ifndef _PERF_LINUX_COMPILER_H_
-#define _PERF_LINUX_COMPILER_H_
-
-#ifndef __always_inline
-# define __always_inline	inline __attribute__((always_inline))
-#endif
-
-#define __user
-
-#ifndef __attribute_const__
-# define __attribute_const__
-#endif
-
-#ifndef __maybe_unused
-# define __maybe_unused		__attribute__((unused))
-#endif
-
-#ifndef __packed
-# define __packed		__attribute__((__packed__))
-#endif
-
-#ifndef __force
-# define __force
-#endif
-
-#ifndef __weak
-# define __weak			__attribute__((weak))
-#endif
-
-#endif
-- 
1.8.1.4

