Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3LMPO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:14:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45276 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3LMPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/20] tools lib traceevent: Make add_left() return pevent_errno
Date: Fri, 13 Dec 2013 12:12:01 -0300
Message-Id: <1386947526-7118-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

So that it can propagate error properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index c08ce594cabe..774c3e4c1d9f 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -648,7 +648,7 @@ rotate_op_right(struct filter_arg *a, struct filter_arg *b)
 	return arg;
 }
 
-static int add_left(struct filter_arg *op, struct filter_arg *arg)
+static enum pevent_errno add_left(struct filter_arg *op, struct filter_arg *arg)
 {
 	switch (op->type) {
 	case FILTER_ARG_EXP:
@@ -667,11 +667,11 @@ static int add_left(struct filter_arg *op, struct filter_arg *arg)
 		/* left arg of compares must be a field */
 		if (arg->type != FILTER_ARG_FIELD &&
 		    arg->type != FILTER_ARG_BOOLEAN)
-			return -1;
+			return PEVENT_ERRNO__INVALID_ARG_TYPE;
 		op->num.left = arg;
 		break;
 	default:
-		return -1;
+		return PEVENT_ERRNO__INVALID_ARG_TYPE;
 	}
 	return 0;
 }
-- 
1.8.1.4

