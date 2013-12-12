Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3LLHgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53469 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3LLHgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:24 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-ff-52a96775a81c
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/14] tools lib traceevent: Make add_left() return pevent_errno
Date: Thu, 12 Dec 2013 16:36:10 +0900
Message-Id: <1386833777-3790-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

So that it can propagate error properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

