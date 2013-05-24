Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3EXMjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:39:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab3EXMjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:39:00 -0400
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
Subject: [PATCH 23/25] perf tools: Replace multiple line assignment with multiple statements
Date: Fri, 24 May 2013 14:35:26 +0200
Message-Id: <1369398928-9809-24-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing multiple line assignment with multiple statements.

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
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
 tools/perf/config/Makefile | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9765993..f139dcd 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -78,13 +78,12 @@ ifdef PARSER_DEBUG
   CFLAGS             += -DPARSER_DEBUG
 endif
 
-CFLAGS += \
-  -fno-omit-frame-pointer \
-  -ggdb3 \
-  -funwind-tables \
-  -Wall \
-  -Wextra \
-  -std=gnu99
+CFLAGS += -fno-omit-frame-pointer
+CFLAGS += -ggdb3
+CFLAGS += -funwind-tables
+CFLAGS += -Wall
+CFLAGS += -Wextra
+CFLAGS += -std=gnu99
 
 EXTLIBS = -lpthread -lrt -lelf -lm
 
@@ -106,30 +105,26 @@ ifndef PERF_DEBUG
   endif
 endif
 
-CFLAGS += \
-  -I$(src-perf)/util/include \
-  -I$(src-perf)/arch/$(ARCH)/include \
-  -I$(srctree)/arch/$(ARCH)/include/uapi \
-  -I$(srctree)/arch/$(ARCH)/include \
-  -I$(srctree)/include/uapi \
-  -I$(srctree)/include
+CFLAGS += -I$(src-perf)/util/include
+CFLAGS += -I$(src-perf)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include/uapi
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/include/uapi
+CFLAGS += -I$(srctree)/include
 
 # $(obj-perf)      for generated common-cmds.h
 # $(obj-perf)/util for generated bison/flex headers
 ifneq ($(OUTPUT),)
-CFLAGS += \
-  -I$(obj-perf)/util \
-  -I$(obj-perf)
+CFLAGS += -I$(obj-perf)/util
+CFLAGS += -I$(obj-perf)
 endif
 
-CFLAGS += \
-  -I$(src-perf)/util \
-  -I$(src-perf) \
-  -I$(TRACE_EVENT_DIR) \
-  -I$(srctree)/tools/lib/
+CFLAGS += -I$(src-perf)/util
+CFLAGS += -I$(src-perf)
+CFLAGS += -I$(TRACE_EVENT_DIR)
+CFLAGS += -I$(srctree)/tools/lib/
 
-CFLAGS += \
-  -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-- 
1.7.11.7

