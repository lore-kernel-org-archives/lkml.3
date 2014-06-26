Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbaFZKch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:32:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36790 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbaFZKcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:32:32 -0400
Date: Thu, 26 Jun 2014 12:32:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140626103223.GB1284@pd.tnic>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
 <20140625211757.GD18773@kernel.org>
 <20140626073802.GC1177@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20140626073802.GC1177@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Jun 26, 2014 at 09:38:02AM +0200, Jiri Olsa wrote:
> yep, tip/perf/core maybe plus merges from acme/perf/core and
> jolsa/perf/core should do it ;-)

Ok, just did this (jolsa/perf/coreas up-to-date) nd I still can't
trigger the build failure:

commit f05523d9b9aaf18fb28acd009dc9142b2da16380
Merge: 80f0ae409ee9 07100877ea8f
Author: Borislav Petkov <bp@suse.de>
Date:   Thu Jun 26 11:59:07 2014 +0200

    Merge remote-tracking branch 'acme/perf/core' into ptool-v0.5.2

commit 80f0ae409ee945d598fa982efff53d9f887cc5d5
Merge: d7933ab727ed 2f88993d53c5
Author: Borislav Petkov <bp@suse.de>
Date:   Thu Jun 26 11:58:24 2014 +0200

    Merge remote-tracking branch 'tip/master' into rc2+-3

commit d7933ab727ed035bdf420d7381b831ba959cecc5
Merge: 2a80ff867f35 ce36d9ab3bab
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 25 21:47:28 2014 -0700

    Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6



Maybe we're having different libraries installed?

Auto-detecting system features:
...                         dwarf: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ OFF ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ OFF ]
...     DWARF post unwind library: libunwind

jirka?

Here's the patch again, attached.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

--82I3+IH0IqGh5yIs
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-perf-tool-Carve-out-ctype.h-et-al.patch"

>From b9f9ef3709e7b28470bbbba2bdf57e27ee094e59 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Tue, 24 Jun 2014 22:05:38 +0200
Subject: [PATCH] perf tool: Carve out ctype.h et al

Carve out ctype.* and util.* stuff into tools/lib/util/. We're keeping
those as standalone object files in TOOLS_OBJS and add them to the
targets that need them.

This way we don't do lib archives but single objects only.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/lib/Makefile                    | 35 ++++++++++++++++++++++++++
 tools/lib/symbol/kallsyms.c           |  2 +-
 tools/lib/symbol/kallsyms.h           |  4 ++-
 tools/{perf => lib}/util/ctype.c      |  2 +-
 tools/lib/util/ctype.h                | 46 +++++++++++++++++++++++++++++++++++
 tools/lib/util/util.c                 | 34 ++++++++++++++++++++++++++
 tools/lib/util/util.h                 |  9 +++++++
 tools/perf/MANIFEST                   |  1 +
 tools/perf/Makefile.perf              | 27 ++++++--------------
 tools/perf/arch/common.c              |  2 ++
 tools/perf/builtin-top.c              |  2 ++
 tools/perf/ui/browser.c               |  2 ++
 tools/perf/ui/browsers/map.c          |  2 ++
 tools/perf/util/alias.c               |  2 ++
 tools/perf/util/annotate.c            |  2 ++
 tools/perf/util/color.c               |  2 ++
 tools/perf/util/config.c              |  2 ++
 tools/perf/util/cpumap.c              |  1 +
 tools/perf/util/debug.c               |  2 ++
 tools/perf/util/header.c              |  1 +
 tools/perf/util/include/linux/ctype.h |  1 -
 tools/perf/util/probe-finder.h        |  2 ++
 tools/perf/util/python-ext-sources    |  1 -
 tools/perf/util/strfilter.c           |  2 ++
 tools/perf/util/string.c              |  2 ++
 tools/perf/util/symbol.c              |  2 ++
 tools/perf/util/util.c                | 33 -------------------------
 tools/perf/util/util.h                | 43 --------------------------------
 tools/scripts/Makefile.include        | 12 +++++++++
 29 files changed, 177 insertions(+), 101 deletions(-)
 create mode 100644 tools/lib/Makefile
 rename tools/{perf => lib}/util/ctype.c (98%)
 create mode 100644 tools/lib/util/ctype.h
 create mode 100644 tools/lib/util/util.c
 create mode 100644 tools/lib/util/util.h
 delete mode 100644 tools/perf/util/include/linux/ctype.h

