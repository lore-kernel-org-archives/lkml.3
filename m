Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3KLOKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:10:22 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:48326 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3KLOKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:10:17 -0500
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf trace: Fix syscall summary duration order
Date: Tue, 12 Nov 2013 16:10:10 +0200
Message-Id: <1384265410-12344-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch duration order to minimum, average, maximum for the '--summary'
command line option because it's more natural to read.

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/builtin-trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 329b783..f841d2a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2085,7 +2085,7 @@ static size_t trace__fprintf_threads_header(FILE *fp)
 	printed  = fprintf(fp, "\n _____________________________________________________________________________\n");
 	printed += fprintf(fp, " __)    Summary of events    (__\n\n");
 	printed += fprintf(fp, "              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]\n");
-	printed += fprintf(fp, "                                  syscall  count    min     max    avg  stddev\n");
+	printed += fprintf(fp, "                                  syscall  count    min     avg    max  stddev\n");
 	printed += fprintf(fp, "                                                   msec    msec   msec     %%\n");
 	printed += fprintf(fp, " _____________________________________________________________________________\n\n");
 
@@ -2121,8 +2121,8 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
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
1.8.3.1

