Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3E3QGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:06:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51151 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934760Ab3E3QCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:48 -0400
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
Subject: [PATCH 47/66] perf tools: Move libnuma check config into config/Makefile
Date: Thu, 30 May 2013 19:01:20 +0300
Message-Id: <1369929699-8724-48-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving libnuma check config into config/Makefile

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
Link: http://lkml.kernel.org/r/1369398928-9809-16-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        |  9 +--------
 tools/perf/config/Makefile | 11 +++++++++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9276576..11525ac 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -545,14 +545,7 @@ ifeq ($(NO_PERF_REGS),0)
 endif
 
 ifndef NO_LIBNUMA
-	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
-	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
-		msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
-	else
-		BASIC_CFLAGS += -DLIBNUMA_SUPPORT
-		BUILTIN_OBJS += $(OUTPUT)bench/numa.o
-		EXTLIBS += -lnuma
-	endif
+	BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 endif
 
 ifdef ASCIIDOC8
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8c0e43f..124c344 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -379,3 +379,14 @@ ifndef NO_BACKTRACE
 		BASIC_CFLAGS += -DBACKTRACE_SUPPORT
        endif
 endif
+
+ifndef NO_LIBNUMA
+	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
+	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+		msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
+		NO_LIBNUMA := 1
+	else
+		BASIC_CFLAGS += -DLIBNUMA_SUPPORT
+		EXTLIBS += -lnuma
+	endif
+endif
-- 
1.8.1.4

