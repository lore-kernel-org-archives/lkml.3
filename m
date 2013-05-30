Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935454Ab3E3QKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:10:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51064 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934656Ab3E3QC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:26 -0400
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
Subject: [PATCH 42/66] perf tools: Move gtk2 check config into config/Makefile
Date: Thu, 30 May 2013 19:01:15 +0300
Message-Id: <1369929699-8724-43-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving gtk2 check config into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-11-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 25 +++++++------------------
 tools/perf/config/Makefile | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f0c23ce..8e59a4d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -521,24 +521,13 @@ ifndef NO_SLANG
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
index 06634be..8cf0958 100644
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
1.8.1.4

