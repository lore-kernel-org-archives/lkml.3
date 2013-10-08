Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3JHKYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:24:25 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53120 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3JHKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:18 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 14/52] tools/perf/build: Clean up the mmap logic in config/Makefile
Date: Tue,  8 Oct 2013 12:10:44 +0200
Message-Id: <1381227082-22039-15-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-wwktuHl4Ra5lyrrretkxmxqf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 89630b8..8a27de2 100644
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
1.8.3.1

