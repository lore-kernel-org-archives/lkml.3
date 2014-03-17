Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaCQW1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:27:44 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:41497 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaCQWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:25:57 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] tools lib traceevent: handle the '->' operator
Date: Mon, 17 Mar 2014 18:26:35 -0400
Message-Id: <1395095198-20034-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf test emits the following warning:

  $ perf test
   5: parse events tests
    ...
    Warning: unknown op '->'
    ...

Add the operator to the checks.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1587ea39..42bc571 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1759,6 +1759,8 @@ static int get_op_prio(char *op)
 			return 14;
 		} else if (strcmp(op, "||") == 0) {
 			return 15;
+		} else if (strcmp(op, "->") == 0) {
+			return 17;
 		} else {
 			do_warning("unknown op '%s'", op);
 			return -1;
@@ -1858,7 +1860,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "<=") == 0 ||
 		   strcmp(token, ">=") == 0 ||
 		   strcmp(token, "==") == 0 ||
-		   strcmp(token, "!=") == 0) {
+		   strcmp(token, "!=") == 0 ||
+		   strcmp(token, "->") == 0) {
 
 		left = alloc_arg();
 		if (!left)
-- 
1.9.0.431.g014438b

