Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935424Ab3E3QIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:08:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51090 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934747Ab3E3QC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:28 -0400
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
Subject: [PATCH 64/66] perf tools: Replace multiple line assignment with multiple statements
Date: Thu, 30 May 2013 19:01:37 +0300
Message-Id: <1369929699-8724-65-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Replacing multiple line assignment with multiple statements.

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
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
Link: http://lkml.kernel.org/r/1369398928-9809-24-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

