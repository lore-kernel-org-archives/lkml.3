Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab3CRQmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:42:36 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49316
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298Ab3CRQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/54] perf tools: Remove unused tracing functions
Date: Mon, 18 Mar 2013 13:25:19 -0300
Message-Id: <1363623939-10748-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Leftovers from before libtraceevent integration.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1363151248-16674-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   37 -----------------------------------
 tools/perf/util/trace-event.h       |    4 ---
 2 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 3aabcd6..4454835 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -183,43 +183,6 @@ void event_format__print(struct event_format *event,
 	trace_seq_do_printf(&s);
 }
 
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
-{
-	int type = trace_parse_common_type(pevent, data);
-	struct event_format *event = pevent_find_event(pevent, type);
-
-	if (!event) {
-		warning("ug! no event found for type %d", type);
-		return;
-	}
-
-	event_format__print(event, cpu, data, size);
-}
-
-void print_event(struct pevent *pevent, int cpu, void *data, int size,
-		 unsigned long long nsecs, char *comm)
-{
-	struct pevent_record record;
-	struct trace_seq s;
-	int pid;
-
-	pevent->latency_format = latency_format;
-
-	record.ts = nsecs;
-	record.cpu = cpu;
-	record.size = size;
-	record.data = data;
-	pid = pevent_data_pid(pevent, &record);
-
-	if (!pevent_pid_is_registered(pevent, pid))
-		pevent_register_comm(pevent, comm, pid);
-
-	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
-	trace_seq_do_printf(&s);
-	printf("\n");
-}
-
 void parse_proc_kallsyms(struct pevent *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index a55fd37..28ccde8 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -30,13 +30,9 @@ enum {
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size);
 void event_format__print(struct event_format *event,
 			 int cpu, void *data, int size);
 
-void print_event(struct pevent *pevent, int cpu, void *data, int size,
-		 unsigned long long nsecs, char *comm);
-
 int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
 int parse_event_file(struct pevent *pevent,
 		     char *buf, unsigned long size, char *sys);
-- 
1.7.1

