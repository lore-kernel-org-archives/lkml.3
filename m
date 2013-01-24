Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3AXUSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:18:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50175 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3AXUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 56/74] tools lib traceevent: Fix warning on '>=' operator
Date: Thu, 24 Jan 2013 17:08:05 -0300
Message-Id: <1359058103-31645-57-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1358236939-17393-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index dc42e55..f504619 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1784,6 +1784,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "/") == 0 ||
 		   strcmp(token, "<") == 0 ||
 		   strcmp(token, ">") == 0 ||
+		   strcmp(token, "<=") == 0 ||
+		   strcmp(token, ">=") == 0 ||
 		   strcmp(token, "==") == 0 ||
 		   strcmp(token, "!=") == 0) {
 
-- 
1.8.1.1.361.gec3ae6e

