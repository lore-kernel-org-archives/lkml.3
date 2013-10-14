Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab3JNUtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:49:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3JNUCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 017/161] tools/perf/build: Clean up the libunwind logic in config/Makefile
Date: Mon, 14 Oct 2013 17:00:06 -0300
Message-Id: <1381780950-25642-18-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-jjlmizjmhockUs04wqnScnkl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 718b47611340..0d7558790a02 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -240,19 +240,19 @@ ifneq ($(ARCH),x86)
 endif
 
 ifndef NO_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-  LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-  LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-endif
+  # for linking with debug library, run like:
+  # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+  ifdef LIBUNWIND_DIR
+    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+  endif
 
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
-  NO_LIBUNWIND := 1
-endif # Libunwind support
-endif # NO_LIBUNWIND
+  FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+  ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
+    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+    NO_LIBUNWIND := 1
+  endif
+endif
 
 ifndef NO_LIBUNWIND
   CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
-- 
1.8.1.4

