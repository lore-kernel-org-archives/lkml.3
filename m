Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3I1U2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:28:14 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39869 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3I1U2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:28:09 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf stat: Don't require a workload when using system wide or CPU options
Date: Sat, 28 Sep 2013 14:27:59 -0600
Message-Id: <1380400080-9211-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-stat can do system wide counters or one or more cpus. For
these options do not require a workload to be specified.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6cc0aa2..60239fe 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1517,8 +1517,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && !perf_target__has_task(&target))
+	if (!argc && !perf_target__has_task(&target) &&
+	    !perf_target__has_cpu(&target))
 		usage_with_options(stat_usage, options);
+
 	if (run_count < 0) {
 		usage_with_options(stat_usage, options);
 	} else if (run_count == 0) {
-- 
1.7.10.1

