Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaG1IX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:23:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42426 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaG1IXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:23:54 -0400
Date: Mon, 28 Jul 2014 01:22:33 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-578bea40058b68f83658827c2b68a596b08419fc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-8-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Do not print dangling '=>' for BTS
Git-Commit-ID: 578bea40058b68f83658827c2b68a596b08419fc
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

Commit-ID:  578bea40058b68f83658827c2b68a596b08419fc
Gitweb:     http://git.kernel.org/tip/578bea40058b68f83658827c2b68a596b08419fc
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:16 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:18:00 -0300

perf script: Do not print dangling '=>' for BTS

When using:

	perf record -e branches:u -c1 usleep 1
	perf script -f ip

lines are displayed like:

	ffffffff813b23d5 =>

Change so that the dangling '=>' does not appear.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 333b15e..582da97 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -446,13 +446,13 @@ static void print_sample_bts(union perf_event *event,
 				     PERF_MAX_STACK_DEPTH);
 	}
 
-	printf(" => ");
-
 	/* print branch_to information */
 	if (PRINT_FIELD(ADDR) ||
 	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
-	     !output[attr->type].user_set))
+	     !output[attr->type].user_set)) {
+		printf(" => ");
 		print_sample_addr(event, sample, al->machine, thread, attr);
+	}
 
 	if (print_srcline_last)
 		map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
