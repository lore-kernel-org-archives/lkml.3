Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaEERgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbaEERgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:36:36 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/12] perf tools: Move ACCESS_ONCE from perf.h header
Date: Mon,  5 May 2014 19:35:48 +0200
Message-Id: <1399311348-28152-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
References: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Into tools/include/linux/compiler.h header.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-9sk90owm370kuq3f0ssjjui2@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/include/linux/compiler.h | 2 ++
 tools/perf/perf.h              | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index fbc6665..88461f0 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -35,4 +35,6 @@
 # define unlikely(x)		__builtin_expect(!!(x), 0)
 #endif
 
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
 #endif /* _TOOLS_LINUX_COMPILER_H */
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 813571b..510c65f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -14,8 +14,6 @@ void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 #define HAVE_ATTR_TEST
 #include "perf-sys.h"
 
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
-
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
 #endif
-- 
1.8.3.1

