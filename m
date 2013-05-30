Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935434Ab3E3QJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:09:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51087 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934745Ab3E3QC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:27 -0400
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
Subject: [PATCH 35/66] perf tools: Move programs check into config/Makefile
Date: Thu, 30 May 2013 19:01:08 +0300
Message-Id: <1369929699-8724-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving programs check into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 24 ++++++++----------------
 tools/perf/config/Makefile | 10 ++++++++++
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a4abdaf..2a75476 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -58,6 +58,14 @@ $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
+RM      = rm -f
+MKDIR   = mkdir
+FIND    = find
+INSTALL = install
+FLEX    = flex
+BISON   = bison
+STRIP  ?= strip
+
 # include config/Makefile by default and rule out
 # non-config cases
 config := 1
@@ -100,7 +108,6 @@ CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
-STRIP ?= strip
 
 # Among the variables below, these:
 #   perfexecdir
@@ -137,13 +144,6 @@ lib = lib
 
 export prefix bindir sharedir sysconfdir
 
-RM = rm -f
-MKDIR = mkdir
-FIND = find
-INSTALL = install
-FLEX = flex
-BISON= bison
-
 # sparse is architecture-neutral, which means that we need to tell it
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
@@ -152,14 +152,6 @@ ifneq ($(MAKECMDGOALS),clean)
 ifneq ($(MAKECMDGOALS),tags)
 -include config/feature-tests.mak
 
-ifeq ($(call get-executable,$(FLEX)),)
-	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
-endif
-
-ifeq ($(call get-executable,$(BISON)),)
-	dummy := $(error Error: $(BISON) is missing on this system, please install it)
-endif
-
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index fe317c2..04bf8ac 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -32,3 +32,13 @@ endif
 ifeq ($(NO_PERF_REGS),0)
         BASIC_CFLAGS += -DHAVE_PERF_REGS
 endif
+
+-include config/feature-tests.mak
+
+ifeq ($(call get-executable,$(FLEX)),)
+	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
+endif
+
+ifeq ($(call get-executable,$(BISON)),)
+	dummy := $(error Error: $(BISON) is missing on this system, please install it)
+endif
-- 
1.8.1.4

