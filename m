Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3HBNeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab3HBNeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:34:07 -0400
Date: Fri, 2 Aug 2013 15:33:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] perf tools: Renaming 'time' variable in perf_time_to_tsc due
 to name shadowing error
Message-ID: <20130802133346.GD1711@krava.brq.redhat.com>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
 <20130801120251.GB1032@krava.brq.redhat.com>
 <51FB2B90.6090602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51FB2B90.6090602@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf compilation fails with following error:
      ...
      CC arch/x86/util/tsc.o
  arch/x86/util/tsc.c: In function ‘perf_time_to_tsc’:
  arch/x86/util/tsc.c:13:6: error: declaration of ‘time’ shadows a global declaration [-Werror=shadow]
  cc1: all warnings being treated as errors

Renaming the 'time' variable to prevent this.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/arch/x86/util/tsc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index f111744..9570c2b 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -10,11 +10,11 @@
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
 {
-	u64 time, quot, rem;
+	u64 t, quot, rem;
 
-	time = ns - tc->time_zero;
-	quot = time / tc->time_mult;
-	rem  = time % tc->time_mult;
+	t = ns - tc->time_zero;
+	quot = t / tc->time_mult;
+	rem  = t % tc->time_mult;
 	return (quot << tc->time_shift) +
 	       (rem << tc->time_shift) / tc->time_mult;
 }
-- 
1.7.7.6

