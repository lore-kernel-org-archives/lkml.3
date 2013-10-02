Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3JBJCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:02:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59909 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3JBJCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:02:31 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tool: add example to perf-trace documentation
Date: Wed,  2 Oct 2013 14:25:18 +0530
Message-Id: <1380704118-12377-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not clear that perf trace must be run as a privileged user, so
include an example demonstrating its usage with sudo. While at it,
update the synopsis to include options.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/Documentation/perf-trace.txt | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index daccd2c..4ad8950 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -8,7 +8,7 @@ perf-trace - strace inspired tool
 SYNOPSIS
 --------
 [verse]
-'perf trace'
+'perf trace' [<options>]
 
 DESCRIPTION
 -----------
@@ -78,6 +78,26 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --input
 	Process events from a given perf data file.
 
+EXAMPLES
+--------
+
+$ sudo perf trace -a -e open
+
+   349.934 ( 0.012 ms): 832 open(filename: 0xc1a4f0, flags: RDONLY                                ) = 14
+   349.985 ( 0.004 ms): 832 open(filename: 0xb390e0, flags: RDONLY                                ) = 14
+   350.012 ( 0.004 ms): 832 open(filename: 0xa9c930, flags: RDONLY                                ) = 14
+   350.037 ( 0.003 ms): 832 open(filename: 0xc1a4f0, flags: RDONLY                                ) = 14
+   350.060 ( 0.003 ms): 832 open(filename: 0xb390e0, flags: RDONLY                                ) = 14
+   349.943 ( 0.010 ms): 9379 open(filename: 0x17d3080, flags: RDONLY                               ) = 19
+   350.213 ( 0.003 ms): 832 open(filename: 0xc93d10, flags: RDONLY                                ) = 14
+   350.307 ( 0.002 ms): 832 open(filename: 0xc64820, flags: RDONLY                                ) = 14
+   350.399 ( 0.002 ms): 832 open(filename: 0xea20f0, flags: RDONLY                                ) = 14
+   350.481 ( 0.002 ms): 832 open(filename: 0xbfb940, flags: RDONLY                                ) = 14
+   350.567 ( 0.002 ms): 832 open(filename: 0xb3edb0, flags: RDONLY                                ) = 14
+   850.345 ( 0.010 ms): 832 open(filename: 0xb72ba0, flags: RDONLY                                ) = 14
+   850.390 ( 0.003 ms): 832 open(filename: 0xfd8860, flags: RDONLY                                ) = 14
+   850.414 ( 0.003 ms): 832 open(filename: 0xee4740, flags: RDONLY                                ) = 14
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
-- 
1.8.4.477.g5d89aa9

