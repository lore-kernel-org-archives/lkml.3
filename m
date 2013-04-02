Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625Ab3DBDzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:49 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64356 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760612Ab3DBDzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:45 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 22/23] perf: only add elf to EXTLIBS if CONFIG_LIBELF is set
Date: Mon,  1 Apr 2013 21:54:36 -0600
Message-Id: <1364874877-5618-23-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5037856..5990520 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -87,7 +87,7 @@ ifdef PARSER_DEBUG
 endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lpthread -lrt -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -541,6 +541,7 @@ endif
 # we had "elif" things would have been much nicer...
 
 ifdef CONFIG_LIBELF
+    EXTLIBS += -lelf
     FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 
     # try to compile with libelf support ...
@@ -570,7 +571,7 @@ ifdef CONFIG_LIBELF
 
     # libelf supported - what about dwarf?
     ifdef CONFIG_DWARF
-        FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+        FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
         ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
             $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138.ables dwarf support.)
             $(error Please install new elfutils-devel/libdw-dev or disable CONFIG_DWARF);
@@ -581,7 +582,7 @@ ifdef CONFIG_LIBELF
         else
             BASIC_CFLAGS := $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
             BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
-            EXTLIBS += -lelf -ldw
+            EXTLIBS += -ldw
             LIB_OBJS += $(OUTPUT)util/probe-finder.o
             LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
         endif # PERF_HAVE_DWARF_REGS
@@ -598,8 +599,6 @@ else
         $(error CONFIG_LIBUNWIND depends on LIBELF)
     endif
 
-    EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
-
     # Remove ELF/DWARF dependent codes
     LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
     LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
-- 
1.7.10.1

