Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3EaLv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:51:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3EaLvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:51:47 -0400
Date: Fri, 31 May 2013 04:51:11 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-45528f7c699a71d2f3096173980aadd43dff6eaa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1369527896-3650-9-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-9-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stats: Fix divide by 0 in variance
Git-Commit-ID: 45528f7c699a71d2f3096173980aadd43dff6eaa
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

Commit-ID:  45528f7c699a71d2f3096173980aadd43dff6eaa
Gitweb:     http://git.kernel.org/tip/45528f7c699a71d2f3096173980aadd43dff6eaa
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 25 May 2013 18:24:48 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:04 +0300

perf stats: Fix divide by 0 in variance

Number of samples needs to be greater 1 to have a variance.

Fixes nan% in perf-kvm-live output.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1369527896-3650-9-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 2374212..7c59c28 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -37,7 +37,7 @@ double stddev_stats(struct stats *stats)
 {
 	double variance, variance_mean;
 
-	if (!stats->n)
+	if (stats->n < 2)
 		return 0.0;
 
 	variance = stats->M2 / (stats->n - 1);
