Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3JGMHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:07:50 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36580 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3JGL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:03 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 17/50] tools/perf/build: Clean up the libunwind logic in config/Makefile
Date: Mon,  7 Oct 2013 13:56:10 +0200
Message-Id: <1381147003-2574-18-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-jjlmizjmhockUs04wqnScnkl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 2fcef1f..7735271 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -239,19 +239,19 @@ ifneq ($(ARCH),x86)
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
1.7.11.7

