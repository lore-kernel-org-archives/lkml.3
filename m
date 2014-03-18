Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaCRI3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:29:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaCRI30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:29:26 -0400
Date: Tue, 18 Mar 2014 01:28:01 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-x7h0ghx4pef4n0brywg21krk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, patrick@parcs.ath.cx,
        peterz@infradead.org, efault@gmx.de, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, patrick@parcs.ath.cx,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench numa: Make no args mean '
 run all tests'
Git-Commit-ID: 0fae799e869b9b1ece8c04c714d0529da0b0bade
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

Commit-ID:  0fae799e869b9b1ece8c04c714d0529da0b0bade
Gitweb:     http://git.kernel.org/tip/0fae799e869b9b1ece8c04c714d0529da0b0bade
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 13 Mar 2014 16:54:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 10:04:10 -0300

perf bench numa: Make no args mean 'run all tests'

If we call just:

  perf bench numa mem

it will present the same output as:

  perf bench numa mem -h

i.e. ask for instructions about what to run.

While that is kinda ok, using 'run all tests' as the default, i.e.
making 'no parms' be equivalent to:

  perf bench numa mem -a

Will allow:

  perf bench numa all

to actually do what is asked: i.e. run all the 'bench' tests, instead of
responding to that by asking what to do.

That, in turn, allows:

  perf bench all

to actually complete, for the same reasons.

And after that, the tests that come after that, and that at some point
hit a NULL deref, will run, allowing me to reproduce a recently reported
problem.

That when you have the needed numa libraries, which wasn't the case for
the reporter, making me a bit confused after trying to reproduce his
report.

So make no parms mean -a.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Patrick Palka <patrick@parcs.ath.cx>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-x7h0ghx4pef4n0brywg21krk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/numa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index d4c83c6..97d86d8 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1593,6 +1593,7 @@ static void init_params(struct params *p, const char *name, int argc, const char
 	p->data_rand_walk		= true;
 	p->nr_loops			= -1;
 	p->init_random			= true;
+	p->run_all			= argc == 1;
 }
 
 static int run_bench_numa(const char *name, const char **argv)
