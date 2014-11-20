Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaKTHh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:37:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKTHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:37:27 -0500
Date: Wed, 19 Nov 2014 23:36:56 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-5e2d4d0e88dac4003cf96aca00d63aff2314391e@git.kernel.org>
Cc: acme@redhat.com, paulus@samba.org, namhyung@kernel.org, mingo@kernel.org,
        jolsa@redhat.com, a.p.zijlstra@chello.nl, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, hpa@zytor.com, tglx@linutronix.de
Reply-To: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, namhyung.kim@lge.com, dsahern@gmail.com,
        jolsa@redhat.com, a.p.zijlstra@chello.nl, acme@redhat.com,
        paulus@samba.org, mingo@kernel.org, namhyung@kernel.org
In-Reply-To: <1415337606-2186-3-git-send-email-namhyung@kernel.org>
References: <1415337606-2186-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Clean up libelf feature support code
Git-Commit-ID: 5e2d4d0e88dac4003cf96aca00d63aff2314391e
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

Commit-ID:  5e2d4d0e88dac4003cf96aca00d63aff2314391e
Gitweb:     http://git.kernel.org/tip/5e2d4d0e88dac4003cf96aca00d63aff2314391e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 7 Nov 2014 14:20:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:46 -0300

perf tools: Clean up libelf feature support code

Current EXTLIBS contains -lelf by default and removes it when libelf is
not detected.

This is little bit confusing since we can now build perf without libelf
so there's no need to handle it differently than other libraries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1415337606-2186-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf   | 2 --
 tools/perf/config/Makefile | 5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index aecf61dc..478efa9 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -497,8 +497,6 @@ ifneq ($(OUTPUT),)
 endif
 
 ifdef NO_LIBELF
-EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
-
 # Remove ELF/DWARF dependent codes
 LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
 LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 79f906c..5d4b039 100644
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
