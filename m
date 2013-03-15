Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3COFtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:49:00 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64519 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3COFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:48:58 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-ea-5142b6472e3d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/6] perf test: Fixup return path of open-syscall-tp-fields test case
Date: Fri, 15 Mar 2013 14:48:52 +0900
Message-Id: <1363326533-3310-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add missing evlist cleanup functions.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/open-syscall-tp-fields.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 02cb74174e23..fc5b9fca8b47 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -48,13 +48,13 @@ int test__syscall_open_tp_fields(void)
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_close_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -110,6 +110,10 @@ out_ok:
 	err = 0;
 out_munmap:
 	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
-- 
1.7.11.7

