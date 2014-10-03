Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaJCF1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:27:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaJCF1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:27:39 -0400
Date: Thu, 2 Oct 2014 22:26:47 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-z0yrm8stn9w3423nkov3eksg@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, dzickus@redhat.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, namhyung@kernel.org, adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Fix error message for --filter option not coming after tracepoint
Git-Commit-ID: 281f92f233a59ef52bb45287242bd815a67f5647
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  281f92f233a59ef52bb45287242bd815a67f5647
Gitweb:     http://git.kernel.org/tip/281f92f233a59ef52bb45287242bd815a67f5647
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 1 Oct 2014 15:05:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Oct 2014 15:05:32 -0300

perf record: Fix error message for --filter option not coming after tracepoint

  [root@zoo ~]# perf record --filter "common_pid != PERF_PID" -a
  -F option should follow a -e tracepoint option.

The -F option is for --freq, not --filter. Fix it up to show:

  [root@zoo ~]# perf record --filter "common_pid != PERF_PID" -a
  --filter option should follow a -e tracepoint option

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-z0yrm8stn9w3423nkov3eksg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9522cf2..d76aa30 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -984,7 +984,7 @@ int parse_filter(const struct option *opt, const char *str,
 
 	if (last == NULL || last->attr.type != PERF_TYPE_TRACEPOINT) {
 		fprintf(stderr,
-			"-F option should follow a -e tracepoint option\n");
+			"--filter option should follow a -e tracepoint option\n");
 		return -1;
 	}
 
