Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657Ab3LIFfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:35:08 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58135 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760047Ab3LIFeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:17 -0500
X-AuditID: 9c930197-b7bdbae000000e78-78-52a55656b1dc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/14] tools lib traceevent: Get rid of die() in create_arg_item()
Date: Mon,  9 Dec 2013 14:34:05 +0900
Message-Id: <1386567251-22751-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index faa10824b87d..5efe66a682bd 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -389,8 +389,11 @@ create_arg_item(struct event_format *event, const char *token,
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
-- 
1.7.11.7

