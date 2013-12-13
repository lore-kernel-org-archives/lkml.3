Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3LMIxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:53:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:54371 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab3LMIxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:53:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,477,1384329600"; 
   d="scan'208";a="449437458"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tools: Remove unused next_pow2() and rename next_pow2_l()
Date: Fri, 13 Dec 2013 10:53:36 +0200
Message-Id: <1386924816-24402-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386924816-24402-1-git-send-email-adrian.hunter@intel.com>
References: <1386924816-24402-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fixed version of 'next_pow2_l()' does not call
'next_pow2()' anymore, so it is unused, so remove
it and rename 'next_pow2_l()' to 'next_pow2()'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 2 +-
 tools/perf/util/util.h   | 9 +--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0b31cee..327a1a4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -736,7 +736,7 @@ static long parse_pages_arg(const char *str, unsigned long min,
 		/* leave number of pages at 0 */
 	} else if (!is_power_of_2(pages)) {
 		/* round pages up to next power of 2 */
-		pages = next_pow2_l(pages);
+		pages = next_pow2(pages);
 		if (!pages)
 			return -EINVAL;
 		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index ae609fe..3860d76 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -275,14 +275,7 @@ bool is_power_of_2(unsigned long n)
 	return (n != 0 && ((n & (n - 1)) == 0));
 }
 
-static inline unsigned next_pow2(unsigned x)
-{
-	if (!x)
-		return 1;
-	return 1ULL << (32 - __builtin_clz(x - 1));
-}
-
-static inline unsigned long next_pow2_l(unsigned long x)
+static inline unsigned long next_pow2(unsigned long x)
 {
 	int leading_zeros;
 
-- 
1.7.11.7

