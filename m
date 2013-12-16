Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3LPPbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:31:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3LPP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:29:06 -0500
Date: Mon, 16 Dec 2013 07:28:48 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ff533fc058975579dffbb62a731f63911ae714be@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-8-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Make add_left()
  return pevent_errno
Git-Commit-ID: ff533fc058975579dffbb62a731f63911ae714be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:28:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff533fc058975579dffbb62a731f63911ae714be
Gitweb:     http://git.kernel.org/tip/ff533fc058975579dffbb62a731f63911ae714be
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 12 Dec 2013 16:36:10 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:22 -0300

tools lib traceevent: Make add_left() return pevent_errno

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
index c08ce59..774c3e4 100644
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
