Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaEEMea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbaEEMeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:34:23 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/10] perf tools: Move ACCESS_ONCE from perf.h header
Date: Mon,  5 May 2014 14:33:39 +0200
Message-Id: <1399293219-8732-11-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Into util/evlist.h header as it's the only user
of this define.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h        | 2 --
 tools/perf/util/evlist.h | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f5173cd..fa77cd7 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -17,6 +17,8 @@ struct record_opts;
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
 struct perf_mmap {
 	void		 *base;
 	int		 mask;
-- 
1.8.3.1

