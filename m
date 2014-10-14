Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbaJNVF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:05:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:44793 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416AbaJNVF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:05:56 -0400
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
Subject: [PATCH 13/24] perf callchain: Move the callchain_param extern to callchain.h
Date: Tue, 14 Oct 2014 18:04:22 -0300
Message-Id: <1413320673-5784-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was lost in hist.h, move it to where it belongs, callchain.h, as
there are places that gets hist.h by means of evsel.h, and since evsel.h
is being untangled from hist.h...

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
Link: http://lkml.kernel.org/n/tip-0rg7ji1jnbm6q6gj35j37jby@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c                            | 1 +
 tools/perf/util/callchain.h                            | 2 ++
 tools/perf/util/evsel.c                                | 1 +
 tools/perf/util/hist.h                                 | 2 --
 tools/perf/util/scripting-engines/trace-event-python.c | 1 +
 5 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 44c6f3d55ce7..a6b2132c666f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include "util/callchain.h"
 #include "util/header.h"
 #include "util/event.h"
 #include "util/evlist.h"
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2a1f5a46543a..94cfefddf4db 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -65,6 +65,8 @@ struct callchain_param {
 	enum chain_key		key;
 };
 
+extern struct callchain_param callchain_param;
+
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0580b13df2e6..a08376427448 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,6 +15,7 @@
 #include <linux/perf_event.h>
 #include <sys/resource.h>
 #include "asm/bug.h"
+#include "callchain.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a039cd22b23c..ebfc25886cac 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -8,8 +8,6 @@
 #include "color.h"
 #include "ui/progress.h"
 
-extern struct callchain_param callchain_param;
-
 struct hist_entry;
 struct addr_location;
 struct symbol;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 56ba07cce549..496f21cadd97 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -28,6 +28,7 @@
 
 #include "../../perf.h"
 #include "../debug.h"
+#include "../callchain.h"
 #include "../evsel.h"
 #include "../util.h"
 #include "../event.h"
-- 
1.9.3

