Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab3DXJjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:39:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab3DXJjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:39:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 15/26] perf tools: Move stdlib check config into config/Makefile
Date: Wed, 24 Apr 2013 11:37:42 +0200
Message-Id: <1366796273-4780-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving stdlib check config into config/Makefile.

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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile        | 18 ------------------
 tools/perf/config/Makefile | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c116417..c1fef3d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -546,24 +546,6 @@ ifeq ($(NO_PERF_REGS),0)
 	endif
 endif
 
-ifndef NO_STRLCPY
-	ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
-		BASIC_CFLAGS += -DHAVE_STRLCPY
-	endif
-endif
-
-ifndef NO_ON_EXIT
-	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
-		BASIC_CFLAGS += -DHAVE_ON_EXIT
-	endif
-endif
-
-ifndef NO_BACKTRACE
-       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
-               BASIC_CFLAGS += -DBACKTRACE_SUPPORT
-       endif
-endif
-
 ifndef NO_LIBNUMA
 	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
 	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 68c6a2b..8c832f7 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -361,3 +361,21 @@ else
 		endif
 	endif
 endif
+
+ifndef NO_STRLCPY
+	ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
+		BASIC_CFLAGS += -DHAVE_STRLCPY
+	endif
+endif
+
+ifndef NO_ON_EXIT
+	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
+		BASIC_CFLAGS += -DHAVE_ON_EXIT
+	endif
+endif
+
+ifndef NO_BACKTRACE
+       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
+		BASIC_CFLAGS += -DBACKTRACE_SUPPORT
+       endif
+endif
-- 
1.7.11.7

