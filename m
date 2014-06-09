Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaFIUDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:03:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbaFIUDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:02 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 12/15] perf tools: Add cpumode to struct hist_entry
Date: Mon,  9 Jun 2014 22:02:27 +0200
Message-Id: <1402344150-14860-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

The next patch needs to sort on cpumode, so add it to hist_entry to be tracked.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1401208087-181977-6-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 7 ++++---
 tools/perf/util/sort.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a0a4b2..d5f47a4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -439,9 +439,10 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
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
index 5bf0098..6de22f8 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -89,6 +89,7 @@ struct hist_entry {
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
+	u8			cpumode;
 
 	struct hist_entry_diff	diff;
 
-- 
1.8.3.1

