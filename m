Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab3CULgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:36:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3CULgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:36:20 -0400
Date: Thu, 21 Mar 2013 04:34:45 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-024b13082e9d4a50f2d39c5fe2d1179261e7aa22@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363173585-9754-4-git-send-email-namhyung@kernel.org>
References: <1363173585-9754-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove unnecessary calc_data_size variable
Git-Commit-ID: 024b13082e9d4a50f2d39c5fe2d1179261e7aa22
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:34:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  024b13082e9d4a50f2d39c5fe2d1179261e7aa22
Gitweb:     http://git.kernel.org/tip/024b13082e9d4a50f2d39c5fe2d1179261e7aa22
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 13 Mar 2013 20:19:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:09 -0300

perf tools: Remove unnecessary calc_data_size variable

It's not set from anywhere so no need to keep it.  Looks like an
unneeded copy of the same variable in trace-event-read.c

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363173585-9754-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index b0bbd76..783ab51 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -119,17 +119,10 @@ static void put_tracing_file(char *file)
 	free(file);
 }
 
-static ssize_t calc_data_size;
-
 static ssize_t write_or_die(const void *buf, size_t len)
 {
 	int ret;
 
-	if (calc_data_size) {
-		calc_data_size += len;
-		return len;
-	}
-
 	ret = write(output_fd, buf, len);
 	if (ret < 0)
 		die("writing to '%s'", output_file);
