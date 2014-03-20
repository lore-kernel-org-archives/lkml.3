Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaCTFl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:41:59 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50073 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaCTFgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:36:52 -0400
X-AuditID: 9c93017e-b7b10ae000000e66-01-532a7e71d30e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 07/21] perf callchain: Add callchain_cursor_snapshot()
Date: Thu, 20 Mar 2014 14:36:32 +0900
Message-Id: <1395293806-25847-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callchain_cursor_snapshot() is for saving current status of the
callchain.  It'll be used to accumulate callchain information for each node.

Tested-by: Arun Sharma <asharma@fb.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/callchain.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 66faae21370d..bbd63dfbe112 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -159,4 +159,13 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
 			bool hide_unresolved);
 
 extern const char record_callchain_help[];
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
1.7.11.7