diff --git a/tools/lib/Makefile b/tools/lib/Makefile
new file mode 100644
index 000000000000..9f26cec44cea
--- /dev/null
+++ b/tools/lib/Makefile
@@ -0,0 +1,35 @@
+include ../scripts/Makefile.include
+include ../perf/config/utilities.mak		# QUIET_CLEAN
+
+HEADERS=
+OBJECTS=
+
+HEADERS += symbol/kallsyms.h
+HEADERS += util/ctype.h
+HEADERS += util/util.h
+
+OBJECTS += $(OUTPUT)symbol/kallsyms.o
+OBJECTS += $(OUTPUT)util/ctype.o
+OBJECTS += $(OUTPUT)util/util.o
+
+INCLUDE := -I$(srctree)/tools/include
+CFLAGS = -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(INCLUDE)
+EXTLIBS = -lelf -lpthread -lrt -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RM = rm -f
+
+all: $(OBJECTS)
+
+$(OBJECTS): $(HEADERS)
+
+$(OUTPUT)%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+$(OUTPUT)%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(OBJECTS)
diff --git a/tools/lib/symbol/kallsyms.c b/tools/lib/symbol/kallsyms.c
index 18bc271a4bbc..ab124d5ced82 100644
--- a/tools/lib/symbol/kallsyms.c
+++ b/tools/lib/symbol/kallsyms.c
@@ -1,4 +1,4 @@
-#include "symbol/kallsyms.h"
+#include "kallsyms.h"
 #include <stdio.h>
 #include <stdlib.h>
 
diff --git a/tools/lib/symbol/kallsyms.h b/tools/lib/symbol/kallsyms.h
index 6084f5e18b3c..f8734487d3a7 100644
--- a/tools/lib/symbol/kallsyms.h
+++ b/tools/lib/symbol/kallsyms.h
@@ -2,9 +2,11 @@
 #define __TOOLS_KALLSYMS_H_ 1
 
 #include <elf.h>
-#include <linux/ctype.h>
 #include <linux/types.h>
 
+#include "../util/util.h"
+#include "../util/ctype.h"
+
 #ifndef KSYM_NAME_LEN
 #define KSYM_NAME_LEN 256
 #endif
diff --git a/tools/perf/util/ctype.c b/tools/lib/util/ctype.c
similarity index 98%
rename from tools/perf/util/ctype.c
rename to tools/lib/util/ctype.c
index aada3ac5e891..5cbe3f792c59 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/lib/util/ctype.c
@@ -3,7 +3,7 @@
  *
  * No surprises, and works with signed and unsigned chars.
  */
