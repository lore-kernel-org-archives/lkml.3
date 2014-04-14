Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaDNOwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:52:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbaDNOwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:52:42 -0400
Date: Mon, 14 Apr 2014 07:52:10 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-9e9e5dfd86b9fdea8c75bae42cba052901b94f78@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1395192174-26273-2-git-send-email-namhyung@kernel.org>
References: <1395192174-26273-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent: Do not call warning()
  directly
Git-Commit-ID: 9e9e5dfd86b9fdea8c75bae42cba052901b94f78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e9e5dfd86b9fdea8c75bae42cba052901b94f78
Gitweb:     http://git.kernel.org/tip/9e9e5dfd86b9fdea8c75bae42cba052901b94f78
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 19 Mar 2014 10:22:54 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:00 +0200

tools lib traceevent: Do not call warning() directly

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
