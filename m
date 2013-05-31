Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3EaMFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:05:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3EaMFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:05:48 -0400
Date: Fri, 31 May 2013 05:04:58 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4a8f888a63248db76096a8c9ac8f2124d601c60e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, bp@alien8.de,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, bp@alien8.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1369398928-9809-10-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-10-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move slang check config into config/
 Makefile
Git-Commit-ID: 4a8f888a63248db76096a8c9ac8f2124d601c60e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a8f888a63248db76096a8c9ac8f2124d601c60e
Gitweb:     http://git.kernel.org/tip/4a8f888a63248db76096a8c9ac8f2124d601c60e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Mar 2013 00:56:08 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 14:40:18 +0300

perf tools: Move slang check config into config/Makefile

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
