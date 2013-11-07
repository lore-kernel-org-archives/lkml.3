Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3KGPbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:31:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3KGPbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:31:22 -0500
Date: Thu, 7 Nov 2013 07:31:03 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-f34b9001f9a2f6fa41d3582fe515d194cc86bfb2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383763297-27066-3-git-send-email-dsahern@gmail.com>
References: <1383763297-27066-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Remove advance_output function
Git-Commit-ID: f34b9001f9a2f6fa41d3582fe515d194cc86bfb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:31:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f34b9001f9a2f6fa41d3582fe515d194cc86bfb2
Gitweb:     http://git.kernel.org/tip/f34b9001f9a2f6fa41d3582fe515d194cc86bfb2
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 6 Nov 2013 11:41:35 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 7 Nov 2013 10:43:15 -0300

perf record: Remove advance_output function

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
index 2932069..19c4db6 100644
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
 
