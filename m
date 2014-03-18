Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaCRV0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44410 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaCRV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/13] perf evsel: Update function names in debug messages
Date: Tue, 18 Mar 2014 18:26:03 -0300
Message-Id: <1395177965-8879-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

perf_event_open() was renamed to sys_perf_event_open(); update the debug
messages to reflect this.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395169842-1399-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 26b67b11c65b..5c28d82b76c4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1023,7 +1023,7 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 retry_open:
-			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
+			pr_debug2("sys_perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
 				  pid, cpus->map[cpu], group_fd, flags);
 
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
@@ -1032,7 +1032,7 @@ retry_open:
 								     group_fd, flags);
 			if (FD(evsel, cpu, thread) < 0) {
 				err = -errno;
-				pr_debug2("perf_event_open failed, error %d\n",
+				pr_debug2("sys_perf_event_open failed, error %d\n",
 					  err);
 				goto try_fallback;
 			}
-- 
1.8.1.4

