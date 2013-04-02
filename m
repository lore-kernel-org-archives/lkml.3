Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637Ab3DBD4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:56:04 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47735 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759869Ab3DBDzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:47 -0400
X-Greylist: delayed 18518 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2013 23:55:47 EDT
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 23/23] perf: only add elf-based object files if CONFIG_LIBELF is set
Date: Mon,  1 Apr 2013 21:54:37 -0600
Message-Id: <1364874877-5618-24-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5990520..b16a944 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -430,7 +430,6 @@ LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/dso.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
-LIB_OBJS += $(OUTPUT)util/symbol-elf.o
 LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
@@ -454,7 +453,6 @@ LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
-LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
@@ -515,7 +513,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-stat.o
 BUILTIN_OBJS += $(OUTPUT)builtin-timechart.o
 BUILTIN_OBJS += $(OUTPUT)builtin-top.o
 BUILTIN_OBJS += $(OUTPUT)builtin-script.o
-BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
@@ -588,6 +585,10 @@ ifdef CONFIG_LIBELF
         endif # PERF_HAVE_DWARF_REGS
     endif
 
+    LIB_OBJS += $(OUTPUT)util/symbol-elf.o
+    LIB_OBJS += $(OUTPUT)util/probe-event.o
+    BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
+
 else
     ifdef CONFIG_DWARF
         $(error CONFIG_DWARF depends on LIBELF)
@@ -599,11 +600,6 @@ else
         $(error CONFIG_LIBUNWIND depends on LIBELF)
     endif
 
-    # Remove ELF/DWARF dependent codes
-    LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
-    LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
-    BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
-
     # Use minimal symbol handling
     LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 endif
-- 
1.7.10.1

