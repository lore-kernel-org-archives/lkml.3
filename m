Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbaCVJHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 05:07:10 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55622 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCVJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 05:07:04 -0400
Date: Sat, 22 Mar 2014 10:06:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140322090658.GA15570@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 7c144bfbf89d612f0c62b7e71056fb687b068455 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Two oneliner 'perf bench' tooling fixes.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf bench numa: Make no args mean 'run all tests'

Patrick Palka (1):
      perf bench: Fix NULL pointer dereference in "perf bench all"


 tools/perf/bench/numa.c    | 1 +
 tools/perf/builtin-bench.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

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
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e47f90c..8a987d2 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -76,7 +76,7 @@ static struct collection collections[] = {
 
 /* Iterate over all benchmarks within a collection: */
 #define for_each_bench(coll, bench) \
-	for (bench = coll->benchmarks; bench->name; bench++)
+	for (bench = coll->benchmarks; bench && bench->name; bench++)
 
 static void dump_benchmarks(struct collection *coll)
 {
