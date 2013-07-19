Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab3GSHnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:43:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934268Ab3GSHnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:43:43 -0400
Date: Fri, 19 Jul 2013 00:43:29 -0700
From: tip-bot for Robert Richter <tipbot@zytor.com>
Message-ID: <tip-4e319027a7aee58ce8d409f5597b418f08307841@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, robert.richter@linaro.org,
        tglx@linutronix.de, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, robert.richter@linaro.org,
        tglx@linutronix.de, rric@kernel.org
In-Reply-To: <1370964558-8599-1-git-send-email-rric@kernel.org>
References: <1370964558-8599-1-git-send-email-rric@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use default include path notation for libtraceevent headers
Git-Commit-ID: 4e319027a7aee58ce8d409f5597b418f08307841
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:43:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e319027a7aee58ce8d409f5597b418f08307841
Gitweb:     http://git.kernel.org/tip/4e319027a7aee58ce8d409f5597b418f08307841
Author:     Robert Richter <robert.richter@linaro.org>
AuthorDate: Tue, 11 Jun 2013 17:29:18 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:45:54 -0300

perf tools: Use default include path notation for libtraceevent headers

Header files of libtraceevent or no longer local headers. Thus, use
default path notation for them. Also removing extra traceevent include
path and instead handle this similar to liblk.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Robert Richter <rric@kernel.org>
Link: http://lkml.kernel.org/r/1370964558-8599-1-git-send-email-rric@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile               | 2 +-
 tools/perf/builtin-trace.c        | 2 +-
 tools/perf/config/Makefile        | 5 +++--
 tools/perf/tests/evsel-tp-sched.c | 2 +-
 tools/perf/util/evsel.c           | 8 ++++----
 tools/perf/util/session.c         | 2 +-
 tools/perf/util/trace-event.h     | 2 +-
 7 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 641fccd..5b7c6db 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -281,7 +281,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
-LIB_H += $(TRACE_EVENT_DIR)event-parse.h
+LIB_H += $(LIB_INCLUDE)traceevent/event-parse.h
 LIB_H += util/target.h
 LIB_H += util/rblist.h
 LIB_H += util/intlist.h
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ab3ed4a..87fc7d0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,3 +1,4 @@
+#include <traceevent/event-parse.h>
 #include "builtin.h"
 #include "util/color.h"
 #include "util/evlist.h"
@@ -5,7 +6,6 @@
 #include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/thread_map.h"
-#include "event-parse.h"
 
 #include <libaudit.h>
 #include <stdlib.h>
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b5d9238..214e17e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -46,6 +46,8 @@ ifneq ($(obj-perf),)
 obj-perf := $(abspath $(obj-perf))/
 endif
 
+LIB_INCLUDE := $(srctree)/tools/lib/
+
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
@@ -121,8 +123,7 @@ endif
 
 CFLAGS += -I$(src-perf)/util
 CFLAGS += -I$(src-perf)
-CFLAGS += -I$(TRACE_EVENT_DIR)
-CFLAGS += -I$(srctree)/tools/lib/
+CFLAGS += -I$(LIB_INCLUDE)
 
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index a5d2fcc..f79e7d0 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -1,6 +1,6 @@
+#include <traceevent/event-parse.h>
 #include "evsel.h"
 #include "tests.h"
-#include "event-parse.h"
 
 static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 				  int size, bool should_be_signed)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c9c7494..a635461 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -9,17 +9,17 @@
 
 #include <byteswap.h>
 #include <linux/bitops.h>
-#include "asm/bug.h"
 #include <lk/debugfs.h>
-#include "event-parse.h"
+#include <traceevent/event-parse.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
+#include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
 #include "cpumap.h"
 #include "thread_map.h"
 #include "target.h"
-#include <linux/hw_breakpoint.h>
-#include <linux/perf_event.h>
 #include "perf_regs.h"
 
 static struct {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..ad47fb9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <traceevent/event-parse.h>
 
 #include <byteswap.h>
 #include <unistd.h>
@@ -12,7 +13,6 @@
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
-#include "event-parse.h"
 #include "perf_regs.h"
 #include "vdso.h"
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 1978c39..11eb7fd 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -1,8 +1,8 @@
 #ifndef _PERF_UTIL_TRACE_EVENT_H
 #define _PERF_UTIL_TRACE_EVENT_H
 
+#include <traceevent/event-parse.h>
 #include "parse-events.h"
-#include "event-parse.h"
 #include "session.h"
 
 struct machine;
