Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3DBD5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:57:44 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42242 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555Ab3DBDz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:29 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/23] perf: consolidate CONFIG_LIBUNWIND checks in Makefile
Date: Mon,  1 Apr 2013 21:54:30 -0600
Message-Id: <1364874877-5618-17-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

code move only

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
 tools/perf/Makefile |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 62c10b8..a606eb1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -577,27 +577,6 @@ else
     endif
 endif
 
-# There's only x86 (both 32 and 64) support for CFI unwind so far
-ifneq ($(ARCH),x86)
-ifdef CONFIG_LIBUNWIND
-	$(error CONFIG_LIBUNWIND only supported for x86 architecture)
-endif
-endif
-
-ifdef CONFIG_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-endif
-
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-    $(error No libunwind found. Please install libunwind-dev[el] >= 0.99 or disable CONFIG_LIBUNWIND)
-endif # Libunwind support
-endif
-
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
@@ -637,6 +616,23 @@ else
 endif
 
 ifdef CONFIG_LIBUNWIND
+    # There's only x86 (both 32 and 64) support for CFI unwind so far
+    ifneq ($(ARCH),x86)
+	    $(error CONFIG_LIBUNWIND only supported for x86 architecture)
+    endif
+
+    # for linking with debug library, run like:
+    # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+    ifdef LIBUNWIND_DIR
+	    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+	    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+    endif
+
+    FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+    ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
+        $(error No libunwind found. Please install libunwind-dev[el] >= 0.99 or disable CONFIG_LIBUNWIND)
+    endif
+
 	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
 	EXTLIBS += $(LIBUNWIND_LIBS)
 	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
-- 
1.7.10.1

