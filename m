Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3JNUSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:18:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39046 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab3JNUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 077/161] perf tools: Remove unused trace-event-* code
Date: Mon, 14 Oct 2013 17:01:06 -0300
Message-Id: <1381780950-25642-78-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing unused trace-event-* code.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1379003976-5839-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c | 36 ------------------------------------
 tools/perf/util/trace-event.h       |  9 ---------
 2 files changed, 45 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index e9e1c03f927d..6681f71f2f95 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -120,42 +120,6 @@ raw_field_value(struct event_format *event, const char *name, void *data)
 	return val;
 }
 
-void *raw_field_ptr(struct event_format *event, const char *name, void *data)
-{
-	struct format_field *field;
-
-	field = pevent_find_any_field(event, name);
-	if (!field)
-		return NULL;
-
-	if (field->flags & FIELD_IS_DYNAMIC) {
-		int offset;
-
-		offset = *(int *)(data + field->offset);
-		offset &= 0xffff;
-
-		return data + offset;
-	}
-
-	return data + field->offset;
-}
-
-int trace_parse_common_type(struct pevent *pevent, void *data)
-{
-	struct pevent_record record;
-
-	record.data = data;
-	return pevent_data_type(pevent, &record);
-}
-
-int trace_parse_common_pid(struct pevent *pevent, void *data)
-{
-	struct pevent_record record;
-
-	record.data = data;
-	return pevent_data_pid(pevent, &record);
-}
-
 unsigned long long read_size(struct event_format *event, void *ptr, int size)
 {
 	return pevent_read_number(event->pevent, ptr, size);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index fafe1a40444a..04df63114109 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -11,8 +11,6 @@ union perf_event;
 struct perf_tool;
 struct thread;
 
-extern struct pevent *perf_pevent;
-
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
@@ -23,26 +21,19 @@ int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
 int parse_event_file(struct pevent *pevent,
 		     char *buf, unsigned long size, char *sys);
 
-struct pevent_record *trace_peek_data(struct pevent *pevent, int cpu);
-
 unsigned long long
 raw_field_value(struct event_format *event, const char *name, void *data);
-void *raw_field_ptr(struct event_format *event, const char *name, void *data);
 
 void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size);
 void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size);
 
 ssize_t trace_report(int fd, struct pevent **pevent, bool repipe);
 
-int trace_parse_common_type(struct pevent *pevent, void *data);
-int trace_parse_common_pid(struct pevent *pevent, void *data);
-
 struct event_format *trace_find_next_event(struct pevent *pevent,
 					   struct event_format *event);
 unsigned long long read_size(struct event_format *event, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
 
-struct pevent_record *trace_read_data(struct pevent *pevent, int cpu);
 int read_tracing_data(int fd, struct list_head *pattrs);
 
 struct tracing_data {
-- 
1.8.1.4

