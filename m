Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab3JNUxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:53:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38417 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3JNUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 014/161] tools/perf/build: Clean up the mmap logic in config/Makefile
Date: Mon, 14 Oct 2013 17:00:03 -0300
Message-Id: <1381780950-25642-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Nest the rules properly. No change in functionality.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-wwktuHl4Ra5lyrrretkxmxqf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 51 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 89630b8c8d59..8a27de27f7c2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -199,37 +199,38 @@ else
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
-CFLAGS += -DHAVE_LIBELF_SUPPORT
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
-  CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
-endif
-ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM_SUPPORT),y)
-  CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
-endif
+  CFLAGS += -DHAVE_LIBELF_SUPPORT
+  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 
-# include ARCH specific config
--include $(src-perf)/arch/$(ARCH)/Makefile
+  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+  endif
 
-ifndef NO_DWARF
-ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-  msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-  NO_DWARF := 1
-else
-  CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
-  LDFLAGS += $(LIBDW_LDFLAGS)
-  EXTLIBS += -lelf -ldw
-endif # PERF_HAVE_DWARF_REGS
-endif # NO_DWARF
+  ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM_SUPPORT),y)
+    CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
+  endif
+
+  # include ARCH specific config
+  -include $(src-perf)/arch/$(ARCH)/Makefile
 
+  ifndef NO_DWARF
+    ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+      msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+      NO_DWARF := 1
+    else
+      CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
+      LDFLAGS += $(LIBDW_LDFLAGS)
+      EXTLIBS += -lelf -ldw
+    endif # PERF_HAVE_DWARF_REGS
+  endif # NO_DWARF
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
-CFLAGS += -DHAVE_LIBELF_SUPPORT
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
-  CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
-endif # try-cc
+  CFLAGS += -DHAVE_LIBELF_SUPPORT
+  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
+  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+  endif # try-cc
 endif # NO_LIBELF
 
 # There's only x86 (both 32 and 64) support for CFI unwind so far
-- 
1.8.1.4

