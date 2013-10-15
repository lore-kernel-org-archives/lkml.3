Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3JOFOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:14:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab3JOFOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:43 -0400
Date: Mon, 14 Oct 2013 22:14:26 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-fb3d333b3faa6bf975f00973c6a6271b2ab93c0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Clean up the mmap logic in config/Makefile
Git-Commit-ID: fb3d333b3faa6bf975f00973c6a6271b2ab93c0c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:14:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb3d333b3faa6bf975f00973c6a6271b2ab93c0c
Gitweb:     http://git.kernel.org/tip/fb3d333b3faa6bf975f00973c6a6271b2ab93c0c
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 10:05:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:36 +0200

tools/perf/build: Clean up the mmap logic in config/Makefile

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
