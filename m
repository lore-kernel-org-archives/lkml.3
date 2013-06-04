Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab3FDFUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:20:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62623 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3FDFUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:35 -0400
X-AuditID: 9c930179-b7c07ae000000e33-2a-51ad7921da82
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/16] tools lib traceevent: Add const qualifier to string arguments
Date: Tue,  4 Jun 2013 14:20:18 +0900
Message-Id: <1370323231-14022-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If pevent_register_event_handler() received a string literal as
@sys_name or @event_name parameter, it emitted a warning about const
qualifier removal.  Since they're not modified in the function we can
make it have const qualifier.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 7 +++----
 tools/lib/traceevent/event-parse.h | 3 ++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 82b0606dcb8a..d1c2a6a4cd32 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5450,10 +5450,9 @@ int pevent_register_print_function(struct pevent *pevent,
  * If @id is >= 0, then it is used to find the event.
  * else @sys_name and @event_name are used.
  */
-int pevent_register_event_handler(struct pevent *pevent,
-				  int id, char *sys_name, char *event_name,
-				  pevent_event_handler_func func,
-				  void *context)
+int pevent_register_event_handler(struct pevent *pevent, int id,
+				  const char *sys_name, const char *event_name,
+				  pevent_event_handler_func func, void *context)
 {
 	struct event_format *event;
 	struct event_handler *handle;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 7be7e89533e4..bfceab948f22 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -561,7 +561,8 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct pevent_record *record, int err);
 
-int pevent_register_event_handler(struct pevent *pevent, int id, char *sys_name, char *event_name,
+int pevent_register_event_handler(struct pevent *pevent, int id,
+				  const char *sys_name, const char *event_name,
 				  pevent_event_handler_func func, void *context);
 int pevent_register_print_function(struct pevent *pevent,
 				   pevent_func_handler func,
-- 
1.7.11.7

