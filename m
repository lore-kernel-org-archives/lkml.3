Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab3DBJfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:35:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab3DBJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:35:12 -0400
Date: Tue, 2 Apr 2013 02:34:49 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-d4304958a25414a6e67b8a41c0f230e05cafafb6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1360846649-6411-3-git-send-email-eranian@google.com>
References: <1360846649-6411-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Rename --aggr-socket to --per-socket
Git-Commit-ID: d4304958a25414a6e67b8a41c0f230e05cafafb6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:34:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4304958a25414a6e67b8a41c0f230e05cafafb6
Gitweb:     http://git.kernel.org/tip/d4304958a25414a6e67b8a41c0f230e05cafafb6
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 14 Feb 2013 13:57:28 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Mar 2013 16:09:24 -0300

perf stat: Rename --aggr-socket to --per-socket

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
 tools/perf/Documentation/perf-stat.txt | 4 ++--
 tools/perf/builtin-stat.c              | 2 +-
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
index ded34fc..6f6ea931 100644
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
