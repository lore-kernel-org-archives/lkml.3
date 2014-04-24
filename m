Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaDXPow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:44:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187AbaDXPk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:40:59 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 05/11] perf hists: Collapse expanded callchains after filter is applied
Date: Thu, 24 Apr 2014 17:40:39 +0200
Message-Id: <1398354045-16505-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
References: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When a filter is applied a hist entry checks whether its callchain was
folded and account it to the output stat.  But this is rather hacky
and only TUI-specific.  Simply fold the callchains for the entry looks
like a simpler and more generic solution IMHO.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-6-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b675857..8d5cfcc 100644
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
1.8.3.1

