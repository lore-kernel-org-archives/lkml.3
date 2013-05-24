Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3EXMhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:37:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab3EXMhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:37:07 -0400
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
Subject: [PATCH 21/25] perf tools: Add NO_BIONIC variable to confiure bionic setup
Date: Fri, 24 May 2013 14:35:24 +0200
Message-Id: <1369398928-9809-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding NO_BIONIC variable to confiure bionic setup

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
 tools/perf/Makefile        | 4 ++++
 tools/perf/config/Makefile | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 87c70e8..9b6d100 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -51,6 +51,10 @@ include config/utilities.mak
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
 #
 # Define NO_LIBNUMA if you do not want numa perf benchmark
+#
+# Define NO_LIBAUDIT if you do not want libaudit support
+#
+# Define NO_LIBBIONIC if you do not want bionic support
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8762209..cc464f1 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -131,11 +131,13 @@ CFLAGS += \
 CFLAGS += \
 	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
+ifndef NO_BIONIC
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	BIONIC := 1
 	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 endif
+endif # NO_BIONIC
 
 ifdef NO_LIBELF
 	NO_DWARF := 1
-- 
1.7.11.7

