Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3LQUwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:52:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3LQUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/10] tools/: Convert to new topic libraries
Date: Tue, 17 Dec 2013 17:52:02 -0300
Message-Id: <1387313531-14629-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387313531-14629-1-git-send-email-acme@infradead.org>
References: <1387313531-14629-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Move debugfs.* to api/fs/. We have a common tools/lib/api/ place where
the Makefile lives and then we place the headers in subdirs.

For example, all the fs-related stuff goes to tools/lib/api/fs/ from
which we get libapikfs.a (acme got almost the naming he wanted :-)) and
we link it into the tools which need it - in this case perf and
tools/vm/page-types.

acme:

"Looking at the implementation, I think some tools can even link
directly to the .o files, avoiding the .a file altogether.

But that is just an optimization/finer granularity tools/lib/
cherrypicking that toolers can make use of."

Fixup documentation cleaning target while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
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
Link: http://lkml.kernel.org/r/1386605664-24041-2-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile                     |  12 ++---
 tools/lib/api/Makefile             |  42 ++++++++++++++++
 tools/lib/api/fs/debugfs.c         | 100 +++++++++++++++++++++++++++++++++++++
 tools/lib/api/fs/debugfs.h         |  29 +++++++++++
 tools/lib/lk/Makefile              |  38 --------------
 tools/lib/lk/debugfs.c             | 100 -------------------------------------
 tools/lib/lk/debugfs.h             |  29 -----------
 tools/perf/Makefile.perf           |  33 ++++++------
 tools/perf/builtin-kvm.c           |   2 +-
 tools/perf/builtin-probe.c         |   2 +-
 tools/perf/perf.c                  |   2 +-
 tools/perf/tests/parse-events.c    |   2 +-
 tools/perf/util/evlist.c           |   2 +-
 tools/perf/util/evsel.c            |   2 +-
 tools/perf/util/parse-events.c     |   2 +-
 tools/perf/util/probe-event.c      |   2 +-
 tools/perf/util/setup.py           |   4 +-
 tools/perf/util/trace-event-info.c |   2 +-
 tools/perf/util/util.h             |   2 +-
 tools/vm/Makefile                  |  14 +++---
 tools/vm/page-types.c              |   2 +-
 21 files changed, 213 insertions(+), 210 deletions(-)
 create mode 100644 tools/lib/api/Makefile
 create mode 100644 tools/lib/api/fs/debugfs.c
 create mode 100644 tools/lib/api/fs/debugfs.h
 delete mode 100644 tools/lib/lk/Makefile
 delete mode 100644 tools/lib/lk/debugfs.c
 delete mode 100644 tools/lib/lk/debugfs.h

diff --git a/tools/Makefile b/tools/Makefile
index a9b02008443c..927cd46d36dc 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -39,10 +39,10 @@ cpupower: FORCE
 cgroup firewire guest usb virtio vm net: FORCE
 	$(call descend,$@)
 
-liblk: FORCE
-	$(call descend,lib/lk)
+libapikfs: FORCE
+	$(call descend,lib/api)
 
-perf: liblk FORCE
+perf: libapikfs FORCE
 	$(call descend,$@)
 
 selftests: FORCE
@@ -80,10 +80,10 @@ cpupower_clean:
 cgroup_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean net_clean:
 	$(call descend,$(@:_clean=),clean)
 
-liblk_clean:
-	$(call descend,lib/lk,clean)
+libapikfs_clean:
+	$(call descend,lib/api,clean)
 
-perf_clean: liblk_clean
+perf_clean: libapikfs_clean
 	$(call descend,$(@:_clean=),clean)
 
 selftests_clean:
diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
new file mode 100644
index 000000000000..ed2f51e11b80
--- /dev/null
+++ b/tools/lib/api/Makefile
@@ -0,0 +1,42 @@
+include ../../scripts/Makefile.include
+include ../../perf/config/utilities.mak		# QUIET_CLEAN
+
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
+# guard against environment variables
+LIB_H=
+LIB_OBJS=
+
+LIB_H += fs/debugfs.h
+
+LIB_OBJS += $(OUTPUT)fs/debugfs.o
+
+LIBFILE = libapikfs.a
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
+EXTLIBS = -lelf -lpthread -lrt -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RM = rm -f
+
+$(LIBFILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $(OUTPUT)$@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+libapi_dirs:
+	$(QUIET_MKDIR)mkdir -p $(OUTPUT)fs/
+
+$(OUTPUT)%.o: %.c libapi_dirs
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.c libapi_dirs
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+$(OUTPUT)%.o: %.S libapi_dirs
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(call QUIET_CLEAN, libapi) $(RM) $(LIB_OBJS) $(LIBFILE)
+
+.PHONY: clean
diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
new file mode 100644
index 000000000000..7c4347962353
--- /dev/null
+++ b/tools/lib/api/fs/debugfs.c
@@ -0,0 +1,100 @@
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <sys/vfs.h>
+#include <sys/mount.h>
+#include <linux/kernel.h>
+
+#include "debugfs.h"
+
+char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
+
+static const char * const debugfs_known_mountpoints[] = {
+	"/sys/kernel/debug/",
+	"/debug/",
+	0,
+};
+
+static bool debugfs_found;
+
+/* find the path to the mounted debugfs */
+const char *debugfs_find_mountpoint(void)
+{
+	const char * const *ptr;
+	char type[100];
+	FILE *fp;
+
+	if (debugfs_found)
+		return (const char *)debugfs_mountpoint;
+
+	ptr = debugfs_known_mountpoints;
+	while (*ptr) {
+		if (debugfs_valid_mountpoint(*ptr) == 0) {
+			debugfs_found = true;
+			strcpy(debugfs_mountpoint, *ptr);
+			return debugfs_mountpoint;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		return NULL;
+
+	while (fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
+		      debugfs_mountpoint, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		return NULL;
+
+	debugfs_found = true;
+
+	return debugfs_mountpoint;
+}
+
+/* verify that a mountpoint is actually a debugfs instance */
+
+int debugfs_valid_mountpoint(const char *debugfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(debugfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+
+	return 0;
+}
+
+/* mount the debugfs somewhere if it's not mounted */
+char *debugfs_mount(const char *mountpoint)
+{
+	/* see if it's already mounted */
+	if (debugfs_find_mountpoint())
+		goto out;
+
+	/* if not mounted and no argument */
+	if (mountpoint == NULL) {
+		/* see if environment variable set */
+		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
+		/* if no environment variable, use default */
+		if (mountpoint == NULL)
+			mountpoint = "/sys/kernel/debug";
+	}
+
+	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
+		return NULL;
+
+	/* save the mountpoint */
+	debugfs_found = true;
+	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+out:
+	return debugfs_mountpoint;
+}
diff --git a/tools/lib/api/fs/debugfs.h b/tools/lib/api/fs/debugfs.h
new file mode 100644
index 000000000000..f19d3df9609d
--- /dev/null
+++ b/tools/lib/api/fs/debugfs.h
@@ -0,0 +1,29 @@
+#ifndef __API_DEBUGFS_H__
+#define __API_DEBUGFS_H__
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+/*
+ * On most systems <limits.h> would have given us this, but  not on some systems
+ * (e.g. GNU/Hurd).
+ */
+#ifndef PATH_MAX
+#define PATH_MAX 4096
+#endif
+
+#ifndef DEBUGFS_MAGIC
+#define DEBUGFS_MAGIC          0x64626720
+#endif
+
+#ifndef PERF_DEBUGFS_ENVIRONMENT
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
+#endif
+
+const char *debugfs_find_mountpoint(void);
+int debugfs_valid_mountpoint(const char *debugfs);
+char *debugfs_mount(const char *mountpoint);
+
+extern char debugfs_mountpoint[];
+
+#endif /* __API_DEBUGFS_H__ */
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
deleted file mode 100644
index 3dba0a4aebbf..000000000000
--- a/tools/lib/lk/Makefile
+++ /dev/null
@@ -1,38 +0,0 @@
-include ../../scripts/Makefile.include
-
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
-
-# guard against environment variables
-LIB_H=
-LIB_OBJS=
-
-LIB_H += debugfs.h
-
-LIB_OBJS += $(OUTPUT)debugfs.o
-
-LIBFILE = liblk.a
-
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
-EXTLIBS = -lelf -lpthread -lrt -lm
-ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
-ALL_LDFLAGS = $(LDFLAGS)
-
-RM = rm -f
-
-$(LIBFILE): $(LIB_OBJS)
-	$(QUIET_AR)$(RM) $@ && $(AR) rcs $(OUTPUT)$@ $(LIB_OBJS)
-
-$(LIB_OBJS): $(LIB_H)
-
-$(OUTPUT)%.o: %.c
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
-$(OUTPUT)%.s: %.c
-	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
-$(OUTPUT)%.o: %.S
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
-
-clean:
-	$(RM) $(LIB_OBJS) $(LIBFILE)
-
-.PHONY: clean
diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
deleted file mode 100644
index 7c4347962353..000000000000
--- a/tools/lib/lk/debugfs.c
+++ /dev/null
@@ -1,100 +0,0 @@
-#include <errno.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdbool.h>
-#include <sys/vfs.h>
-#include <sys/mount.h>
-#include <linux/kernel.h>
-
-#include "debugfs.h"
-
-char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
-
-static const char * const debugfs_known_mountpoints[] = {
-	"/sys/kernel/debug/",
-	"/debug/",
-	0,
-};
-
-static bool debugfs_found;
-
-/* find the path to the mounted debugfs */
-const char *debugfs_find_mountpoint(void)
-{
-	const char * const *ptr;
-	char type[100];
-	FILE *fp;
-
-	if (debugfs_found)
-		return (const char *)debugfs_mountpoint;
-
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			debugfs_found = true;
-			strcpy(debugfs_mountpoint, *ptr);
-			return debugfs_mountpoint;
-		}
-		ptr++;
-	}
-
-	/* give up and parse /proc/mounts */
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		return NULL;
-
-	while (fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
-		      debugfs_mountpoint, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
-			break;
-	}
-	fclose(fp);
-
-	if (strcmp(type, "debugfs") != 0)
-		return NULL;
-
-	debugfs_found = true;
-
-	return debugfs_mountpoint;
-}
-
-/* verify that a mountpoint is actually a debugfs instance */
-
-int debugfs_valid_mountpoint(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
-}
-
-/* mount the debugfs somewhere if it's not mounted */
-char *debugfs_mount(const char *mountpoint)
-{
-	/* see if it's already mounted */
-	if (debugfs_find_mountpoint())
-		goto out;
-
-	/* if not mounted and no argument */
-	if (mountpoint == NULL) {
-		/* see if environment variable set */
-		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
-		/* if no environment variable, use default */
-		if (mountpoint == NULL)
-			mountpoint = "/sys/kernel/debug";
-	}
-
-	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
-		return NULL;
-
-	/* save the mountpoint */
-	debugfs_found = true;
-	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
-out:
-	return debugfs_mountpoint;
-}
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/lk/debugfs.h
deleted file mode 100644
index 935c59bdb442..000000000000
--- a/tools/lib/lk/debugfs.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef __LK_DEBUGFS_H__
-#define __LK_DEBUGFS_H__
-
-#define _STR(x) #x
-#define STR(x) _STR(x)
-
-/*
- * On most systems <limits.h> would have given us this, but  not on some systems
- * (e.g. GNU/Hurd).
- */
-#ifndef PATH_MAX
-#define PATH_MAX 4096
-#endif
-
-#ifndef DEBUGFS_MAGIC
-#define DEBUGFS_MAGIC          0x64626720
-#endif
-
-#ifndef PERF_DEBUGFS_ENVIRONMENT
-#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
-#endif
-
-const char *debugfs_find_mountpoint(void);
-int debugfs_valid_mountpoint(const char *debugfs);
-char *debugfs_mount(const char *mountpoint);
-
-extern char debugfs_mountpoint[];
-
-#endif /* __LK_DEBUGFS_H__ */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index fad61079e795..97a2145e4cc6 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -86,7 +86,7 @@ FLEX    = flex
 BISON   = bison
 STRIP   = strip
 
-LK_DIR          = $(srctree)/tools/lib/lk/
+LIB_DIR          = $(srctree)/tools/lib/api/
 TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
 
 # include config/Makefile by default and rule out
@@ -127,20 +127,20 @@ strip-libs = $(filter-out -l%,$(1))
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-  LK_PATH=$(OUTPUT)/../lib/lk/
+  LIB_PATH=$(OUTPUT)/../lib/api/
 else
-  LK_PATH=$(OUTPUT)
+  LIB_PATH=$(OUTPUT)
 endif
 else
   TE_PATH=$(TRACE_EVENT_DIR)
-  LK_PATH=$(LK_DIR)
+  LIB_PATH=$(LIB_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
 export LIBTRACEEVENT
 
-LIBLK = $(LK_PATH)liblk.a
-export LIBLK
+LIBAPIKFS = $(LIB_PATH)libapikfs.a
+export LIBAPIKFS
 
 # python extension build directories
 PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
@@ -151,7 +151,7 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 python-clean := $(call QUIET_CLEAN, python) $(RM) -r $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
-PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBLK)
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBAPIKFS)
 
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
@@ -441,7 +441,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
-PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
+PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
@@ -730,19 +730,19 @@ $(LIBTRACEEVENT)-clean:
 install-traceevent-plugins: $(LIBTRACEEVENT)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
 
-LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
+LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch])
 
 # if subdir is set, we've been called from above so target has been built
 # already
