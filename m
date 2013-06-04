Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab3FDFYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:24:16 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62012 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3FDFUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:36 -0400
X-AuditID: 9c930179-b7c07ae000000e33-32-51ad7921a339
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 07/16] perf util: Save page size in a trace file to pevent
Date: Tue,  4 Jun 2013 14:20:22 +0900
Message-Id: <1370323231-14022-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We now have page_size field in struct pevent, save the actual size of
the system.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index af215c0d2379..c6b491bcb8cd 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -349,6 +349,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	int show_funcs = 0;
 	int show_printk = 0;
 	ssize_t size = -1;
+	int file_page_size;
 	struct pevent *pevent;
 	int err;
 
@@ -393,10 +394,12 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		goto out;
 	long_size = buf[0];
 
-	page_size = read4(pevent);
-	if (!page_size)
+	file_page_size = read4(pevent);
+	if (!file_page_size)
 		goto out;
 
+	pevent_set_page_size(pevent, file_page_size);
+
 	err = read_header_files(pevent);
 	if (err)
 		goto out;
-- 
1.7.11.7

