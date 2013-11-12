Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3KLV5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:57:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3KLV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:52 -0500
Date: Tue, 12 Nov 2013 13:56:40 -0800
From: tip-bot for Pekka Enberg <tipbot@zytor.com>
Message-ID: <tip-7f7a4138c66e857cc5bbf6e248a47379765349b5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, penberg@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384265410-12344-1-git-send-email-penberg@kernel.org>
References: <1384265410-12344-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Change syscall summary duration order
Git-Commit-ID: 7f7a4138c66e857cc5bbf6e248a47379765349b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:56:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f7a4138c66e857cc5bbf6e248a47379765349b5
Gitweb:     http://git.kernel.org/tip/7f7a4138c66e857cc5bbf6e248a47379765349b5
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 12 Nov 2013 16:10:10 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 13:00:38 -0300

perf trace: Change syscall summary duration order

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
index 8d6ea8f..8990fbe 100644
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
