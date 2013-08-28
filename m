Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3H1PAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:00:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40568 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab3H1O7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/21] perf trace: Add --verbose option
Date: Wed, 28 Aug 2013 11:59:26 -0300
Message-Id: <1377701977-2085-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.8.1.4

