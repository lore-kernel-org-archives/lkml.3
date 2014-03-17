Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaCQW05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:26:57 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:59726 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaCQWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:25:58 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] tools lib traceevent: use else-if cascade, not separate ifs
Date: Mon, 17 Mar 2014 18:26:36 -0400
Message-Id: <1395095198-20034-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When token cannot be more than one value, it seems wasteful to go
through all the strcmp() calls. Use an else-if cascade instead.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 42bc571..7a8d9ae 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2770,21 +2770,17 @@ process_function(struct event_format *event, struct print_arg *arg,
 		free_token(token);
 		is_flag_field = 1;
 		return process_flags(event, arg, tok);
-	}
-	if (strcmp(token, "__print_symbolic") == 0) {
+	} else if (strcmp(token, "__print_symbolic") == 0) {
 		free_token(token);
 		is_symbolic_field = 1;
 		return process_symbols(event, arg, tok);
-	}
-	if (strcmp(token, "__print_hex") == 0) {
+	} else if (strcmp(token, "__print_hex") == 0) {
 		free_token(token);
 		return process_hex(event, arg, tok);
-	}
-	if (strcmp(token, "__get_str") == 0) {
+	} else if (strcmp(token, "__get_str") == 0) {
 		free_token(token);
 		return process_str(event, arg, tok);
-	}
-	if (strcmp(token, "__get_dynamic_array") == 0) {
+	} else if (strcmp(token, "__get_dynamic_array") == 0) {
 		free_token(token);
 		return process_dynamic_array(event, arg, tok);
 	}
-- 
1.9.0.431.g014438b

