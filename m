Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaGPUDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:03:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaGPUDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:09 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/13] perf tests: Update attr test with PERF_FLAG_FD_CLOEXEC flag
Date: Wed, 16 Jul 2014 22:02:38 +0200
Message-Id: <1405540969-18975-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index e9bd6391f2ae..f710b92ccff6 100644
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
index 91cd48b399f3..dc3ada2470c0 100644
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
-- 
1.8.3.1

