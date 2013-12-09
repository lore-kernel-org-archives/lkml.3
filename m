Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725Ab3LIFhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:37:07 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58135 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3LIFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:16 -0500
X-AuditID: 9c930197-b7bdbae000000e78-60-52a556540d18
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 03/14] tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_alloc()
Date: Mon,  9 Dec 2013 14:34:00 +0900
Message-Id: <1386567251-22751-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It returns NULL when allocation fails so the users should check the
return value from now on.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index d9c239933992..21d13a4f9a5f 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -198,7 +198,10 @@ struct event_filter *pevent_filter_alloc(struct pevent *pevent)
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
-- 
1.7.11.7

