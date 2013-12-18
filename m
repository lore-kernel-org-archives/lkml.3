Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3LRKcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:31:57 -0500
Date: Wed, 18 Dec 2013 02:30:35 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-553873e1df63a20559ac9c336765dc7055cfc3d4@git.kernel.org>
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
In-Reply-To: <1386605664-24041-2-git-send-email-bp@alien8.de>
References: <1386605664-24041-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/: Convert to new topic libraries
Git-Commit-ID: 553873e1df63a20559ac9c336765dc7055cfc3d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:30:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  553873e1df63a20559ac9c336765dc7055cfc3d4
Gitweb:     http://git.kernel.org/tip/553873e1df63a20559ac9c336765dc7055cfc3d4
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 9 Dec 2013 17:14:23 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Dec 2013 16:03:27 -0300

tools/: Convert to new topic libraries

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
 tools/Makefile                     | 12 ++++++------
 tools/lib/{lk => api}/Makefile     | 18 +++++++++++-------
 tools/lib/{lk => api/fs}/debugfs.c |  0
 tools/lib/{lk => api/fs}/debugfs.h |  6 +++---
 tools/perf/Makefile.perf           | 33 ++++++++++++++++-----------------
 tools/perf/builtin-kvm.c           |  2 +-
 tools/perf/builtin-probe.c         |  2 +-
 tools/perf/perf.c                  |  2 +-
 tools/perf/tests/parse-events.c    |  2 +-
 tools/perf/util/evlist.c           |  2 +-
 tools/perf/util/evsel.c            |  2 +-
 tools/perf/util/parse-events.c     |  2 +-
 tools/perf/util/probe-event.c      |  2 +-
 tools/perf/util/setup.py           |  4 ++--
 tools/perf/util/trace-event-info.c |  2 +-
 tools/perf/util/util.h             |  2 +-
 tools/vm/Makefile                  | 14 +++++++-------
 tools/vm/page-types.c              |  2 +-
 18 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/tools/Makefile b/tools/Makefile
index a9b0200..927cd46 100644
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
diff --git a/tools/lib/lk/Makefile b/tools/lib/api/Makefile
similarity index 66%
rename from tools/lib/lk/Makefile
rename to tools/lib/api/Makefile
index 3dba0a4..ed2f51e 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/api/Makefile
@@ -1,4 +1,5 @@
 include ../../scripts/Makefile.include
+include ../../perf/config/utilities.mak		# QUIET_CLEAN
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
@@ -7,11 +8,11 @@ AR = $(CROSS_COMPILE)ar
 LIB_H=
 LIB_OBJS=
 
-LIB_H += debugfs.h
+LIB_H += fs/debugfs.h
 
-LIB_OBJS += $(OUTPUT)debugfs.o
+LIB_OBJS += $(OUTPUT)fs/debugfs.o
 
-LIBFILE = liblk.a
+LIBFILE = libapikfs.a
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
 EXTLIBS = -lelf -lpthread -lrt -lm
@@ -25,14 +26,17 @@ $(LIBFILE): $(LIB_OBJS)
 
 $(LIB_OBJS): $(LIB_H)
 
-$(OUTPUT)%.o: %.c
+libapi_dirs:
+	$(QUIET_MKDIR)mkdir -p $(OUTPUT)fs/
+
+$(OUTPUT)%.o: %.c libapi_dirs
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
-$(OUTPUT)%.s: %.c
+$(OUTPUT)%.s: %.c libapi_dirs
 	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
-$(OUTPUT)%.o: %.S
+$(OUTPUT)%.o: %.S libapi_dirs
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
 
 clean:
-	$(RM) $(LIB_OBJS) $(LIBFILE)
+	$(call QUIET_CLEAN, libapi) $(RM) $(LIB_OBJS) $(LIBFILE)
 
 .PHONY: clean
diff --git a/tools/lib/lk/debugfs.c b/tools/lib/api/fs/debugfs.c
similarity index 100%
rename from tools/lib/lk/debugfs.c
rename to tools/lib/api/fs/debugfs.c
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/api/fs/debugfs.h
similarity index 86%
rename from tools/lib/lk/debugfs.h
rename to tools/lib/api/fs/debugfs.h
index 935c59b..f19d3df 100644
--- a/tools/lib/lk/debugfs.h
+++ b/tools/lib/api/fs/debugfs.h
@@ -1,5 +1,5 @@
-#ifndef __LK_DEBUGFS_H__
-#define __LK_DEBUGFS_H__
+#ifndef __API_DEBUGFS_H__
+#define __API_DEBUGFS_H__
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
@@ -26,4 +26,4 @@ char *debugfs_mount(const char *mountpoint);
 
 extern char debugfs_mountpoint[];
 
-#endif /* __LK_DEBUGFS_H__ */
+#endif /* __API_DEBUGFS_H__ */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index fad6107..97a2145 100644
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
index c6fa3cb..154b397 100644
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
index 6ea9e85..c98ccb5 100644
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
index 8b38b4e..431798a 100644
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
index 3cbd104..e4ce8ae 100644
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
index 0b31cee..da31829 100644
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
index 7b510fd..01ff4cf 100644
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
index 969cb8f..094c28b 100644
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
index d7cff57..544ac18 100644
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
index 58ea5ca..d0aee4b 100644
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
index f3c9e55..c354b95 100644
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
index a1eea3e..9a2c268 100644
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
index 24e9ddd..3d907da 100644
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
index d5e9d6d..f9be24d 100644
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
