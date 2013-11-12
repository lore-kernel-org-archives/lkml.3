Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3KLV4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:56:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3KLV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:17 -0500
Date: Tue, 12 Nov 2013 13:55:38 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-a9986fad6645b98d5bb3c2f83c22efb0761ca272@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383884605-30968-2-git-send-email-dsahern@gmail.com>
References: <1383884605-30968-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record:
  Move existing write_output into helper function
Git-Commit-ID: a9986fad6645b98d5bb3c2f83c22efb0761ca272
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:55:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9986fad6645b98d5bb3c2f83c22efb0761ca272
Gitweb:     http://git.kernel.org/tip/a9986fad6645b98d5bb3c2f83c22efb0761ca272
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 7 Nov 2013 21:23:24 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 11 Nov 2013 15:56:40 -0300

perf record: Move existing write_output into helper function

Code move only; no logic changes. In preparation for the mmap based
output option in the next patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383884605-30968-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8f5af32..880227e 100644
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
