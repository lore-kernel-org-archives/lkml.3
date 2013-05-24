Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3EXMgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3EXMgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:36:36 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 09/25] perf tools: Move slang check config into config/Makefile
Date: Fri, 24 May 2013 14:35:12 +0200
Message-Id: <1369398928-9809-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile        | 39 +++++++++++++--------------------------
 tools/perf/config/Makefile | 17 +++++++++++++++++
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 57d39ed..f0c23ce 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -99,10 +99,6 @@ ifeq ($(config),1)
 include config/Makefile
 endif
 
-ifdef NO_NEWT
-	NO_SLANG=1
-endif
-
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
@@ -509,28 +505,19 @@ ifndef NO_LIBAUDIT
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

