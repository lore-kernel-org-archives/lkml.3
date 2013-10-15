Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab3JOFaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:30:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab3JOFaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:30:25 -0400
Date: Mon, 14 Oct 2013 22:30:08 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-ac3063bd4725689f39d7a23fdfca2e034c73dcac@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <52497F3C.9070908@gmail.com>
References: <52497F3C.9070908@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Don'
 t require a workload when using system wide or CPU options
Git-Commit-ID: ac3063bd4725689f39d7a23fdfca2e034c73dcac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:30:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac3063bd4725689f39d7a23fdfca2e034c73dcac
Gitweb:     http://git.kernel.org/tip/ac3063bd4725689f39d7a23fdfca2e034c73dcac
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 30 Sep 2013 07:37:37 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:44 -0300

perf stat: Don't require a workload when using system wide or CPU options

The "perf stat" command can do system wide counters or one or more cpus.
For these options do not require a workload to be specified.

v2: use perf_target__none per Namhyung's comment.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/52497F3C.9070908@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c8a2662..2178e66 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1659,8 +1659,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && !perf_target__has_task(&target))
+	if (!argc && perf_target__none(&target))
 		usage_with_options(stat_usage, options);
+
 	if (run_count < 0) {
 		usage_with_options(stat_usage, options);
 	} else if (run_count == 0) {
