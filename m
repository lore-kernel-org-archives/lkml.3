Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaJQTuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:50:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:41636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaJQTuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:50:08 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/5] perf evsel: No need to drag util/cgroup.h
Date: Fri, 17 Oct 2014 16:49:31 -0300
Message-Id: <1413575373-10787-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413575373-10787-1-git-send-email-acme@kernel.org>
References: <1413575373-10787-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The only thing we need is a forward declaration for 'struct cgroup_sel',
that is inside 'struct perf_evsel'.

Include cgroup.h instead on the tools that support cgroups.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-b7kuymbgf0zxi5viyjjtu5hk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 1 +
 tools/perf/builtin-stat.c   | 1 +
 tools/perf/util/evsel.c     | 1 +
 tools/perf/util/evsel.h     | 3 ++-
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a6b2132c666f..2583a9b04317 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -15,6 +15,7 @@
 #include "util/parse-events.h"
 
 #include "util/callchain.h"
+#include "util/cgroup.h"
 #include "util/header.h"
 #include "util/event.h"
 #include "util/evlist.h"
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b22c62f80078..055ce9232c9e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,6 +43,7 @@
 
 #include "perf.h"
 #include "builtin.h"
+#include "util/cgroup.h"
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 786ea557af26..2f9e68025ede 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -16,6 +16,7 @@
 #include <sys/resource.h>
 #include "asm/bug.h"
 #include "callchain.h"
+#include "cgroup.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 1d5c754aebc4..163c5604e5d1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -7,7 +7,6 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 #include "xyarray.h"
-#include "cgroup.h"
 #include "symbol.h"
 
 struct perf_counts_values {
@@ -42,6 +41,8 @@ struct perf_sample_id {
 	u64			period;
 };
 
+struct cgroup_sel;
+
 /** struct perf_evsel - event selector
  *
  * @name - Can be set to retain the original event name passed by the user,
-- 
1.9.3

