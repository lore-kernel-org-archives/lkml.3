Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3LSHAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:00:50 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47860 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3LSHAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:00:17 -0500
X-AuditID: 9c930179-b7bedae000000f15-7b-52b2997d49cd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/6] perf tools: Save message when pr_*() was called
Date: Thu, 19 Dec 2013 16:00:09 +0900
Message-Id: <1387436411-20160-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The message will be saved in a temp file so that it can be shown at a
UI dialog at any time.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 299b55586502..f55b499c93fb 100644
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
+		perf_log_addv(fmt, ap);
+		va_end(ap);
 	}
 
 	return ret;
-- 
1.7.11.7

