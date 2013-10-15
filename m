Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3JOFOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:14:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab3JOFOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:05 -0400
Date: Mon, 14 Oct 2013 22:13:51 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-50eed7a71ebaf6676be8c497192b978f07581326@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Clean up the libelf logic in config/Makefile
Git-Commit-ID: 50eed7a71ebaf6676be8c497192b978f07581326
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:13:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50eed7a71ebaf6676be8c497192b978f07581326
Gitweb:     http://git.kernel.org/tip/50eed7a71ebaf6676be8c497192b978f07581326
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 14:11:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:34 +0200

tools/perf/build: Clean up the libelf logic in config/Makefile

Nest the rules properly. No change in functionality.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-dDgivr9xtjrof2vmoyOfwxkj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 58 +++++++++++++++++++++++-----------------------
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
