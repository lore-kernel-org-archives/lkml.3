Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaKFVFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:05:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:43243 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaKFVFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:05:41 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/18] perf build-id: Rename dsos__write_buildid_table()
Date: Thu,  6 Nov 2014 18:04:31 -0300
Message-Id: <1415307879-912-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The dsos__write_buildid_table() is not use struct dso and it mostly
uses perf_session struct.

So rename it to perf_session__write_buildid_ table() so that it
corresponds to other related functions such as
perf_session__read_build_ids() and perf_session__cache_build_ids().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415063674-17206-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

