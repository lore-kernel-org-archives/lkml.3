Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaCRVgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:36:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44731 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaCRVgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:36:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/13] perf timechart: Fix off-by-one error in 'record' argv handling
Date: Tue, 18 Mar 2014 18:25:53 -0300
Message-Id: <1395177965-8879-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Since 367b315 (perf timechart: Add support for -P and -T in timechart
recording, 2013-11-01), the 'perf timechart record' command stopped
working:

  $ perf timechart record -- git status
  Workload failed: No such file or directory

This happens because of an off-by-one error while preparing the argv for
cmd_record(): it attempts to execute the command 'status' and complains
that it doesn't exist. Fix this error.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Link: http://lkml.kernel.org/r/1394985965-2332-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 25526d6eae59..d4991a235155 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1238,7 +1238,7 @@ static int timechart__record(struct timechart *tchart, int argc, const char **ar
 	for (i = 0; i < old_power_args_nr; i++)
 		*p++ = strdup(old_power_args[i]);
 
-	for (j = 1; j < (unsigned int)argc; j++)
+	for (j = 0; j < (unsigned int)argc; j++)
 		*p++ = argv[j];
 
 	return cmd_record(rec_argc, rec_argv, NULL);
-- 
1.8.1.4

