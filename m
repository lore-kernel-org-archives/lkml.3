Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaKDBRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:17:01 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:32955 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaKDBQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:16:59 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf tools: Rename dsos__write_buildid_table()
Date: Tue,  4 Nov 2014 10:14:29 +0900
Message-Id: <1415063674-17206-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dsos__write_buildid_table() is not use struct dso and it mostly
uses perf_session struct.  So rename it to perf_session__write_buildid_
table() so that it corresponds to other related functions such as
perf_session__read_build_ids() and perf_session__cache_build_ids().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0ecf4a304cbc..be8d02eb97e9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -297,10 +297,8 @@ static int machine__write_buildid_table(struct machine *machine, int fd)
 	return err;
 }
 
-static int dsos__write_buildid_table(struct perf_header *header, int fd)
+static int perf_session__write_buildid_table(struct perf_session *session, int fd)
 {
-	struct perf_session *session = container_of(header,
-			struct perf_session, header);
 	struct rb_node *nd;
 	int err = machine__write_buildid_table(&session->machines.host, fd);
 
@@ -523,7 +521,7 @@ static int write_build_id(int fd, struct perf_header *h,
 	if (!perf_session__read_build_ids(session, true))
 		return -1;
 
-	err = dsos__write_buildid_table(h, fd);
+	err = perf_session__write_buildid_table(session, fd);
 	if (err < 0) {
 		pr_debug("failed to write buildid table\n");
 		return err;
-- 
2.1.2

