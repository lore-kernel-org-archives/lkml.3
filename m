Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab3EZA3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:29:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45023 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab3EZA0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:26:37 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/16] perf top: move CONSOLE_CLEAR to header file
Date: Sat, 25 May 2013 18:24:45 -0600
Message-Id: <1369527896-3650-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For use with kvm-live mode.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/builtin-top.c |    2 --
 tools/perf/util/top.h    |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f036af9..495171a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -237,8 +237,6 @@ out_unlock:
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static const char		CONSOLE_CLEAR[] = "[H[2J";
-
 static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 						     struct addr_location *al,
 						     struct perf_sample *sample)
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index df46be9..b554ffc 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -39,6 +39,8 @@ struct perf_top {
 	float		   min_percent;
 };
 
+#define CONSOLE_CLEAR "[H[2J"
+
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
 void perf_top__reset_sample_counters(struct perf_top *top);
 #endif /* __PERF_TOP_H */
-- 
1.7.10.1

