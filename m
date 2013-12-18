Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3LRFVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:21:50 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63059 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3LRFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:30 -0500
X-AuditID: 9c93017d-b7c5eae000004296-20-52b130d898ba
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 03/18] perf tools: Do not pass period and weight to add_hist_entry()
Date: Wed, 18 Dec 2013 14:21:11 +0900
Message-Id: <1387344086-12744-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The @entry argument already has the info so no need to pass them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 822903eaa201..63234e37583c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -342,15 +342,15 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 }
 
 static struct hist_entry *add_hist_entry(struct hists *hists,
-				      struct hist_entry *entry,
-				      struct addr_location *al,
-				      u64 period,
-				      u64 weight)
+					 struct hist_entry *entry,
+					 struct addr_location *al)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	int64_t cmp;
+	u64 period = entry->stat.period;
+	u64 weight = entry->stat.weight;
 
 	p = &hists->entries_in->rb_node;
 
@@ -437,7 +437,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.transaction = transaction,
 	};
 
-	return add_hist_entry(hists, &entry, al, period, weight);
+	return add_hist_entry(hists, &entry, al);
 }
 
 int64_t
-- 
1.7.11.7

