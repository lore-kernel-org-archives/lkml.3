Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbaCSNGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:06:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34158 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933972AbaCSNGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:06:48 -0400
Date: Wed, 19 Mar 2014 06:06:27 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-263f89bf7d0f5ba98077dda8df1ff814862ad5ba@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        stfomichev@yandex-team.ru, dsahern@gmail.com, tglx@linutronix.de,
        artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        stfomichev@yandex-team.ru, dsahern@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1394985965-2332-1-git-send-email-artagnon@gmail.com>
References: <1394985965-2332-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Fix off-by-one error in 'record'
  argv handling
Git-Commit-ID: 263f89bf7d0f5ba98077dda8df1ff814862ad5ba
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

Commit-ID:  263f89bf7d0f5ba98077dda8df1ff814862ad5ba
Gitweb:     http://git.kernel.org/tip/263f89bf7d0f5ba98077dda8df1ff814862ad5ba
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Sun, 16 Mar 2014 12:06:05 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:16:47 -0300

perf timechart: Fix off-by-one error in 'record' argv handling

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
