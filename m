Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3DATUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759517Ab3DATUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:20:46 -0400
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
Subject: [PATCH 16/27] perf tools: Move libnuma check config into config/Makefile
Date: Mon,  1 Apr 2013 21:18:39 +0200
Message-Id: <1364843930-17974-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving libnuma check config into config/Makefile

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
 tools/perf/Makefile        |  9 +--------
 tools/perf/config/Makefile | 11 +++++++++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ad826b5..1524de7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -533,14 +533,7 @@ ifeq ($(NO_PERF_REGS),0)
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
index 8c832f7..b559693 100644
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
1.7.11.7

