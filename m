Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab3DOFLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:11:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50881 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:11:42 -0400
X-AuditID: 9c930179-b7bd8ae000004629-cd-516b8c0c5970
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/10] perf util: Make file/host_bigendian variable local
Date: Mon, 15 Apr 2013 14:11:31 +0900
Message-Id: <1366002698-10728-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
References: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

They're not used anywhere, just make them local variables.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 6166294d7f22..0dd9fbda88eb 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -39,9 +39,6 @@
 
 static int input_fd;
 
-int file_bigendian;
-int host_bigendian;
-
 static ssize_t trace_data_size;
 static bool repipe;
 
@@ -342,6 +339,8 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	int show_funcs = 0;
 	int show_printk = 0;
 	ssize_t size = -1;
+	int file_bigendian;
+	int host_bigendian;
 	int file_long_size;
 	int file_page_size;
 	struct pevent *pevent;
-- 
1.7.11.7

