Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3KGPFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:05:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55633 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3KGPEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:04:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/7] perf record: Remove advance_output function
Date: Thu,  7 Nov 2013 12:04:16 -0300
Message-Id: <1383836658-10518-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383836658-10518-1-git-send-email-acme@infradead.org>
References: <1383836658-10518-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

1 line function with only 1 user; might as well embed directly.

Signed-off-by: David Ahern <dsahern@gmail.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383763297-27066-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2932069ad7a8..19c4db6bdd6f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -77,11 +77,6 @@ struct perf_record {
 	off_t			post_processing_offset;
 };
 
-static void advance_output(struct perf_record *rec, size_t size)
-{
-	rec->bytes_written += size;
-}
-
 static int write_output(struct perf_record *rec, void *buf, size_t size)
 {
 	struct perf_data_file *file = &rec->file;
@@ -461,7 +456,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 				pr_err("Couldn't record tracing data.\n");
 				goto out_delete_session;
 			}
-			advance_output(rec, err);
+			rec->bytes_written += err;
 		}
 	}
 
-- 
1.8.1.4

