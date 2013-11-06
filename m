Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3KFSmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:42:24 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41551 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3KFSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:41:47 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf record: Remove advance_output function
Date: Wed,  6 Nov 2013 11:41:35 -0700
Message-Id: <1383763297-27066-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1 line function with only 1 user; might as well embed directly.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
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
1.8.3.4 (Apple Git-47)

