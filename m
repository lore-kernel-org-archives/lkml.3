Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3KHEX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:23:57 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47168 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3KHEXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:23:33 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf record: Move existing write_output into helper function
Date: Thu,  7 Nov 2013 21:23:24 -0700
Message-Id: <1383884605-30968-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code move only; no logic changes. In preparation for the mmap
based output option in the next patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 15280b5e5574..6e6a41856c41 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,7 +76,7 @@ struct perf_record {
 	long			samples;
 };
 
-static int write_output(struct perf_record *rec, void *buf, size_t size)
+static int do_write_output(struct perf_record *rec, void *buf, size_t size)
 {
 	struct perf_data_file *file = &rec->file;
 
@@ -97,6 +97,11 @@ static int write_output(struct perf_record *rec, void *buf, size_t size)
 	return 0;
 }
 
+static int write_output(struct perf_record *rec, void *buf, size_t size)
+{
+	return do_write_output(rec, buf, size);
+}
+
 static int process_synthesized_event(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_sample *sample __maybe_unused,
-- 
1.8.3.4 (Apple Git-47)

