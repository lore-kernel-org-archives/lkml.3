Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbaGRKWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:22:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761027AbaGRKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:22:20 -0400
Date: Fri, 18 Jul 2014 03:21:57 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2mgzn5p9u74drmdmxo5unar0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Update attr test with PERF_FLAG_FD_CLOEXEC flag
Git-Commit-ID: fb578179a54553716afb0666a4d8c194acd313ba
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

Commit-ID:  fb578179a54553716afb0666a4d8c194acd313ba
Gitweb:     http://git.kernel.org/tip/fb578179a54553716afb0666a4d8c194acd313ba
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 14 Jul 2014 08:50:03 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 18 Jul 2014 09:09:53 +0200

perf tests: Update attr test with PERF_FLAG_FD_CLOEXEC flag

We not support PERF_FLAG_FD_CLOEXEC flag, updating attr tests
accordingly.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-2mgzn5p9u74drmdmxo5unar0@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/attr/base-record | 3 ++-
 tools/perf/tests/attr/base-stat   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index e9bd639..f710b92 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -1,7 +1,8 @@
 [event]
 fd=1
 group_fd=-1
-flags=0
+# 0 or PERF_FLAG_FD_CLOEXEC flag
+flags=0|8
 cpu=*
 type=0|1
 size=96
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 91cd48b..dc3ada2 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -1,7 +1,8 @@
 [event]
 fd=1
 group_fd=-1
-flags=0
+# 0 or PERF_FLAG_FD_CLOEXEC flag
+flags=0|8
 cpu=*
 type=0
 size=96
