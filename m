Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3K3Mtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:49:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3K3Mtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:49:40 -0500
Date: Sat, 30 Nov 2013 04:49:19 -0800
From: tip-bot for Pekka Enberg <tipbot@zytor.com>
Message-ID: <tip-15e65c693d7de4c83d1e97fd89f87d47f2219782@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1384447410-1771-1-git-send-email-penberg@kernel.org>
References: <1384447410-1771-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Remove thread summary coloring
Git-Commit-ID: 15e65c693d7de4c83d1e97fd89f87d47f2219782
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:49:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15e65c693d7de4c83d1e97fd89f87d47f2219782
Gitweb:     http://git.kernel.org/tip/15e65c693d7de4c83d1e97fd89f87d47f2219782
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Thu, 14 Nov 2013 18:43:30 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:34 -0300

perf trace: Remove thread summary coloring

Thread summary line coloring looks ugly.  It doesn't add much value so
remove coloring completely.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1384447410-1771-1-git-send-email-penberg@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8be17fc..e9f345e2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2158,7 +2158,6 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	size_t printed = data->printed;
 	struct trace *trace = data->trace;
 	struct thread_trace *ttrace = thread->priv;
-	const char *color;
 	double ratio;
 
 	if (ttrace == NULL)
@@ -2166,17 +2165,9 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 
 	ratio = (double)ttrace->nr_events / trace->nr_events * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 50.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 25.0)
-		color = PERF_COLOR_GREEN;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
-
-	printed += color_fprintf(fp, color, " %s (%d), ", thread__comm_str(thread), thread->tid);
+	printed += fprintf(fp, " %s (%d), ", thread__comm_str(thread), thread->tid);
 	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
-	printed += color_fprintf(fp, color, "%.1f%%", ratio);
+	printed += fprintf(fp, "%.1f%%", ratio);
 	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
