Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab3DBD7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:59:49 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63650 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760461Ab3DBDzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:04 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/23] perf: remove GTK2_SUPPORT in favor of CONFIG_GTK2
Date: Mon,  1 Apr 2013 21:54:21 -0600
Message-Id: <1364874877-5618-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile        |    1 -
 tools/perf/ui/ui.h         |    2 +-
 tools/perf/util/annotate.h |    2 +-
 tools/perf/util/hist.h     |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0cee87c..0060275 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -696,7 +696,6 @@ ifdef CONFIG_GTK2
     ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
         BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
     endif
-    BASIC_CFLAGS += -DGTK2_SUPPORT
     BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
     EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
     LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index b030017..5f3465c 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -24,7 +24,7 @@ static inline int ui__init(void)
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef CONFIG_GTK2
 int perf_gtk__init(void);
 void perf_gtk__exit(bool wait_for_ok);
 #else
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 0435758..2a2e413 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -156,7 +156,7 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 }
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef CONFIG_GTK2
 int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 			 struct hist_browser_timer *hbt);
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 83c1627..e1c2182 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -214,7 +214,7 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #define K_SWITCH_INPUT_DATA -3000
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef CONFIG_GTK2
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt __maybe_unused);
 #else
-- 
1.7.10.1

