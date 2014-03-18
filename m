Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaCRTKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:10:00 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:45907 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaCRTJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:09:58 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf evsel: Update function names in debug messages
Date: Tue, 18 Mar 2014 15:10:42 -0400
Message-Id: <1395169842-1399-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event_open() was renamed to sys_perf_event_open(); update the debug
messages to reflect this.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/util/evsel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 55407c5..2ebe4ca 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1004,7 +1004,7 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 retry_open:
-			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
+			pr_debug2("sys_perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
 				  pid, cpus->map[cpu], group_fd, flags);
 
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
@@ -1013,7 +1013,7 @@ retry_open:
 								     group_fd, flags);
 			if (FD(evsel, cpu, thread) < 0) {
 				err = -errno;
-				pr_debug2("perf_event_open failed, error %d\n",
+				pr_debug2("sys_perf_event_open failed, error %d\n",
 					  err);
 				goto try_fallback;
 			}
-- 
1.9.0.431.g014438b

