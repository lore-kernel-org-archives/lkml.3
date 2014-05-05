Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaEERir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477AbaEERgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:36:15 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/12] perf tools: Remove min define from perf.h
Date: Mon,  5 May 2014 19:35:41 +0200
Message-Id: <1399311348-28152-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
References: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's defined in tools/perf/util/include/linux/kernel.h header.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-4-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index a547f38..50aa88d 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -203,12 +203,6 @@ static inline unsigned long long rdclock(void)
  */
 #define asmlinkage
 
-#define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
-
 extern bool test_attr__enabled;
 void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
-- 
1.8.3.1

