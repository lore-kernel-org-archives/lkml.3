Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaLXHSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:18:06 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40271 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLXHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:42 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 31/37] perf record: Show total size of multi file data
Date: Wed, 24 Dec 2014 16:15:27 +0900
Message-Id: <1419405333-27952-32-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf record shows header file size only - extends it to show
total size of multi-file data storage.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7f7a4725d080..eb485f1ee66e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -538,9 +538,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		 */
 		fprintf(stderr,
 			"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
-			(double)rec->bytes_written / 1024.0 / 1024.0,
+			(double)(u64)perf_data_file__multi_size(file) / 1024.0 / 1024.0,
 			file->path,
-			rec->bytes_written / 24);
+			perf_data_file__multi_size(file) / 24);
 	}
 
 out_child:
-- 
2.1.3

