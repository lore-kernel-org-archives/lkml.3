Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab3DATUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:20:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415Ab3DATT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:19:57 -0400
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
Subject: [PATCH 09/27] perf tools: Move libaudit check config into config/Makefile
Date: Mon,  1 Apr 2013 21:18:32 +0200
Message-Id: <1364843930-17974-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving libaudit check config into config/Makefile.

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
index 5e877a4..16d1362 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -493,14 +493,7 @@ ifndef NO_LIBUNWIND
 endif
 
 ifndef NO_LIBAUDIT
-	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
-	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
-		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
-	else
-		BASIC_CFLAGS += -DLIBAUDIT_SUPPORT
-		BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
-		EXTLIBS += -laudit
-	endif
+	BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
 endif
 
 ifndef NO_SLANG
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 92c395f..52d6fe9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -197,3 +197,14 @@ ifndef NO_LIBUNWIND
 	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
 	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
 endif # NO_LIBUNWIND
+
+ifndef NO_LIBAUDIT
+	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
+	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
+		NO_LIBAUDIT := 1
+	else
+		BASIC_CFLAGS += -DLIBAUDIT_SUPPORT
+		EXTLIBS += -laudit
+	endif
+endif
-- 
1.7.11.7

