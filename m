Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab3ILQk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:40:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab3ILQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:39:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/4] perf tools: Remove unused trace-event-* code
Date: Thu, 12 Sep 2013 18:39:34 +0200
Message-Id: <1379003976-5839-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
References: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing unused trace-event-* code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/trace-event-parse.c | 36 ------------------------------------
 tools/perf/util/trace-event.h       |  9 ---------
 2 files changed, 45 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index fe7a27d..da28065 100644
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
index fafe1a4..04df631 100644
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
1.7.11.7

