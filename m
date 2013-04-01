Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab3DATYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759483Ab3DATUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:20:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/27] perf tools: Move slang check config into config/Makefile
Date: Mon,  1 Apr 2013 21:18:33 +0200
Message-Id: <1364843930-17974-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving slang check config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile        | 39 +++++++++++++--------------------------
 tools/perf/config/Makefile | 17 +++++++++++++++++
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 16d1362..f6744cb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -87,10 +87,6 @@ ifeq ($(filter clean tags,$(MAKECMDGOALS)),)
 include config/Makefile
 endif
 
-ifdef NO_NEWT
-	NO_SLANG=1
-endif
-
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
@@ -497,28 +493,19 @@ ifndef NO_LIBAUDIT
 endif
 
 ifndef NO_SLANG
-	FLAGS_SLANG=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-	ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
-		msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
-	else
-		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
-		BASIC_CFLAGS += -I/usr/include/slang
-		BASIC_CFLAGS += -DSLANG_SUPPORT
-		EXTLIBS += -lslang
-		LIB_OBJS += $(OUTPUT)ui/browser.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
-		LIB_OBJS += $(OUTPUT)ui/tui/util.o
-		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
-		LIB_OBJS += $(OUTPUT)ui/tui/progress.o
-		LIB_H += ui/browser.h
-		LIB_H += ui/browsers/map.h
-		LIB_H += ui/keysyms.h
-		LIB_H += ui/libslang.h
-	endif
+	LIB_OBJS += $(OUTPUT)ui/browser.o
+	LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
+	LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
+	LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+	LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
+	LIB_OBJS += $(OUTPUT)ui/tui/setup.o
+	LIB_OBJS += $(OUTPUT)ui/tui/util.o
+	LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
+	LIB_OBJS += $(OUTPUT)ui/tui/progress.o
+	LIB_H += ui/browser.h
+	LIB_H += ui/browsers/map.h
+	LIB_H += ui/keysyms.h
+	LIB_H += ui/libslang.h
 endif
 
 ifndef NO_GTK2
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 52d6fe9..008b212 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -208,3 +208,20 @@ ifndef NO_LIBAUDIT
 		EXTLIBS += -laudit
 	endif
 endif
+
+ifdef NO_NEWT
+	NO_SLANG=1
+endif
+
+ifndef NO_SLANG
+	FLAGS_SLANG=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
+	ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+		msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
+		NO_SLANG := 1
+	else
+		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
+		BASIC_CFLAGS += -I/usr/include/slang
+		BASIC_CFLAGS += -DSLANG_SUPPORT
+		EXTLIBS += -lslang
+	endif
+endif
-- 
1.7.11.7

