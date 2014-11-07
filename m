Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaKGFap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:30:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaKGFal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:30:41 -0500
Date: Thu, 6 Nov 2014 21:30:24 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-714c9c4a98f722115e10d021ea80600f4427b71e@git.kernel.org>
Cc: adrian.hunter@intel.com, tglx@linutronix.de, dsahern@gmail.com,
        paulus@samba.org, mingo@kernel.org, namhyung.kim@lge.com,
        hpa@zytor.com, namhyung@kernel.org, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl
Reply-To: adrian.hunter@intel.com, tglx@linutronix.de, dsahern@gmail.com,
        namhyung@kernel.org, namhyung.kim@lge.com, paulus@samba.org,
        mingo@kernel.org, hpa@zytor.com, eranian@google.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl
In-Reply-To: <1415063674-17206-4-git-send-email-namhyung@kernel.org>
References: <1415063674-17206-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf build-id: Rename dsos__write_buildid_table()
Git-Commit-ID: 714c9c4a98f722115e10d021ea80600f4427b71e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  714c9c4a98f722115e10d021ea80600f4427b71e
Gitweb:     http://git.kernel.org/tip/714c9c4a98f722115e10d021ea80600f4427b71e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 4 Nov 2014 10:14:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Nov 2014 10:14:07 -0300

perf build-id: Rename dsos__write_buildid_table()

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
index 0ecf4a3..be8d02e 100644
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
