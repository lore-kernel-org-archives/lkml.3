Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbbATQlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:41:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbbATQlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:41:04 -0500
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
Subject: [PATCH 08/36] perf build: Add builtin objects building
Date: Tue, 20 Jan 2015 17:39:05 +0100
Message-Id: <1421771973-6022-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the rest of builtin objects (bench and test are
already in) building under build framework.

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
 tools/perf/Build           | 29 +++++++++++++++++++++++++++++
 tools/perf/Makefile.perf   | 35 -----------------------------------
 tools/perf/config/Makefile |  4 ++++
 3 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/tools/perf/Build b/tools/perf/Build
index b4b6a7ca760b..80a944b929da 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -1,3 +1,32 @@
 perf-y += builtin-bench.o
+perf-y += builtin-annotate.o
+perf-y += builtin-diff.o
+perf-y += builtin-evlist.o
+perf-y += builtin-help.o
+perf-y += builtin-sched.o
+perf-y += builtin-buildid-list.o
+perf-y += builtin-buildid-cache.o
+perf-y += builtin-list.o
+perf-y += builtin-record.o
+perf-y += builtin-report.o
+perf-y += builtin-stat.o
+perf-y += builtin-timechart.o
+perf-y += builtin-top.o
+perf-y += builtin-script.o
+perf-y += builtin-kmem.o
+perf-y += builtin-lock.o
+perf-y += builtin-kvm.o
+perf-y += builtin-inject.o
+perf-y += builtin-mem.o
+
+perf-$(CONFIG_AUDIT) += builtin-trace.o
+
 perf-y += bench/
 perf-y += tests/
+
+paths += -DPERF_HTML_PATH="BUILD_STR($(htmldir_SQ))"
+paths += -DPERF_INFO_PATH="BUILD_STR($(infodir_SQ))"
+paths += -DPERF_MAN_PATH="BUILD_STR($(mandir_SQ))"
+
+CFLAGS_builtin-help.o      += $(paths)
+CFLAGS_builtin-timechart.o += $(paths)
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 43620bd640ae..b0df3ec91104 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -425,26 +425,7 @@ LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
 LIB_OBJS += $(OUTPUT)arch/common.o
 
-BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
-BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
-BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
-BUILTIN_OBJS += $(OUTPUT)builtin-help.o
-BUILTIN_OBJS += $(OUTPUT)builtin-sched.o
-BUILTIN_OBJS += $(OUTPUT)builtin-buildid-list.o
-BUILTIN_OBJS += $(OUTPUT)builtin-buildid-cache.o
-BUILTIN_OBJS += $(OUTPUT)builtin-list.o
-BUILTIN_OBJS += $(OUTPUT)builtin-record.o
-BUILTIN_OBJS += $(OUTPUT)builtin-report.o
-BUILTIN_OBJS += $(OUTPUT)builtin-stat.o
-BUILTIN_OBJS += $(OUTPUT)builtin-timechart.o
-BUILTIN_OBJS += $(OUTPUT)builtin-top.o
-BUILTIN_OBJS += $(OUTPUT)builtin-script.o
 BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
-BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
-BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
-BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
-BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
-BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
 PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
 
@@ -486,10 +467,6 @@ ifndef NO_LIBUNWIND
   LIB_OBJS += $(OUTPUT)util/unwind-libunwind.o
 endif
 
-ifndef NO_LIBAUDIT
-  BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
-endif
-
 ifndef NO_SLANG
   LIB_OBJS += $(OUTPUT)ui/browser.o
   LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
@@ -591,18 +568,6 @@ $(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
 $(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) -o $@ -shared $(LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
 
-$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
-
-$(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
-
 $(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
 
 $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 10a0ad839390..e8723b4134f1 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -450,6 +450,7 @@ ifndef NO_LIBAUDIT
   else
     CFLAGS += -DHAVE_LIBAUDIT_SUPPORT
     EXTLIBS += -laudit
+    $(call detected,CONFIG_AUDIT)
   endif
 endif
 
@@ -825,3 +826,6 @@ $(call detected_var,PYTHON_WORD)
 ifneq ($(OUTPUT),)
 $(call detected_var,OUTPUT)
 endif
+$(call detected_var,htmldir_SQ)
+$(call detected_var,infodir_SQ)
+$(call detected_var,mandir_SQ)
-- 
1.9.3

