Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614Ab3DBDzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:44 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59545 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760585Ab3DBDzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:39 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 20/23] perf: consolidate CONFIG_LIBELF checks in Makefile
Date: Mon,  1 Apr 2013 21:54:34 -0600
Message-Id: <1364874877-5618-21-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e76fa2f..a3a62611 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -530,6 +530,12 @@ PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 ifneq ($(MAKECMDGOALS),clean)
 ifneq ($(MAKECMDGOALS),tags)
 
+-include arch/$(ARCH)/Makefile
+
+ifneq ($(OUTPUT),)
+	BASIC_CFLAGS += -I$(OUTPUT)
+endif
+
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
@@ -565,25 +571,7 @@ ifdef CONFIG_LIBELF
             $(error Please install new elfutils-devel/libdw-dev or disable CONFIG_DWARF);
         endif
     endif
-else
-    ifdef CONFIG_DWARF
-        $(error CONFIG_DWARF depends on LIBELF)
-    endif
-    ifdef CONFIG_DEMANGLE
-        $(error CONFIG_DEMANGLE depends on LIBELF)
-    endif
-    ifdef CONFIG_LIBUNWIND
-        $(error CONFIG_LIBUNWIND depends on LIBELF)
-    endif
-endif
 
--include arch/$(ARCH)/Makefile
-
-ifneq ($(OUTPUT),)
-	BASIC_CFLAGS += -I$(OUTPUT)
-endif
-
-ifdef CONFIG_LIBELF
     FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
     ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
 	    BASIC_CFLAGS += -DLIBELF_MMAP
@@ -602,6 +590,16 @@ ifdef CONFIG_LIBELF
     endif
 
 else
+    ifdef CONFIG_DWARF
+        $(error CONFIG_DWARF depends on LIBELF)
+    endif
+    ifdef CONFIG_DEMANGLE
+        $(error CONFIG_DEMANGLE depends on LIBELF)
+    endif
+    ifdef CONFIG_LIBUNWIND
+        $(error CONFIG_LIBUNWIND depends on LIBELF)
+    endif
+
     EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
 
     # Remove ELF/DWARF dependent codes
-- 
1.7.10.1

