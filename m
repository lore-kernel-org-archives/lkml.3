Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBBVk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbaBBVkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:25 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 16/22] tools lib traceevent: Make the name output optional in pevent_field_info
Date: Sun,  2 Feb 2014 22:39:04 +0100
Message-Id: <1391377150-23920-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making the name output optional in pevent_field_info function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 9 ++++++---
 tools/lib/traceevent/event-parse.h | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index a3370f2..7b5b2dc 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4028,13 +4028,16 @@ static int is_printable_array(char *p, unsigned int len)
 
 void pevent_field_info(struct trace_seq *s,
 		       struct format_field *field,
-		       void *data, int size __maybe_unused)
+		       void *data, int size __maybe_unused,
+		       bool print_name)
 {
 	struct event_format *event = field->event;
 	unsigned int offset, len, i;
 	unsigned long long val;
 
-	trace_seq_printf(s, " %s=", field->name);
+	if (print_name)
+		trace_seq_printf(s, " %s=", field->name);
+
 	if (field->flags & FIELD_IS_ARRAY) {
 		offset = field->offset;
 		len = field->size;
@@ -4100,7 +4103,7 @@ static void print_event_fields(struct trace_seq *s, void *data, int size,
 
 	field = event->format.fields;
 	while (field) {
-		pevent_field_info(s, field, data, size);
+		pevent_field_info(s, field, data, size, true);
 		field = field->next;
 	}
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 73492a9..b49fad1 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -590,7 +590,8 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 
 void pevent_field_info(struct trace_seq *s,
 		       struct format_field *field,
-		       void *data, int size);
+		       void *data, int size __maybe_unused,
+		       bool print_name);
 
 int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
 			     int long_size);
-- 
1.8.3.1

