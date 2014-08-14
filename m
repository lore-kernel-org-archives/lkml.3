Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaHNIsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:48:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaHNIsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:48:03 -0400
Date: Thu, 14 Aug 2014 01:47:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-0493410612486cadaa4e076caf4df3fa9cd20fde@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-10-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Move call to symbol__init()
  after creating session
Git-Commit-ID: 0493410612486cadaa4e076caf4df3fa9cd20fde
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

Commit-ID:  0493410612486cadaa4e076caf4df3fa9cd20fde
Gitweb:     http://git.kernel.org/tip/0493410612486cadaa4e076caf4df3fa9cd20fde
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:34:29 -0300

perf sched: Move call to symbol__init() after creating session

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7c16aeb..dcd9ebf 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1462,6 +1462,8 @@ static int perf_sched__read_events(struct perf_sched *sched,
 		return -1;
 	}
 
+	symbol__init();
+
 	if (perf_session__set_tracepoints_handlers(session, handlers))
 		goto out_delete;
 
@@ -1747,7 +1749,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv, prefix);
 
-	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
