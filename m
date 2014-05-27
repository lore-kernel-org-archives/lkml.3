Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaE0Q3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaE0Q3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:29:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: jolsa@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 5/7] perf: Add cpumode to struct hist_entry
Date: Tue, 27 May 2014 12:28:05 -0400
Message-Id: <1401208087-181977-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
References: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch needs to sort on cpumode, so add it to hist_entry to be tracked.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/hist.c | 7 ++++---
 tools/perf/util/sort.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7f0236c..b7160b1c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -410,9 +410,10 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.map	= al->map,
 			.sym	= al->sym,
 		},
-		.cpu	= al->cpu,
-		.ip	= al->addr,
-		.level	= al->level,
+		.cpu	 = al->cpu,
+		.cpumode = al->cpumode,
+		.ip	 = al->addr,
+		.level	 = al->level,
 		.stat = {
 			.nr_events = 1,
 			.period	= period,
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff4..22cf912 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -87,6 +87,7 @@ struct hist_entry {
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
+	u8			cpumode;
 
 	struct hist_entry_diff	diff;
 
-- 
1.7.11.7

