Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaHDQVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:21:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:39542 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaHDQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:57 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/33] perf tools: Left-align output contents
Date: Mon,  4 Aug 2014 13:17:36 -0300
Message-Id: <1407169064-25625-26-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Now perf left-aligns column headers but the contents does not.  It
should have same alignment.  This requires a change in pid sort key - it
consists of two part (pid and comm).  As length of comm can be vary it'd
be better to change the order of them.

Thanks to Jiri Olsa for pointing this out.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406785662-5534-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 14e5a039bc45..eda9ee836cee 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -70,12 +70,12 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
 	const char *comm = thread__comm_str(he->thread);
-	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
-			       comm ?: "", he->thread->tid);
+	return repsep_snprintf(bf, size, "%5d:%-*s", he->thread->tid,
+			       width - 6, comm ?: "");
 }
 
 struct sort_entry sort_thread = {
-	.se_header	= "Command:  Pid",
+	.se_header	= "  Pid:Command",
 	.se_cmp		= sort__thread_cmp,
 	.se_snprintf	= hist_entry__thread_snprintf,
 	.se_width_idx	= HISTC_THREAD,
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
1.9.3

