Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3AYLyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:54:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3AYLyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:54:38 -0500
Date: Fri, 25 Jan 2013 03:54:07 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ff582680f8762293aa45eb5cf2faacadbe73b435@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1358236939-17393-1-git-send-email-namhyung@kernel.org>
References: <1358236939-17393-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Fix warning on '>='
  operator
Git-Commit-ID: ff582680f8762293aa45eb5cf2faacadbe73b435
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:54:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff582680f8762293aa45eb5cf2faacadbe73b435
Gitweb:     http://git.kernel.org/tip/ff582680f8762293aa45eb5cf2faacadbe73b435
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 15 Jan 2013 17:02:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:43 -0300

tools lib traceevent: Fix warning on '>=' operator

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
 
