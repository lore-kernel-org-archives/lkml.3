Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaDXIYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:24:21 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38635 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaDXIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:24:11 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 05/11] perf hists: Collapse expanded callchains after filter is applied
Date: Thu, 24 Apr 2014 17:23:57 +0900
Message-Id: <1398327843-31845-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a filter is applied a hist entry checks whether its callchain was
folded and account it to the output stat.  But this is rather hacky
and only TUI-specific.  Simply fold the callchains for the entry looks
like a simpler and more generic solution IMHO.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b675857883a2..8d5cfcc3bc63 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -716,8 +716,8 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->filtered)
 		return;
 
-	if (h->ms.unfolded)
-		hists->nr_non_filtered_entries += h->nr_rows;
+	/* force fold unfiltered entry for simplicity */
+	h->ms.unfolded = false;
 	h->row_offset = 0;
 
 	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
-- 
1.9.2

