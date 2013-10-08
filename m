Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3JHKZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:25:10 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51594 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3JHKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:15 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/52] tools/perf/build: Clean up the libelf logic in config/Makefile
Date: Tue,  8 Oct 2013 12:10:40 +0200
Message-Id: <1381227082-22039-11-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
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
index 09e2ecc..a2e0e1b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -164,38 +164,38 @@ ifdef NO_LIBELF
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
1.8.3.1

