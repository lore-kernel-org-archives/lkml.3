Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3LTTKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3LTTJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/35] perf hists: Do not pass period and weight to add_hist_entry()
Date: Fri, 20 Dec 2013 16:08:38 -0300
Message-Id: <1387566550-3524-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The @entry argument already has the info so no need to pass them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1387344086-12744-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

