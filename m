Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3KLUqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:46:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41920 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab3KLUqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:46:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/13] perf trace: Change syscall summary duration order
Date: Tue, 12 Nov 2013 17:46:10 -0300
Message-Id: <1384289178-31374-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

Switch duration order to minimum, average, maximum for the '--summary'
command line option because it's more natural to read.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/1384265410-12344-1-git-send-email-penberg@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8d6ea8fbf476..8990fbeb8b41 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2093,7 +2093,7 @@ static size_t trace__fprintf_threads_header(FILE *fp)
 	printed  = fprintf(fp, "\n _____________________________________________________________________________\n");
 	printed += fprintf(fp, " __)    Summary of events    (__\n\n");
 	printed += fprintf(fp, "              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]\n");
-	printed += fprintf(fp, "                                  syscall  count    min     max    avg  stddev\n");
+	printed += fprintf(fp, "                                  syscall  count    min     avg    max  stddev\n");
 	printed += fprintf(fp, "                                                   msec    msec   msec     %%\n");
 	printed += fprintf(fp, " _____________________________________________________________________________\n\n");
 
@@ -2129,8 +2129,8 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 			sc = &trace->syscalls.table[inode->i];
 			printed += fprintf(fp, "%24s  %14s : ", "", sc->name);
 			printed += fprintf(fp, "%5" PRIu64 "  %8.3f  %8.3f",
-					   n, min, max);
-			printed += fprintf(fp, "  %8.3f  %6.2f\n", avg, pct);
+					   n, min, avg);
+			printed += fprintf(fp, "  %8.3f  %6.2f\n", max, pct);
 		}
 
 		inode = intlist__next(inode);
-- 
1.8.1.4

