Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3LKLGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:06:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3LKLGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:40 -0500
Date: Wed, 11 Dec 2013 03:06:15 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2036fcd1c7ce455424c11bdb1c8a2ac906430e2f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1386567251-22751-9-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die()
  in create_arg_item()
Git-Commit-ID: 2036fcd1c7ce455424c11bdb1c8a2ac906430e2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:06:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2036fcd1c7ce455424c11bdb1c8a2ac906430e2f
Gitweb:     http://git.kernel.org/tip/2036fcd1c7ce455424c11bdb1c8a2ac906430e2f
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 9 Dec 2013 14:34:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:39:46 -0300

tools lib traceevent: Get rid of die() in create_arg_item()

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386567251-22751-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 2b73abf..53e48eb 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -362,8 +362,11 @@ create_arg_item(struct event_format *event, const char *token,
 		arg->value.type =
 			type == EVENT_DQUOTE ? FILTER_STRING : FILTER_CHAR;
 		arg->value.str = strdup(token);
-		if (!arg->value.str)
-			die("malloc string");
+		if (!arg->value.str) {
+			free_arg(arg);
+			show_error(error_str, "failed to allocate string filter arg");
+			return NULL;
+		}
 		break;
 	case EVENT_ITEM:
 		/* if it is a number, then convert it */
