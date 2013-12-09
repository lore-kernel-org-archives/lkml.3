Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643Ab3LIFfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:35:04 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51889 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060Ab3LIFeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:18 -0500
X-AuditID: 9c930197-b7bdbae000000e78-7f-52a55657b7a4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 09/14] tools lib traceevent: Get rid of die() in add_right()
Date: Mon,  9 Dec 2013 14:34:06 +0900
Message-Id: <1386567251-22751-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 5efe66a682bd..a1ad609a860f 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -583,12 +583,18 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 			op->str.type = op_type;
 			op->str.field = left->field.field;
 			op->str.val = strdup(str);
-			if (!op->str.val)
-				die("malloc string");
+			if (!op->str.val) {
+				show_error(error_str, "Failed to allocate string filter");
+				return -1;
+			}
 			/*
 			 * Need a buffer to copy data for tests
 			 */
-			op->str.buffer = malloc_or_die(op->str.field->size + 1);
+			op->str.buffer = malloc(op->str.field->size + 1);
+			if (op->str.buffer) {
+				show_error(error_str, "Failed to allocate string filter");
+				return -1;
+			}
 			/* Null terminate this buffer */
 			op->str.buffer[op->str.field->size] = 0;
 
-- 
1.7.11.7

