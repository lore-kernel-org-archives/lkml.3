Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaEAI1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:27:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaEAI1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:27:38 -0400
Date: Thu, 1 May 2014 10:27:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [rfc][patch] perf,tools: Remove test_attr_* muck from perf.h
Message-ID: <20140501082729.GM11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I occasionally build the odd program against raw perf and use perf.h for
this.

Now I find that no longer works because of:

52502bf201a85 ("perf tests: Add framework for automated perf_event_attr tests")

So revert the hunk touching on perf.h.

Also, it seems to be for snake shit only, and snakes stink, except on a
plane :-)

---
 tools/perf/perf.h | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ebdad3376c67..4a089338b60c 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -212,25 +212,13 @@ static inline unsigned long long rdclock(void)
 	(void) (&_min1 == &_min2);		\
 	_min1 < _min2 ? _min1 : _min2; })
 
-extern bool test_attr__enabled;
-void test_attr__init(void);
-void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
-		     int fd, int group_fd, unsigned long flags);
-
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	int fd;
-
-	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
+	return syscall(__NR_perf_event_open, attr, pid, cpu,
 		     group_fd, flags);
-
-	if (unlikely(test_attr__enabled))
-		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
-
-	return fd;
 }
 
 #define MAX_COUNTERS			256
