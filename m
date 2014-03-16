Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaCPQF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:05:27 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:61073 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaCPQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:05:25 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf timechart record: fix off-by-one error in argv
Date: Sun, 16 Mar 2014 12:06:05 -0400
Message-Id: <1394985965-2332-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.rc0.1.g9d22d25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 367b315 (perf timechart: Add support for -P and -T in timechart
recording, 2013-11-01), the 'perf timechart record' command stopped
working:

  $ perf timechart record -- git status
  Workload failed: No such file or directory

This happens because of an off-by-one error while preparing the argv for
cmd_record(): it attempts to execute the command 'status' and complains
that it doesn't exist. Fix this error.

Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-timechart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 25526d6..d4991a2 100644
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
1.9.rc0.1.g9d22d25

