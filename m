Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3KLV5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:57:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3KLV5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:57:08 -0500
Date: Tue, 12 Nov 2013 13:56:31 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-3fe2130523b2e098085eb4d38cd5b737a97cbee6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <5281D3B8.2030104@intel.com>
References: <5281D3B8.2030104@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tests:
  Compensate lower sample freq with longer test loop
Git-Commit-ID: 3fe2130523b2e098085eb4d38cd5b737a97cbee6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:56:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fe2130523b2e098085eb4d38cd5b737a97cbee6
Gitweb:     http://git.kernel.org/tip/3fe2130523b2e098085eb4d38cd5b737a97cbee6
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 12 Nov 2013 11:45:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 13:00:37 -0300

perf tests: Compensate lower sample freq with longer test loop

Doesn't work for me:

./perf test -v 19
19: Test software clock events have valid period values    :
--- start ---
mmap size 528384B
mmap size 528384B
All (0) samples have period value of 1!
---- end ----
Test software clock events have valid period values: FAILED!

Compensate the lower freq introduced in 67c1e4a53b17 with a longer loop,

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/5281D3B8.2030104@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/sw-clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 93a7139..6664a7c 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -9,7 +9,7 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 
-#define NR_LOOPS  1000000
+#define NR_LOOPS  10000000
 
 /*
  * This test will open software clock events (cpu-clock, task-clock)
