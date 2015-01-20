Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbbATR2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:28:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbbATR2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:28:00 -0500
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
Subject: [PATCH 14/36] perf build: Add slang objects building
Date: Tue, 20 Jan 2015 17:39:11 +0100
Message-Id: <1421771973-6022-15-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the slang objects building under build framework
to be included in the libperf build object.

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
 tools/perf/Makefile.perf     | 33 ---------------------------------
 tools/perf/config/Makefile   |  1 +
 tools/perf/ui/Build          |  6 ++++++
 tools/perf/ui/browsers/Build | 10 ++++++++++
 tools/perf/ui/tui/Build      |  4 ++++
 5 files changed, 21 insertions(+), 33 deletions(-)
 create mode 100644 tools/perf/ui/browsers/Build
 create mode 100644 tools/perf/ui/tui/Build

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 264c36c13e7d..603940d5f53b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -339,24 +339,6 @@ ifneq ($(OUTPUT),)
   CFLAGS += -I$(OUTPUT)
 endif
 
-ifndef NO_SLANG
-  LIB_OBJS += $(OUTPUT)ui/browser.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/map.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/header.o
-  LIB_OBJS += $(OUTPUT)ui/tui/setup.o
-  LIB_OBJS += $(OUTPUT)ui/tui/util.o
-  LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
-  LIB_OBJS += $(OUTPUT)ui/tui/progress.o
-  LIB_H += ui/tui/tui.h
-  LIB_H += ui/browser.h
-  LIB_H += ui/browsers/map.h
-  LIB_H += ui/keysyms.h
-  LIB_H += ui/libslang.h
-endif
-
 ifndef NO_GTK2
   ALL_PROGRAMS += $(OUTPUT)libperf-gtk.so
 
@@ -484,21 +466,6 @@ $(OUTPUT)%.o: %.S
 $(OUTPUT)%.s: %.S
 	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
 
-$(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/annotate.o: ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e7d1b46b7d31..4e5f080e2a22 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -473,6 +473,7 @@ ifndef NO_SLANG
     CFLAGS += -I/usr/include/slang
     CFLAGS += -DHAVE_SLANG_SUPPORT
     EXTLIBS += -lslang
+    $(call detected,CONFIG_SLANG)
   endif
 endif
 
diff --git a/tools/perf/ui/Build b/tools/perf/ui/Build
index 077b6a448ddc..0a73538c0441 100644
--- a/tools/perf/ui/Build
+++ b/tools/perf/ui/Build
@@ -6,3 +6,9 @@ libperf-y += hist.o
 libperf-y += stdio/hist.o
 
 CFLAGS_setup.o += -DLIBDIR="BUILD_STR($(LIBDIR))"
+
+libperf-$(CONFIG_SLANG) += browser.o
+libperf-$(CONFIG_SLANG) += browsers/
+libperf-$(CONFIG_SLANG) += tui/
+
+CFLAGS_browser.o += -DENABLE_SLFUTURE_CONST
diff --git a/tools/perf/ui/browsers/Build b/tools/perf/ui/browsers/Build
new file mode 100644
index 000000000000..de223f5bed58
--- /dev/null
+++ b/tools/perf/ui/browsers/Build
@@ -0,0 +1,10 @@
+libperf-y += annotate.o
+libperf-y += hists.o
+libperf-y += map.o
+libperf-y += scripts.o
+libperf-y += header.o
+
+CFLAGS_annotate.o += -DENABLE_SLFUTURE_CONST
+CFLAGS_hists.o    += -DENABLE_SLFUTURE_CONST
+CFLAGS_map.o      += -DENABLE_SLFUTURE_CONST
+CFLAGS_scripts.o  += -DENABLE_SLFUTURE_CONST
diff --git a/tools/perf/ui/tui/Build b/tools/perf/ui/tui/Build
new file mode 100644
index 000000000000..9e4c6ca41a9f
--- /dev/null
+++ b/tools/perf/ui/tui/Build
@@ -0,0 +1,4 @@
+libperf-y += setup.o
+libperf-y += util.o
+libperf-y += helpline.o
+libperf-y += progress.o
-- 
1.9.3

