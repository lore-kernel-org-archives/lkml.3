Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbaFANcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbaFANb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:31:59 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 08/27] perf callchain: Add callchain_cursor_snapshot()
Date: Sun,  1 Jun 2014 15:31:19 +0200
Message-Id: <1401629498-8726-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The callchain_cursor_snapshot() is for saving current status of the
callchain.  It'll be used to accumulate callchain information for each node.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-9-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/callchain.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 24a53d5..8f84423 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -167,4 +167,13 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
 
 extern const char record_callchain_help[];
 int parse_callchain_report_opt(const char *arg);
+
+static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
+					     struct callchain_cursor *src)
+{
+	*dest = *src;
+
+	dest->first = src->curr;
+	dest->nr -= src->pos;
+}
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.8.3.1

