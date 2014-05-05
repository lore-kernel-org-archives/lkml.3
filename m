Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaEERum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:50:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaEERuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:50:37 -0400
Date: Mon, 5 May 2014 10:49:50 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9sk90owm370kuq3f0ssjjui2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, bp@suse.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move ACCESS_ONCE from perf.h header
Git-Commit-ID: 73a31b7c6a85e2f033524058bad5bce900e4f2ed
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

Commit-ID:  73a31b7c6a85e2f033524058bad5bce900e4f2ed
Gitweb:     http://git.kernel.org/tip/73a31b7c6a85e2f033524058bad5bce900e4f2ed
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 13:16:41 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:49:07 +0200

perf tools: Move ACCESS_ONCE from perf.h header

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
