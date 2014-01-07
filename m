Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaAGMsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:48:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaAGMsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:48:02 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 03/16] perf tools: Make perf_event__synthesize_mmap_events global
Date: Tue,  7 Jan 2014 13:47:20 +0100
Message-Id: <1389098853-14466-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making perf_event__synthesize_mmap_events global, it's used
in following patch from test code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/util/event.c | 12 ++++++------
 tools/perf/util/event.h |  7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 45a76c6..1fc1c2f 100644
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
index 30fec99..faf6e21 100644
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
1.8.3.1

