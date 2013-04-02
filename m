Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344Ab3DBDyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:54:16 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:50208 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760314Ab3DBDyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:54:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/23] perf: remove NEWT_SUPPORT in favor of CONFIG_NEWT
Date: Mon,  1 Apr 2013 21:53:12 -0600
Message-Id: <1364874809-5575-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874809-5575-1-git-send-email-dsahern@gmail.com>
References: <1364874809-5575-1-git-send-email-dsahern@gmail.com>
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
 tools/perf/ui/ui.h         |    3 ++-
 tools/perf/util/annotate.h |    3 ++-
 tools/perf/util/hist.h     |    3 ++-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f4c3b02..0cee87c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -672,7 +672,6 @@ ifdef CONFIG_NEWT
 
     # Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
     BASIC_CFLAGS += -I/usr/include/slang
-    BASIC_CFLAGS += -DNEWT_SUPPORT
     EXTLIBS += -lnewt -lslang
     LIB_OBJS += $(OUTPUT)ui/browser.o
     LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index d86359c..b030017 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -4,6 +4,7 @@
 #include <pthread.h>
 #include <stdbool.h>
 #include <linux/compiler.h>
+#include <linux/kconfig.h>
 
 extern pthread_mutex_t ui__lock;
 
@@ -12,7 +13,7 @@ extern int use_browser;
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef NEWT_SUPPORT
+#ifdef CONFIG_NEWT
 int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #else
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c422440..0435758 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <pthread.h>
+#include <linux/kconfig.h>
 
 struct ins;
 
@@ -141,7 +142,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
 			 int max_lines);
 
-#ifdef NEWT_SUPPORT
+#ifdef CONFIG_NEWT
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			 struct hist_browser_timer *hbt);
 #else
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 226a4ae..83c1627 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include <linux/kconfig.h>
 
 extern struct callchain_param callchain_param;
 
@@ -175,7 +176,7 @@ struct hist_browser_timer {
 	int refresh;
 };
 
-#ifdef NEWT_SUPPORT
+#ifdef CONFIG_NEWT
 #include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 			     struct hist_browser_timer *hbt);
-- 
1.7.10.1

