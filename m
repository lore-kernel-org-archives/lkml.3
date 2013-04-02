Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642Ab3DBD4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:56:39 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58716 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592Ab3DBDzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:42 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/23] perf: consolidate CONFIG_DWARF checks in Makefile
Date: Mon,  1 Apr 2013 21:54:35 -0600
Message-Id: <1364874877-5618-22-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a3a62611..5037856 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -563,6 +563,11 @@ ifdef CONFIG_LIBELF
 		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
 	endif
 
+    FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+    ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
+	    BASIC_CFLAGS += -DLIBELF_MMAP
+    endif
+
     # libelf supported - what about dwarf?
     ifdef CONFIG_DWARF
         FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
@@ -570,14 +575,7 @@ ifdef CONFIG_LIBELF
             $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138.ables dwarf support.)
             $(error Please install new elfutils-devel/libdw-dev or disable CONFIG_DWARF);
         endif
-    endif
 
-    FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-    ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-	    BASIC_CFLAGS += -DLIBELF_MMAP
-    endif
-
-    ifdef CONFIG_DWARF
         ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	        msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
         else
-- 
1.7.10.1

