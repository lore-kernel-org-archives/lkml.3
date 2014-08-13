Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaHMFSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:18:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMFST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:18:19 -0400
Date: Tue, 12 Aug 2014 22:17:59 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-8246de88e95ddef7508f5601d7af85c3ab9e476b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1406785662-5534-2-git-send-email-namhyung@kernel.org>
References: <1406785662-5534-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Left-align output contents
Git-Commit-ID: 8246de88e95ddef7508f5601d7af85c3ab9e476b
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

Commit-ID:  8246de88e95ddef7508f5601d7af85c3ab9e476b
Gitweb:     http://git.kernel.org/tip/8246de88e95ddef7508f5601d7af85c3ab9e476b
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 31 Jul 2014 14:47:35 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:04 -0300

perf tools: Left-align output contents

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
index 14e5a03..eda9ee8 100644
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
