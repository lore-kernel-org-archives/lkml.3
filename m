Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3E3QPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:15:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50821 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934348Ab3E3QCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/66] perf hists: Rename hist_entry__add_pair arguments
Date: Thu, 30 May 2013 19:01:00 +0300
Message-Id: <1369929699-8724-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The current logic is to attach pair to the leader hist_entry.

Arguments of hist_entry__add_pair function were placed the other way
round.. driving me crazy.

I.e. list_add_tail expects (new_node, head).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1355404152-16523-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 51f1b5a..45ac84c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -117,10 +117,10 @@ static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
 	return NULL;
 }
 
-static inline void hist_entry__add_pair(struct hist_entry *he,
-					struct hist_entry *pair)
+static inline void hist_entry__add_pair(struct hist_entry *pair,
+					struct hist_entry *he)
 {
-	list_add_tail(&he->pairs.head, &pair->pairs.node);
+	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
 enum sort_mode {
-- 
1.8.1.4

