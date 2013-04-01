Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab3DATUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372Ab3DATUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:20:06 -0400
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
Subject: [PATCH 04/27] perf tools: Move programs check into config/Makefile
Date: Mon,  1 Apr 2013 21:18:27 +0200
Message-Id: <1364843930-17974-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving programs check into config/Makefile.

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
 tools/perf/Makefile        | 24 ++++++++----------------
 tools/perf/config/Makefile | 10 ++++++++++
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 032e099..8dd3320 100644
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
 ifeq ($(filter clean tags,$(MAKECMDGOALS)),)
 include config/Makefile
 endif
@@ -88,7 +96,6 @@ CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
-STRIP ?= strip
 
 # Among the variables below, these:
 #   perfexecdir
@@ -125,13 +132,6 @@ lib = lib
 
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
@@ -140,14 +140,6 @@ ifneq ($(MAKECMDGOALS),clean)
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
1.7.11.7

