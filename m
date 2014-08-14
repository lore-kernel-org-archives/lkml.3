Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaHNIsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:48:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaHNIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:48:43 -0400
Date: Thu, 14 Aug 2014 01:48:25 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-cb2ffae241cfdd6d90acb7ec5f52ad8401885dd2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        minchan@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, minchan@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1407825645-24586-13-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Move call to symbol__init()
  after creating session
Git-Commit-ID: cb2ffae241cfdd6d90acb7ec5f52ad8401885dd2
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

Commit-ID:  cb2ffae241cfdd6d90acb7ec5f52ad8401885dd2
Gitweb:     http://git.kernel.org/tip/cb2ffae241cfdd6d90acb7ec5f52ad8401885dd2
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:41:38 -0300

perf trace: Move call to symbol__init() after creating session

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 20fac50..8a83bd8 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2241,13 +2241,13 @@ static int trace__replay(struct trace *trace)
 	/* add tid to output */
 	trace->multiple_threads = true;
 
-	if (symbol__init() < 0)
-		return -1;
-
 	session = perf_session__new(&file, false, &trace->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (symbol__init() < 0)
+		goto out;
+
 	trace->host = &session->machines.host;
 
 	err = perf_session__set_tracepoints_handlers(session, handlers);
