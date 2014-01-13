Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaAMUx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:53:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/38] perf tools: Make perf_event__synthesize_mmap_events global
Date: Mon, 13 Jan 2014 17:47:19 -0300
Message-Id: <1389646059-24881-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Making perf_event__synthesize_mmap_events global, it will be used in
following patch from test code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 12 ++++++------
 tools/perf/util/event.h |  7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 45a76c69a9ed..1fc1c2f04772 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -175,12 +175,12 @@ out:
 	return tgid;
 }
 
-static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
-					      union perf_event *event,
-					      pid_t pid, pid_t tgid,
-					      perf_event__handler_t process,
-					      struct machine *machine,
-					      bool mmap_data)
+int perf_event__synthesize_mmap_events(struct perf_tool *tool,
+				       union perf_event *event,
+				       pid_t pid, pid_t tgid,
+				       perf_event__handler_t process,
+				       struct machine *machine,
+				       bool mmap_data)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 30fec9901e44..faf6e219be21 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -266,6 +266,13 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
 
+int perf_event__synthesize_mmap_events(struct perf_tool *tool,
+				       union perf_event *event,
+				       pid_t pid, pid_t tgid,
+				       perf_event__handler_t process,
+				       struct machine *machine,
+				       bool mmap_data);
+
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
-- 
1.8.1.4

