Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3LKLGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:06:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3LKLGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:17 -0500
Date: Wed, 11 Dec 2013 03:05:56 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4f24416331e9a507e953e90d4534e9a9802cbc12@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1386567251-22751-4-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  in pevent_filter_alloc()
Git-Commit-ID: 4f24416331e9a507e953e90d4534e9a9802cbc12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:06:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f24416331e9a507e953e90d4534e9a9802cbc12
Gitweb:     http://git.kernel.org/tip/4f24416331e9a507e953e90d4534e9a9802cbc12
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 9 Dec 2013 14:34:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:39:35 -0300

tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_alloc()

It returns NULL when allocation fails so the users should check the
return value from now on.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386567251-22751-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 2500e75..b3a61d4 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -182,7 +182,10 @@ struct event_filter *pevent_filter_alloc(struct pevent *pevent)
 {
 	struct event_filter *filter;
 
-	filter = malloc_or_die(sizeof(*filter));
+	filter = malloc(sizeof(*filter));
+	if (filter == NULL)
+		return NULL;
+
 	memset(filter, 0, sizeof(*filter));
 	filter->pevent = pevent;
 	pevent_ref(pevent);
