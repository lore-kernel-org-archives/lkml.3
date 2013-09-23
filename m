Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3IWBqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:46:22 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42265 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3IWBpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:45:13 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/5] perf trace: Add mmap2 handler
Date: Sun, 22 Sep 2013 19:44:58 -0600
Message-Id: <1379900700-5186-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5c5e854b changed perf_event__synthesize_mmap_events to generate MMAP2
events. Since perf-trace does not have a handler for it it dies with a
segfault when trying to process files:

perf trace -i /tmp/perf.data
Segmentation fault

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-trace.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9c7f017..f61c968 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1383,6 +1383,7 @@ static int trace__replay(struct trace *trace)
 
 	trace->tool.sample	  = trace__process_sample;
 	trace->tool.mmap	  = perf_event__process_mmap;
+	trace->tool.mmap2	  = perf_event__process_mmap2;
 	trace->tool.comm	  = perf_event__process_comm;
 	trace->tool.exit	  = perf_event__process_exit;
 	trace->tool.fork	  = perf_event__process_fork;
-- 
1.7.10.1

