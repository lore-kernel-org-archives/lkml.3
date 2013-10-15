Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab3JOFPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:15:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3JOFPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:15:07 -0400
Date: Mon, 14 Oct 2013 22:14:52 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-308e1e700a1337b89c7530a4f4cdde5ccb52fb4e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Clean up the libunwind logic in config/Makefile
Git-Commit-ID: 308e1e700a1337b89c7530a4f4cdde5ccb52fb4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:14:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  308e1e700a1337b89c7530a4f4cdde5ccb52fb4e
Gitweb:     http://git.kernel.org/tip/308e1e700a1337b89c7530a4f4cdde5ccb52fb4e
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 10:30:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:38 +0200

tools/perf/build: Clean up the libunwind logic in config/Makefile

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
index 718b476..0d75587 100644
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
