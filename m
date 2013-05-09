Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3EIEdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:33:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54750 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3EIEcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:32:19 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 08/13] perf stats: fix divide by 0 in variance
Date: Wed,  8 May 2013 22:31:44 -0600
Message-Id: <1368073909-8825-9-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Number of samples needs to be greater 1 to have a variance.
Fixes nan% in perf-kvm-live output.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/util/stat.c |    2 +-
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
-- 
1.7.10.1

