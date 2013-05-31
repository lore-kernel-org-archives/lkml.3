Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3EaL7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:59:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57102 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3EaL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:59:45 -0400
Date: Fri, 31 May 2013 04:57:12 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a32f4936bc022fd82b08a350a5587bd5a7e500d1@git.kernel.org>
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
In-Reply-To: <1369398928-9809-4-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move programs check into config/
 Makefile
Git-Commit-ID: a32f4936bc022fd82b08a350a5587bd5a7e500d1
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

Commit-ID:  a32f4936bc022fd82b08a350a5587bd5a7e500d1
Gitweb:     http://git.kernel.org/tip/a32f4936bc022fd82b08a350a5587bd5a7e500d1
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Mar 2013 00:32:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:06 +0300

perf tools: Move programs check into config/Makefile

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
