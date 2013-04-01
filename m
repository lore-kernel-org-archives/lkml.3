Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab3DATYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:24:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372Ab3DATUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:20:24 -0400
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
Subject: [PATCH 11/27] perf tools: Move gtk2 check config into config/Makefile
Date: Mon,  1 Apr 2013 21:18:34 +0200
Message-Id: <1364843930-17974-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving gtk2 check config into config/Makefile.

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
 tools/perf/Makefile        | 25 +++++++------------------
 tools/perf/config/Makefile | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f6744cb..8d3dd8e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -509,24 +509,13 @@ ifndef NO_SLANG
 endif
 
 ifndef NO_GTK2
-	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
-		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
-	else
-		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
-		endif
-		BASIC_CFLAGS += -DGTK2_SUPPORT
-		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
-		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
-	endif
+	LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
+	LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
+	LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
+	LIB_OBJS += $(OUTPUT)ui/gtk/util.o
+	LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
+	LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
+	LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
 endif
 
 ifdef NO_LIBPERL
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 008b212..6fc2089 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -225,3 +225,18 @@ ifndef NO_SLANG
 		EXTLIBS += -lslang
 	endif
 endif
+
+ifndef NO_GTK2
+	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
+		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
+		NO_GTK2 := 1
+	else
+		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
+			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
+		endif
+		BASIC_CFLAGS += -DGTK2_SUPPORT
+		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+	endif
+endif
-- 
1.7.11.7

