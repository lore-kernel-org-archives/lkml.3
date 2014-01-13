Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaAMIB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:01:56 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56271 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaAMIBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:01:00 -0500
X-AuditID: 9c930179-b7c5fae000006619-41-52d39d3a8863
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/5] perf tools: Save message when pr_*() was called
Date: Mon, 13 Jan 2014 17:00:54 +0900
Message-Id: <1389600057-26999-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389600057-26999-1-git-send-email-namhyung@kernel.org>
References: <1389600057-26999-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message will be saved in a temp file so that it can be shown at a
UI dialog at any time.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 299b55586502..801cdf205d3e 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -19,12 +19,18 @@ bool dump_trace = false, quiet = false;
 static int _eprintf(int level, const char *fmt, va_list args)
 {
 	int ret = 0;
+	va_list ap;
 
 	if (verbose >= level) {
+		va_copy(ap, args);
+
 		if (use_browser >= 1)
 			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
+
+		perf_log__addv(fmt, ap);
+		va_end(ap);
 	}
 
 	return ret;
-- 
1.7.11.7

