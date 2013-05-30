Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab3E3QIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:08:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51093 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934296Ab3E3QC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 41/66] perf tools: Move slang check config into config/Makefile
Date: Thu, 30 May 2013 19:01:14 +0300
Message-Id: <1369929699-8724-42-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving slang check config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-10-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 02e58ff..06634be 100644
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
1.8.1.4

