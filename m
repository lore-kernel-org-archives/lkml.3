Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaDYNOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:14:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaDYNOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:14:31 -0400
Date: Fri, 25 Apr 2014 06:14:11 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-87e90f43285f4096e9ba5fc18b05c2e04caf3fab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-6-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Collapse expanded callchains after filter is applied
Git-Commit-ID: 87e90f43285f4096e9ba5fc18b05c2e04caf3fab
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

Commit-ID:  87e90f43285f4096e9ba5fc18b05c2e04caf3fab
Gitweb:     http://git.kernel.org/tip/87e90f43285f4096e9ba5fc18b05c2e04caf3fab
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 24 Apr 2014 16:44:16 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:31:50 +0200

perf hists: Collapse expanded callchains after filter is applied

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