-#include "util.h"
+#include "ctype.h"
 
 enum {
 	S = GIT_SPACE,
diff --git a/tools/lib/util/ctype.h b/tools/lib/util/ctype.h
new file mode 100644
index 000000000000..238ef8c8cdfc
--- /dev/null
+++ b/tools/lib/util/ctype.h
@@ -0,0 +1,46 @@
+#ifndef __TOOLS_CTYPE_H__
+#define __TOOLS_CTYPE_H__
+
+/* Sane ctype - no locale, and works with signed chars */
+#undef isascii
+#undef isspace
+#undef isdigit
+#undef isxdigit
+#undef isalpha
+#undef isprint
+#undef isalnum
+#undef islower
+#undef isupper
+#undef tolower
+#undef toupper
+
+extern unsigned char sane_ctype[256];
+
+#define GIT_SPACE		0x01
+#define GIT_DIGIT		0x02
+#define GIT_ALPHA		0x04
+#define GIT_GLOB_SPECIAL	0x08
+#define GIT_REGEX_SPECIAL	0x10
+#define GIT_PRINT_EXTRA		0x20
+#define GIT_PRINT		0x3E
+#define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
+#define isascii(x) (((x) & ~0x7f) == 0)
+#define isspace(x) sane_istest(x,GIT_SPACE)
+#define isdigit(x) sane_istest(x,GIT_DIGIT)
+#define isxdigit(x)	\
+	(sane_istest(toupper(x), GIT_ALPHA | GIT_DIGIT) && toupper(x) < 'G')
+#define isalpha(x) sane_istest(x,GIT_ALPHA)
+#define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
+#define isprint(x) sane_istest(x,GIT_PRINT)
+#define islower(x) (sane_istest(x,GIT_ALPHA) && (x & 0x20))
+#define isupper(x) (sane_istest(x,GIT_ALPHA) && !(x & 0x20))
+#define tolower(x) sane_case((unsigned char)(x), 0x20)
+#define toupper(x) sane_case((unsigned char)(x), 0)
+
+static inline int sane_case(int x, int high)
+{
+	if (sane_istest(x, GIT_ALPHA))
+		x = (x & ~0x20) | high;
+	return x;
+}
+#endif /* __TOOLS_CTYPE_H__ */
diff --git a/tools/lib/util/util.c b/tools/lib/util/util.c
new file mode 100644
index 000000000000..091c8b990744
--- /dev/null
+++ b/tools/lib/util/util.c
@@ -0,0 +1,34 @@
+#include "util.h"
+
+static int hex(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+int hex2u64(const char *ptr, u64 *long_val)
+{
+	const char *p = ptr;
+	*long_val = 0;
+
+	while (*p) {
+		const int hex_val = hex(*p);
+
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		p++;
+	}
+
+	return p - ptr;
+}
diff --git a/tools/lib/util/util.h b/tools/lib/util/util.h
new file mode 100644
index 000000000000..575c41f4f3f3
--- /dev/null
+++ b/tools/lib/util/util.h
@@ -0,0 +1,9 @@
+#ifndef __TOOLS_UTIL_H__
+#define __TOOLS_UTIL_H__
+
+#include <linux/types.h>
+
+int hex2u64(const char *ptr, u64 *val);
+
+#endif /* __TOOLS_UTIL_H__ */
+
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 45da209b6ed3..3608c5bf33cf 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -4,6 +4,7 @@ tools/lib/traceevent
 tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
+tools/lib/util/*.[ch]
 tools/include/asm/bug.h
 tools/include/linux/compiler.h
 tools/include/linux/hash.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16fa577..d359370d78c0 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -61,16 +61,6 @@ include config/utilities.mak
 # Define NO_LIBDW_DWARF_UNWIND if you do not want libdw support
 # for dwarf backtrace post unwind.
 
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(shell pwd)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-#$(info Determined 'srctree' to be $(srctree))
-endif
-
-ifneq ($(objtree),)
-#$(info Determined 'objtree' to be $(objtree))
-endif
-
 ifneq ($(OUTPUT),)
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
 endif
@@ -124,6 +114,7 @@ LIB_OBJS =
 GTK_OBJS =
 PYRF_OBJS =
 SCRIPT_SH =
+TOOLS_OBJS =
 
 SCRIPT_SH += perf-archive.sh
 
@@ -148,6 +139,9 @@ export LIBTRACEEVENT
 LIBAPIKFS = $(LIB_PATH)libapikfs.a
 export LIBAPIKFS
 
+TOOLS_OBJS += $(patsubst %.c,%.o,$(wildcard $(srctree)/tools/lib/symbol/*.c))
+TOOLS_OBJS += $(patsubst %.c,%.o,$(wildcard $(srctree)/tools/lib/util/*.c))
+
 # python extension build directories
 PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
 PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
@@ -157,7 +151,7 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 python-clean := $(call QUIET_CLEAN, python) $(RM) -r $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
-PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBAPIKFS)
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBAPIKFS) $(TOOLS_OBJS)
 
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
@@ -208,7 +202,6 @@ $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-LIB_H += ../lib/symbol/kallsyms.h
 LIB_H += ../../include/uapi/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
@@ -219,7 +212,6 @@ LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += util/include/linux/const.h
-LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += ../include/linux/export.h
@@ -306,7 +298,6 @@ LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
-LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
@@ -314,7 +305,6 @@ LIB_OBJS += $(OUTPUT)util/evlist.o
 LIB_OBJS += $(OUTPUT)util/evsel.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
-LIB_OBJS += $(OUTPUT)util/kallsyms.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
@@ -699,9 +689,6 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
-
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
@@ -741,8 +728,8 @@ $(DIRECTORY_DEPS): | $(OUTPUT_DIRECTORIES)
 $(OUTPUT_DIRECTORIES):
 	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
 
-$(LIB_FILE): $(LIB_OBJS)
-	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+$(LIB_FILE): $(LIB_OBJS) $(TOOLS_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS) $(TOOLS_OBJS)
 
 # libtraceevent.a
 TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 42faf369211c..a86e75f66b68 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -3,6 +3,8 @@
 #include "common.h"
 #include "../util/debug.h"
 
+#include <util/ctype.h>
+
 const char *const arm_triplets[] = {
 	"arm-eabi-",
 	"arm-linux-androideabi-",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 377971dc89a3..8cc7a361e756 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -66,6 +66,8 @@
 #include <sys/utsname.h>
 #include <sys/mman.h>
 
+#include <util/ctype.h>
+
 #include <linux/unistd.h>
 #include <linux/types.h>
 
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 9d2294efc00c..09b9f28849b5 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -14,6 +14,8 @@
 #include "keysyms.h"
 #include "../color.h"
 
+#include <util/ctype.h>
+
 static int ui_browser__percent_color(struct ui_browser *browser,
 				     double percent, bool current)
 {
diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index b11639f33682..e77ee26aa5e9 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -12,6 +12,8 @@
 #include "../keysyms.h"
 #include "map.h"
 
+#include <util/ctype.h>
+
 struct map_browser {
 	struct ui_browser b;
 	struct map	  *map;
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index c0b43ee40d95..c9c8429ade1e 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -1,5 +1,7 @@
 #include "cache.h"
 
+#include <util/ctype.h>
+
 static const char *alias_key;
 static char *alias_val;
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 809b4c50beae..947c871737f1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -20,6 +20,8 @@
 #include <pthread.h>
 #include <linux/bitops.h>
 
+#include <util/ctype.h>
+
 const char 	*disassembler_style;
 const char	*objdump_path;
 
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 87b8672eb413..d933e1daa19a 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -3,6 +3,8 @@
 #include "color.h"
 #include <math.h>
 
+#include <util/ctype.h>
+
 int perf_use_color_default = -1;
 
 static int parse_color(const char *name, int len)
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 24519e14ac56..ca6a6c24361b 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -13,6 +13,8 @@
 #include "exec_cmd.h"
 #include "util/hist.h"  /* perf_hist_config */
 
+#include <util/ctype.h>
+
 #define MAXNAME (256)
 
 #define DEBUG_CACHE_DIR ".debug"
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index c4e55b71010c..43ec84c77d87 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,5 +1,6 @@
 #include "util.h"
 #include <api/fs/fs.h>
+#include <util/ctype.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 299b55586502..b705653b776d 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -1,5 +1,7 @@
 /* For general debugging purposes */
 
+#include <util/ctype.h>
+
 #include "../perf.h"
 
 #include <string.h>
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 893f8e2df928..3e0455e53302 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <sys/utsname.h>
+#include <util/ctype.h>
 
 #include "evlist.h"
 #include "evsel.h"
diff --git a/tools/perf/util/include/linux/ctype.h b/tools/perf/util/include/linux/ctype.h
deleted file mode 100644
index a53d4ee1e0b7..000000000000
--- a/tools/perf/util/include/linux/ctype.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../util.h"
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 92590b2c7e1c..f8a50e89dc3b 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -6,6 +6,8 @@
 #include "intlist.h"
 #include "probe-event.h"
 
+#include <util/ctype.h>
+
 #define MAX_PROBE_BUFFER	1024
 #define MAX_PROBES		 128
 #define MAX_PROBE_ARGS		 128
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 16a475a7d492..24a991a7d9e8 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -6,7 +6,6 @@
 #
 
 util/python.c
-util/ctype.c
 util/evlist.c
 util/evsel.c
 util/cpumap.c
diff --git a/tools/perf/util/strfilter.c b/tools/perf/util/strfilter.c
index 79a757a2a15c..4b40baf0006d 100644
--- a/tools/perf/util/strfilter.c
+++ b/tools/perf/util/strfilter.c
@@ -2,6 +2,8 @@
 #include "string.h"
 #include "strfilter.h"
 
+#include <util/ctype.h>
+
 /* Operators */
 static const char *OP_and	= "&";	/* Logical AND */
 static const char *OP_or	= "|";	/* Logical OR */
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 2553e5b55b89..4017e56cc513 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,6 +1,8 @@
 #include "util.h"
 #include "linux/string.h"
 
+#include <util/ctype.h>
+
 #define K 1024LL
 /*
  * perf_atoll()
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7b9096f29cdb..38a370d906b8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -21,6 +21,8 @@
 #include <symbol/kallsyms.h>
 #include <sys/utsname.h>
 
+#include <util/util.h>
+
 static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter);
 static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 95aefa78bb07..175e6909ceb3 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -206,39 +206,6 @@ size_t hex_width(u64 v)
 	return n;
 }
 
-static int hex(char ch)
-{
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
-/*
- * While we find nice hex chars, build a long_val.
- * Return number of chars processed.
- */
-int hex2u64(const char *ptr, u64 *long_val)
-{
-	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
-
-		if (hex_val < 0)
-			break;
-
-		*long_val = (*long_val << 4) | hex_val;
-		p++;
-	}
-
-	return p - ptr;
-}
-
 /* Obtain a backtrace and print it to stdout. */
 #ifdef HAVE_BACKTRACE_SUPPORT
 void dump_stack(void)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 66864364ccb4..0021cda21b00 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -196,54 +196,12 @@ static inline int has_extension(const char *filename, const char *ext)
 	return len > extlen && !memcmp(filename + len - extlen, ext, extlen);
 }
 
