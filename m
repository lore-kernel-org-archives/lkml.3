Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaGIF2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:28:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39827 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaGIF2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:28:17 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/6] perf tools: Left-align output contents
Date: Wed,  9 Jul 2014 14:28:09 +0900
Message-Id: <1404883694-5342-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf left-aligns column headers but the contents does not.  It
should have same alignment.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 14e5a039bc45..9a531743c8c2 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -70,7 +70,7 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
 	const char *comm = thread__comm_str(he->thread);
-	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
+	return repsep_snprintf(bf, size, "%-*s:%5d", width - 6,
 			       comm ?: "", he->thread->tid);
 }
 
@@ -106,7 +106,7 @@ sort__comm_sort(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s", width, comm__str(he->comm));
+	return repsep_snprintf(bf, size, "%-*s", width, comm__str(he->comm));
 }
 
 struct sort_entry sort_comm = {
@@ -305,7 +305,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
-	return repsep_snprintf(bf, size, "%s", he->srcline);
+	return repsep_snprintf(bf, size, "%-s", he->srcline);
 }
 
 struct sort_entry sort_srcline = {
-- 
2.0.0

