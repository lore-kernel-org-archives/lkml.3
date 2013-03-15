Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3COFt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:49:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61292 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3COFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:48:58 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-ed-5142b6476ab6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/6] perf test: Fixup return path of perf record test case
Date: Fri, 15 Mar 2013 14:48:53 +0900
Message-Id: <1363326533-3310-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add missing perf_evlist__close() function.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/perf-record.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index ffab5a41ff0a..72d8881873b0 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -143,7 +143,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_maps;
+		goto out_close_evlist;
 	}
 
 	/*
@@ -306,6 +306,8 @@ found_exit:
 	}
 out_err:
 	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
 out_delete_maps:
 	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
-- 
1.7.11.7

