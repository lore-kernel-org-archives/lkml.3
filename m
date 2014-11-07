Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKGFUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:20:34 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33216 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGFUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:20:30 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/3] perf tools: Clean up libelf feature support code
Date: Fri,  7 Nov 2014 14:20:06 +0900
Message-Id: <1415337606-2186-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current EXTLIBS contains -lelf by default and removes it when libelf
is not detected.  This is little bit confusing since we can now build
perf without libelf so there's no need to handle it differently than
other libraries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf   | 2 --
 tools/perf/config/Makefile | 5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 31a76ee92c93..06cccdceb0ae 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -495,8 +495,6 @@ ifneq ($(OUTPUT),)
 endif
 
 ifdef NO_LIBELF
-EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
-
 # Remove ELF/DWARF dependent codes
 LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
 LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 79f906c7124e..5d4b039fe1ed 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -150,7 +150,7 @@ CFLAGS += -std=gnu99
 # adding assembler files missing the .GNU-stack linker note.
 LDFLAGS += -Wl,-z,noexecstack
 
-EXTLIBS = -lelf -lpthread -lrt -lm -ldl
+EXTLIBS = -lpthread -lrt -lm -ldl
 
 ifneq ($(OUTPUT),)
   OUTPUT_FEATURES = $(OUTPUT)config/feature-checks/
@@ -354,6 +354,7 @@ endif # NO_LIBELF
 
 ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
+  EXTLIBS += -lelf
 
   ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
@@ -373,7 +374,7 @@ ifndef NO_LIBELF
     else
       CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
       LDFLAGS += $(LIBDW_LDFLAGS)
-      EXTLIBS += -lelf -ldw
+      EXTLIBS += -ldw
     endif # PERF_HAVE_DWARF_REGS
   endif # NO_DWARF
 endif # NO_LIBELF
-- 
2.1.2

