Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3IYRUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:20:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54918 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3IYRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:20:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] perf trace: Add mmap2 handler
Date: Wed, 25 Sep 2013 14:20:24 -0300
Message-Id: <1380129628-16808-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380129628-16808-1-git-send-email-acme@infradead.org>
References: <1380129628-16808-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

5c5e854b changed perf_event__synthesize_mmap_events to generate MMAP2
events. Since perf-trace does not have a handler for it it dies with a
segfault when trying to process files:

perf trace -i /tmp/perf.data
Segmentation fault

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fd48534..71aa3e3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1055,6 +1055,7 @@ static int trace__replay(struct trace *trace)
 
 	trace->tool.sample	  = trace__process_sample;
 	trace->tool.mmap	  = perf_event__process_mmap;
+	trace->tool.mmap2	  = perf_event__process_mmap2;
 	trace->tool.comm	  = perf_event__process_comm;
 	trace->tool.exit	  = perf_event__process_exit;
 	trace->tool.fork	  = perf_event__process_fork;
-- 
1.8.1.4

