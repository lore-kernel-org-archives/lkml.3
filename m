Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaEWKJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:09:46 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49115 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaEWKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:04:35 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 07/26] perf callchain: Add callchain_cursor_snapshot()
Date: Fri, 23 May 2014 19:04:04 +0900
Message-Id: <1400839463-21933-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callchain_cursor_snapshot() is for saving current status of the
callchain.  It'll be used to accumulate callchain information for each node.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/callchain.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 24a53d562d0a..8f84423a75da 100644
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
1.9.2

