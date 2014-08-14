Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaHNIsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:48:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaHNIs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:48:27 -0400
Date: Thu, 14 Aug 2014 01:48:09 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-dc5c8190b800dc59eff6bb2aa47ea749712197df@git.kernel.org>
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
In-Reply-To: <1407825645-24586-12-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-12-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Move call to symbol__init()
  after creating session
Git-Commit-ID: dc5c8190b800dc59eff6bb2aa47ea749712197df
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

Commit-ID:  dc5c8190b800dc59eff6bb2aa47ea749712197df
Gitweb:     http://git.kernel.org/tip/dc5c8190b800dc59eff6bb2aa47ea749712197df
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:43 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:35:19 -0300

perf timechart: Move call to symbol__init() after creating session

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
Link: http://lkml.kernel.org/r/1407825645-24586-12-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 912e3b5..df3b1c5 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1607,6 +1607,8 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 	if (session == NULL)
 		return -ENOMEM;
 
+	symbol__init();
+
 	(void)perf_header__process_sections(&session->header,
 					    perf_data_file__fd(session->file),
 					    tchart,
@@ -1982,8 +1984,6 @@ int cmd_timechart(int argc, const char **argv,
 		return -1;
 	}
 
-	symbol__init();
-
 	if (argc && !strncmp(argv[0], "rec", 3)) {
 		argc = parse_options(argc, argv, record_options, record_usage,
 				     PARSE_OPT_STOP_AT_NON_OPTION);
