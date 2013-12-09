Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab3LIFe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:34:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58135 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3LIFeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:18 -0500
X-AuditID: 9c930197-b7bdbae000000e78-83-52a556573e26
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 11/14] tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_add_filter_str()
Date: Mon,  9 Dec 2013 14:34:08 +0900
Message-Id: <1386567251-22751-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index dabae52bbbcb..d8613308c08d 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1319,7 +1319,13 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 		else
 			len = strlen(filter_str);
 
-		this_event = malloc_or_die(len + 1);
+		this_event = malloc(len + 1);
+		if (this_event == NULL) {
+			show_error(error_str, "Memory allocation failure");
+			/* This can only happen when events is NULL, but still */
+			free_events(events);
+			return -1;
+		}
 		memcpy(this_event, filter_str, len);
 		this_event[len] = 0;
 
-- 
1.7.11.7