-$(LIBLK): $(LIBLK_SOURCES)
+$(LIBAPIKFS): $(LIBAPIKFS_SOURCES)
 ifeq ($(subdir),)
-	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
+	$(QUIET_SUBDIR0)$(LIB_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libapikfs.a
 endif
 
-$(LIBLK)-clean:
+$(LIBAPIKFS)-clean:
 ifeq ($(subdir),)
-	$(call QUIET_CLEAN, liblk)
-	@$(MAKE) -C $(LK_DIR) O=$(OUTPUT) clean >/dev/null
+	$(call QUIET_CLEAN, libapikfs)
+	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
 endif
 
 help:
@@ -881,12 +881,11 @@ config-clean:
 	$(call QUIET_CLEAN, config)
 	@$(MAKE) -C config/feature-checks clean >/dev/null
 
-clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean config-clean
+clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
-	$(call QUIET_CLEAN, Documentation)
-	@$(MAKE) -C Documentation O=$(OUTPUT) clean >/dev/null
+	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(python-clean)
 
 #
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index c6fa3cbd45a9..154b397a5d27 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -13,7 +13,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 #include "util/debug.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include "util/tool.h"
 #include "util/stat.h"
 #include "util/top.h"
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 6ea9e85bdc00..c98ccb570509 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -37,7 +37,7 @@
 #include "util/strfilter.h"
 #include "util/symbol.h"
 #include "util/debug.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 8b38b4e80ec2..431798a4110d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,7 +13,7 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include <pthread.h>
 
 const char perf_usage_string[] =
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 3cbd10496087..e4ce8aed29d3 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -3,7 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include "fs.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0b31cee34874..da3182914984 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -7,7 +7,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 #include "util.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7b510fd1f08d..01ff4cfde1f5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -9,7 +9,7 @@
 
 #include <byteswap.h>
 #include <linux/bitops.h>
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include <traceevent/event-parse.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 969cb8f0d88d..094c28ba2fae 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -10,7 +10,7 @@
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include "parse-events-bison.h"
 #define YY_EXTRA_TYPE int
 #include "parse-events-flex.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d7cff57945c2..544ac1898a9f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -40,7 +40,7 @@
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include "trace-event.h"	/* For __maybe_unused */
 #include "probe-event.h"
 #include "probe-finder.h"
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 58ea5ca6c255..d0aee4b9dfd4 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -25,7 +25,7 @@ cflags += ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter'
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 libtraceevent = getenv('LIBTRACEEVENT')
-liblk = getenv('LIBLK')
+libapikfs = getenv('LIBAPIKFS')
 
 ext_sources = [f.strip() for f in file('util/python-ext-sources')
 				if len(f.strip()) > 0 and f[0] != '#']
@@ -34,7 +34,7 @@ perf = Extension('perf',
 		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
-		  extra_objects = [libtraceevent, liblk],
+		  extra_objects = [libtraceevent, libapikfs],
                  )
 
 setup(name='perf',
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index f3c9e551bd35..c354b95a2348 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -38,7 +38,7 @@
 
 #include "../perf.h"
 #include "trace-event.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include "evsel.h"
 
 #define VERSION "0.5"
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a1eea3e809a3..9a2c268ad718 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -71,7 +71,7 @@
 #include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 #include <termios.h>
 #include <linux/bitops.h>
 
diff --git a/tools/vm/Makefile b/tools/vm/Makefile
index 24e9ddd93fa4..3d907dacf2ac 100644
--- a/tools/vm/Makefile
+++ b/tools/vm/Makefile
@@ -2,21 +2,21 @@
 #
 TARGETS=page-types slabinfo
 
-LK_DIR = ../lib/lk
-LIBLK = $(LK_DIR)/liblk.a
+LIB_DIR = ../lib/api
+LIBS = $(LIB_DIR)/libapikfs.a
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -I../lib/
-LDFLAGS = $(LIBLK)
+LDFLAGS = $(LIBS)
 
-$(TARGETS): liblk
+$(TARGETS): $(LIBS)
 
-liblk:
-	make -C $(LK_DIR)
+$(LIBS):
+	make -C $(LIB_DIR)
 
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
 	$(RM) page-types slabinfo
-	make -C ../lib/lk clean
+	make -C $(LIB_DIR) clean
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index d5e9d6d185c8..f9be24d9efac 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -36,7 +36,7 @@
 #include <sys/statfs.h>
 #include "../../include/uapi/linux/magic.h"
 #include "../../include/uapi/linux/kernel-page-flags.h"
-#include <lk/debugfs.h>
+#include <api/fs/debugfs.h>
 
 #ifndef MAX_PATH
 # define MAX_PATH 256
-- 
1.8.1.4

