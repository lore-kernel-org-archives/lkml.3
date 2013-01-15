Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3AOICj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:02:39 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51622 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3AOICh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:02:37 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-98-50f50d1a7a43
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools lib traceevent: Fix warning on '>=' operator
Date: Tue, 15 Jan 2013 17:02:19 +0900
Message-Id: <1358236939-17393-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Although the '>=' (and '<=') operator is handled properly in
libtraceevent, it emitted following spurious warnings on perf test:

 $ perf test
 5: parse events tests                                     :
  ...
  Warning: unknown op '>='
  Warning: unknown op '>='
  Warning: unknown op '>='
  Warning: unknown op '>='
  Warning: unknown op '>='
  Warning: unknown op '>='
  ...

Add the operator to the checks.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5a824e355d04..7286f0e82c29 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1785,6 +1785,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "/") == 0 ||
 		   strcmp(token, "<") == 0 ||
 		   strcmp(token, ">") == 0 ||
+		   strcmp(token, "<=") == 0 ||
+		   strcmp(token, ">=") == 0 ||
 		   strcmp(token, "==") == 0 ||
 		   strcmp(token, "!=") == 0) {
 
-- 
1.7.11.7

