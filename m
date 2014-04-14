Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaDNOSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:18:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaDNOSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 03/17] tools lib traceevent: Do not call warning() directly
Date: Mon, 14 Apr 2014 16:17:27 +0200
Message-Id: <1397485061-17215-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The patch 3a3ffa2e82205 ("tools lib traceevent: Report better error
message on bad function args") added the error message but it seems
there's no reason to call warning() directly.

So change it to do_warning_event() to provide event information too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1395192174-26273-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 33803c0b9..baec7d8 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2742,14 +2742,16 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 		type = process_arg(event, farg, &token);
 		if (i < (func->nr_args - 1)) {
 			if (type != EVENT_DELIM || strcmp(token, ",") != 0) {
-				warning("Error: function '%s()' expects %d arguments but event %s only uses %d",
+				do_warning_event(event,
+					"Error: function '%s()' expects %d arguments but event %s only uses %d",
 					func->name, func->nr_args,
 					event->name, i + 1);
 				goto err;
 			}
 		} else {
 			if (type != EVENT_DELIM || strcmp(token, ")") != 0) {
-				warning("Error: function '%s()' only expects %d arguments but event %s has more",
+				do_warning_event(event,
+					"Error: function '%s()' only expects %d arguments but event %s has more",
 					func->name, func->nr_args, event->name);
 				goto err;
 			}
-- 
1.8.3.1

