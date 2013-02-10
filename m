Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912Ab3BJAmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:42:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45257 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760877Ab3BJAkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:40:07 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 03/11] perf: stop using liblockdep_init and liblockdep_set_thread
Date: Sat,  9 Feb 2013 19:39:33 -0500
Message-Id: <1360456781-32462-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are no longer needed by liblockdep, drop them.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/perf/builtin-sched.c          | 2 --
 tools/perf/builtin-top.c            | 4 ----
 tools/perf/config/feature-tests.mak | 1 -
 tools/perf/perf.c                   | 3 ---
 tools/perf/util/liblockdep.h        | 2 --
 5 files changed, 12 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 53d9225..e1f0c44 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -468,8 +468,6 @@ static void *thread_func(void *ctx)
 	char comm2[22];
 	int fd;
 
-	liblockdep_set_thread();
-
 	free(parms);
 
 	sprintf(comm2, ":%s", this_task->comm);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9b99ef..c9ff395 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -588,8 +588,6 @@ static void *display_thread_tui(void *arg)
 		.refresh	= top->delay_secs,
 	};
 
-	liblockdep_set_thread();
-
 	perf_top__sort_new_samples(top);
 
 	/*
@@ -615,8 +613,6 @@ static void *display_thread(void *arg)
 	struct perf_top *top = arg;
 	int delay_msecs, c;
 
-	liblockdep_set_thread();
-
 	tcgetattr(0, &save);
 	tc = save;
 	tc.c_lflag &= ~(ICANON | ECHO);
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 1f5a37e..20f8f7b 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -223,7 +223,6 @@ define SOURCE_LIBLOCKDEP
 
 int main(void)
 {
-	liblockdep_init();
 	return 0;
 }
 endef
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index ddbd315..0f661fb 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -446,9 +446,6 @@ int main(int argc, const char **argv)
 {
 	const char *cmd;
 
-	liblockdep_init();
-	liblockdep_set_thread();
-
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
diff --git a/tools/perf/util/liblockdep.h b/tools/perf/util/liblockdep.h
index 628a2f5..798263f 100644
--- a/tools/perf/util/liblockdep.h
+++ b/tools/perf/util/liblockdep.h
@@ -5,7 +5,5 @@
 #else
 
 #define LIBLOCKDEP_PTHREAD_MUTEX_INITIALIZER(mtx) PTHREAD_MUTEX_INITIALIZER
-#define liblockdep_init()
-#define liblockdep_set_thread()
 
 #endif
-- 
1.8.1.2

