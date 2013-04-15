Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904Ab3DOFLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:11:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50881 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395Ab3DOFLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:11:43 -0400
X-AuditID: 9c930179-b7bd8ae000004629-dc-516b8c0d36f4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/10] perf util: Move latency_format variable to builtin-script.c
Date: Mon, 15 Apr 2013 14:11:35 +0900
Message-Id: <1366002698-10728-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
References: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's the only user of the variable, so move it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-script.c         | 1 +
 tools/perf/util/trace-event-parse.c | 2 --
 tools/perf/util/trace-event.h       | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 92d4658f56fb..3de8979fe87d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -24,6 +24,7 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static bool			latency_format;
 static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0deae885c7ba..fe7a27d67d2b 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -28,8 +28,6 @@
 #include "util.h"
 #include "trace-event.h"
 
-bool latency_format;
-
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian)
 {
 	struct pevent *pevent = pevent_alloc();
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 10d6e7b202c5..96ad22f98726 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -10,7 +10,6 @@ struct perf_sample;
 union perf_event;
 struct perf_tool;
 
-extern bool latency_format;
 extern struct pevent *perf_pevent;
 
 enum {
-- 
1.7.11.7

