Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3H2KJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:09:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab3H2KJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:09:27 -0400
Date: Thu, 29 Aug 2013 03:08:48 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ain6q4u8g3bpnh18yhw24v2x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add --verbose option
Git-Commit-ID: 7c304ee0fc66b4c21282e1cce32631c263f8c481
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:08:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c304ee0fc66b4c21282e1cce32631c263f8c481
Gitweb:     http://git.kernel.org/tip/7c304ee0fc66b4c21282e1cce32631c263f8c481
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Aug 2013 16:49:54 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:43 -0300

perf trace: Add --verbose option

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ain6q4u8g3bpnh18yhw24v2x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  4 ++++
 tools/perf/builtin-trace.c              | 12 ++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 4754f11..fe19811 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -49,6 +49,10 @@ OPTIONS
 --uid=::
         Record events in threads owned by uid. Name or number.
 
+-v::
+--verbose=::
+        Verbosity level.
+
 -i::
 --no-inherit::
 	Child tasks do not inherit counters.
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6ab7a7a..c907e7e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,6 +1,7 @@
 #include <traceevent/event-parse.h>
 #include "builtin.h"
 #include "util/color.h"
+#include "util/debug.h"
 #include "util/evlist.h"
 #include "util/machine.h"
 #include "util/thread.h"
@@ -311,10 +312,12 @@ static struct syscall *trace__syscall_info(struct trace *trace,
 	return &trace->syscalls.table[id];
 
 out_cant_read:
-	fprintf(trace->output, "Problems reading syscall %d", id);
-	if (id <= trace->syscalls.max && trace->syscalls.table[id].name != NULL)
-		fprintf(trace->output, "(%s)", trace->syscalls.table[id].name);
-	fputs(" information", trace->output);
+	if (verbose) {
+		fprintf(trace->output, "Problems reading syscall %d", id);
+		if (id <= trace->syscalls.max && trace->syscalls.table[id].name != NULL)
+			fprintf(trace->output, "(%s)", trace->syscalls.table[id].name);
+		fputs(" information\n", trace->output);
+	}
 	return NULL;
 }
 
@@ -714,6 +717,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "show only events with duration > N.M ms",
 		     trace__set_duration),
 	OPT_BOOLEAN(0, "sched", &trace.sched, "show blocking scheduler events"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_END()
 	};
 	int err;
