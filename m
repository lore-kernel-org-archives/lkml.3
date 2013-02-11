Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3BKMXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:23:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3BKMXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:23:52 -0500
Date: Mon, 11 Feb 2013 04:23:36 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-bf48cfee5efb3f86c0620acd76b873a6f50bb11a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-3-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-3-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] perf: Stop using liblockdep_init()
  and liblockdep_set_thread()
Git-Commit-ID: bf48cfee5efb3f86c0620acd76b873a6f50bb11a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:23:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf48cfee5efb3f86c0620acd76b873a6f50bb11a
Gitweb:     http://git.kernel.org/tip/bf48cfee5efb3f86c0620acd76b873a6f50bb11a
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:33 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:37 +0100

perf: Stop using liblockdep_init() and liblockdep_set_thread()

These functions are no longer needed by liblockdep, drop them.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-3-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
