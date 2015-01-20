Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbbATQqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:46:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbbATQmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:42:18 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/36] perf build: Remove uneeded variables
Date: Tue, 20 Jan 2015 17:39:26 +0100
Message-Id: <1421771973-6022-30-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing uneeded variables from Makefile.perf:

  BUILTIN_OBJS LIB_OBJS GTK_OBJS
  - objects are now hold by in the build Makefiles

  LIB_H
  - header dependencies iare now handled by Build
    framework

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile.perf | 125 ++---------------------------------------------
 1 file changed, 5 insertions(+), 120 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e0351da7cfde..d02c1f2622ca 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -137,10 +137,6 @@ export prefix bindir sharedir sysconfdir DESTDIR
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
 # Guard against environment variables
-BUILTIN_OBJS =
-LIB_H =
-LIB_OBJS =
-GTK_OBJS =
 PYRF_OBJS =
 SCRIPT_SH =
 
@@ -218,115 +214,6 @@ export PERL_PATH
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-LIB_H += ../lib/symbol/kallsyms.h
-LIB_H += ../../include/uapi/linux/perf_event.h
-LIB_H += ../../include/linux/rbtree.h
-LIB_H += ../../include/linux/list.h
-LIB_H += ../../include/uapi/linux/const.h
-LIB_H += ../include/linux/hash.h
-LIB_H += ../../include/linux/stringify.h
-LIB_H += util/include/linux/bitmap.h
-LIB_H += ../include/linux/bitops.h
-LIB_H += ../include/asm-generic/bitops/arch_hweight.h
-LIB_H += ../include/asm-generic/bitops/atomic.h
-LIB_H += ../include/asm-generic/bitops/const_hweight.h
-LIB_H += ../include/asm-generic/bitops/find.h
-LIB_H += ../include/asm-generic/bitops/fls64.h
-LIB_H += ../include/asm-generic/bitops/fls.h
-LIB_H += ../include/asm-generic/bitops/__ffs.h
-LIB_H += ../include/asm-generic/bitops/__fls.h
-LIB_H += ../include/asm-generic/bitops/hweight.h
-LIB_H += ../include/asm-generic/bitops.h
-LIB_H += ../include/linux/compiler.h
-LIB_H += ../include/linux/log2.h
-LIB_H += util/include/linux/const.h
-LIB_H += util/include/linux/ctype.h
-LIB_H += util/include/linux/kernel.h
-LIB_H += util/include/linux/list.h
-LIB_H += ../include/linux/export.h
-LIB_H += util/include/linux/poison.h
-LIB_H += util/include/linux/rbtree.h
-LIB_H += util/include/linux/rbtree_augmented.h
-LIB_H += util/include/linux/string.h
-LIB_H += ../include/linux/types.h
-LIB_H += util/include/linux/linkage.h
-LIB_H += util/include/asm/asm-offsets.h
-LIB_H += ../include/asm/bug.h
-LIB_H += util/include/asm/byteorder.h
-LIB_H += util/include/asm/swab.h
-LIB_H += util/include/asm/system.h
-LIB_H += util/include/asm/uaccess.h
-LIB_H += util/include/dwarf-regs.h
-LIB_H += util/include/asm/dwarf2.h
-LIB_H += util/include/asm/cpufeature.h
-LIB_H += util/include/asm/unistd_32.h
-LIB_H += util/include/asm/unistd_64.h
-LIB_H += perf.h
-LIB_H += util/annotate.h
-LIB_H += util/cache.h
-LIB_H += util/callchain.h
-LIB_H += util/build-id.h
-LIB_H += util/db-export.h
-LIB_H += util/debug.h
-LIB_H += util/pmu.h
-LIB_H += util/event.h
-LIB_H += util/evsel.h
-LIB_H += util/evlist.h
-LIB_H += util/exec_cmd.h
-LIB_H += util/find-vdso-map.c
-LIB_H += util/levenshtein.h
-LIB_H += util/machine.h
-LIB_H += util/map.h
-LIB_H += util/parse-options.h
-LIB_H += util/parse-events.h
-LIB_H += util/quote.h
-LIB_H += util/util.h
-LIB_H += util/xyarray.h
-LIB_H += util/header.h
-LIB_H += util/help.h
-LIB_H += util/session.h
-LIB_H += util/ordered-events.h
-LIB_H += util/strbuf.h
-LIB_H += util/strlist.h
-LIB_H += util/strfilter.h
-LIB_H += util/svghelper.h
-LIB_H += util/tool.h
-LIB_H += util/run-command.h
-LIB_H += util/sigchain.h
-LIB_H += util/dso.h
-LIB_H += util/symbol.h
-LIB_H += util/color.h
-LIB_H += util/values.h
-LIB_H += util/sort.h
-LIB_H += util/hist.h
-LIB_H += util/comm.h
-LIB_H += util/thread.h
-LIB_H += util/thread_map.h
-LIB_H += util/trace-event.h
-LIB_H += util/probe-finder.h
-LIB_H += util/dwarf-aux.h
-LIB_H += util/probe-event.h
-LIB_H += util/pstack.h
-LIB_H += util/cpumap.h
-LIB_H += util/top.h
-LIB_H += $(ARCH_INCLUDE)
-LIB_H += util/cgroup.h
-LIB_H += $(LIB_INCLUDE)traceevent/event-parse.h
-LIB_H += util/target.h
-LIB_H += util/rblist.h
-LIB_H += util/intlist.h
-LIB_H += util/perf_regs.h
-LIB_H += util/unwind.h
-LIB_H += util/vdso.h
-LIB_H += util/tsc.h
-LIB_H += ui/helpline.h
-LIB_H += ui/progress.h
-LIB_H += ui/util.h
-LIB_H += ui/ui.h
-LIB_H += util/data.h
-LIB_H += util/kvm-stat.h
-LIB_H += util/thread-stack.h
-
 PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
@@ -379,9 +266,8 @@ build := -f $(srctree)/tools/build/Makefile.build dir=. obj
 $(PERF_IN): $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h FORCE
 	@$(MAKE) $(build)=perf
 
-$(OUTPUT)perf: $(BUILTIN_OBJS) $(PERFLIBS) $(PERF_IN)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) \
-               $(BUILTIN_OBJS) $(PERF_IN) $(LIBS) -o $@
+$(OUTPUT)perf: $(PERFLIBS) $(PERF_IN)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(PERF_IN) $(LIBS) -o $@
 
 $(GTK_IN): FORCE
 	@$(MAKE) $(build)=gtk
@@ -462,15 +348,14 @@ $(OUTPUT)perf-read-vdsox32: perf-read-vdso.c util/find-vdso-map.c
 	$(QUIET_CC)$(CC) -mx32 $(filter -static,$(LDFLAGS)) -Wall -Werror -o $@ perf-read-vdso.c
 endif
 
-$(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
-$(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
+$(patsubst perf-%,%.o,$(PROGRAMS)): $(wildcard */*.h)
 
 LIBPERF_IN := $(OUTPUT)libperf-in.o
 
 $(LIBPERF_IN): FORCE
 	@$(MAKE) $(build)=libperf
 
-$(LIB_FILE): $(LIB_OBJS) $(LIBPERF_IN)
+$(LIB_FILE): $(LIBPERF_IN)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIBPERF_IN) $(LIB_OBJS)
 
 # libtraceevent.a
@@ -655,7 +540,7 @@ config-clean:
 	@$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
-	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(LANG_BINDINGS)
+	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(LANG_BINDINGS)
 	@find . -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
 	@$(RM) .config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
-- 
1.9.3

