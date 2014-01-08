Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaAHIrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:47:36 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63883 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbaAHIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:46 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-12-52cd106ffdd0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 11/28] perf callchain: Add callchain_cursor_snapshot()
Date: Wed,  8 Jan 2014 17:46:16 +0900
Message-Id: <1389170793-21926-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callchain_cursor_snapshot() is for saving current status of the
callchain.  It'll be used to accumulate callchain information for each node.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/callchain.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 08b25af9eea1..bad694287cb8 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -151,4 +151,13 @@ int record_parse_callchain_opt(const struct option *opt, const char *arg, int un
 int record_callchain_opt(const struct option *opt, const char *arg, int unset);
 
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

