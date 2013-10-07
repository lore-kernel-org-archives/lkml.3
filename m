Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab3JGMJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:09:07 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34184 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3JGL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:57:56 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/50] tools/perf/build: Clean up the libelf logic in config/Makefile
Date: Mon,  7 Oct 2013 13:56:03 +0200
Message-Id: <1381147003-2574-11-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nest the rules properly. No change in functionality.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-dDgivr9xtjrof2vmoyOfwxkj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 58 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 2469d5b..3e9fe16 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -163,38 +163,38 @@ ifdef NO_LIBELF
   NO_DEMANGLE := 1
   NO_LIBUNWIND := 1
 else
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
-  FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
-  ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
-    LIBC_SUPPORT := 1
-  endif
-  ifeq ($(BIONIC),1)
-    LIBC_SUPPORT := 1
-  endif
-  ifeq ($(LIBC_SUPPORT),1)
-    msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
+  ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+    FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
+    ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
+      LIBC_SUPPORT := 1
+    endif
+    ifeq ($(BIONIC),1)
+      LIBC_SUPPORT := 1
+    endif
+    ifeq ($(LIBC_SUPPORT),1)
+      msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
 
-    NO_LIBELF := 1
-    NO_DWARF := 1
-    NO_DEMANGLE := 1
+      NO_LIBELF := 1
+      NO_DWARF := 1
+      NO_DEMANGLE := 1
+    else
+      msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+    endif
   else
-    msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-  endif
-else
-  # for linking with debug library, run like:
-  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
-  ifdef LIBDW_DIR
-    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-  endif
+    # for linking with debug library, run like:
+    # make DEBUG=1 LIBDW_DIR=/opt/libdw/
+    ifdef LIBDW_DIR
+      LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+      LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+    endif
 
-  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lz -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
-    msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-    NO_DWARF := 1
-  endif # Dwarf support
-endif # SOURCE_LIBELF
+    FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lz -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
+    ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
+      msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+      NO_DWARF := 1
+    endif # Dwarf support
+  endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
-- 
1.7.11.7