-/* Sane ctype - no locale, and works with signed chars */
-#undef isascii
-#undef isspace
-#undef isdigit
-#undef isxdigit
-#undef isalpha
-#undef isprint
-#undef isalnum
-#undef islower
-#undef isupper
-#undef tolower
-#undef toupper
-
 #ifndef NSEC_PER_MSEC
 #define NSEC_PER_MSEC	1000000L
 #endif
 
 int parse_nsec_time(const char *str, u64 *ptime);
 
-extern unsigned char sane_ctype[256];
-#define GIT_SPACE		0x01
-#define GIT_DIGIT		0x02
-#define GIT_ALPHA		0x04
-#define GIT_GLOB_SPECIAL	0x08
-#define GIT_REGEX_SPECIAL	0x10
-#define GIT_PRINT_EXTRA		0x20
-#define GIT_PRINT		0x3E
-#define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
-#define isascii(x) (((x) & ~0x7f) == 0)
-#define isspace(x) sane_istest(x,GIT_SPACE)
-#define isdigit(x) sane_istest(x,GIT_DIGIT)
-#define isxdigit(x)	\
-	(sane_istest(toupper(x), GIT_ALPHA | GIT_DIGIT) && toupper(x) < 'G')
-#define isalpha(x) sane_istest(x,GIT_ALPHA)
-#define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
-#define isprint(x) sane_istest(x,GIT_PRINT)
-#define islower(x) (sane_istest(x,GIT_ALPHA) && (x & 0x20))
-#define isupper(x) (sane_istest(x,GIT_ALPHA) && !(x & 0x20))
-#define tolower(x) sane_case((unsigned char)(x), 0x20)
-#define toupper(x) sane_case((unsigned char)(x), 0)
-
-static inline int sane_case(int x, int high)
-{
-	if (sane_istest(x, GIT_ALPHA))
-		x = (x & ~0x20) | high;
-	return x;
-}
-
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
 int copyfile_mode(const char *from, const char *to, mode_t mode);
@@ -296,7 +254,6 @@ static inline unsigned long next_pow2_l(unsigned long x)
 }
 
 size_t hex_width(u64 v);
-int hex2u64(const char *ptr, u64 *val);
 
 char *ltrim(char *s);
 char *rtrim(char *s);
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 8abbef164b4e..7439b9de1a4a 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -82,3 +82,15 @@ ifneq ($(findstring $(MAKEFLAGS),s),s)
 	QUIET_INSTALL  = @printf '  INSTALL  %s\n' $1;
   endif
 endif
+
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
+endif
+
+ifneq ($(objtree),)
+#$(info Determined 'objtree' to be $(objtree))
+endif
+
+
-- 
2.0.0


--82I3+IH0IqGh5yIs--
