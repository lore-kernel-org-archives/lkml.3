Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327Ab3DBDyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:54:07 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49230 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760312Ab3DBDyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:54:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/23] perf: make newt support based on CONFIG_NEWT
Date: Mon,  1 Apr 2013 21:53:11 -0600
Message-Id: <1364874809-5575-6-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile                 |   46 +++++++++++++++++------------------
 tools/perf/Pconfig                  |    3 +++
 tools/perf/config/feature-tests.mak |    2 +-
 3 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 01e2abf..f4c3b02 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -34,8 +34,6 @@ include config/utilities.mak
 #
 # Define WERROR=0 to disable treating any warnings as errors.
 #
-# Define NO_NEWT if you do not want TUI support.
-#
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
 # Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
@@ -666,29 +664,29 @@ ifndef NO_LIBAUDIT
 	endif
 endif
 
-ifndef NO_NEWT
+ifdef CONFIG_NEWT
 	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
-	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT),libnewt),y)
-		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
-	else
-		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
-		BASIC_CFLAGS += -I/usr/include/slang
-		BASIC_CFLAGS += -DNEWT_SUPPORT
-		EXTLIBS += -lnewt -lslang
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
+    ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT),libnewt),y)
+        $(error newt not found. Please install newt-devel or libnewt-dev or disable CONFIG_NEWT)
+    endif
+
+    # Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
+    BASIC_CFLAGS += -I/usr/include/slang
+    BASIC_CFLAGS += -DNEWT_SUPPORT
+    EXTLIBS += -lnewt -lslang
+    LIB_OBJS += $(OUTPUT)ui/browser.o
+    LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
+    LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
+    LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+    LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
+    LIB_OBJS += $(OUTPUT)ui/tui/setup.o
+    LIB_OBJS += $(OUTPUT)ui/tui/util.o
+    LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
+    LIB_OBJS += $(OUTPUT)ui/tui/progress.o
+    LIB_H += ui/browser.h
+    LIB_H += ui/browsers/map.h
+    LIB_H += ui/keysyms.h
+    LIB_H += ui/libslang.h
 endif
 
 ifdef CONFIG_GTK2
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index 79e1fc3..367cc65 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -1,3 +1,6 @@
+config NEWT
+    bool "Enable newt-based TUI"
+
 config GTK2
     bool "Enable GTK-based UI"
 
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index bf906e8..7ec044f 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -61,7 +61,7 @@ int main(void)
 }
 endef
 
-ifndef NO_NEWT
+ifdef CONFIG_NEWT
 define SOURCE_NEWT
 #include <newt.h>
 
-- 
1.7.10.1

