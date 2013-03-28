Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3C1RIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:08:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47751
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756896Ab3C1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/36] perf stat: Rename --aggr-socket to --per-socket
Date: Thu, 28 Mar 2013 14:02:12 -0300
Message-Id: <1364490156-32064-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

To make it more obvious what this option does as suggested by Andi on
LKML.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1360846649-6411-3-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |    4 ++--
 tools/perf/builtin-stat.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 23e587a..46027e1 100644
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
index ded34fc..6f6ea93 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1370,7 +1370,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run after to the measured command"),
 	OPT_UINTEGER('I', "interval-print", &interval,
 		    "print counts at regular interval in ms (>= 100)"),
-	OPT_SET_UINT(0, "aggr-socket", &aggr_mode,
+	OPT_SET_UINT(0, "per-socket", &aggr_mode,
 		     "aggregate counts per processor socket", AGGR_SOCKET),
 	OPT_END()
 	};
-- 
1.7.1

