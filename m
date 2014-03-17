Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaCQW0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:26:17 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:46255 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaCQWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:25:59 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf test: squelch warnings about undefined sizeof
Date: Mon, 17 Mar 2014 18:26:38 -0400
Message-Id: <1395095198-20034-6-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf test emits the following warnings on the parse events test:

  $ perf test
   5: parse events tests
    Warning: function sizeof not defined
    Warning: function sizeof not defined
    Warning: function sizeof not defined
    Warning: function sizeof not defined
    Warning: function sizeof not defined
    Warning: function sizeof not defined
    Warning: function sizeof not defined
    Warning: function sizeof not defined
    ...

Squelch the warnings by explicitly ignoring the sizeof function.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Probably incorrect.

 tools/lib/traceevent/event-parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 567d9ba..06c269a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2783,6 +2783,10 @@ process_function(struct event_format *event, struct print_arg *arg,
 	} else if (strcmp(token, "__get_dynamic_array") == 0) {
 		free_token(token);
 		return process_dynamic_array(event, arg, tok);
+	} else if (strcmp(token, "sizeof") == 0) {
+		/* ignore sizeof function */
+		free_token(token);
+		return 0;
 	}
 
 	func = find_func_handler(event->pevent, token);
-- 
1.9.0.431.g014438b

