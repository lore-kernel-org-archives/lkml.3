Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615Ab3BNM5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:57:53 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54896 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934270Ab3BNM5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:57:52 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v2 2/3] perf stat: rename --aggr-socket to --per-socket
Date: Thu, 14 Feb 2013 13:57:28 +0100
Message-Id: <1360846649-6411-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360846649-6411-1-git-send-email-eranian@google.com>
References: <1360846649-6411-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make it more obvious what this option does as
suggested by Andi on LKML.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-stat.txt |    4 ++--
 tools/perf/builtin-stat.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index faf4f4f..01117c5 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -119,10 +119,10 @@ perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/clean' -- m
 	Print count deltas every N milliseconds (minimum: 100ms)
 	example: perf stat -I 1000 -e cycles -a sleep 5
 
---aggr-socket::
+--per-socket::
 Aggregate counts per processor socket for system-wide mode measurements.  This
 is a useful mode to detect imbalance between sockets.  To enable this mode,
-use --aggr-socket in addition to -a. (system-wide).  The output includes the
+use --per-socket in addition to -a. (system-wide).  The output includes the
 socket number and the number of online processors on that socket. This is
 useful to gauge the amount of aggregation.
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a19f8d5..508d9b4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1357,7 +1357,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run after to the measured command"),
 	OPT_UINTEGER('I', "interval-print", &interval,
 		    "print counts at regular interval in ms (>= 100)"),
-	OPT_SET_UINT(0, "aggr-socket", &aggr_mode,
+	OPT_SET_UINT(0, "per-socket", &aggr_mode,
 		     "aggregate counts per processor socket", AGGR_SOCKET),
 	OPT_END()
 	};
-- 
1.7.9.5

