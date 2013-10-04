Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3JDRch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:32:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JDRcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:32:35 -0400
Date: Fri, 4 Oct 2013 10:31:58 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-354cc40e3b0981c38ba2ce2964954480e6c03c37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1380637335-30110-1-git-send-email-andi@firstfloor.org>
References: <1380637335-30110-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf: Fix sorting for 64bit entries
Git-Commit-ID: 354cc40e3b0981c38ba2ce2964954480e6c03c37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:32:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  354cc40e3b0981c38ba2ce2964954480e6c03c37
Gitweb:     http://git.kernel.org/tip/354cc40e3b0981c38ba2ce2964954480e6c03c37
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 1 Oct 2013 07:22:15 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:06:06 +0200

tools/perf: Fix sorting for 64bit entries

Some of the node comparisons in hist.c dropped the upper
32bit by using an int variable to store the compare
result. This broke various 64bit fields, causing
incorrect collapsing (found for the TSX transaction field)

Just use int64_t always.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1380637335-30110-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/hist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9ff6cf3..97dc280 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -346,7 +346,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
-	int cmp;
+	int64_t cmp;
 
 	p = &hists->entries_in->rb_node;
 
@@ -884,7 +884,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
-	int cmp;
+	int64_t cmp;
 
 	if (sort__need_collapse)
 		root = &hists->entries_collapsed;
